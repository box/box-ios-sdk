//
//  BOXCollaborationRemoveRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"

@interface BOXCollaborationRemoveRequest : BOXRequest

@property (nonatomic, readonly, strong) NSString *collaborationID;

- (instancetype)initWithCollaborationID:(NSString *)collaborationID;
- (void)performRequestWithCompletion:(BOXErrorBlock)completionBlock;

@end
