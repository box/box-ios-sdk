//
//  BOXCommentDeleteRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXCommentDeleteRequest.h"
#import "BOXAPIJSONOperation.h"

@interface BOXCommentDeleteRequest ()

@property (nonatomic, readwrite, strong) NSString *commentID;

@end

@implementation BOXCommentDeleteRequest


- (instancetype)initWithCommentID:(NSString *)commentID
{
    if (self = [super init]) {
        _commentID = commentID;
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
    
    operation = [self JSONOperationWithURL:url 
                                HTTPMethod:BOXAPIHTTPMethodDELETE 
                     queryStringParameters:nil 
                            bodyDictionary:nil 
                          JSONSuccessBlock:nil 
                              failureBlock:nil];

    return operation;
}

- (void)performRequestWithCompletion:(BOXErrorBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];

    BOXAPIJSONOperation *commentDeleteOperation = (BOXAPIJSONOperation *)self.operation;

    commentDeleteOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {

        if ([self.cacheClient respondsToSelector:@selector(cacheDeleteCommentRequest:error:)]) {
            [self.cacheClient cacheDeleteCommentRequest:self error:nil];
        }
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil);
            } onMainThread:isMainThread];
        }
    };
    commentDeleteOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

        if ([self.cacheClient respondsToSelector:@selector(cacheDeleteCommentRequest:error:)]) {
            [self.cacheClient cacheDeleteCommentRequest:self error:error];
        }
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(error);
            } onMainThread:isMainThread];
        }
    };
    [self performRequest];
}

@end
