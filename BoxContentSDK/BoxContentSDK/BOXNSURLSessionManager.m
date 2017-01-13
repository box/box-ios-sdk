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

//Advanced NSURLSession to be used by NSURLSessionTask which needs a delegate to handle specific tasks
//during the life of a session/task, and to be run in the background e.g. download, upload
@property (nonatomic, readwrite, strong) NSURLSession *advancedSession;

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

- (NSURLSession *)defaultSession
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

- (NSURLSession *)advancedSession
{
    if (_advancedSession == nil) {
        //FIXME: revisit configuration for url session and its operation queue
        //arbitrary maxConcurrentOperationCount given that the number should not go above
        //the max number of concurrent Box api operations
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:backgroundSessionIdentifier];

        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.name = @"com.box.BOXNSURLSessionManager.advanced";
        queue.maxConcurrentOperationCount = 8;

        _advancedSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:queue];
    }
    return _advancedSession;
}

#pragma mark - public methods

- (void)pendingBackgroundDownloadUploadSessionTasks:(void (^)(NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks))completion
{
    if (completion != nil) {
        [self.advancedSession getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
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

- (NSURLSessionDataTask *)createDataTask:(NSURLRequest *)request completionHandler:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler
{
    return [self.defaultSession dataTaskWithRequest:request completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)createDataTaskForDownload:(NSURLRequest *)request taskDelegate:(id <BOXNSURLSessionTaskDelegate, BOXNSURLSessionDownloadTaskDelegate>)taskDelegate
{
    NSURLSessionTask *task = [self.advancedSession dataTaskWithRequest:request];
    [self associateSessionTaskId:task.taskIdentifier withTaskDelegate:taskDelegate];
    return task;
}

- (NSURLSessionDownloadTask *)createDownloadTaskWithRequest:(NSURLRequest *)request taskDelegate:(id <BOXNSURLSessionTaskDelegate, BOXNSURLSessionDownloadTaskDelegate>)taskDelegate
{
    NSURLSessionTask *task = [self.advancedSession downloadTaskWithRequest:request];
    [self associateSessionTaskId:task.taskIdentifier withTaskDelegate:taskDelegate];
    return task;
}

- (NSURLSessionDownloadTask *)createDownloadTaskWithResumeData:(NSData *)resumeData
{
    return [self.advancedSession downloadTaskWithResumeData:resumeData];
}

- (NSURLSessionUploadTask *)createUploadTask:(NSURLRequest *)request fromFile:(NSURL *)fileURL
{
    return [self.advancedSession uploadTaskWithRequest:request fromFile:fileURL];
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
        [self.delegate downloadTask:downloadTask.taskIdentifier didFinishDownloadingToURL:location];
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
        [self.delegate finishURLSessionTask:task.taskIdentifier withResponse:task.response error:error];
    }
    [self dessociateSessionTaskId:task.taskIdentifier];
}

@end

NS_ASSUME_NONNULL_END
