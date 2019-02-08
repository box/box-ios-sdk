//
//  BOXFolderShareRequest.h
//  BoxContentSDK
//

#import "BOXItemShareRequest.h"

@interface BOXFolderShareRequest : BOXItemShareRequest

@property (nonatomic, readonly, strong) NSString *folderID;

- (instancetype)initWithFolderID:(NSString *)folderID;
- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock;

@end
