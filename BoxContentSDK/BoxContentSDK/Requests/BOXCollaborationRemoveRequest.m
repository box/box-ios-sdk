//
//  BOXCollaborationRemoveRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXCollaborationRemoveRequest.h"
#import "BOXAPIJSONOperation.h"
#import "BOXContentSDKConstants.h"

@implementation BOXCollaborationRemoveRequest

- (instancetype)initWithCollaborationID:(NSString *)collaborationID
{
    if (self = [super init]) {
        _collaborationID = collaborationID;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceCollaborations
                                    ID:self.collaborationID
                           subresource:nil
                                 subID:nil];
    
    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodDELETE
                                              queryStringParameters:nil
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    
    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXErrorBlock)completionBlock {
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *collaborationOperation = (BOXAPIJSONOperation *)self.operation;
    
    collaborationOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
        if ([self.cacheClient respondsToSelector:@selector(cacheCollaborationCreateRequest:withCollaboration:error:)]) {
            [self.cacheClient cacheCollaborationRemoveRequest:self
                                                        error:nil];
        }
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil);
            } onMainThread:isMainThread];
        }
    };
    collaborationOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
        if ([self.cacheClient respondsToSelector:@selector(cacheCollaborationCreateRequest:withCollaboration:error:)]) {
            [self.cacheClient cacheCollaborationRemoveRequest:self
                                                        error:error];
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
