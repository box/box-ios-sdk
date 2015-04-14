//
//  BOXCollaborationUpdateRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"
#import "BOXContentSDKConstants.h"

@interface BOXCollaborationUpdateRequest : BOXRequest

@property (nonatomic, readwrite, strong) BOXCollaborationRole *role;
@property (nonatomic, readwrite, strong) NSString *status;

- (instancetype)initWithCollaborationID:(NSString *)collaborationID;
- (void)performRequestWithCompletion:(BOXCollaborationBlock)completionBlock;

@end
