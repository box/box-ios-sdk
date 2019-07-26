//
//  BOXURLSessionManager.h
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 12/15/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOXURLSessionCacheClient.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BOXURLSessionTaskDelegate <NSObject>

/**
 * To be called to finish the operation for a NSURLSessionTask upon its completion
 *
 * @param response      The response received from Box as a result of the API call.
 * @param responseData  The response data received from Box as a result of the API call. Will be nil for foreground session tasks
 * @param error         An error in the NSURLErrorDomain
 */
- (void)sessionTask:(NSURLSessionTask *)sessionTask didFinishWithResponse:(NSURLResponse *)response responseData:(nullable NSData *)responseData error:(NSError *)error;

@optional

/**
 * To be called to process the intermediate response from the task
 *
 * @param response  The intermediate response received from Box as a result of the API call
 */
- (void)sessionTask:(NSURLSessionTask *)sessionTask processIntermediateResponse:(NSURLResponse *)response;

/**
 * To be called to process the intermediate data from the task
 *
 * @param data  The intermediate data received from Box as a result of the API call
 */
- (void)sessionTask:(NSURLSessionTask *)sessionTask processIntermediateData:(NSData *)data;

@end


@protocol BOXURLSessionDownloadTaskDelegate <BOXURLSessionTaskDelegate>

@optional

/**
 * Destination file path to move downloaded file into for background download
 */
- (NSString *)destinationFilePath;

/**
 * Notify delegate about download progress
 */
- (void)downloadTask:(NSURLSessionDownloadTask *)downloadTask
   didWriteTotalBytes:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;

@end


@protocol BOXURLSessionUploadTaskDelegate <BOXURLSessionTaskDelegate>

@optional

/**
 * Notify delegate about upload progress
 */
- (void)sessionTask:(NSURLSessionTask *)sessionTask
    didSendTotalBytes:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;

@end


@protocol BOXURLSessionManagerDelegate <BOXURLSessionCacheClientDelegate>
@end

/**
 This class is responsible for creating different NSURLSessionTask
 */
@interface BOXURLSessionManager : NSObject

/**
 * Should only use sharedInstance instead of creating a new instance of BOXURLSessionManager
 * BOXURLSessionManager is responsible for a unique background NSURLSession for the app
 * with BOXURLSessionManager itself as delegate
 */
+ (BOXURLSessionManager *)sharedInstance;

/**
 * This method needs to be called once in main app to set up the manager to be ready to
 * support background upload/download tasks.
 * If this method has not been called, all background task creations will fail
 *
 * @param delegate          used for encrypting/decrypting metadata cached for background session tasks
 * @param rootCacheDir      root directory for caching background session tasks' data
 * @param completionBlock   block to execute upon completion of setup, indicating background tasks can be provided
 */
- (void)oneTimeSetUpInAppToSupportBackgroundTasksWithDelegate:(id<BOXURLSessionManagerDelegate>)delegate
                                                 rootCacheDir:(NSString *)rootCacheDir
                                                   completion:(nullable void (^)( NSError * _Nullable error))completionBlock;

/**
 * This method needs to be called once in app extensions to set up the manager to be ready to
 * support background upload/download tasks.
 * If this method has not been called, all background task creations will fail in extensions
 *
 * @param delegate          used for encrypting/decrypting metadata cached for background session tasks
 * @param rootCacheDir      root directory for caching background session tasks' data. Should be the same
 *                          as rootCacheDir for main app to allow main app takes over background session
 *                          tasks created from extensions
 * @param sharedContainerIdentifier an identifier for a container shared between the app extension
 *                                  and its containing app. This is used to configure a background URL session
 *                                  to be used by an app extension.
 * @param completionBlock           block to execute upon completion of setup, indicating background tasks can be provided
 */
- (void)oneTimeSetUpInExtensionToSupportBackgroundTasksWithDelegate:(id<BOXURLSessionManagerDelegate>)delegate
                                                       rootCacheDir:(NSString *)rootCacheDir
                                          sharedContainerIdentifier:(NSString *)sharedContainerIdentifier
                                                         completion:(nullable void (^)(NSError * _Nullable error))completionBlock;

/**
 * This method results in this BOXURLSessionManager becomes the delegate for session with backgroundSessionId identifier
 * should share the same rootCacheDir as the main app to work properly
 *
 * @param backgroundSessionId   Id of background session to reconnect with
 * @param completionBlock           block to execute upon completion of reconnecting to background session
 */
- (void)reconnectWithBackgroundSessionIdFromExtension:(NSString *)backgroundSessionId
                                           completion:(nullable void (^)(NSError * _Nullable error))completionBlock;

/**
 Create a NSURLSessionDataTask which does not need to be run in background,
 and its completionHandler will be called upon completion of the task
 */
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler;

/**
 Create a NSURLSessionDataTask which can be run in foreground to download data
 */
- (NSURLSessionDataTask *)foregroundDownloadTaskWithRequest:(NSURLRequest *)request
                                               taskDelegate:(id <BOXURLSessionDownloadTaskDelegate>)taskDelegate;

/**
 Create a foreground upload task given stream request
 */
- (NSURLSessionUploadTask *)foregroundUploadTaskWithStreamedRequest:(NSURLRequest *)request
                                                       taskDelegate:(id <BOXURLSessionUploadTaskDelegate>)taskDelegate;

/**
 Retrieve a NSURLSessionDownloadTask to be run in the background to download file into a destination file path.
 If there is an existing task for userId and associateId and it's on-going, return that; if it finished, return nil.
 If have not seen this userId and associateId before or have cleaned it up
 using cleanUpBackgroundSessionTaskIfExistForUserId:associateId:error, return a new one.

 @param request         request to create download task with
 @param taskDelegate    the delegate to receive callback for the session task
 @param userId          userId that this task belongs to
 @param associateId     an id to associate with this session task to retrieve cache for or clean up later
 @param error           error if failed to create background task

 @return a background download task. Nil if already completed, or failed to get one because
 background session has not finished setting up. Wait for completionBlock of
 oneTimeSetUpInAppToSupportBackgroundTasksWithDelegate:rootCacheDir:completion in main app or
 oneTimeSetUpInExtensionToSupportBackgroundTasksWithDelegate:rootCacheDir:completion
 */
- (NSURLSessionDownloadTask *)backgroundDownloadTaskWithRequest:(NSURLRequest *)request
                                                   taskDelegate:(id <BOXURLSessionDownloadTaskDelegate>)taskDelegate
                                                         userId:(NSString *)userId
                                                    associateId:(NSString *)associateId
                                                          error:(NSError **)error;

/**
 Retrieve a NSURLSessionUploadTask which can be run in the background to upload file given an source file.
 If there is an existing task for userId and associateId and it's on-going, return that; if it finished, return nil.
 If have not seen this userId and associateId before or have cleaned it up
 using cleanUpBackgroundSessionTaskIfExistForUserId:associateId:error, return a new one.

 @param request         request to create upload task with
 @param fileURL         url of the source file to upload
 @param taskDelegate    the delegate to receive callback for the session task
 @param userId          userId that this task belongs to
 @param associateId     an id to associate with this session task to retrieve cache for or clean up later
 @param error           error if failed to create background task

 @return a background upload task. Nil if already completed, or failed to get one because
 background session has not finished setting up. Wait for completionBlock of
 oneTimeSetUpInAppToSupportBackgroundTasksWithDelegate:rootCacheDir:completion in main app or
 oneTimeSetUpInExtensionToSupportBackgroundTasksWithDelegate:rootCacheDir:completion
 */
- (NSURLSessionUploadTask *)backgroundUploadTaskWithRequest:(NSURLRequest *)request
                                                   fromFile:(NSURL *)fileURL
                                               taskDelegate:(id <BOXURLSessionUploadTaskDelegate>)taskDelegate
                                                     userId:(NSString *)userId
                                                associateId:(NSString *)associateId
                                                      error:(NSError **)error;

/**
 Retrieve completed session task's cached info associated with userId and associateId

 @param userId          userId that this task belongs to
 @param associateId     an id that uniquely identify the session task for this userId
 @param error           error retrieving cached info

 @return session task's cached info
 */
- (BOXURLSessionTaskCachedInfo *)sessionTaskCompletedCachedInfoGivenUserId:(NSString *)userId
                                                               associateId:(NSString *)associateId
                                                                     error:(NSError **)error;

/**
 Clean up session task's cached info associated with userId and associateId.
 Its task delegate will no longer handle callbacks for the task if any

 @param userId          userId that this task belongs to
 @param associateId     an id that uniquely identify the session task for this userId
 @param error           error retrieving cached info

 @return YES if successfully clean up, NO otherwise
 */
- (BOOL)cleanUpBackgroundSessionTaskIfExistForUserId:(NSString *)userId associateId:(NSString *)associateId error:(NSError **)error;

/**
 * Asynchronously calls a completion callback with all background upload, and download tasks in a session.
 */
- (void)pendingBackgroundDownloadUploadSessionTasks:(void (^)(NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks))completion;

/**
 * Cancel and clean up all background session tasks associated with this user
 */
- (void)cancelAndCleanUpBackgroundSessionTasksForUserId:(NSString *)userId error:(NSError **)outError;

/**
 * Cache resumeData for background download session task of this userId and associateId
 */
- (BOOL)cacheResumeData:(NSData *)resumeData forUserId:(NSString *)userId associateId:(NSString *)associateId;

@end

NS_ASSUME_NONNULL_END
