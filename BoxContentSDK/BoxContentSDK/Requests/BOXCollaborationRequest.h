//
//  BOXCollaborationRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"

@interface BOXCollaborationRequest : BOXRequest

@property (nonatomic, readonly, strong) NSString *collaborationID;

- (instancetype)initWithCollaborationID:(NSString *)collaborationID;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCompletion:(BOXCollaborationBlock)completionBlock;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCached:(BOXCollaborationBlock)cacheBlock
                       refreshed:(BOXCollaborationBlock)refreshBlock;

@end
