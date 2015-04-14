//
//  BOXTrashedFileRestoreRequest.h
//  BoxContentSDK
//

#import "BOXRequest_Private.h"

@interface BOXTrashedFileRestoreRequest : BOXRequest

@property (nonatomic, readonly, strong) NSString *fileID;

@property (nonatomic, readwrite, strong) NSString *fileName;

@property (nonatomic, readwrite, strong) NSString *parentFolderID;

- (instancetype)initWithFileID:(NSString *)fileID;
- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock;

@end
