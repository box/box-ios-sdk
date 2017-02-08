//
//  BOXURLSessionManager.h
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 12/15/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BOXURLSessionTaskDelegate <NSObject>

/**
 * To be called to finish the operation for a NSURLSessionTask upon its completion
 *
 * @param response  The response received from Box as a result of the API call.
 * @param error     An error in the NSURLErrorDomain
 */
- (void)sessionTask:(NSURLSessionTask *)sessionTask didFinishWithResponse:(NSURLResponse *)response error:(NSError *)error;

@optional

/**
 * To be called to process the intermediate response from the task
 *
 * @param response  The intermediate response received from Box as a result of the API call
 */
- (void)processIntermediateResponse:(NSURLResponse *)response;

/**
 * To be called to process the intermediate data from the task
 *
 * @param data  The intermediate data received from Box as a result of the API call
 */
- (void)processIntermediateData:(NSData *)data;

@end


@protocol BOXURLSessionDownloadTaskDelegate <BOXURLSessionTaskDelegate>

@optional

/**
 * Notify delegate about download progress
 */
- (void)downloadTask:(NSURLSessionDownloadTask *)downloadTask
   didWriteTotalBytes:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;

/**
 * Sent when a download session task has finish downloading into a url location
 */
- (void)downloadTask:(NSURLSessionTask *)sessionTask didFinishDownloadingToURL:(NSURL *)location;

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


@protocol BOXURLSessionManagerDelegate <BOXURLSessionDownloadTaskDelegate, BOXURLSessionUploadTaskDelegate>
@end

/**
 This class is responsible for creating different NSURLSessionTask
 */
@interface BOXURLSessionManager : NSObject

/**
 * This method needs to be called once to set up the manager to be ready to perform other public methods
 * @param defaultDelegate   handle callbacks from session tasks that do not have associated task delegates
 *                          possible if the background tasks were created outside of BOXURLSessionManager
 *                          (e.g. app restarts)
 *                          A task delegate can always be re-associated with a session task by calling
 *                          associateSessionTaskId:withTaskDelegate:
 */
- (void)setUpWithDefaultDelegate:(id<BOXURLSessionManagerDelegate>)defaultDelegate;

/**
 Create a NSURLSessionDataTask which does not need to be run in background,
 and its completionHandler will be called upon completion of the task
 */
- (NSURLSessionDataTask *)createDataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler;

/**
 Create a NSURLSessionDownloadTask which can be run in the background and download to an outputstream
 */
- (NSURLSessionDownloadTask *)createBackgroundDownloadTaskWithRequest:(NSURLRequest *)request taskDelegate:(id <BOXURLSessionDownloadTaskDelegate>)taskDelegate;

/**
 Create a NSURLSessionDataTask which can be run to download data into a destination path but not run in the background
 */
- (NSURLSessionDataTask *)createNonBackgroundDownloadTaskWithRequest:(NSURLRequest *)request taskDelegate:(id <BOXURLSessionDownloadTaskDelegate>)taskDelegate;

/**
 Create a NSURLSessionDownloadTask to be resumed
 */
- (NSURLSessionDownloadTask *)createBackgroundDownloadTaskWithResumeData:(NSData *)resumeData taskDelegate:(id <BOXURLSessionDownloadTaskDelegate>)taskDelegate;

/**
 Create a NSURLSessionUploadTask which can be run in background
 */
- (NSURLSessionUploadTask *)createBackgroundUploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL taskDelegate:(id <BOXURLSessionUploadTaskDelegate>)taskDelegate;

/**
 Create a non-background upload task given stream request
 */
- (NSURLSessionUploadTask *)createNonBackgroundUploadTaskWithStreamedRequest:(NSURLRequest *)request taskDelegate:(id <BOXURLSessionUploadTaskDelegate>)taskDelegate;

/**
 * Associate a session task with its task delegate to handle callbacks for it, taskDelegate is not retained
 */
- (void)associateSessionTaskId:(NSUInteger)sessionTaskId withTaskDelegate:(id <BOXURLSessionTaskDelegate> )taskDelegate;

/**
 * Dessociate a session task with its task delegate so the task delegate will no longer handle callbacks for the task
 */
- (void)dessociateSessionTaskId:(NSUInteger)sessionTaskId;

/**
 * Asynchronously calls a completion callback with all background upload, and download tasks in a session.
 */
- (void)pendingBackgroundDownloadUploadSessionTasks:(void (^)(NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks))completion;

@end

NS_ASSUME_NONNULL_END
