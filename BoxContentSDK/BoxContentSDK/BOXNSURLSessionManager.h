//
//  BOXNSURLSessionManager.h
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 12/15/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BOXNSURLSessionTaskDelegate <NSObject>

/**
 * To be called to finish the operation for a NSURLSessionTask upon its completion
 *
 * @param response  The response received from Box as a result of the API call.
 * @param error     An error in the NSURLErrorDomain
 */
- (void)finishURLSessionTaskWithResponse:(NSURLResponse *)response error:(NSError *)error;

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

@protocol BOXNSURLSessionDownloadTaskDelegate <BOXNSURLSessionTaskDelegate>

@optional

/**
 * To be called to report ongoing progress of the task
 */
- (void)progressWithTotalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;

/**
 * Notify that the file has been downloaded to the location
 * The delegate should copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns.
 */
- (void)didFinishDownloadingToURL:(NSURL *)location;

@end

@protocol BOXNSURLSessionManagerDelegate <NSObject>

/**
 * Sent when a download session task has finish downloading into a url location
 */
- (void)downloadTask:(NSUInteger)sessionTaskId didFinishDownloadingToURL:(NSURL *)location;

/**
 * Sent when a session task finishes
 */
- (void)finishURLSessionTask:(NSUInteger)sessionTaskId withResponse:(NSURLResponse *)response error:(NSError *)error;

@end

/**
 This class is responsible for creating different NSURLSessionTask
 */
@interface BOXNSURLSessionManager : NSObject

/**
 * A delegate to handle callbacks from session tasks that do not have associated task delegates
 * This is possible if the background tasks were created outside of this BOXNSURLSessionManager (e.g. app restarts)
 * A task delegate can always be re-associated back with a session task by calling associateSessionTaskId:withTaskDelegate:
 */
@property (nonatomic, strong, readwrite) id<BOXNSURLSessionManagerDelegate> delegate;

/**
 Create a NSURLSessionDataTask which does not need to be run in background,
 and its completionHandler will be called upon completion of the task
 */
- (NSURLSessionDataTask *)createDataTask:(NSURLRequest *)request completionHandler:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler;

/**
 Create a NSURLSessionDownloadTask which can be run in the background and download to an outputstream
 */
- (NSURLSessionDownloadTask *)createDownloadTaskWithRequest:(NSURLRequest *)request taskDelegate:(id <BOXNSURLSessionDownloadTaskDelegate>)taskDelegate;

/**
 Create a NSURLSessionDataTask which can be run to download data into a destination path but not run in the background
 */
- (NSURLSessionDataTask *)createDataTaskForDownload:(NSURLRequest *)request taskDelegate:(id <BOXNSURLSessionDownloadTaskDelegate>)taskDelegate;

/**
 Create a NSURLSessionDownloadTask to be resumed
 */
- (NSURLSessionDownloadTask *)createDownloadTaskWithResumeData:(NSData *)resumeData;

/**
 Create a NSURLSessionUploadTask which can be run in background
 */
- (NSURLSessionUploadTask *)createUploadTask:(NSURLRequest *)request fromFile:(NSURL *)fileURL;

/**
 * Associate a session task with its task delegate to handle callbacks for it, taskDelegate is not retained
 */
- (void)associateSessionTaskId:(NSUInteger)sessionTaskId withTaskDelegate:(id <BOXNSURLSessionTaskDelegate> )taskDelegate;

/**
 * Dessociate a session task with its task delegate so the task delegate will no longer handle callbacks for the task
 */
- (void)dessociateSessionTaskId:(NSUInteger)sessionTaskId;

@end

NS_ASSUME_NONNULL_END
