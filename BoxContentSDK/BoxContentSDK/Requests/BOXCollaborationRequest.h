//
//  BOXCollaborationRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"

@interface BOXCollaborationRequest : BOXRequest

- (instancetype)initWithCollaborationID:(NSString *)collaborationID;
- (void)performRequestWithCompletion:(BOXCollaborationBlock)completionBlock;

@end
