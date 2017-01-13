//
//  BOXFileDownloadRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFileDownloadRequest.h"

#import "BOXAPIDataOperation.h"

@interface BOXFileDownloadRequest ()

@property (nonatomic, readonly, strong) NSString *destinationPath;
@property (nonatomic, readonly, strong) NSOutputStream *outputStream;
@property (nonatomic, readonly, strong) NSString *fileID;
@property (nonatomic, readwrite, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, readwrite, strong) BOXSessionTaskReplacedBlock downloadTaskReplacedBlock;
@end

@implementation BOXFileDownloadRequest

- (instancetype)initWithLocalDestination:(NSString *)destinationPath
                                  fileID:(NSString *)fileID;
{
    if (self = [super init]) {
        _destinationPath = destinationPath;
        _fileID = fileID;
    }
    return self;
}


- (instancetype)initWithLocalDestination:(NSString *)destinationPath
                                  fileID:(NSString *)fileID
                            downloadTask:(NSURLSessionDownloadTask *)downloadTask
                downloadTaskReplacedBlock:(BOXSessionTaskReplacedBlock)downloadTaskReplacedBlock
{
    self = [self initWithLocalDestination:destinationPath fileID:fileID];
    self.downloadTask = downloadTask;
    self.downloadTaskReplacedBlock = downloadTaskReplacedBlock;
    return self;
}

- (instancetype)initWithOutputStream:(NSOutputStream *)outputStream
                              fileID:(NSString *)fileID
{
    if (self = [super init]) {
        _outputStream = outputStream;
        _fileID = fileID;
    }
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:BOXAPISubresourceContent
                                 subID:nil];

    NSDictionary *queryParameters = nil;

    if (self.versionID.length > 0) {
        queryParameters = @{BOXAPIParameterKeyFileVersion : self.versionID};
    }

    BOXAPIDataOperation *dataOperation = [self dataOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:nil
                                                       successBlock:nil
                                                       failureBlock:nil
                                                        sessionTask:self.downloadTask
                                            sessionTaskReplacedBlock:self.downloadTaskReplacedBlock];

    dataOperation.modelID = self.fileID;
    
    BOXAssert(self.outputStream != nil || self.destinationPath != nil, @"An output stream or destination file path must be specified.");
    BOXAssert(!(self.outputStream != nil && self.destinationPath != nil), @"You cannot specify both an outputStream and a destination file path.");

    dataOperation.outputStream = self.outputStream;
    dataOperation.destinationPath = self.destinationPath;
    [self addSharedLinkHeaderToRequest:dataOperation.APIRequest];

    return dataOperation;
}

- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock completion:(BOXErrorBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];

        BOXAPIDataOperation *fileOperation = (BOXAPIDataOperation *)self.operation;
        if (progressBlock) {
            fileOperation.progressBlock = ^(long long expectedTotalBytes, unsigned long long bytesReceived) {
                [BOXDispatchHelper callCompletionBlock:^{
                    progressBlock(bytesReceived, expectedTotalBytes);
                } onMainThread:isMainThread];
            };
        }

        fileOperation.successBlock = ^(NSString *modelID, long long expectedTotalBytes) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil);
            } onMainThread:isMainThread];
        };
        fileOperation.failureBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(error);
            } onMainThread:isMainThread];
        };
        [self performRequest];
    }
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
