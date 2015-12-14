//
//  BOXFileUploadRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFileUploadRequest.h"

#import "BOXAPIMultipartToJSONOperation.h"
#import "BOXAssetInputStream.h"
#import "BOXFile.h"
#import "BOXLog.h"
#import "BOXHashHelper.h"
#import "NSString+BOXURLHelper.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface BOXFileUploadRequest ()

@property (nonatomic, readwrite, strong) NSString *localFilePath;
@property (nonatomic, readwrite, strong) NSData *fileData;

@end

@implementation BOXFileUploadRequest

- (instancetype)initWithName:(NSString *)fileName
              targetFolderID:(NSString *)folderID
{
    if (self = [super init]) {
        _fileName = fileName;
        _folderID = folderID;
    }

    return self;
}

- (instancetype)initWithPath:(NSString *)filePath
              targetFolderID:(NSString *)folderID
{
    if (self = [self initWithName:[filePath lastPathComponent] targetFolderID:folderID]) {
        _localFilePath = filePath;
    }

    return self;
}

- (instancetype)initWithName:(NSString *)fileName
              targetFolderID:(NSString *)folderID
                        data:(NSData *)data
{
    if (self = [self initWithName:fileName targetFolderID:folderID]) {
        _fileData = data;
    }

    return self;
}

- (instancetype)initWithALAsset:(ALAsset *)asset
                  assetsLibrary:(ALAssetsLibrary *)assetsLibrary
                targetForlderID:(NSString *)folderID
{    
    if (self = [self initWithName:asset.defaultRepresentation.filename targetFolderID:folderID] ) {
        _asset = asset;
        _assetsLibrary = assetsLibrary;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self uploadURLWithResource:BOXAPIResourceFiles
                                          ID:nil
                                 subresource:BOXAPISubresourceContent];
    
    NSDictionary *queryParameters = nil;
    
    if (self.requestAllFileFields) {
        queryParameters = @{BOXAPIParameterKeyFields: [self fullFileFieldsParameterString]};
    }

    // Body Form Elements Parameters
    // The only parameters allowed in multipart form requests for files are name, parent ID,
    // content created at, and content modified at.
    NSMutableDictionary *multipartBodyParameters = [NSMutableDictionary dictionary];
    // Name
    NSString *fileName = [self nonEmptyFilename:self.fileName];
    multipartBodyParameters[BOXAPIObjectKeyName] = fileName;
    // Parent ID
    NSString *parentIDString = self.folderID;

    if ([parentIDString length] == 0) {
        parentIDString = BOXAPIFolderIDRoot;
    }

    multipartBodyParameters[BOXAPIMultipartParameterFieldKeyParentID] = parentIDString;

    // Content created at
    if (self.contentCreatedAt != nil) {
        multipartBodyParameters[BOXAPIObjectKeyContentCreatedAt] = [self.contentCreatedAt box_ISO8601String];
    }

    // Content modified at
    if (self.contentModifiedAt != nil) {
        multipartBodyParameters[BOXAPIObjectKeyContentModifiedAt] = [self.contentModifiedAt box_ISO8601String];
    }

    BOXAPIMultipartToJSONOperation *operation =
        [[BOXAPIMultipartToJSONOperation alloc] initWithURL:URL
                                                 HTTPMethod:BOXAPIHTTPMethodPOST
                                                       body:multipartBodyParameters
                                                queryParams:queryParameters
                                              session:self.queueManager.session];

    if ([self.localFilePath length] > 0 && [[NSFileManager defaultManager] fileExistsAtPath:self.localFilePath]) {
        NSInputStream *inputStream = [[NSInputStream alloc] initWithFileAtPath:self.localFilePath];

        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.localFilePath
                                                                                        error:nil];
        unsigned long long contentLength = [fileAttributes fileSize];

        [operation appendMultipartPieceWithInputStream:inputStream
                                         contentLength:contentLength
                                             fieldName:BOXAPIMultipartParameterFieldKeyFile
                                              filename:fileName
                                              MIMEType:nil];
    } else if (self.fileData != nil) {
        [operation appendMultipartPieceWithData:self.fileData
                                      fieldName:BOXAPIMultipartParameterFieldKeyFile
                                       filename:fileName
                                       MIMEType:nil];
    } else if (self.asset != nil) {
        BOXAssetInputStream *inputStream =
            [[BOXAssetInputStream alloc] initWithAssetRepresentation:self.asset.defaultRepresentation
                                                       assetsLibrary:self.assetsLibrary];

        [operation appendMultipartPieceWithInputStream:inputStream
                                         contentLength:self.asset.defaultRepresentation.size
                                             fieldName:BOXAPIMultipartParameterFieldKeyFile
                                              filename:fileName
                                              MIMEType:nil];
    } else {
        BOXAssertFail(@"The File Upload Request was not given an existing file path to upload from or data to upload.");
    }

    if (self.enableCheckForCorruptionInTransit) {
        // Set up the Content-MD5 header
        [operation.APIRequest setValue:[self fileSHA1] forHTTPHeaderField:BOXAPIHTTPHeaderContentMD5];
    }

    return operation;
}

- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock completion:(BOXFileBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIMultipartToJSONOperation *uploadOperation = (BOXAPIMultipartToJSONOperation *)self.operation;
    
    // Unlike other operation types, BOXAPIMultipartToJSONOperation cannot be gracefully re-enqueued if the access token is expired (and can be refreshed).
    // In order to minimize the risk of a failed request due to an expired access token, more aggressively check if it is expired, and refresh it manually
    // beforehand if necessary.
    if ([self.operation.session.accessTokenExpiration timeIntervalSinceNow] < 300) {
        // We rely on our operations layer to block the upload request until this is done, because
        // BOXParallelOAuth2Session cannot reliably call the completion block. (See TODO in [BOXParallelOAuth2Session:performRefreshTokenGrant:withCompletionBlock]
        [self.operation.session performRefreshTokenGrant:self.operation.session.accessToken withCompletionBlock:nil];
    }
    
    if (progressBlock) {
        uploadOperation.progressBlock = ^(unsigned long long totalBytes, unsigned long long bytesSent) {
            [BOXDispatchHelper callCompletionBlock:^{
                progressBlock(bytesSent, totalBytes);
            } onMainThread:isMainThread];
        };
    }
    
    uploadOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
        BOXFile *file = [[BOXFile alloc] initWithJSON:JSONDictionary];

        if ([self.cacheClient respondsToSelector:@selector(cacheFileUploadRequest:withFile:error:)]) {
            [self.cacheClient cacheFileUploadRequest:self withFile:file error:nil];
        }
        
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(file, nil);
            } onMainThread:isMainThread];
        }
    };
    uploadOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
        if ([self.cacheClient respondsToSelector:@selector(cacheFileUploadRequest:withFile:error:)]) {
            [self.cacheClient cacheFileUploadRequest:self withFile:nil error:error];
        }
        
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        }
    };
    [self performRequest];
}

#pragma mark - Helper Methods

- (NSString *)nonEmptyFilename:(NSString *)filename
{
    if ([filename length] == 0) {
        if ([self.localFilePath length] > 0) {
            filename = [self.localFilePath lastPathComponent];
        } else {
            filename = [super nonEmptyFilename:filename];
        }
    }

    return filename;
}

- (NSString *)fileSHA1
{
    NSString *hash = nil;

    if ([self.localFilePath length] > 0 && [[NSFileManager defaultManager] fileExistsAtPath:self.localFilePath]) {
        hash = [BOXHashHelper sha1HashOfFileAtPath:self.localFilePath];
    } else if (self.fileData != nil) {
        hash = [BOXHashHelper sha1HashOfData:self.fileData];
    } else if (self.asset != nil) {
        hash = [BOXHashHelper sha1HashOfALAsset:self.asset];
    } else {
        BOXAssertFail(@"The File Upload Request was not given an existing file path or data to calculate the hash from.");
    }

    return hash;
}

#pragma mark - Superclass overidden methods

- (NSString *)itemIDForSharedLink
{
    return self.folderID;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeFolder;
}

@end
