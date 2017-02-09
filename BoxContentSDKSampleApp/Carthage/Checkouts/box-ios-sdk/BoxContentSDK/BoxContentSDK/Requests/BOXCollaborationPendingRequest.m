//
//  BOXCollaborationPendingRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXCollaborationPendingRequest.h"
#import "BOXAPIJSONOperation.h"
#import "BOXCollaboration.h"

@implementation BOXCollaborationPendingRequest

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceCollaborations
                                    ID:nil
                           subresource:nil
                                 subID:nil];

    NSDictionary *queryParameters = @{BOXAPIObjectKeyStatus : BOXCollaborationStatusPending};
    
    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    
    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXCollaborationArrayCompletionBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *collaborationOperation = (BOXAPIJSONOperation *)self.operation;

        collaborationOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            NSDictionary *collaborationDictionaries = JSONDictionary[BOXAPIObjectKeyEntries];
            NSMutableArray *collaborations = [NSMutableArray array];
            for (NSDictionary *collaborationDictionary in collaborationDictionaries) {
                BOXCollaboration *collaboration = [[BOXCollaboration alloc] initWithJSON:collaborationDictionary];
                [collaborations addObject:collaboration];
            }
            
            if ([self.cacheClient respondsToSelector:@selector(cacheCollaborationPendingRequest:withCollaborations:error:)]) {
                [self.cacheClient cacheCollaborationPendingRequest:self
                                                withCollaborations:collaborations
                                                            error:nil];
            }
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(collaborations, nil);
            } onMainThread:isMainThread];
        };
        collaborationOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            if ([self.cacheClient respondsToSelector:@selector(cacheCollaborationPendingRequest:withCollaborations:error:)]) {
                [self.cacheClient cacheCollaborationPendingRequest:self
                                                withCollaborations:nil
                                                             error:error];
            }
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        };
        [self performRequest];
    }
}

- (void)performRequestWithCached:(BOXCollaborationArrayCompletionBlock)cacheBlock
                       refreshed:(BOXCollaborationArrayCompletionBlock)refreshBlock
{
    if (cacheBlock) {
        if ([self.cacheClient respondsToSelector:@selector(retrieveCacheForCollaborationPendingRequest:completion:)]) {
            [self.cacheClient retrieveCacheForCollaborationPendingRequest:self completion:cacheBlock];
        } else {
            cacheBlock(nil, nil);
        }
    }
    [self performRequestWithCompletion:refreshBlock];
}

@end
