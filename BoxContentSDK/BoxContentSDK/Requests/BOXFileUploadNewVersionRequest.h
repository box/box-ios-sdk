//
//  BOXFileUploadNewVersionRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileUploadNewVersionRequest : BOXRequestWithSharedLinkHeader <BOXBackgroundRequestProtocol>

@property (nonatomic, readonly, strong) NSString *fileID;
@property (nonatomic, readwrite, assign) BOOL requestAllFileFields;

@property (nonatomic, readwrite, strong) NSString *matchingEtag;

- (instancetype)initWithFileID:(NSString *)fileID localPath:(NSString *)localPath;

//initialize a request which will run in the background even if app terminates if uploadMultipartCopyFilePath is provided
- (instancetype)initWithFileID:(NSString *)fileID localPath:(NSString *)localPath uploadMultipartCopyFilePath:(NSString *)uploadMultipartCopyFilePath associateID:(NSString *)associateID;

- (instancetype)initWithFileID:(NSString *)fileID data:(NSData *)data;
- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock completion:(BOXFileBlock)completionBlock;

@end
