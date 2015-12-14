//
//  BOXCollaborationCreateRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXCollaborationCreateRequest.h"
#import "BOXAPIJSONOperation.h"
#import "BOXCollaboration.h"

@implementation BOXCollaborationCreateRequest

- (instancetype)initWithFolderID:(NSString *)folderID
{
    if (self = [super init]) {
        _folderID = folderID;
    }
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceCollaborations
                                    ID:nil
                           subresource:nil
                                 subID:nil];
    
    NSMutableDictionary *bodyDictionary = [NSMutableDictionary dictionary];
    
    NSDictionary *itemDictionary = @{BOXAPIObjectKeyID : self.folderID,
                                     BOXAPIObjectKeyType : BOXAPIItemTypeFolder};
    
    bodyDictionary[BOXAPIObjectKeyItem] = itemDictionary;
    
    NSMutableDictionary *accessibleByDictionary = [NSMutableDictionary dictionary];
    
    if (self.userID.length > 0 || self.login.length > 0) {
        if (self.userID.length > 0) {
            accessibleByDictionary[BOXAPIObjectKeyID] = self.userID;
        } else if (self.login.length > 0) {
            accessibleByDictionary[BOXAPIObjectKeyLogin] = self.login;
        }
        accessibleByDictionary[BOXAPIObjectKeyType] = BOXCollaborationCollaboratorTypeUser;
    } else if (self.groupID.length > 0) {
        accessibleByDictionary[BOXAPIObjectKeyID] = self.groupID;
        accessibleByDictionary[BOXAPIObjectKeyType] = BOXCollaborationCollaboratorTypeGroup;
    }
    
    bodyDictionary[BOXAPIObjectKeyAccessibleBy] = accessibleByDictionary;
    
    if (self.role.length > 0) {
        bodyDictionary[BOXAPIObjectKeyRole] = self.role;
    }
    
    NSDictionary *queryParameters = nil;

    if (self.shouldNotifyUsers) {
        queryParameters = @{BOXAPIParameterKeyNotify : [NSNumber numberWithBool:self.shouldNotifyUsers]};
    }
    
    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodPOST
                                              queryStringParameters:queryParameters
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

        if ([self.cacheClient respondsToSelector:@selector(cacheCollaborationCreateRequest:withCollaboration:error:)]) {
            [self.cacheClient cacheCollaborationCreateRequest:self
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
        if ([self.cacheClient respondsToSelector:@selector(cacheCollaborationCreateRequest:withCollaboration:error:)]) {
            [self.cacheClient cacheCollaborationCreateRequest:self
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
