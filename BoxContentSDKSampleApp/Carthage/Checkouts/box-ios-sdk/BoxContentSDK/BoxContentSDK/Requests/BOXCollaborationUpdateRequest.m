//
//  BOXCollaborationUpdateRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXCollaborationUpdateRequest.h"
#import "BOXAPIJSONOperation.h"
#import "BOXCollaboration.h"

@interface BOXCollaborationUpdateRequest ()

@property (nonatomic, readwrite, strong) NSString *collaborationID;

@end

@implementation BOXCollaborationUpdateRequest

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
    
    NSMutableDictionary *bodyDictionary = [NSMutableDictionary dictionary];

    if (self.role.length > 0) {
        bodyDictionary[BOXAPIObjectKeyRole] = self.role;
    }

    if (self.status.length > 0) {
        bodyDictionary[BOXAPIObjectKeyStatus] = self.status;
    }
    
    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodPUT
                                              queryStringParameters:nil
                                                     bodyDictionary:bodyDictionary
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    
    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXCollaborationBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *collaborationOperation = (BOXAPIJSONOperation *)self.operation;
    
    collaborationOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
        BOXCollaboration *collaboration = [[BOXCollaboration alloc] initWithJSON:JSONDictionary];
        if ([self.cacheClient respondsToSelector:@selector(cacheCollaborationUpdateRequest:withCollaboration:error:)]) {
            [self.cacheClient cacheCollaborationUpdateRequest:self
                                            withCollaboration:collaboration
                                                        error:nil];
        }
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(collaboration, nil);
            } onMainThread:isMainThread];
        }
    };
    collaborationOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
        if ([self.cacheClient respondsToSelector:@selector(cacheCollaborationUpdateRequest:withCollaboration:error:)]) {
            [self.cacheClient cacheCollaborationUpdateRequest:self
                                            withCollaboration:nil
                                                        error:error];
        }
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        }
    };
    [self performRequest];
}

@end
