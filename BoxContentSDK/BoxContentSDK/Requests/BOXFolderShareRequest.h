//
//  BOXFolderShareRequest.h
//  BoxContentSDK
//

#import "BOXItemShareRequest.h"

@interface BOXFolderShareRequest : BOXItemShareRequest

- (instancetype)initWithFolderID:(NSString *)folderID;
- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock;

@end
