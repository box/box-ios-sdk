//
//  BOXCollaborationRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"

@interface BOXCollaborationRequest : BOXRequest

@property (nonatomic, readonly, strong) NSString *collaborationID;

- (instancetype)initWithCollaborationID:(NSString *)collaborationID;
- (void)performRequestWithCompletion:(BOXCollaborationBlock)completionBlock;
- (void)performRequestWithCached:(BOXCollaborationBlock)cacheBlock
                       refreshed:(BOXCollaborationBlock)refreshBlock;

@end
