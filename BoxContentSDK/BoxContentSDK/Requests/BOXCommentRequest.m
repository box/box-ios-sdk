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
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (self.requestAllItemFields) {
        parameters[BOXAPIParameterKeyFields] = [self fullCommentFieldsParameterString];
    }
    
    operation = [self JSONOperationWithURL:url
                                HTTPMethod:BOXAPIHTTPMethodGET 
                     queryStringParameters:parameters
                            bodyDictionary:nil 
                          JSONSuccessBlock:nil 
                              failureBlock:nil];
    
    return operation;
}

- (void)performRequestWithCompletion:(BOXCommentBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *commentOperation = (BOXAPIJSONOperation *)self.operation;

        commentOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            BOXComment *comment = [[BOXComment alloc] initWithJSON:JSONDictionary];

            if ([self.cacheClient respondsToSelector:@selector(cacheCommentRequest:withComment:error:)]) {
                [self.cacheClient cacheCommentRequest:self
                                          withComment:comment
                                                error:nil];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(comment, nil);
            } onMainThread:isMainThread];
        };
        commentOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

            if ([self.cacheClient respondsToSelector:@selector(cacheCommentRequest:withComment:error:)]) {
                [self.cacheClient cacheCommentRequest:self
                                          withComment:nil
                                                error:error];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        };
        [self performRequest];
    }
}

- (void)performRequestWithCached:(BOXCommentBlock)cacheBlock refreshed:(BOXCommentBlock)refreshBlock
{
    if (cacheBlock) {
        if ([self.cacheClient respondsToSelector:@selector(retrieveCacheForCommentRequest:completion:)]) {
            [self.cacheClient retrieveCacheForCommentRequest:self
                                                  completion:cacheBlock];
        } else {
            cacheBlock(nil, nil);
        }
    }

    [self performRequestWithCompletion:refreshBlock];
}

@end
