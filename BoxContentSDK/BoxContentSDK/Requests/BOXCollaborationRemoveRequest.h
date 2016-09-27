//
//  BOXCollaborationRemoveRequest.h
//  BoxContentSDK
//

#import <BoxContentSDK/BOXRequest.h>

@interface BOXCollaborationRemoveRequest : BOXRequest

@property (nonatomic, readonly, strong) NSString *collaborationID;

- (instancetype)initWithCollaborationID:(NSString *)collaborationID;
- (void)performRequestWithCompletion:(BOXErrorBlock)completionBlock;

@end
