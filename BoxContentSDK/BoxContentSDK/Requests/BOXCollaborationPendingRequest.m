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
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *collaborationOperation = (BOXAPIJSONOperation *)self.operation;
    
    if (completionBlock) {
        collaborationOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            NSDictionary *collaborationDictionaries = JSONDictionary[BOXAPIObjectKeyEntries];
            NSMutableArray *collaborations = [NSMutableArray array];
            for (NSDictionary *collaborationDictionary in collaborationDictionaries) {
                BOXCollaboration *collaboration = [[BOXCollaboration alloc] initWithJSON:collaborationDictionary];
                [collaborations addObject:collaboration];
            }
            
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(collaborations, nil);
            } onMainThread:isMainThread];
        };
        collaborationOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        };
    }
    
    [self performRequest];
}

@end
