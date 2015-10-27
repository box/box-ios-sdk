//
//  BOXFolderCollaborationsRequest.h
//  BoxContentSDK
//

#import "BOXRequest_Private.h"

@interface BOXFolderCollaborationsRequest : BOXRequest

@property (nonatomic, readonly, strong) NSString *folderID;

- (instancetype)initWithFolderID:(NSString *)folderID;
- (void)performRequestWithCompletion:(BOXCollaborationArrayCompletionBlock)completionBlock;
- (void)performRequestWithCached:(BOXCollaborationArrayCompletionBlock)cacheBlock
                       refreshed:(BOXCollaborationArrayCompletionBlock)refreshBlock;

@end
