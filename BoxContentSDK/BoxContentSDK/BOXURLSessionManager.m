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

@interface BOXSessionTaskAndDelegate : NSObject

@property (nonatomic, strong, readwrite) NSURLSessionTask *task;
@property (nonatomic, weak, readwrite) id<BOXURLSessionTaskDelegate> delegate;

- (id)initWithTask:(NSURLSessionTask *)task delegate:(id<BOXURLSessionTaskDelegate>)delegate;

@end

@implementation BOXSessionTaskAndDelegate

- (id)initWithTask:(NSURLSessionTask *)task delegate:(id<BOXURLSessionTaskDelegate>)delegate
{
    self = [super init];
    if (self != nil) {
        self.task = task;
        self.delegate = delegate;
    }
    return self;
}

@end

@interface BOXBackgroundSessionIdAndTask : NSObject

@property (nonatomic, copy, readwrite) NSString *backgroundSessionId;
@property (nonatomic, strong, readwrite) NSURLSessionTask *sessionTask;
- (id)initWithBackgroundSessionId:(NSString *)backgroundSessionId sessionTask:(NSURLSessionTask *)sessionTask;

@end

@implementation BOXBackgroundSessionIdAndTask

- (id)initWithBackgroundSessionId:(NSString *)backgroundSessionId sessionTask:(NSURLSessionTask *)sessionTask
{
    self = [super init];
    if (self != nil) {
        self.backgroundSessionId = backgroundSessionId;
        self.sessionTask = sessionTask;
    }
    return self;
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
@property (nonatomic, strong, readwrite) id<BOXURLSessionManagerDelegate> defaultDelegate;

//a map to associate a progress session' task to its delegate
//during session/task's delegate callbacks, we call appropriate methods on task delegate
@property (nonatomic, readonly, strong) NSMapTable<NSNumber *, id<BOXURLSessionTaskDelegate>> *progressSessionTaskIdToTaskDelegate;

//a map to associate a background session to its session task and session task delegate
//there can be more than one background session at a time as an app takes over background sessions created from app extensions
//during session/task's delegate callbacks, we call appropriate methods on task delegate
@property (nonatomic, readonly, strong) NSMutableDictionary<NSString *, NSMapTable<NSNumber *, BOXSessionTaskAndDelegate *> *> *backgroundSessionIdToSessionTask;

@property (nonatomic, readonly, strong) NSMutableDictionary<NSString *, NSURLSession *> *backgroundSessionIdToSession;

@property (nonatomic, readwrite, strong) BOXURLSessionCacheClient *cacheClient;

@end

static NSString *backgroundSessionIdentifier = @"com.box.BOXURLSessionManager.backgroundSessionIdentifier";

@implementation BOXURLSessionManager

@synthesize progressSessionTaskIdToTaskDelegate = _progressSessionTaskIdToTaskDelegate;
@synthesize backgroundSessionIdToSessionTask = _backgroundSessionIdToSessionTask;

+ (BOXURLSessionManager *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        _progressSessionTaskIdToTaskDelegate = [NSMapTable strongToWeakObjectsMapTable];
        _backgroundSessionIdToSessionTask = [NSMutableDictionary new];
        [self createDefaultSession];
        [self createProgressSession];
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
        self.backgroundSessionIdToSessionTask[backgroundSessionIdentifier] = [NSMapTable strongToWeakObjectsMapTable];
    }
    return _backgroundSession;
}

- (BOXURLSessionCacheClient *)createCacheClient:(NSString *)rootCacheDir delegate:(id<BOXURLSessionCacheClientDelegate>)delegate
{
    if (_cacheClient == nil) {
        _cacheClient = [[BOXURLSessionCacheClient alloc] initWithCacheRootDir:rootCacheDir];
        _cacheClient.delegate = delegate;
    }
    return _cacheClient;
}

#pragma mark - public methods

- (void)setUpToSupportBackgroundTasksWithDefaultDelegate:(id<BOXURLSessionManagerDelegate>)delegate rootCacheDir:(NSString *)rootCacheDir
{
    self.defaultDelegate = delegate;
    [self createBackgroundSession];

    //prepare the map of background session id to its NSURLSession object, which is needed to support background sessions created from extensions
    if (_backgroundSessionIdToSession == nil) {
        _backgroundSessionIdToSession = [NSMutableDictionary new];
    }
    self.backgroundSessionIdToSession[backgroundSessionIdentifier] = self.backgroundSession;

    [self createCacheClient:rootCacheDir delegate:delegate];

    //populate pending background session tasks
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    [self pendingBackgroundDownloadUploadSessionTasks:^(NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        for (NSURLSessionUploadTask *uploadTask in uploadTasks) {
            [self associateBackgroundSessionTask:uploadTask withTaskDelegate:nil];
        }
        for (NSURLSessionDownloadTask *downloadTask in downloadTasks) {
            [self associateBackgroundSessionTask:downloadTask withTaskDelegate:nil];
        }
        dispatch_semaphore_signal(sema);
    }];

    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

- (void)pendingBackgroundDownloadUploadSessionTasks:(void (^)(NSArray<NSURLSessionUploadTask *> * uploadTasks, NSArray<NSURLSessionDownloadTask *> * downloadTasks))completion
{
    if (completion != nil) {
        [self.backgroundSession getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
            completion(uploadTasks, downloadTasks);
        }];
    }
}

- (void)associateBackgroundSessionTask:(NSURLSessionTask *)sessionTask withTaskDelegate:(id <BOXURLSessionTaskDelegate> )taskDelegate
{
    [self associateSessionId:backgroundSessionIdentifier sessionTask:sessionTask withTaskDelegate:taskDelegate];
}

- (void)associateProgressSessionTask:(NSURLSessionTask *)sessionTask withTaskDelegate:(id <BOXURLSessionTaskDelegate> )taskDelegate
{
    [self associateSessionId:nil sessionTask:sessionTask withTaskDelegate:taskDelegate];
}

- (void)associateSessionId:(NSString *)sessionId sessionTask:(NSURLSessionTask *)sessionTask withTaskDelegate:(id <BOXURLSessionTaskDelegate> )taskDelegate
{
    NSUInteger sessionTaskId = sessionTask.taskIdentifier;

    if (sessionId == nil) {
        @synchronized (self.progressSessionTaskIdToTaskDelegate) {
            [self.progressSessionTaskIdToTaskDelegate setObject:taskDelegate forKey:@(sessionTaskId)];
        }
    } else {
        @synchronized (self.backgroundSessionIdToSessionTask[sessionId]) {
            BOXSessionTaskAndDelegate *obj = [[BOXSessionTaskAndDelegate alloc] initWithTask:sessionTask delegate:taskDelegate];
            [self.backgroundSessionIdToSessionTask[sessionId] setObject:obj forKey:@(sessionTaskId)];
        }
    }
}

- (void)deassociateSessionId:(NSString *)sessionId sessionTaskId:(NSUInteger)sessionTaskId
{
    if (sessionId == nil) {
        @synchronized (self.progressSessionTaskIdToTaskDelegate) {
            [self.progressSessionTaskIdToTaskDelegate removeObjectForKey:@(sessionTaskId)];
        }
    } else {
        @synchronized (self.backgroundSessionIdToSessionTask[sessionId]) {
            [self.backgroundSessionIdToSessionTask[sessionId] removeObjectForKey:@(sessionTaskId)];
        }
    }
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler
{
    return [self.defaultSession dataTaskWithRequest:request completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)foregroundDownloadTaskWithRequest:(NSURLRequest *)request taskDelegate:(id <BOXURLSessionDownloadTaskDelegate>)taskDelegate
{
    NSURLSessionDataTask *task = [self.progressSession dataTaskWithRequest:request];
    [self associateProgressSessionTask:task withTaskDelegate:taskDelegate];
    return task;
}

- (NSURLSessionUploadTask *)foregroundUploadTaskWithStreamedRequest:(NSURLRequest *)request taskDelegate:(id <BOXURLSessionUploadTaskDelegate>)taskDelegate
{
    NSURLSessionUploadTask *task = [self.progressSession uploadTaskWithStreamedRequest:request];
    [self associateBackgroundSessionTask:task withTaskDelegate:taskDelegate];
    return task;
}

- (NSURLSessionDownloadTask *)backgroundDownloadTaskWithRequest:(NSURLRequest *)request taskDelegate:(id <BOXURLSessionDownloadTaskDelegate>)taskDelegate userId:(NSString *)userId associateId:(NSString *)associateId
{
    if (request == nil || taskDelegate == nil || userId == nil || associateId == nil) {
        return nil;
    }
    return [self backgroundTaskWithRequest:request orResumeDownloadData:nil orUploadFromFile:nil taskDelegate:taskDelegate userId:userId associateId:associateId];
}

- (NSURLSessionDownloadTask *)backgroundDownloadTaskWithResumeData:(NSData *)resumeData taskDelegate:(id <BOXURLSessionDownloadTaskDelegate>)taskDelegate userId:(NSString *)userId associateId:(NSString *)associateId
{
    if (resumeData == nil || taskDelegate == nil || userId == nil || associateId == nil) {
        return nil;
    }
    return [self backgroundTaskWithRequest:nil orResumeDownloadData:resumeData orUploadFromFile:nil taskDelegate:taskDelegate userId:userId associateId:associateId];
}

- (NSURLSessionUploadTask *)backgroundUploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL taskDelegate:(id <BOXURLSessionUploadTaskDelegate>)taskDelegate userId:(NSString *)userId associateId:(NSString *)associateId
{
    if (request == nil || fileURL == nil || taskDelegate == nil || userId == nil || associateId == nil) {
        return nil;
    }
    return [self backgroundTaskWithRequest:request orResumeDownloadData:nil orUploadFromFile:fileURL taskDelegate:taskDelegate userId:userId associateId:associateId];
}

- (BOXURLSessionTaskCachedInfo *)sessionTaskCachedInfoGivenUserId:(NSString *)userId associateId:(NSString *)associateId error:(NSError **)error
{
    return [self.cacheClient cachedInfoForUserId:userId associateId:associateId error:error];
}

- (BOOL)cleanUpSessionTaskInfoGivenUserId:(NSString *)userId associateId:(NSString *)associateId error:(NSError **)error
{
    if (userId == nil || associateId == nil) {
        return YES;
    }
    NSError *err = nil;
    BOXURLBackgroundSessionIdAndSessionTaskId *backgroundSessionIdAndSessionTaskId = [self.cacheClient backgroundSessionIdAndSessionTaskIdGivenUserId:userId associateId:associateId error:&err];
    BOOL success = YES;
    if (err != nil) {
        success = NO;

        if (error != nil) {
            *error = err;
        }
    } else {

        if (backgroundSessionIdAndSessionTaskId != nil) {
            [self deassociateSessionId:backgroundSessionIdAndSessionTaskId.backgroundSessionId sessionTaskId:backgroundSessionIdAndSessionTaskId.sessionTaskId];
        }
        success = [self.cacheClient deleteCachedInfoForUserId:userId associateId:associateId error:&err];

        if (error != nil) {
            *error = err;
        }
    }
    return success;
}

#pragma mark - Private Helpers

- (BOXBackgroundSessionIdAndTask *)existingBackgroundSessionTaskGivenUserId:(NSString *)userId associateId:(NSString *)associateId
{
    NSError *error = nil;
    BOXBackgroundSessionIdAndTask *returned = nil;

    BOXURLBackgroundSessionIdAndSessionTaskId *backgroundSessionIdAndSessionTaskId = [self.cacheClient backgroundSessionIdAndSessionTaskIdGivenUserId:userId associateId:associateId error:&error];

    if (backgroundSessionIdAndSessionTaskId != nil) {
        NSString *backgroundSessionId = backgroundSessionIdAndSessionTaskId.backgroundSessionId;
        NSUInteger sessionTaskId = backgroundSessionIdAndSessionTaskId.sessionTaskId;
        NSURLSessionTask *task = [self existingBackgroundSessionTaskForSessionId:backgroundSessionId sessionTaskId:sessionTaskId];
        returned = [[BOXBackgroundSessionIdAndTask alloc] initWithBackgroundSessionId:backgroundSessionId sessionTask:task];
    }
    return returned;
}

- (NSURLSessionTask *)backgroundTaskWithRequest:(NSURLRequest *)request orResumeDownloadData:(NSData *)resumeDownloadData orUploadFromFile:(NSURL *)uploadFromFileURL taskDelegate:(id <BOXURLSessionDownloadTaskDelegate>)taskDelegate userId:(NSString *)userId associateId:(NSString *)associateId
{
    NSError *error = nil;
    NSURLSessionTask *sessionTask = nil;
    BOXBackgroundSessionIdAndTask *task = [self existingBackgroundSessionTaskGivenUserId:userId associateId:associateId];

    NSString *backgroundSessionId = nil;

    if (task == nil) {
        backgroundSessionId = backgroundSessionIdentifier;
        sessionTask = uploadFromFileURL == nil ? (request != nil ? [self.backgroundSession downloadTaskWithRequest:request] : [self.backgroundSession downloadTaskWithResumeData:resumeDownloadData]) : [self.backgroundSession uploadTaskWithRequest:request fromFile:uploadFromFileURL];
    } else {
        backgroundSessionId = task.backgroundSessionId;
        sessionTask = task.sessionTask;
        if (backgroundSessionId != nil) {
            NSURLSession *session = self.backgroundSessionIdToSession[backgroundSessionId];
            if (resumeDownloadData != nil) {
                sessionTask = [session downloadTaskWithResumeData:resumeDownloadData];
            }
        }
    }

    [self persistBackgroundSessionTaskWithSessionId:backgroundSessionId sessionTask:sessionTask taskDelegate:taskDelegate userId:userId associateId:associateId];
    return sessionTask;
}

- (void)persistBackgroundSessionTaskWithSessionId:(NSString *)backgroundSessionId sessionTask:(NSURLSessionTask *)task taskDelegate:(id <BOXURLSessionDownloadTaskDelegate>)taskDelegate userId:(NSString *)userId associateId:(NSString *)associateId
{
    if (task == nil || taskDelegate == nil || userId == nil || associateId == nil) {
        return;
    }

    [self associateSessionId:backgroundSessionId sessionTask:task withTaskDelegate:taskDelegate];

    //cache background task if have not
    NSError *error = nil;
    BOOL success = [self.cacheClient cacheUserId:userId associateId:associateId backgroundSessionId:backgroundSessionId sessionTaskId:task.taskIdentifier error:&error];
    BOXAssert(success, @"failed to cache background task %@", error);
}

- (id<BOXURLSessionTaskDelegate>)taskDelegateForSessionId:(NSString *)sessionId sessionTaskId:(NSUInteger)sessionTaskId
{
    id<BOXURLSessionTaskDelegate> taskDelegate = nil;
    if (sessionId == nil) {
        taskDelegate = [self.progressSessionTaskIdToTaskDelegate objectForKey:@(sessionTaskId)];
    } else {
        taskDelegate = [[self.backgroundSessionIdToSessionTask[sessionId] objectForKey:@(sessionTaskId)] delegate];
    }
    return taskDelegate;
}

- (NSURLSessionTask *)existingBackgroundSessionTaskForSessionId:(NSString *)sessionId sessionTaskId:(NSUInteger)sessionTaskId
{
    return [[self.backgroundSessionIdToSessionTask[sessionId] objectForKey:@(sessionTaskId)] task];
}

- (BOOL)moveDownloadedFileAtTemporaryURL:(NSURL *)temporaryURL toDestinationFilePath:(NSString *)destinationFilePath error:(NSError **)error
{
    BOOL success = YES;
    NSError *err = nil;
    if (destinationFilePath != nil) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *destURL = [[NSURL alloc] initFileURLWithPath:destinationFilePath];

        if (![fileManager fileExistsAtPath:destinationFilePath]) {
            success = [fileManager moveItemAtURL:temporaryURL toURL:destURL error:&err];
        } else {
            success = [fileManager replaceItemAtURL:destURL
                            withItemAtURL:temporaryURL
                           backupItemName:nil
                                  options:NSFileManagerItemReplacementUsingNewMetadataOnly
                         resultingItemURL:nil
                                    error:&err];
        }
    }

    if (error != nil) {
        *error = err;
    }
    return success;
}

#pragma mark - implementations for NSURLSession-related delegates for advanced session

//foreground session tasks' taskDelegates will be called at each callback if provided
//background session tasks' taskDelegates will only be called at completion, i.e. in URLSession:task:didCompleteWithError

#pragma mark - NSURLSessionDownloadDelegate

/**
 * Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    //this method is only called by background download tasks
    if ([downloadTask.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)downloadTask.response;

        NSError *error = nil;
        BOOL success = NO;

        if (HTTPResponse.statusCode < 200 || HTTPResponse.statusCode >= 300) {
            // If we received an error, don't write the response data to the destination path
            NSData *responseData = [NSData dataWithContentsOfURL:location];
            success = [self.cacheClient cacheBackgroundSessionId:session.configuration.identifier sessionTaskId:downloadTask.taskIdentifier responseData:responseData error:&error];
            BOXAssert(success, @"failed to cache response data for background download session task", error);
        } else {
            // File was downloaded into a temporary location, retrieve destinationFilePath to move the downloaded file into
            // If taskDelegate exists, retrieve destinationFilePath from it, else retrieve from cache

            id<BOXURLSessionTaskDelegate> taskDelegate = [self taskDelegateForSessionId:session.configuration.identifier sessionTaskId:downloadTask.taskIdentifier];
            NSString *destinationFilePath = nil;

            if ([taskDelegate conformsToProtocol:@protocol(BOXURLSessionDownloadTaskDelegate)]) {
                id<BOXURLSessionDownloadTaskDelegate> downloadTaskDelegate = (id<BOXURLSessionDownloadTaskDelegate>)taskDelegate;
                destinationFilePath = [downloadTaskDelegate destinationFilePath];
            } else {
                destinationFilePath = [self.cacheClient destinationFilePathGivenBackgroundSessionId:session.configuration.identifier sessionTaskId:downloadTask.taskIdentifier];
            }
            success = [self moveDownloadedFileAtTemporaryURL:location toDestinationFilePath:destinationFilePath error:&error];
            BOXAssert(success, @"failed to cache response for background download session task", error);
        }
    }
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    //this method is only called by foreground session tasks, call its taskDelegate to handle
    id<BOXURLSessionTaskDelegate> taskDelegate = [self taskDelegateForSessionId:session.configuration.identifier sessionTaskId:downloadTask.taskIdentifier];

    if ([taskDelegate conformsToProtocol:@protocol(BOXURLSessionDownloadTaskDelegate)]) {
        id<BOXURLSessionDownloadTaskDelegate> downloadTaskDelegate = (id<BOXURLSessionDownloadTaskDelegate>)taskDelegate;

        if ([downloadTaskDelegate respondsToSelector:@selector(downloadTask:didWriteTotalBytes:totalBytesExpectedToWrite:)]) {
            [downloadTaskDelegate downloadTask:downloadTask didWriteTotalBytes:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
        }
    }
}

#pragma mark - NSURLSessionDataDelegate

/* The task has received a response and no further messages will be
 * received until the completion block is called. The disposition
 * allows you to cancel a request or to turn a data task into a
 * download task. This delegate message is optional - if you do not
 * implement it, you can get the response as a property of the task.
 *
 * This method will not be called for background upload tasks (which cannot be converted to download tasks).
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    //this method is only called by foreground session tasks, call its taskDelegate to handle
    id<BOXURLSessionTaskDelegate> taskDelegate = [self taskDelegateForSessionId:session.configuration.identifier sessionTaskId:dataTask.taskIdentifier];

    if ([taskDelegate respondsToSelector:@selector(sessionTask:processIntermediateResponse:)]) {
        [taskDelegate sessionTask:dataTask processIntermediateResponse:response];
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
    if (session.configuration.identifier != nil) {
        //for background tasks, cache response data
        NSError *error = nil;
        BOOL success = [self.cacheClient cacheBackgroundSessionId:session.configuration.identifier sessionTaskId:dataTask.taskIdentifier responseData:data error:&error];
        BOXAssert(success, @"failed to cache response for background session task", error);
    } else {
        //for foreground tasks, call its taskDelegate to handle
        id<BOXURLSessionTaskDelegate> taskDelegate = [self taskDelegateForSessionId:session.configuration.identifier sessionTaskId:dataTask.taskIdentifier];
        if ([taskDelegate respondsToSelector:@selector(sessionTask:processIntermediateData:)]) {
            [taskDelegate sessionTask:dataTask processIntermediateData:data];
        }
    }
}

#pragma mark - NSURLSessionTaskDelegate

/* Sent periodically to notify the delegate of upload progress.  This
 * information is also available as properties of the task.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    //this method is only called by foreground session tasks, call its taskDelegate to handle
    id<BOXURLSessionTaskDelegate> taskDelegate = [self taskDelegateForSessionId:session.configuration.identifier sessionTaskId:task.taskIdentifier];

    if ([taskDelegate conformsToProtocol:@protocol(BOXURLSessionUploadTaskDelegate)]) {
        id<BOXURLSessionUploadTaskDelegate> uploadTaskDelegate = (id<BOXURLSessionUploadTaskDelegate>)taskDelegate;
        if ([uploadTaskDelegate respondsToSelector:@selector(sessionTask:didSendTotalBytes:totalBytesExpectedToSend:)]) {
            [uploadTaskDelegate sessionTask:task didSendTotalBytes:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
        }
    }
}

/* Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    if (session.configuration.identifier != nil) {
        //background session task finishes, cache its response and error

        NSError *err = nil;
        NSString *backgroundSessionId = session.configuration.identifier;

        BOOL success = [self.cacheClient cacheBackgroundSessionId:backgroundSessionId sessionTaskId:task.taskIdentifier response:task.response error:&err];
        BOXAssert(success, @"failed to cache response for background session task", err);

        success = [self.cacheClient cacheBackgroundSessionId:session.configuration.identifier sessionTaskId:task.taskIdentifier response:error error:&err];
        BOXAssert(success, @"failed to cache error for background session task", err);

        //notify its taskDelegate about the completion with response, responseData, and error
        NSData *responseData = [self.cacheClient responseDataGivenBackgroundSessionId:backgroundSessionId sessionTaskId:task.taskIdentifier];

        id<BOXURLSessionTaskDelegate> taskDelegate = [self taskDelegateForSessionId:session.configuration.identifier sessionTaskId:task.taskIdentifier];
        [taskDelegate sessionTask:task didFinishWithResponse:task.response responseData:responseData error:error];

    } else {
        //foreground session task finishes, notify its taskDelegate accordingly

        id<BOXURLSessionTaskDelegate> taskDelegate = [self taskDelegateForSessionId:session.configuration.identifier sessionTaskId:task.taskIdentifier];
        [taskDelegate sessionTask:task didFinishWithResponse:task.response responseData:nil error:error];
    }
    [self deassociateSessionId:session.configuration.identifier sessionTaskId:task.taskIdentifier];
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
        BOXLog(@"needNewBodyStream failed to get an new input stream from %@", task.originalRequest.HTTPBodyStream);
    }

    if (completionHandler) {
        completionHandler(inputStream);
    }
}
@end

NS_ASSUME_NONNULL_END
