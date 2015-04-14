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
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *collaborationOperation = (BOXAPIJSONOperation *)self.operation;
    
    if (completionBlock) {
        collaborationOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            BOXCollaboration *collaboration = [[BOXCollaboration alloc] initWithJSON:JSONDictionary];
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(collaboration, nil);
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
