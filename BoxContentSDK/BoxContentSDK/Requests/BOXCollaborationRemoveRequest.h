//
//  BOXCollaborationRemoveRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"

@interface BOXCollaborationRemoveRequest : BOXRequest

- (instancetype)initWithCollaborationID:(NSString *)collaborationID;
- (void)performRequestWithCompletion:(BOXErrorBlock)completionBlock;

@end
