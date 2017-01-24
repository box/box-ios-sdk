//
//  BOXFileUploadNewVersionRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileUploadNewVersionRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readonly, strong) NSString *fileID;
@property (nonatomic, readwrite, assign) BOOL requestAllFileFields;

@property (nonatomic, readwrite, strong) NSString *matchingEtag;

- (instancetype)initWithFileID:(NSString *)fileID localPath:(NSString *)localPath;

//initialize a request which will run in the background even if app terminates if tempUploadFilePath is provided
- (instancetype)initWithFileID:(NSString *)fileID localPath:(NSString *)localPath tempUploadFilePath:(NSString *)tempUploadFilePath;

- (instancetype)initWithFileID:(NSString *)fileID data:(NSData *)data;
- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock completion:(BOXFileBlock)completionBlock;

@end
