//
//  BOXURLSessionManager.m
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 12/15/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import "BOXURLSessionManager.h"
#import "BOXLog.h"

NS_ASSUME_NONNULL_BEGIN

@implementation BOXURLSessionTaskCompletionInfo
@end

@implementation BOXURLSessionDownloadTaskCompletionInfo
@end

@implementation BOXURLSessionUploadTaskCompletionInfo
@end


@interface BOXURLSessionCacheClient : NSObject

@property (nonatomic, copy, readwrite) BOXEncryptCompletionInfoBlock encryptCompletionInfo;

@property (nonatomic, copy, readwrite) BOXDecryptCompletionInfoBlock decryptCompletionInfo;

@property (nonatomic, strong, readonly) NSString *cacheFolderPath;

@property (nonatomic, weak, readwrite) id<BOXURLSessionTaskCacheAssistantDelegate> cacheAssistant;

- (id)initWithCacheFolderPath:(NSString *)cacheFolderPath;

- (BOOL)cacheSessionTaskId:(NSUInteger)sessionTaskId withDownloadedFilePath:(NSString *)downloadedFilePath;

- (BOOL)cacheSessionTaskId:(NSUInteger)sessionTaskId withResonse:(NSURLResponse *)response error:(NSError *)error;

- (BOXURLSessionTaskCompletionInfo *)retrieveCompletionInfoForSessionTaskId:(NSUInteger)sessionTaskId;

- (void)removeCompletionInfoForSessionTaskId:(NSUInteger)sessionTaskId;

@end

@implementation BOXURLSessionCacheClient

@synthesize cacheFolderPath = _cacheFolderPath;

static const NSString *cacheFolderPath = @"urlSessionManagerCacheFolder";

- (id)init
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentRootPath = [documentPaths objectAtIndex:0];
    NSString *folderPath = [documentRootPath stringByAppendingPathComponent:cacheFolderPath];

    return [self initWithCacheFolderPath:folderPath];
}

- (id)initWithCacheFolderPath:(NSString *)cacheFolderPath
{
    self = [super init];
    if (self != nil) {
        if (cacheFolderPath != nil) {
            //create if not exists
            if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFolderPath isDirectory:nil] == NO) {
                [[NSFileManager defaultManager] createDirectoryAtPath:cacheFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            _cacheFolderPath = cacheFolderPath;
        }
    }
    return self;
}

- (BOOL)cacheSessionTaskId:(NSUInteger)sessionTaskId withDownloadedFilePath:(NSString *)downloadedFilePath
{
    return [self cacheSessionTaskId:sessionTaskId withDownloadedFilePath:downloadedFilePath resonse:nil error:nil];
}

- (BOOL)cacheSessionTaskId:(NSUInteger)sessionTaskId withResonse:(NSURLResponse *)response error:(NSError *)error
{
    return [self cacheSessionTaskId:sessionTaskId withDownloadedFilePath:nil resonse:response error:error];
}

- (BOOL)cacheSessionTaskId:(NSUInteger)sessionTaskId withDownloadedFilePath:(NSString *)downloadedFilePath resonse:(NSURLResponse *)response error:(NSError *)error
{
    if ([self.cacheAssistant shouldCacheSessionTaskId:sessionTaskId] == YES) {
        @synchronized (self) {
            BOXURLSessionTaskCompletionInfo *info = [self retrieveCompletionInfoForSessionTaskId:sessionTaskId];
            BOXURLSessionDownloadTaskCompletionInfo *downloadInfo = nil;

            BOOL res = NO;
            if (info == nil || [info isKindOfClass:[BOXURLSessionDownloadTaskCompletionInfo class]] == YES) {
                downloadInfo = info == nil ? [[BOXURLSessionDownloadTaskCompletionInfo alloc] init] : (BOXURLSessionDownloadTaskCompletionInfo *)info;
                downloadInfo.downloadedFilePath = downloadedFilePath;
                downloadInfo.response = response;
                downloadInfo.error = error;
                res = [self cacheSessionTaskId:sessionTaskId completionInfo:downloadInfo];
            }

            return res;
        }
    }
}

- (BOOL)cacheSessionTaskId:(NSUInteger)sessionTaskId completionInfo:(BOXURLSessionTaskCompletionInfo *)completionInfo
{
    if ([self.cacheAssistant shouldCacheSessionTaskId:sessionTaskId] == YES) {
        @synchronized (self) {
            NSString *path = [self pathToSessionTaskId:sessionTaskId];
            if (self.encryptCompletionInfo == nil) {
                return [NSKeyedArchiver archiveRootObject:completionInfo toFile:path];
            } else {
                NSData *encryptedCompletionInfo = self.encryptCompletionInfo(completionInfo);
                return [NSKeyedArchiver archiveRootObject:encryptedCompletionInfo toFile:path];
            }
        }
    }
}

- (BOXURLSessionTaskCompletionInfo *)retrieveCompletionInfoForSessionTaskId:(NSUInteger)sessionTaskId
{
    @synchronized (self) {
        NSString *path = [self pathToSessionTaskId:sessionTaskId];
        if (self.decryptCompletionInfo == nil) {
            return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        } else {
            NSData *encryptedCompletionInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            return self.decryptCompletionInfo(encryptedCompletionInfo);
        }
    }
}

- (NSString *)pathToSessionTaskId:(NSUInteger)sessionTaskId
{
    return  [self.cacheFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", sessionTaskId]];
}

- (BOOL)removeCompletionInfoForSessionTaskId:(NSUInteger)sessionTaskId
{
    @synchronized (self) {
        NSString *path = [self pathToSessionTaskId:sessionTaskId];
        return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

@end


@interface BOXURLSessionManager() <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate, NSURLSessionStreamDelegate>

//Default NSURLSession to be used by NSURLSessionTask which does not need to be run in the background
@property (nonatomic, readwrite, strong) NSURLSession *defaultSession;

//Progress NSURLSession to be used by NSURLSessionTask which needs progress reporting during the life of the tasks
//but does not need to be in the background. e.g. non-background download, upload tasks
@property (nonatomic, readwrite, strong) NSURLSession *progressSession;

//Background NSURLSession to be used by downloads/uploads which needs to be run in the background even if app terminates
@property (nonatomic, readwrite, strong) NSURLSession *backgroundSession;

//A delegate to handle callbacks from session tasks that do not have associated task delegates
//This is possible if the background tasks were created outside of this BOXURLSessionManager (e.g. app restarts)
//A task delegate can always be re-associated back with a session task by calling associateSessionTaskId:withTaskDelegate:
//@property (nonatomic, strong, readwrite) id<BOXURLSessionManagerDelegate> defaultDelegate;

//a map to associate a session task with its task delegate
//during session/task's delegate callbacks, we call appropriate methods on task delegate
@property (nonatomic, readonly, strong) NSMapTable<NSNumber *, id<BOXURLSessionTaskDelegate>> *urlSessionTaskIdToTaskDelegate;

@property (nonatomic, weak, readonly) id<BOXURLSessionManagerDelegate> managerDelegate;

@property (nonatomic, weak, readonly) id<BOXURLSessionTaskCacheAssistantDelegate> cacheAssistant;

@property (nonatomic, weak, readonly) BOXURLSessionCacheClient *cacheClient;

@end

static NSString *backgroundSessionIdentifier = @"com.box.BOXURLSessionManager.backgroundSessionIdentifier";

@implementation BOXURLSessionManager

@synthesize urlSessionTaskIdToTaskDelegate = _urlSessionTaskIdToTaskDelegate;
@synthesize cacheClient = _cacheClient;
@synthesize managerDelegate = _managerDelegate;
@synthesize cacheAssistant = _cacheAssistant;

- (id)init
{
    self = [super init];
    if (self != nil) {
        _urlSessionTaskIdToTaskDelegate = [NSMapTable strongToWeakObjectsMapTable];
    }
    return self;
}

- (NSURLSession *)createDefaultSession
{
    if (_defaultSession == nil) {
        //FIXME: revisit configuration for url session and its operation queue
        //arbitrary maxConcurrentOperationCount given that the number should not go above
        //the max number of concurrent Box api operations
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.name = @"com.box.BOXURLSessionManager.default";
        queue.maxConcurrentOperationCount = 8;

        _defaultSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:queue];
    }
    return _defaultSession;
}

- (NSURLSession *)createProgressSession
{
    if (_progressSession == nil) {
        //FIXME: revisit configuration for url session and its operation queue
        //arbitrary maxConcurrentOperationCount given that the number should not go above
        //the max number of concurrent Box api operations
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.name = @"com.box.BOXURLSessionManager.progress";
        queue.maxConcurrentOperationCount = 8;

        _progressSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:queue];
    }
    return _progressSession;
}

- (NSURLSession *)createBackgroundSession
{
    if (_backgroundSession == nil) {
        //FIXME: revisit configuration for url session and its operation queue
        //arbitrary maxConcurrentOperationCount given that the number should not go above
        //the max number of concurrent Box api operations
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:backgroundSessionIdentifier];

        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.name = @"com.box.BOXURLSessionManager.background";
        queue.maxConcurrentOperationCount = 8;

        _backgroundSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:queue];
    }
    return _backgroundSession;
}

#pragma mark - public methods

- (void)setUpWithManagerDelegate:(id<BOXURLSessionManagerDelegate>)managerDelegate cacheAssistant:(id<BOXURLSessionTaskCacheAssistantDelegate>)cacheAssistant;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _managerDelegate = managerDelegate;
        _cacheAssistant = cacheAssistant;
        _cacheClient = [[BOXURLSessionCacheClient alloc] init];
        _cacheClient.cacheAssistant = self.cacheAssistant;

        self.defaultSession = [self createDefaultSession];
        self.progressSession = [self createProgressSession];
        self.backgroundSession = [self createBackgroundSession];

        //FIXME: build up the mapping of sessionTaskId to sessionTask for ongoing tasks
    });
}

- (void)pendingBackgroundDownloadUploadSessionTasks:(void (^)(NSArray<NSURLSessionUploadTask *> * uploadTasks, NSArray<NSURLSessionDownloadTask *> * downloadTasks))completion
{
    if (completion != nil) {
        [self.backgroundSession getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
            completion(uploadTasks, downloadTasks);
        }];
    }
}

- (void)taskDelegate:(id<BOXURLSessionTaskDelegate>)taskDelegate becomesDelegateForSessionTaskId:(NSUInteger)sessionTaskId
{
    @synchronized (self.urlSessionTaskIdToTaskDelegate) {
        [self.urlSessionTaskIdToTaskDelegate setObject:taskDelegate forKey:@(sessionTaskId)];
    }
    [self.managerDelegate associateUrlSessionTaskId:sessionTaskId withDelegateId:taskDelegate.urlSessionTaskDelegateId];
}

- (void)taskDelegate:(id<BOXURLSessionTaskDelegate>)taskDelegate stopsBeingDelegateForSessionTaskId:(NSUInteger)sessionTaskId
{
    if (taskDelegate != nil) {
        @synchronized (self.urlSessionTaskIdToTaskDelegate) {
            id<BOXURLSessionTaskDelegate> currentTaskDelegate = [self.urlSessionTaskIdToTaskDelegate objectForKey:@(sessionTaskId)];
            if (currentTaskDelegate == taskDelegate) {
                [self.urlSessionTaskIdToTaskDelegate removeObjectForKey:@(sessionTaskId)];
                [self.managerDelegate dessociateUrlSessionTaskId:sessionTaskId fromDelegateId:taskDelegate.urlSessionTaskDelegateId];
            }
        }
    }
}

- (void)stopDelegateForSessionTaskId:(NSUInteger)sessionTaskId
{
    @synchronized (self.urlSessionTaskIdToTaskDelegate) {
        id<BOXURLSessionTaskDelegate> taskDelegate = [self.urlSessionTaskIdToTaskDelegate objectForKey:@(sessionTaskId)];
        [self.urlSessionTaskIdToTaskDelegate removeObjectForKey:@(sessionTaskId)];

        if (taskDelegate != nil) {
            [self.managerDelegate dessociateUrlSessionTaskId:sessionTaskId fromDelegateId:taskDelegate.urlSessionTaskDelegateId];
        }
    }
}

- (NSURLSessionDataTask *)createDataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler
{
    return [self.defaultSession dataTaskWithRequest:request completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)createNonBackgroundDownloadTaskWithRequest:(NSURLRequest *)request taskDelegate:(id <BOXURLSessionDownloadTaskDelegate>)taskDelegate
{
   return [self.progressSession dataTaskWithRequest:request];
}

- (NSURLSessionDownloadTask *)createBackgroundDownloadTaskWithRequest:(NSURLRequest *)request taskDelegate:(id <BOXURLSessionDownloadTaskDelegate>)taskDelegate
{
    return [self.backgroundSession downloadTaskWithRequest:request];
}

- (NSURLSessionDownloadTask *)createBackgroundDownloadTaskWithResumeData:(NSData *)resumeData taskDelegate:(id <BOXURLSessionDownloadTaskDelegate>)taskDelegate
{
    return [self.backgroundSession downloadTaskWithResumeData:resumeData];
}

- (NSURLSessionUploadTask *)createBackgroundUploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL taskDelegate:(id <BOXURLSessionUploadTaskDelegate>)taskDelegate
{
    return [self.backgroundSession uploadTaskWithRequest:request fromFile:fileURL];
}

- (NSURLSessionUploadTask *)createNonBackgroundUploadTaskWithStreamedRequest:(NSURLRequest *)request taskDelegate:(id <BOXURLSessionUploadTaskDelegate>)taskDelegate
{
    return [self.progressSession uploadTaskWithStreamedRequest:request];
}

- (BOXURLSessionTaskCompletionInfo *)retrieveCompletionInfoForSessionTaskId:(NSUInteger)sessionTaskId
{
    [self.cacheClient retrieveCompletionInfoForSessionTaskId:sessionTaskId];
}

- (void)removeCompletionInfoForSessionTaskId:(NSUInteger)sessionTaskId
{
    [self.cacheClient removeCompletionInfoForSessionTaskId:sessionTaskId];
}

#pragma mark - implementations for NSURLSession-related delegates for advanced session

#pragma mark - NSURLSessionDownloadDelegate

/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    id<BOXURLSessionTaskDelegate> taskDelegate = [self.urlSessionTaskIdToTaskDelegate objectForKey:@(downloadTask.taskIdentifier)];
    if ([taskDelegate conformsToProtocol:@protocol(BOXURLSessionDownloadTaskDelegate)]) {
        id<BOXURLSessionDownloadTaskDelegate> downloadTaskDelegate = (id<BOXURLSessionDownloadTaskDelegate>)taskDelegate;

        if ([downloadTaskDelegate respondsToSelector:@selector(downloadTask:didFinishDownloadingToURL:)]) {
            [downloadTaskDelegate downloadTask:downloadTask didFinishDownloadingToURL:location];
        }
    } else {
        NSString *newFilePath = [self.managerDelegate defaultHandleOfDownloadedFileAtURL:location];
        [self.cacheClient cacheSessionTaskId:downloadTask.taskIdentifier withDownloadedFilePath:newFilePath];
    }
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    id<BOXURLSessionTaskDelegate> taskDelegate = [self.urlSessionTaskIdToTaskDelegate objectForKey:@(downloadTask.taskIdentifier)];
    if ([taskDelegate conformsToProtocol:@protocol(BOXURLSessionDownloadTaskDelegate)]) {
        id<BOXURLSessionDownloadTaskDelegate> downloadTaskDelegate = (id<BOXURLSessionDownloadTaskDelegate>)taskDelegate;

        if ([downloadTaskDelegate respondsToSelector:@selector(downloadTask:didWriteTotalBytes:totalBytesExpectedToWrite:)]) {
            [downloadTaskDelegate downloadTask:downloadTask didWriteTotalBytes:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
        }
    }
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    id<BOXURLSessionTaskDelegate> taskDelegate = [self.urlSessionTaskIdToTaskDelegate objectForKey:@(dataTask.taskIdentifier)];
    if ([taskDelegate respondsToSelector:@selector(processIntermediateResponse:)]) {
        [taskDelegate processIntermediateResponse:response];
    }
    completionHandler(NSURLSessionResponseAllow);
}

/* Sent when data is available for the delegate to consume.  It is
 * assumed that the delegate will retain and not copy the data.  As
 * the data may be discontiguous, you should use
 * [NSData enumerateByteRangesUsingBlock:] to access it.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    id<BOXURLSessionTaskDelegate> taskDelegate = [self.urlSessionTaskIdToTaskDelegate objectForKey:@(dataTask.taskIdentifier)];
    if ([taskDelegate respondsToSelector:@selector(processIntermediateData:)]) {
        [taskDelegate processIntermediateData:data];
    }
}

/* Sent periodically to notify the delegate of upload progress.  This
 * information is also available as properties of the task.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    id<BOXURLSessionTaskDelegate> taskDelegate = [self.urlSessionTaskIdToTaskDelegate objectForKey:@(task.taskIdentifier)];
    if ([taskDelegate conformsToProtocol:@protocol(BOXURLSessionUploadTaskDelegate)]) {
        id<BOXURLSessionUploadTaskDelegate> uploadTaskDelegate = (id<BOXURLSessionUploadTaskDelegate>)taskDelegate;
        if ([uploadTaskDelegate respondsToSelector:@selector(sessionTask:didSendTotalBytes:totalBytesExpectedToSend:)]) {
            [uploadTaskDelegate sessionTask:task didSendTotalBytes:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
        }
    }
}

#pragma mark - NSURLSessionTaskDelegate

/* Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    id<BOXURLSessionTaskDelegate> taskDelegate = [self.urlSessionTaskIdToTaskDelegate objectForKey:@(task.taskIdentifier)];
    if (taskDelegate != nil) {
        [taskDelegate sessionTask:task didFinishWithResponse:task.response error:error];
    } else {
        [self.cacheClient cacheSessionTaskId:task.taskIdentifier withResonse:task.response error:error];
    }
}

/* Sent if a task requires a new, unopened body stream.  This may be
 * necessary when authentication has failed for any request that
 * involves a body stream.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * _Nullable bodyStream))completionHandler
{
    NSInputStream *inputStream = nil;

    if (task.originalRequest.HTTPBodyStream && [task.originalRequest.HTTPBodyStream conformsToProtocol:@protocol(NSCopying)]) {
        inputStream = [task.originalRequest.HTTPBodyStream copy];
    } else {
        BOXLog(@"needNewBodyStream failed to get a new input stream from %@", task.originalRequest.HTTPBodyStream);
    }

    if (completionHandler) {
        completionHandler(inputStream);
    }
}

@end

NS_ASSUME_NONNULL_END
