//
//  BOXFileUploadRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileUploadRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, strong) NSString *fileName;
@property (nonatomic, readonly, strong) NSString *folderID;
@property (nonatomic, readwrite, strong) NSDate *contentCreatedAt;
@property (nonatomic, readwrite, strong) NSDate *contentModifiedAt;
@property (nonatomic, readwrite, assign) BOOL requestAllFileFields;

- (instancetype)initWithPath:(NSString *)filePath targetFolderID:(NSString *)folderID;

//initialize a request which will run in the background even if app terminates if uploadMultipartCopyFilePath is provided
- (instancetype)initWithPath:(NSString *)filePath targetFolderID:(NSString *)folderID uploadMultipartCopyFilePath:(NSString *)uploadMultipartCopyFilePath associateId:(NSString *)associateId;

- (instancetype)initWithName:(NSString *)fileName targetFolderID:(NSString *)folderID data:(NSData *)data;
- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock completion:(BOXFileBlock)completionBlock;

@end
