//
//  BOXFolderShareRequest.h
//  BoxContentSDK
//

#import "BOXItemShareRequest.h"

@interface BOXFolderShareRequest : BOXItemShareRequest

@property (nonatomic, readonly, copy) NSString *folderID;

- (instancetype)initWithFolderID:(NSString *)folderID;
- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock;

@end
