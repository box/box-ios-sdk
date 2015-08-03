//
//  BOXFileUploadNewVersionRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@class ALAsset;
@class ALAssetsLibrary;

@interface BOXFileUploadNewVersionRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readonly, strong) NSString *fileID;
@property (nonatomic, readonly, strong) ALAsset *asset;
@property (nonatomic, readonly, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, readwrite, assign) BOOL requestAllFileFields;

@property (nonatomic, readwrite, strong) NSString *matchingEtag;

- (instancetype)initWithFileID:(NSString *)fileID localPath:(NSString *)localPath;
- (instancetype)initWithFileID:(NSString *)fileID data:(NSData *)data;
- (instancetype)initWithFileID:(NSString *)fileID
                       ALAsset:(ALAsset *)asset
                 assetsLibrary:(ALAssetsLibrary *)assetsLibrary;
- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock completion:(BOXFileBlock)completionBlock;

@end
