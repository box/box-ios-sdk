//
//  BOXFileUploadRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@class ALAsset;
@class ALAssetsLibrary;

@interface BOXFileUploadRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, strong) NSString *fileName;
@property (nonatomic, readonly, strong) NSString *folderID;
@property (nonatomic, readonly, strong) ALAsset *asset;
@property (nonatomic, readonly, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, readwrite, strong) NSDate *contentCreatedAt;
@property (nonatomic, readwrite, strong) NSDate *contentModifiedAt;
@property (nonatomic, readwrite, assign) BOOL requestAllFileFields;
// This setting uses the locally generated SHA1 hash of the file to ensure that the
// file is not corrputed in transit. Settings this value to YES will result in a delay
// before the upload actually begins as the hash is calculated. The default is NO.
@property (nonatomic, readwrite, assign) BOOL enableCheckForCorruptionInTransit;

- (instancetype)initWithPath:(NSString *)filePath targetFolderID:(NSString *)folderID;
- (instancetype)initWithName:(NSString *)fileName targetFolderID:(NSString *)folderID data:(NSData *)data;
- (instancetype)initWithALAsset:(ALAsset *)asset assetsLibrary:(ALAssetsLibrary *)assetsLibrary targetForlderID:(NSString *)folderID;
- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock completion:(BOXFileBlock)completionBlock;

@end
