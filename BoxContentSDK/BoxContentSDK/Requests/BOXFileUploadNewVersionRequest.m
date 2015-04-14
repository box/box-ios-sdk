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
    
    BOXAPIMultipartToJSONOperation *operation = [[BOXAPIMultipartToJSONOperation alloc] initWithURL:URL
                                                                                         HTTPMethod:BOXAPIHTTPMethodPOST
                                                                                               body:nil
                                                                                        queryParams:nil
                                                                                      OAuth2Session:self.queueManager.OAuth2Session];
    
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
    if (progressBlock) {
        uploadOperation.progressBlock = ^(unsigned long long totalBytes, unsigned long long bytesSent) {
            [BOXDispatchHelper callCompletionBlock:^{
                progressBlock(bytesSent, totalBytes);
            } onMainThread:isMainThread];
        };
    }
    if (completionBlock) {
        uploadOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            BOXFile *file = [[BOXFile alloc] initWithJSON:JSONDictionary];
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(file, nil);
            } onMainThread:isMainThread];
        };
        uploadOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        };
    }
    
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
