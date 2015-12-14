//
//  BOXFileUploadNewVersionRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFileUploadNewVersionRequest.h"

#import "BOXAPIMultipartToJSONOperation.h"
#import "BOXAssetInputStream.h"
#import "BOXFile.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface BOXFileUploadNewVersionRequest ()

@property (nonatomic, readwrite, strong) NSString *localFilePath;
@property (nonatomic, readwrite, strong) NSData *fileData;

@end

@implementation BOXFileUploadNewVersionRequest

- (instancetype)initWithFileID:(NSString *)fileID localPath:(NSString *)localPath
{
    if (self = [super init]) {
        _localFilePath = localPath;
        _fileID = fileID;
    }
    
    return self;
}

- (instancetype)initWithFileID:(NSString *)fileID data:(NSData *)data
{
    if (self = [super init]) {
        _fileData = data;
        _fileID = fileID;
    }
    
    return self;
}

- (instancetype)initWithFileID:(NSString *)fileID
                       ALAsset:(ALAsset *)asset
                 assetsLibrary:(ALAssetsLibrary *)assetsLibrary
{
    if (self = [super init]) {
        _fileID = fileID;
        _asset = asset;
        _assetsLibrary = assetsLibrary;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self uploadURLWithResource:BOXAPIResourceFiles
                                          ID:self.fileID
                                 subresource:BOXAPISubresourceContent];
    
    NSDictionary *queryParameters = nil;
    
    if (self.requestAllFileFields) {
        queryParameters = @{BOXAPIParameterKeyFields: [self fullFileFieldsParameterString]};
    }
    
    BOXAPIMultipartToJSONOperation *operation = [[BOXAPIMultipartToJSONOperation alloc] initWithURL:URL
                                                                                         HTTPMethod:BOXAPIHTTPMethodPOST
                                                                                               body:nil
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
                                              filename:@"" // Box API ignores the filename when uploading a new version.
                                              MIMEType:nil];
    } else if (self.fileData != nil) {
        [operation appendMultipartPieceWithData:self.fileData
                                      fieldName:BOXAPIMultipartParameterFieldKeyFile
                                       filename:@"" // Box API ignores the filename when uploading a new version.
                                       MIMEType:nil];
    } else if (self.asset != nil) {
        BOXAssetInputStream *inputStream =
            [[BOXAssetInputStream alloc] initWithAssetRepresentation:self.asset.defaultRepresentation
                                                       assetsLibrary:self.assetsLibrary];

        [operation appendMultipartPieceWithInputStream:inputStream
                                         contentLength:self.asset.defaultRepresentation.size
                                             fieldName:BOXAPIMultipartParameterFieldKeyFile
                                              filename:@""
                                              MIMEType:nil];
    } else {
        BOXAssertFail(@"The File Upload Request was not given an existing file path to upload from or data to upload.");
    }
    
    if ([self.matchingEtag length] > 0) {
        [operation.APIRequest setValue:self.matchingEtag forHTTPHeaderField:BOXAPIHTTPHeaderIfMatch];
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
        
        if ([self.cacheClient respondsToSelector:@selector(cacheFileUploadNewVersionRequest:withFile:error:)]) {
            [self.cacheClient cacheFileUploadNewVersionRequest:self withFile:file error:nil];
        }
        
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(file, nil);
            } onMainThread:isMainThread];
        }
    };
    uploadOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
        if ([self.cacheClient respondsToSelector:@selector(cacheFileUploadNewVersionRequest:withFile:error:)]) {
            [self.cacheClient cacheFileUploadNewVersionRequest:self withFile:nil error:error];
        }
        
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        }
    };
    [self performRequest];
}

#pragma mark - Superclass overidden methods

- (NSString *)itemIDForSharedLink
{
    return self.fileID;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeFile;
}

@end
