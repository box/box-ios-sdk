//
//  BOXCollaborationUpdateRequest.h
//  BoxContentSDK
//

#import <BoxContentSDK/BOXContentSDKConstants.h>
#import <BoxContentSDK/BOXRequest.h>

@interface BOXCollaborationUpdateRequest : BOXRequest

@property (nonatomic, readwrite, strong) BOXCollaborationRole *role;
@property (nonatomic, readwrite, strong) NSString *status;
@property (nonatomic, readonly, strong) NSString *collaborationID;

- (instancetype)initWithCollaborationID:(NSString *)collaborationID;
- (void)performRequestWithCompletion:(BOXCollaborationBlock)completionBlock;

@end
