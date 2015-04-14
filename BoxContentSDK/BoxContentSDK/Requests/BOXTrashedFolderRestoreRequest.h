//
//  BOXTrashedFolderRestoreRequest.h
//  BoxContentSDK
//

#import "BOXRequest_Private.h"

@interface BOXTrashedFolderRestoreRequest : BOXRequest

@property (nonatomic, readonly, strong) NSString *folderID;

@property (nonatomic, readwrite, strong) NSString *folderName;

@property (nonatomic, readwrite, strong) NSString *parentFolderID;

- (instancetype)initWithFolderID:(NSString *)folderID;
- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock;

@end
