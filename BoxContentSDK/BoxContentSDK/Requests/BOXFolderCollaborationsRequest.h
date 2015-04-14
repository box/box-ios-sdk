//
//  BOXFolderCollaborationsRequest.h
//  BoxContentSDK
//

#import "BOXRequest_Private.h"

@interface BOXFolderCollaborationsRequest : BOXRequest

- (instancetype)initWithFolderID:(NSString *)folderID;
- (void)performRequestWithCompletion:(BOXCollaborationArrayCompletionBlock)completionBlock;

@end
