//
//  BOXURLSessionManager.m
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 12/15/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import "BOXURLSessionManager.h"
#import "BOXLog.h"
#import "BOXContentSDKErrors.h"

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

@interface BOXURLSessionManager() <NSURLSessionDataDelegate, NSURLSessionDownloadDelegate, NSURLSessionStreamDelegate>

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
//map backgroundSessionId -> sessionTaskId -> (sessionTask, taskDelegate)
@property (nonatomic, readonly, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSNumber *, BOXSessionTaskAndDelegate *> *> *backgroundSessionIdToSessionTask;

//A map to associate backgroundSessionId and equivalent background NSURLSession objects that this BOXURLSessionManager knows about
//If inside an app, there will be one background session for app, and 0 or more from previous runs of extensions
//If inside an extension, there will be one background session for extension
@property (nonatomic, readonly, strong) NSMutableDictionary<NSString *, NSURLSession *> *backgroundSessionIdToSession;

//A cache client to cache background session task-related data to file system for retrieval by task delegate
@property (nonatomic, readwrite, strong) BOXURLSessionCacheClient *cacheClient;

//Indicate if background session's setup has completed
@property (nonatomic, readwrite, assign) BOOL didFinishSettingUpBackgroundSession;

//An array of extra protocol subclasses that handle requests in NSURLSession
//Currently used by test cases to control the expected responses/data for API requests without reaching the server
@property (nonatomic, readwrite, copy) NSArray<Class> *protocolClasses;

@end

static NSString *backgroundSessionIdentifierForMainApp = @"com.box.BOXURLSessionManager.backgroundSessionIdentifier";

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
    return [self initWithProtocolClasses:nil];
}

- (id)initWithProtocolClasses:(nullable NSArray *)protocolClasses
{
    self = [super init];
    if (self != nil) {
        _protocolClasses = protocolClasses;
        _progressSessionTaskIdToTaskDelegate = [NSMapTable strongToWeakObjectsMapTable];
        _backgroundSessionIdToSessionTask = [NSMutableDictionary new];
        _backgroundSessionIdToSession = [NSMutableDictionary new];
        [self createDefaultSession];
        [self createProgressSession];
        _didFinishSettingUpBackgroundSession = NO;
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
        if (self.protocolClasses != nil) {
            sessionConfig.protocolClasses = [self.protocolClasses arrayByAddingObjectsFromArray:sessionConfig.protocolClasses];
        }
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.name = @"com.box.BOXURLSessionManager.default";
        queue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;

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
        
        if (self.protocolClasses != nil) {
            sessionConfig.protocolClasses = [self.protocolClasses arrayByAddingObjectsFromArray:sessionConfig.protocolClasses];
        }
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.name = @"com.box.BOXURLSessionManager.progress";
        queue.maxConcurrentOperationCount = 40;

        _progressSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:queue];
    }
    
    return _progressSession;
}

- (NSURLSession *)createBackgroundSessionWithId:(NSString *)backgroundSessionIdentifier
                      sharedContainerIdentifier:(nullable NSString *)sharedContainerIdentifier
                    maxConcurrentOperationCount:(NSInteger)maxConcurrentOperationCount
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:backgroundSessionIdentifier];
    sessionConfig.sharedContainerIdentifier = sharedContainerIdentifier;
    
    if (self.protocolClasses != nil) {
        sessionConfig.protocolClasses = [self.protocolClasses arrayByAddingObjectsFromArray:sessionConfig.protocolClasses];
    }
    
    NSOperationQueue *queue = nil; //use default queue of NSURLSession by default, unless background task is for main app
    
    if (maxConcurrentOperationCount > 0) {
        queue = [[NSOperationQueue alloc] init];
        queue.name = @"com.box.BOXURLSessionManager.background";
        queue.maxConcurrentOperationCount = maxConcurrentOperationCount;
    }

    NSURLSession *backgroundSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:queue];
    [self recordBackgroundSession:backgroundSession];
    
    return backgroundSession;
}

- (BOXURLSessionCacheClient *)createCacheClient:(NSString *)rootCacheDir
{
    if (_cacheClient == nil) {
        _cacheClient = [[BOXURLSessionCacheClient alloc] initWithCacheRootDir:rootCacheDir];
    }
    
    return _cacheClient;
}

#pragma mark - public methods

- (void)oneTimeSetUpInAppToSupportBackgroundTasksWithDelegate:(id<BOXURLSessionManagerDelegate>)delegate
                                                 rootCacheDir:(NSString *)rootCacheDir
                                                   completion:(nullable void (^)(NSError * _Nullable error))completionBlock
{
    //used by main app to create and reuse one background NSURLSession
    //completionBlock will be called once the app's background session is ready
    //to provide background session tasks
    [self oneTimeSetUpToSupportBackgroundTasksWithBackgroundSessionId:backgroundSessionIdentifierForMainApp
                                                             delegate:delegate
                                                         rootCacheDir:rootCacheDir
                                            sharedContainerIdentifier:nil
                                                           completion:completionBlock];

    //setting up previously reconnected background sessions
    NSError *error = nil;
    NSArray *extensionSessionIds = [self.cacheClient backgroundSessionIdsFromExtensionsWithError:&error];
    BOXAssert(error == nil, @"Failed to retrieve backgroundSessionIds from extensions with error %@", error);

    for (NSString *extensionSessionId in extensionSessionIds) {
        [self reconnectWithBackgroundSessionIdFromExtension:extensionSessionId completion:nil];
    }
}

// Return string in the format $backgroundSessionIdentifierForMainApp_$randomString
+ (NSString *)randomExtensionBackgroundSessionId
{
    NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    int length = 32;

    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];

    for (NSInteger i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return [NSString stringWithFormat:@"%@_%@", backgroundSessionIdentifierForMainApp, randomString];
}

- (void)oneTimeSetUpInExtensionToSupportBackgroundTasksWithDelegate:(id<BOXURLSessionManagerDelegate>)delegate
                                                       rootCacheDir:(NSString *)rootCacheDir
                                          sharedContainerIdentifier:(NSString *)sharedContainerIdentifier
                                                         completion:(nullable void (^)(NSError * _Nullable error))completionBlock
{
    //this method is expected to call once by an extension to create its own background session
    //if extension restarts, it will get a different backgroundSessionId given that its previous background session
    //will now be handled by the main app (app got woken up about background sessions from a terminated extension)
    NSString *backgroundSessionId = [BOXURLSessionManager randomExtensionBackgroundSessionId];
    [self oneTimeSetUpToSupportBackgroundTasksWithBackgroundSessionId:backgroundSessionId delegate:delegate rootCacheDir:rootCacheDir sharedContainerIdentifier:sharedContainerIdentifier completion:completionBlock];
}

- (void)oneTimeSetUpToSupportBackgroundTasksWithBackgroundSessionId:(NSString *)backgroundSessionId
                                                           delegate:(id<BOXURLSessionManagerDelegate>)delegate
                                                       rootCacheDir:(NSString *)rootCacheDir
                                          sharedContainerIdentifier:(nullable NSString *)sharedContainerIdentifier
                                                         completion:(nullable void (^)(NSError * _Nullable error))completionBlock
{
    BOOL firstSetUp = NO;
    @synchronized (self) {
        //create one _backgroundSession which can provide new session tasks for this app
        //or this extension if called from extension
        if (_backgroundSession == nil) {
            _backgroundSession = [self createBackgroundSessionWithId:backgroundSessionId sharedContainerIdentifier:sharedContainerIdentifier maxConcurrentOperationCount:40];
            firstSetUp = YES;
        }
    }

    if (firstSetUp == YES) {
        self.defaultDelegate = delegate;
        [self createCacheClient:rootCacheDir];
        self.cacheClient.delegate = delegate;
        [self populatePendingSessionTasksForBackgroundSession:_backgroundSession completion:completionBlock];

    } else if (completionBlock != nil) {
        // Have set up this background session previously
        completionBlock(nil);
    }
}

- (void)reconnectWithBackgroundSessionIdFromExtension:(NSString *)backgroundSessionId completion:(nullable void (^)(NSError * _Nullable error))completionBlock
{
    if (self.supportBackgroundSessionTasks == NO) {
        if (completionBlock != nil) {
            NSError *error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKURLSessionFailToReconnectBecauseBackgroundSessionIsNotSupported userInfo:nil];
            completionBlock(error);
        }
    } else if ([self backgroundSessionForId:backgroundSessionId] == nil) {
        // Have not reconnected to this background session previously, create it and populate its tasks' information
        NSError *error = nil;
        NSURLSession *backgroundSession = [self createBackgroundSessionWithId:backgroundSessionId sharedContainerIdentifier:nil maxConcurrentOperationCount:-1];
        if ([self.cacheClient cacheBackgroundSessionIdFromExtension:backgroundSessionId error:&error] == YES) {
            [self populatePendingSessionTasksForBackgroundSession:backgroundSession completion:completionBlock];
        } else if (completionBlock != nil) {
            completionBlock(error);
        }

    } else if (completionBlock != nil) {
        // Have reconnected to this background session previously
        completionBlock(nil);
    }
}

- (void)populatePendingSessionTasksForBackgroundSession:(NSURLSession *)backgroundSession completion:(void (^)(NSError *error))completionBlock
{
    if (backgroundSession == nil) {
        NSError *error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKURLSessionInvalidBackgroundSession userInfo:nil];
        if (completionBlock != nil) {
            completionBlock(error);
        }
        
        return;
    }
    NSString *backgroundSessionId = backgroundSession.configuration.identifier;
    //populate pending background session tasks
    [backgroundSession getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        NSMutableSet *pendingSessionTaskIds = [NSMutableSet new];

        for (NSURLSessionUploadTask *uploadTask in uploadTasks) {
            [self associateSessionId:backgroundSessionId sessionTask:uploadTask withTaskDelegate:nil];
            [pendingSessionTaskIds addObject:@(uploadTask.taskIdentifier)];
        }
        
        for (NSURLSessionDownloadTask *downloadTask in downloadTasks) {
            [self associateSessionId:backgroundSessionId sessionTask:downloadTask withTaskDelegate:nil];
            [pendingSessionTaskIds addObject:@(downloadTask.taskIdentifier)];
        }
        NSError *error = nil;
        BOOL success = [self.cacheClient completeOnGoingSessionTasksForBackgroundSessionId:backgroundSessionId excludingSessionTaskIds:pendingSessionTaskIds error:&error];
        BOXAssert(success, @"Failed to complete tasks which are no longer in pending with error %@", error);
        self.didFinishSettingUpBackgroundSession = YES;
        
        if (completionBlock != nil) {
            completionBlock(error);
        }
    }];
}

- (void)recordBackgroundSession:(NSURLSession *)session
{
    @synchronized (self.backgroundSessionIdToSession) {
        self.backgroundSessionIdToSession[session.configuration.identifier] = session;
    }
}

- (NSURLSession *)backgroundSessionForId:(NSString *)backgroundSessionId
{
    @synchronized (self.backgroundSessionIdToSession) {
        return self.backgroundSessionIdToSession[backgroundSessionId];
    }
}

- (void)pendingBackgroundDownloadUploadSessionTasks:(void (^)(NSArray<NSURLSessionUploadTask *> * _Nullable uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nullable downloadTasks))completionBlock
{
    if (completionBlock != nil) {
        if (self.supportBackgroundSessionTasks == NO) {
            completionBlock(nil, nil);
        } else {
            [self.backgroundSession getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
                completionBlock(uploadTasks, downloadTasks);
            }];
        }
    }
}

- (NSString *)backgroundSessionIdentifier
{
    return self.backgroundSession.configuration.identifier;
}

- (void)associateProgressSessionTask:(NSURLSessionTask *)sessionTask withTaskDelegate:(id <BOXURLSessionTaskDelegate> )taskDelegate
{
    [self associateSessionId:nil sessionTask:sessionTask withTaskDelegate:taskDelegate];
}

- (void)associateSessionId:(nullable NSString *)sessionId
               sessionTask:(NSURLSessionTask *)sessionTask
          withTaskDelegate:(nullable id <BOXURLSessionTaskDelegate> )taskDelegate
{
    NSUInteger sessionTaskId = sessionTask.taskIdentifier;

    if (sessionId == nil) {
        @synchronized (self.progressSessionTaskIdToTaskDelegate) {
            [self.progressSessionTaskIdToTaskDelegate setObject:taskDelegate forKey:@(sessionTaskId)];
        }
    } else {
        if (self.backgroundSessionIdToSessionTask[sessionId] == nil) {
            @synchronized(self.backgroundSessionIdToSessionTask) {
                if (self.backgroundSessionIdToSessionTask[sessionId] == nil) {
                    self.backgroundSessionIdToSessionTask[sessionId] = [NSMutableDictionary new];
                }
            }
        }
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

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler
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
    [self associateProgressSessionTask:task withTaskDelegate:taskDelegate];
    
    return task;
}

- (NSURLSessionDownloadTask *)backgroundDownloadTaskWithRequest:(NSURLRequest *)request
                                                   taskDelegate:(id <BOXURLSessionDownloadTaskDelegate>)taskDelegate
                                                         userId:(NSString *)userId
                                                    associateId:(NSString *)associateId
                                                          error:(NSError **)error
{
    if (request == nil || taskDelegate == nil || userId == nil || associateId == nil) {
        return nil;
    }

    NSURLSessionTask *task = [self backgroundTaskWithRequest:request
                                            orUploadFromFile:nil
                                                taskDelegate:taskDelegate
                                                      userId:userId
                                                 associateId:associateId
                                                       error:error];
    if ([task isKindOfClass:[NSURLSessionDownloadTask class]]) {
        return (NSURLSessionDownloadTask *) task;
    }

    return nil;
}

- (NSURLSessionUploadTask *)backgroundUploadTaskWithRequest:(NSURLRequest *)request
                                                   fromFile:(NSURL *)fileURL
                                               taskDelegate:(id <BOXURLSessionUploadTaskDelegate>)taskDelegate
                                                     userId:(NSString *)userId
                                                associateId:(NSString *)associateId
                                                      error:(NSError **)error
{
    if (request == nil || fileURL == nil || taskDelegate == nil || userId == nil || associateId == nil) {
        return nil;
    }

    NSURLSessionTask *task = [self backgroundTaskWithRequest:request
                                            orUploadFromFile:fileURL
                                                taskDelegate:taskDelegate
                                                      userId:userId
                                                 associateId:associateId
                                                       error:error];
    if ([task isKindOfClass:[NSURLSessionUploadTask class]]) {
        return (NSURLSessionUploadTask *) task;
    }

    return nil;
}

- (BOXURLSessionTaskCachedInfo *)sessionTaskCompletedCachedInfoGivenUserId:(NSString *)userId associateId:(NSString *)associateId error:(NSError **)error
{
    return self.supportBackgroundSessionTasks == NO ? nil : [self.cacheClient completedCachedInfoForUserId:userId associateId:associateId error:error];
}

- (BOOL)supportBackgroundSessionTasks
{
    return self.backgroundSession != nil && self.cacheClient != nil;
}

- (BOOL)cleanUpBackgroundSessionTaskIfExistForUserId:(NSString *)userId associateId:(NSString *)associateId error:(NSError **)outError
{
    if (self.supportBackgroundSessionTasks == NO || userId == nil || associateId == nil) {
        return YES;
    }
    NSError *error = nil;
    BOXURLBackgroundSessionIdAndSessionTaskId *backgroundSessionIdAndSessionTaskId = [self.cacheClient backgroundSessionIdAndSessionTaskIdForUserId:userId associateId:associateId error:&error];
    BOOL success = YES;
    if (error != nil) {
        success = NO;
    } else {

        if (backgroundSessionIdAndSessionTaskId != nil) {
            [self deassociateSessionId:backgroundSessionIdAndSessionTaskId.backgroundSessionId sessionTaskId:backgroundSessionIdAndSessionTaskId.sessionTaskId];
        }
        success = [self.cacheClient deleteCachedInfoForUserId:userId associateId:associateId error:&error];

        if (success == YES) {
            NSString *backgroundSessionId = backgroundSessionIdAndSessionTaskId.backgroundSessionId;
            if (backgroundSessionId != nil && [backgroundSessionId isEqualToString:[self backgroundSessionIdentifier]] == NO) {
                //this background session is not self.backgroundSession so we must be running inside the main app
                //and this background session is from extension, clean it up if it has no more pending tasks
                BOOL shouldCleanUp = NO;
                @synchronized (self.backgroundSessionIdToSessionTask[backgroundSessionId]) {
                    NSMutableDictionary *sessionTask = self.backgroundSessionIdToSessionTask[backgroundSessionId];
                    shouldCleanUp = sessionTask.count == 0;
                }
                if (shouldCleanUp == YES) {
                    success = [self cleanUpBackgroundSessionId:backgroundSessionId error:&error];
                    NSURLSession *backgroundSession = [self backgroundSessionForId:backgroundSessionId];
                    [backgroundSession invalidateAndCancel];
                }
            }
        }
    }
    if (outError != nil) {
        *outError = error;
    }
    
    return success;
}

- (void)cancelAndCleanUpBackgroundSessionTasksForUserId:(NSString *)userId error:(NSError **)outError
{
    //FIXME: make sure set up is completed, and prevents any new tasks created for this userId while we clean it up

    if (self.supportBackgroundSessionTasks == YES && userId != nil) {
        NSError *finalError = nil;

        //cancel on-going session tasks associated with this userId
        [self cancelOnGoingSessionTasksForUserId:userId error:&finalError];
        BOXAssert(finalError == nil, @"Failed to cancel on-going session tasks with error %@", finalError);

        //clean up memory entries and cached info of all session tasks associated with this userId
        NSArray *associateIds = [self.cacheClient associateIdsForUserId:userId error:&finalError];
        for (NSString *associateId in associateIds) {
            NSError *error = nil;
            [self cleanUpBackgroundSessionTaskIfExistForUserId:userId associateId:associateId error:&error];
            if (error != nil && finalError == nil) {
                finalError = error;
            }
        }

        if (finalError == nil) {
            BOOL success = [self.cacheClient cleanUpForUserIdIfEmpty:userId error:&finalError];
            BOXAssert(success, @"Failed to clean up user id when cancelling and cleaning up tasks with error %@", finalError);
        }

        if (outError != nil) {
            *outError = finalError;
        }
    }
}

- (void)cancelOnGoingSessionTasksForUserId:(NSString *)userId error:(NSError **)error
{
    NSDictionary *associateIdToBackgroundSessionIdAndSessionTaskId = [self.cacheClient associateIdToBackgroundSessionIdAndSessionTaskIdsForUserId:userId error:error];

    for (NSString *associateId in associateIdToBackgroundSessionIdAndSessionTaskId.allKeys) {
        // Check if session task is still on-going, only then cancel it
        // There can only be one on-going session task of a backgroundSessionId and sessionTaskId,
        // but there can be multiple completed session tasks of the same backgroundSessionId and sessionTaskId
        if ([self.cacheClient isSessionTaskCompletedForUserId:userId associateId:associateId] == NO) {

            BOXURLBackgroundSessionIdAndSessionTaskId *backgroundSessionIdAndSessionTaskId = associateIdToBackgroundSessionIdAndSessionTaskId[associateId];
            NSString *backgroundSessionId = backgroundSessionIdAndSessionTaskId.backgroundSessionId;
            NSUInteger sessionTaskId = backgroundSessionIdAndSessionTaskId.sessionTaskId;

            NSURLSessionTask *sessionTask = [self existingBackgroundSessionTaskForSessionId:backgroundSessionId sessionTaskId:sessionTaskId];
            [sessionTask cancel];
        }
    }
}

#pragma mark - Private Helpers

- (BOOL)cleanUpBackgroundSessionId:(NSString *)backgroundSessionId
                             error:(NSError **)error
{
    @synchronized (self.backgroundSessionIdToSessionTask) {
        [self.backgroundSessionIdToSessionTask removeObjectForKey:backgroundSessionId];
    }
    
    @synchronized (self.backgroundSessionIdToSession) {
        [self.backgroundSessionIdToSession removeObjectForKey:backgroundSessionId];
    }
    
    return [self.cacheClient cleanUpOnGoingCachedInfoOfBackgroundSessionId:backgroundSessionId error:error];
}

// Return background session Id and sessionTask for this userId and associateId
// If we have never seen the combination of userId and associateId before, return nil
// If we have, backgroundSessionId will not be nil, but sessionTask might be nil if the task has completed
- (BOXBackgroundSessionIdAndTask *)existingBackgroundSessionTaskGivenUserId:(NSString *)userId
                                                                associateId:(NSString *)associateId
{
    NSError *error = nil;
    BOXBackgroundSessionIdAndTask *returned = nil;

    BOXURLBackgroundSessionIdAndSessionTaskId *backgroundSessionIdAndSessionTaskId = [self.cacheClient backgroundSessionIdAndSessionTaskIdForUserId:userId associateId:associateId error:&error];

    if (backgroundSessionIdAndSessionTaskId != nil) {
        NSString *backgroundSessionId = backgroundSessionIdAndSessionTaskId.backgroundSessionId;
        NSUInteger sessionTaskId = backgroundSessionIdAndSessionTaskId.sessionTaskId;
        NSURLSessionTask *task = [self existingBackgroundSessionTaskForSessionId:backgroundSessionId sessionTaskId:sessionTaskId];
        returned = [[BOXBackgroundSessionIdAndTask alloc] initWithBackgroundSessionId:backgroundSessionId sessionTask:task];
    }
    
    return returned;
}

// If we have never seen this userId and associateId before, create new background task and return that
// If there was a background task created previously for this userId and associateId, get it;
// if we can no longer retrieve a session task object, possible if session task finishes
// before we populate pending tasks upon app restart, we will return nil,
// unless the task was a completed background download task with valid resume data,
// re-create the download task with resume data and return that
- (NSURLSessionTask *)backgroundTaskWithRequest:(NSURLRequest *)request
                               orUploadFromFile:(nullable NSURL *)uploadFromFileURL
                                   taskDelegate:(id <BOXURLSessionTaskDelegate>)taskDelegate
                                         userId:(NSString *)userId
                                    associateId:(NSString *)associateId
                                          error:(NSError **)outError
{
    if (self.didFinishSettingUpBackgroundSession == NO) {
        //trying to get a background session task before setting up background session completes
        //will fail this method
        if (outError != nil) {
            *outError = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain
                                                   code:BOXContentSDKURLSessionFailToCreateBackgroundSessionTaskBeforeBackgroundSessionSetUpCompletes
                                               userInfo:nil];
        }
        
        return nil;
    }

    BOXBackgroundSessionIdAndTask *backgroundSessionIdAndTask = [self existingBackgroundSessionTaskGivenUserId:userId associateId:associateId];
    NSString *backgroundSessionId = nil;
    NSURLSessionTask *sessionTask = nil;
    BOOL newBackgroundDownloadTaskCreated = NO;
    NSError *error = nil;

    if (backgroundSessionIdAndTask == nil) {
        //have not created session task for this userId with associatedId before
        backgroundSessionId = self.backgroundSessionIdentifier;
        if (uploadFromFileURL != nil) {
            sessionTask = [self.backgroundSession uploadTaskWithRequest:request fromFile:uploadFromFileURL];
        } else if (request != nil) {
            sessionTask = [self.backgroundSession downloadTaskWithRequest:request];
            newBackgroundDownloadTaskCreated = YES;
        }
    } else {
        //found a previously created session task for this userId and associateId
        backgroundSessionId = backgroundSessionIdAndTask.backgroundSessionId;
        sessionTask = backgroundSessionIdAndTask.sessionTask;
        if (backgroundSessionId != nil && sessionTask == nil) {

            //cannot retrieve session task because it's either finished, or cancelled
            //for background dowload task, if cancelled, we could try to re-create it with resumeDownloadData
            if ([self.cacheClient isSessionTaskCompletedForUserId:userId associateId:associateId] == YES) {
                NSData *resumeDownloadData = [self.cacheClient resumeDataForUserId:userId associateId:associateId];
                if (resumeDownloadData != nil) {
                    NSURLSession *session = [self backgroundSessionForId:backgroundSessionId];
                    sessionTask = [session downloadTaskWithResumeData:resumeDownloadData];
                    BOOL success = [self.cacheClient resumeCompletedDownloadSessionTaskForUserId:userId
                                                                                     associateId:associateId
                                                                                           error:&error];
                    BOXAssert(success, @"Failed to resume completed download task with error %@", error);
                    newBackgroundDownloadTaskCreated = success;
                }
            }
        }
    }

    if (sessionTask != nil) {
        BOOL success = [self persistBackgroundSessionTaskWithSessionId:backgroundSessionId
                                                           sessionTask:sessionTask
                                                          taskDelegate:taskDelegate
                                                                userId:userId
                                                           associateId:associateId
                                                                 error:&error];
        if (success == NO || error != nil) {
            //if we fail to persist data needed to support background session tasks, cancel the one we created and do not return it
            [sessionTask cancel];
            success = [self cleanUpBackgroundSessionTaskIfExistForUserId:userId associateId:associateId error:&error];
            BOXAssert(success, @"Failed to clean up session task after failing to persist its cached info", error);
            sessionTask = nil;
        } else if (newBackgroundDownloadTaskCreated == YES && [taskDelegate conformsToProtocol:@protocol(BOXURLSessionDownloadTaskDelegate)] == YES) {
            //for a new background download task, we need to cache destinationFilePath to be used later

            id<BOXURLSessionDownloadTaskDelegate> downloadTaskDelegate = (id<BOXURLSessionDownloadTaskDelegate>)taskDelegate;
            [self.cacheClient cacheBackgroundSessionId:backgroundSessionId
                                         sessionTaskId:sessionTask.taskIdentifier
                                   destinationFilePath:downloadTaskDelegate.destinationFilePath
                                                 error:&error];
        }
    }
    
    if (outError != nil) {
        *outError = error;
    }
    
    return sessionTask;
}

- (BOOL)persistBackgroundSessionTaskWithSessionId:(NSString *)backgroundSessionId
                                      sessionTask:(NSURLSessionTask *)task
                                     taskDelegate:(id <BOXURLSessionTaskDelegate>)taskDelegate
                                           userId:(NSString *)userId
                                      associateId:(NSString *)associateId
                                            error:(NSError **)error
{
    if (task == nil || taskDelegate == nil || userId == nil || associateId == nil) {
        if (error != nil) {
            *error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain
                                                code:BOXContentSDKURLSessionCacheErrorInvalidUserIdOrAssociateId
                                            userInfo:nil];
        }
        
        return NO;
    }

    [self associateSessionId:backgroundSessionId
                 sessionTask:task
            withTaskDelegate:taskDelegate];

    //cache background task if have not
    return [self.cacheClient cacheUserId:userId
                             associateId:associateId
                     backgroundSessionId:backgroundSessionId
                           sessionTaskId:task.taskIdentifier
                                   error:error];
}

- (id<BOXURLSessionTaskDelegate>)taskDelegateForSessionId:(NSString *)sessionId sessionTaskId:(NSUInteger)sessionTaskId
{
    id<BOXURLSessionTaskDelegate> taskDelegate = nil;
    
    if (sessionId == nil) {
        @synchronized (self.progressSessionTaskIdToTaskDelegate) {
            taskDelegate = [self.progressSessionTaskIdToTaskDelegate objectForKey:@(sessionTaskId)];
        }
    } else {
        @synchronized (self.backgroundSessionIdToSessionTask[sessionId]) {
            taskDelegate = [[self.backgroundSessionIdToSessionTask[sessionId] objectForKey:@(sessionTaskId)] delegate];
        }
    }
    
    return taskDelegate;
}

- (NSURLSessionTask *)existingBackgroundSessionTaskForSessionId:(NSString *)sessionId sessionTaskId:(NSUInteger)sessionTaskId
{
    @synchronized (self.backgroundSessionIdToSessionTask[sessionId]) {
        return [[self.backgroundSessionIdToSessionTask[sessionId] objectForKey:@(sessionTaskId)] task];
    }
}

- (BOOL)moveDownloadedFileAtTemporaryURL:(NSURL *)temporaryURL toDestinationFilePath:(NSString *)destinationFilePath error:(NSError **)error
{
    BOOL success = NO;
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
    } else {
        err = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKURLSessionErrorInvalidDestinationFilePath userInfo:nil];
    }

    if (error != nil) {
        *error = err;
    }
    
    return success;
}

- (BOOL)cacheResumeData:(NSData *)resumeData forUserId:(NSString *)userId associateId:(NSString *)associateId
{
    if (self.supportBackgroundSessionTasks == NO) {
        return NO;
    }
    NSError *error = nil;
    BOOL success = NO;
    if ([self.cacheClient isSessionTaskCompletedForUserId:userId associateId:associateId] == NO) {
        BOXURLBackgroundSessionIdAndSessionTaskId *backgroundSessionIdAndSessionTaskId = [self.cacheClient backgroundSessionIdAndSessionTaskIdForUserId:userId associateId:associateId error:&error];

        NSString *backgroundSessionId = backgroundSessionIdAndSessionTaskId.backgroundSessionId;
        NSUInteger sessionTaskId = backgroundSessionIdAndSessionTaskId.sessionTaskId;

        success = [self.cacheClient cacheBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId resumeData:resumeData error:&error];
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
    // This method is only called by background download tasks
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

            if ([taskDelegate conformsToProtocol:@protocol(BOXURLSessionDownloadTaskDelegate)] && [taskDelegate respondsToSelector:@selector(destinationFilePath)]) {
                id<BOXURLSessionDownloadTaskDelegate> downloadTaskDelegate = (id<BOXURLSessionDownloadTaskDelegate>)taskDelegate;
                destinationFilePath = [downloadTaskDelegate destinationFilePath];
            } else {
                destinationFilePath = [self.cacheClient destinationFilePathForBackgroundSessionId:session.configuration.identifier sessionTaskId:downloadTask.taskIdentifier];
            }
            success = [self moveDownloadedFileAtTemporaryURL:location toDestinationFilePath:destinationFilePath error:&error];
            if (success == NO) {
                NSLog(@"Failed to move downloaded file at temporary location %@ to %@ with error %@", location, destinationFilePath, error);
            }
            //FIXME: review if we should cache error failing to cache data or to move temporary file to destination path
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
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
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
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    if (session.configuration.identifier != nil) {
        //for background tasks, cache response data
        NSError *error = nil;
        BOOL success = [self.cacheClient cacheBackgroundSessionId:session.configuration.identifier
                                                    sessionTaskId:dataTask.taskIdentifier
                                                     responseData:data
                                                            error:&error];
        
        if (!success) {
            BOXLog(@"failed to cache response for background session task due to %@", error);
        }
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
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    if (session.configuration.identifier != nil) {
        //background session task finishes, cache its response and error

        NSError *err = nil;
        NSString *backgroundSessionId = session.configuration.identifier;

        BOOL success = [self.cacheClient cacheBackgroundSessionId:backgroundSessionId
                                                    sessionTaskId:task.taskIdentifier
                                                         response:task.response
                                                            error:&err];
        BOXAssert(success, @"failed to cache response for background session task with error %@", err);

        success = [self.cacheClient cacheBackgroundSessionId:session.configuration.identifier
                                               sessionTaskId:task.taskIdentifier
                                                   taskError:error
                                                       error:&err];
        BOXAssert(success, @"failed to cache error for background session task with error %@", err);

        //notify its taskDelegate about the completion with response, responseData, and error
        NSData *responseData = [self.cacheClient responseDataForBackgroundSessionId:backgroundSessionId
                                                                      sessionTaskId:task.taskIdentifier];
        
        //the task finished/cancelled, update its cache info accordingly
        success = [self.cacheClient completeSessionTaskForBackgroundSessionId:backgroundSessionId
                                                                sessionTaskId:task.taskIdentifier
                                                                        error:&err];
        BOXAssert(success, @"failed to complete session task for background session task with error %@", err);

        id<BOXURLSessionTaskDelegate> taskDelegate = [self taskDelegateForSessionId:backgroundSessionId
                                                                      sessionTaskId:task.taskIdentifier];
        [taskDelegate sessionTask:task
            didFinishWithResponse:task.response
                     responseData:responseData
                            error:error];

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
