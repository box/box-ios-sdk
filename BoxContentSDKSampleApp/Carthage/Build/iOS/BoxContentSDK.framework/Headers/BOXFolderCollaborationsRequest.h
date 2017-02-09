//
//  BOXFolderCollaborationsRequest.h
//  BoxContentSDK
//

#import "BOXRequest_Private.h"

@interface BOXFolderCollaborationsRequest : BOXRequest

@property (nonatomic, readonly, strong) NSString *folderID;

- (instancetype)initWithFolderID:(NSString *)folderID;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCompletion:(BOXCollaborationArrayCompletionBlock)completionBlock;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCached:(BOXCollaborationArrayCompletionBlock)cacheBlock
                       refreshed:(BOXCollaborationArrayCompletionBlock)refreshBlock;

@end
