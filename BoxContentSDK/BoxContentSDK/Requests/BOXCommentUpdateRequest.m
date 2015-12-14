//
//  BOXCommentUpdateRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXCommentUpdateRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXComment.h"

@interface BOXCommentUpdateRequest ()

@property (nonatomic, readwrite, strong) NSString *commentID;
@property (nonatomic ,readwrite, strong) NSString *updatedMessage;

@end

@implementation BOXCommentUpdateRequest

- (instancetype)initWithCommentID:(NSString *)commentID updatedMessage:(NSString *)updatedMessage
{
    if (self = [super init]) {
        _commentID = commentID;
        _updatedMessage = updatedMessage;
    }
    return self;
}

- (BOXAPIOperation *)createOperation
{
    BOXAPIOperation *operation = nil;
    
    NSURL *url = [self URLWithResource:BOXAPIResourceComments 
                                    ID:self.commentID
                           subresource:nil 
                                 subID:nil];
    
    NSDictionary *bodyDictionary = nil;

    if (self.updatedMessage) {
        bodyDictionary = @{BOXAPIObjectKeyMessage : self.updatedMessage};
    }
    
    operation = [self JSONOperationWithURL:url 
                                HTTPMethod:BOXAPIHTTPMethodPUT
                     queryStringParameters:nil
                            bodyDictionary:bodyDictionary
                          JSONSuccessBlock:nil
                              failureBlock:nil];        
    
    return operation;
}

- (void)performRequestWithCompletion:(BOXCommentBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *commentAddOperation = (BOXAPIJSONOperation *)self.operation;

    commentAddOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
        BOXComment *comment = [[BOXComment alloc] initWithJSON:JSONDictionary];

        if ([self.cacheClient respondsToSelector:@selector(cacheUpdateCommentRequest:withComment:error:)]) {
            [self.cacheClient cacheUpdateCommentRequest:self
                                            withComment:comment
                                                  error:nil];
        }
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(comment ,nil);
            } onMainThread:isMainThread];
        }
    };
    commentAddOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

        if ([self.cacheClient respondsToSelector:@selector(cacheUpdateCommentRequest:withComment:error:)]) {
            [self.cacheClient cacheUpdateCommentRequest:self
                                            withComment:nil
                                                  error:error];
        }
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil,error);
            } onMainThread:isMainThread];
        }
    };
    [self performRequest];
}

@end
