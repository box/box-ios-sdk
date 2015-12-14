//
//  BOXCollaborationRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXCollaborationRequest.h"
#import "BOXAPIJSONOperation.h"
#import "BOXCollaboration.h"

@interface BOXCollaborationRequest ()

@property (nonatomic, readwrite, strong) NSString *collaborationID;

@end

@implementation BOXCollaborationRequest

- (instancetype)initWithCollaborationID:(NSString *)collaborationID
{
    self = [super init];
    if (self != nil) {
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
    
    BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:nil
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    
    return JSONOperation;
}

- (void)performRequestWithCompletion:(BOXCollaborationBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *collaborationOperation = (BOXAPIJSONOperation *)self.operation;

        collaborationOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            BOXCollaboration *collaboration = [[BOXCollaboration alloc] initWithJSON:JSONDictionary];

            if ([self.cacheClient respondsToSelector:@selector(cacheCollaborationRequest:withCollaboration:error:)]) {
                [self.cacheClient cacheCollaborationRequest:self
                                          withCollaboration:collaboration
                                                      error:nil];
            }
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(collaboration, nil);
            } onMainThread:isMainThread];
        };
        collaborationOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            if ([self.cacheClient respondsToSelector:@selector(cacheCollaborationRequest:withCollaboration:error:)]) {
                [self.cacheClient cacheCollaborationRequest:self
                                          withCollaboration:nil
                                                      error:error];
            }
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        };
        [self performRequest];
    }
}

- (void)performRequestWithCached:(BOXCollaborationBlock)cacheBlock
                       refreshed:(BOXCollaborationBlock)refreshBlock
{
    if (cacheBlock) {
        if ([self.cacheClient respondsToSelector:@selector(retrieveCacheForCollaborationRequest:completion:)]) {
            [self.cacheClient retrieveCacheForCollaborationRequest:self completion:cacheBlock];
        } else {
            cacheBlock(nil, nil);
        }
    }
    [self performRequestWithCompletion:refreshBlock];
}

@end
