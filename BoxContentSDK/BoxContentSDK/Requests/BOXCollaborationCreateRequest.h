//
//  BOXCollaborationCreateRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"
#import "BOXContentSDKConstants.h"

@interface BOXCollaborationCreateRequest : BOXRequest

@property (nonatomic, readwrite, assign) BOOL shouldNotifyUsers;
@property (nonatomic, readwrite, strong) NSString *userID;
@property (nonatomic, readwrite, strong) NSString *groupID;
@property (nonatomic, readwrite, strong) NSString *login;
@property (nonatomic, readwrite, strong) BOXCollaborationRole *role;
@property (nonatomic, readonly, strong) NSString *folderID;

- (instancetype)initWithFolderID:(NSString *)folderID;
- (void)performRequestWithCompletion:(BOXCollaborationBlock)completionBlock;

@end
