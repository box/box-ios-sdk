//
//  BOXCollaborationPendingRequest.h
//  BoxContentSDK
//

#import <BoxContentSDK/BOXRequest.h>

//FIXME: Rename this request class
// From API Docs: Used to retrieve all pending collaboration invites for this user.

//FIXME: This has a fields parameter

@interface BOXCollaborationPendingRequest : BOXRequest

- (void)performRequestWithCompletion:(BOXCollaborationArrayCompletionBlock)completionBlock;

- (void)performRequestWithCached:(BOXCollaborationArrayCompletionBlock)cacheBlock
                       refreshed:(BOXCollaborationArrayCompletionBlock)refreshBlock;

@end
