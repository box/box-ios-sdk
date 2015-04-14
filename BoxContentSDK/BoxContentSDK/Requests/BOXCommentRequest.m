//
//  BOXCommentRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXCommentRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXComment.h"

@interface BOXCommentRequest ()

@property (nonatomic, readwrite, strong) NSString *commentID;

@end

@implementation BOXCommentRequest

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
                                HTTPMethod:BOXAPIHTTPMethodGET 
                     queryStringParameters:nil 
                            bodyDictionary:nil 
                          JSONSuccessBlock:nil 
                              failureBlock:nil];
    
    return operation;
}

- (void)performRequestWithCompletion:(BOXCommentBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];

    BOXAPIJSONOperation *commentOperation = (BOXAPIJSONOperation *)self.operation;

    if (completionBlock) {
        commentOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                BOXComment *comment = [[BOXComment alloc] initWithJSON:JSONDictionary];
                completionBlock(comment, nil);
            } onMainThread:isMainThread];
        };
        commentOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        };
    }
    
    [self performRequest];
}

@end
