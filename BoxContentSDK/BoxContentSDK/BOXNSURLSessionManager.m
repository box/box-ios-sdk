//
//  BOXNSURLSessionManager.m
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 12/15/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import "BOXNSURLSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BOXNSURLSessionManager() <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate, NSURLSessionStreamDelegate>

//Default NSURLSession to be used by NSURLSessionTask which does not need to be run in the background
@property (nonatomic, readwrite, strong) NSURLSession *defaultSession;

//Progress NSURLSession to be used by NSURLSessionTask which needs progress reporting during the life of the tasks
//but does not need to be in the background. e.g. non-background download, upload tasks
@property (nonatomic, readwrite, strong) NSURLSession *progressSession;

//Background NSURLSession to be used by downloads/uploads which needs to be run in the background even if app terminates
@property (nonatomic, readwrite, strong) NSURLSession *backgroundSession;

//A delegate to handle callbacks from session tasks that do not have associated task delegates
//This is possible if the background tasks were created outside of this BOXNSURLSessionManager (e.g. app restarts)
//A task delegate can always be re-associated back with a session task by calling associateSessionTaskId:withTaskDelegate:
@property (nonatomic, strong, readwrite) id<BOXNSURLSessionManagerDelegate> defaultDelegate;

//a map to associate a session task with its task delegate
//during session/task's delegate callbacks, we call appropriate methods on task delegate
@property (nonatomic, readonly, strong) NSMapTable<NSNumber *, id<BOXNSURLSessionTaskDelegate>> *sessionTaskIdToTaskDelegate;

@end

static const NSString *backgroundSessionIdentifier = @"com.box.BOXNSURLSessionManager.backgroundSessionIdentifier";

@implementation BOXNSURLSessionManager

@synthesize sessionTaskIdToTaskDelegate = _sessionTaskIdToTaskDelegate;

- (id)init
{
    self = [super init];
    if (self != nil) {
        _sessionTaskIdToTaskDelegate = [NSMapTable strongToWeakObjectsMapTable];
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
        queue.name = @"com.box.BOXNSURLSessionManager.default";
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
        queue.name = @"com.box.BOXNSURLSessionManager.progress";
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
        queue.name = @"com.box.BOXNSURLSessionManager.background";
        queue.maxConcurrentOperationCount = 8;

        _backgroundSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:queue];
    }
    return _backgroundSession;
}

#pragma mark - public methods

- (void)setUpWithDefaultDelegate:(id<BOXNSURLSessionManagerDelegate>)delegate
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.defaultDelegate = delegate;
        self.defaultSession = [self createDefaultSession];
        self.progressSession = [self createProgressSession];
        self.backgroundSession = [self createBackgroundSession];
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

- (void)associateSessionTaskId:(NSUInteger)sessionTaskId withTaskDelegate:(id <BOXNSURLSessionTaskDelegate> )taskDelegate
{
    @synchronized (self.sessionTaskIdToTaskDelegate) {
        [self.sessionTaskIdToTaskDelegate setObject:taskDelegate forKey:@(sessionTaskId)];
    }
}

- (void)dessociateSessionTaskId:(NSUInteger)sessionTaskId
{
    @synchronized (self.sessionTaskIdToTaskDelegate) {
        [self.sessionTaskIdToTaskDelegate removeObjectForKey:@(sessionTaskId)];
    }
}

- (NSURLSessionDataTask *)createDataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler
{
    return [self.defaultSession dataTaskWithRequest:request completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)createNonBackgroundDownloadTaskWithRequest:(NSURLRequest *)request taskDelegate:(id <BOXNSURLSessionDownloadTaskDelegate>)taskDelegate
{
    NSURLSessionTask *task = [self.progressSession dataTaskWithRequest:request];
    [self associateSessionTaskId:task.taskIdentifier withTaskDelegate:taskDelegate];
    return task;
}

- (NSURLSessionDownloadTask *)createBackgroundDownloadTaskWithRequest:(NSURLRequest *)request taskDelegate:(id <BOXNSURLSessionDownloadTaskDelegate>)taskDelegate
{
    NSURLSessionTask *task = [self.backgroundSession downloadTaskWithRequest:request];
    [self associateSessionTaskId:task.taskIdentifier withTaskDelegate:taskDelegate];
    return task;
}

- (NSURLSessionDownloadTask *)createBackgroundDownloadTaskWithResumeData:(NSData *)resumeData taskDelegate:(id <BOXNSURLSessionDownloadTaskDelegate>)taskDelegate
{
    NSURLSessionDownloadTask *task = [self.backgroundSession downloadTaskWithResumeData:resumeData];
    [self associateSessionTaskId:task.taskIdentifier withTaskDelegate:taskDelegate];
    return task;
}

- (NSURLSessionUploadTask *)createBackgroundUploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL taskDelegate:(id <BOXNSURLSessionUploadTaskDelegate>)taskDelegate
{
    NSURLSessionUploadTask *task = [self.backgroundSession uploadTaskWithRequest:request fromFile:fileURL];
    [self associateSessionTaskId:task.taskIdentifier withTaskDelegate:taskDelegate];
    return task;
}

- (NSURLSessionUploadTask *)createNonBackgroundUploadTaskWithStreamedRequest:(NSURLRequest *)request taskDelegate:(id <BOXNSURLSessionUploadTaskDelegate>)taskDelegate
{
    NSURLSessionUploadTask *task = [self.progressSession uploadTaskWithStreamedRequest:request];
    [self associateSessionTaskId:task.taskIdentifier withTaskDelegate:taskDelegate];
    return task;
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
    id<BOXNSURLSessionTaskDelegate> taskDelegate = [self.sessionTaskIdToTaskDelegate objectForKey:@(downloadTask.taskIdentifier)];
    if ([taskDelegate conformsToProtocol:@protocol(BOXNSURLSessionDownloadTaskDelegate)]) {
        id<BOXNSURLSessionDownloadTaskDelegate> downloadTaskDelegate = taskDelegate;

        if ([downloadTaskDelegate respondsToSelector:@selector(didFinishDownloadingToURL:)]) {
            [downloadTaskDelegate didFinishDownloadingToURL:location];
        }
    } else {
        [self.defaultDelegate downloadTask:downloadTask didFinishDownloadingToURL:location];
    }
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    id<BOXNSURLSessionTaskDelegate> taskDelegate = [self.sessionTaskIdToTaskDelegate objectForKey:@(downloadTask.taskIdentifier)];
    if ([taskDelegate conformsToProtocol:@protocol(BOXNSURLSessionDownloadTaskDelegate)]) {
        id<BOXNSURLSessionDownloadTaskDelegate> downloadTaskDelegate = taskDelegate;

        if ([downloadTaskDelegate respondsToSelector:@selector(progressWithTotalBytesWritten:totalBytesExpectedToWrite:)]) {
            [downloadTaskDelegate progressWithTotalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
        }
    } else {
        [self.defaultDelegate downloadTask:downloadTask totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    id<BOXNSURLSessionTaskDelegate> taskDelegate = [self.sessionTaskIdToTaskDelegate objectForKey:@(dataTask.taskIdentifier)];
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
    id<BOXNSURLSessionTaskDelegate> taskDelegate = [self.sessionTaskIdToTaskDelegate objectForKey:@(dataTask.taskIdentifier)];
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
    id<BOXNSURLSessionTaskDelegate> taskDelegate = [self.sessionTaskIdToTaskDelegate objectForKey:@(task.taskIdentifier)];
    if ([taskDelegate conformsToProtocol:@protocol(BOXNSURLSessionUploadTaskDelegate)]) {
        id<BOXNSURLSessionUploadTaskDelegate> uploadTaskDelegate = taskDelegate;
        if ([uploadTaskDelegate respondsToSelector:@selector(progressWithTotalBytesSent:totalBytesExpectedToSend:)]) {
            [uploadTaskDelegate progressWithTotalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
        }
    } else {
        [self.defaultDelegate uploadTask:task totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
    }
}

#pragma mark - NSURLSessionTaskDelegate

/* Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    id<BOXNSURLSessionTaskDelegate> taskDelegate = [self.sessionTaskIdToTaskDelegate objectForKey:@(task.taskIdentifier)];
    if (taskDelegate != nil) {
        [taskDelegate finishURLSessionTaskWithResponse:task.response error:error];
    } else {
        [self.defaultDelegate finishURLSessionTask:task withResponse:task.response error:error];
    }
    [self dessociateSessionTaskId:task.taskIdentifier];
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
    }

    if (completionHandler) {
        completionHandler(inputStream);
    }
}
@end

NS_ASSUME_NONNULL_END
