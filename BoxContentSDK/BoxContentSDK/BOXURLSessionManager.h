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

- (NSString *)urlSessionTaskDelegateId;

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


@interface BOXURLSessionTaskCompletionInfo : NSObject

@property (nonatomic, strong, readwrite) NSURLResponse *response;
@property (nonatomic, strong, readwrite) NSError *error;

@end

@interface BOXURLSessionDownloadTaskCompletionInfo : BOXURLSessionTaskCompletionInfo
@property (nonatomic, strong, readwrite) NSString *downloadedFilePath;
@end

@interface BOXURLSessionUploadTaskCompletionInfo : BOXURLSessionTaskCompletionInfo
@end

@interface BOXURLSessionDownloadTaskAndCompletionInfo : NSObject
@property (nonatomic, strong, readwrite) NSURLSessionDownloadTask *sessionTask;
@property (nonatomic, strong, readwrite) BOXURLSessionDownloadTaskCompletionInfo *completionInfo;
@end

@interface BOXURLSessionUploadTaskAndCompletionInfo : NSObject
@property (nonatomic, strong, readwrite) NSURLSessionUploadTask *sessionTask;
@property (nonatomic, strong, readwrite) BOXURLSessionUploadTaskCompletionInfo *completionInfo;
@end


typedef NSData *(^BOXEncryptCompletionInfoBlock)(BOXURLSessionTaskCompletionInfo *completionInfo);
typedef BOXURLSessionTaskCompletionInfo *(^BOXDecryptCompletionInfoBlock)(NSData *data);

@protocol BOXURLSessionManagerDelegate <NSObject>

- (void)associateUrlSessionTaskId:(NSUInteger)urlSessionTaskId withDelegateId:(NSString *)delegateId;
- (void)dessociateUrlSessionTaskId:(NSUInteger)urlSessionTaskId fromDelegateId:(NSString *)delegateId;

/**
 * Copy/move file at the input URL into another location and return the new location.
 * This also allows file to be encrypted as soon as its download completes in the background
 * when no delegate is assigned to the download task
 */
- (NSString *)defaultHandleOfDownloadedFileAtURL:(NSURL *)url;

- (BOXEncryptCompletionInfoBlock *)encryptCompletionInfoBlock;

- (BOXDecryptCompletionInfoBlock *)decryptCompletionInfoBlock;

@end

@protocol BOXURLSessionTaskCacheAssistantDelegate <NSObject>

- (BOOL)shouldCacheSessionTaskId:(NSUInteger)sessionTaskId;

@end

/**
 This class is responsible for creating different NSURLSessionTask
 */
@interface BOXURLSessionManager : NSObject

//to be called
- (void)setUpWithManagerDelegate:(id<BOXURLSessionManagerDelegate>)managerDelegate cacheAssistant:(id<BOXURLSessionTaskCacheAssistantDelegate>)cacheAssistant;

/**
 Create a NSURLSessionDataTask which does not need to be run in background,
 and its completionHandler will be called upon completion of the task
 */
- (NSURLSessionDataTask *)createDataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler;

/**
 Create a NSURLSessionDownloadTask which can be run in the background and download to an outputstream
 */
- (NSURLSessionDownloadTask *)createBackgroundDownloadTaskWithRequest:(NSURLRequest *)request;

/**
 Create a NSURLSessionDataTask which can be run to download data into a destination path but not run in the background
 */
- (NSURLSessionDataTask *)createNonBackgroundDownloadTaskWithRequest:(NSURLRequest *)request;

/**
 Create a NSURLSessionDownloadTask to be resumed
 */
- (NSURLSessionDownloadTask *)createBackgroundDownloadTaskWithResumeData:(NSData *)resumeData;

/**
 Create a NSURLSessionUploadTask which can be run in background
 */
- (NSURLSessionUploadTask *)createBackgroundUploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL;

/**
 Create a non-background upload task given stream request
 */
- (NSURLSessionUploadTask *)createNonBackgroundUploadTaskWithStreamedRequest:(NSURLRequest *)request;

- (BOXURLSessionDownloadTaskAndCompletionInfo *)retrieveUrlSessionDownloadTaskAndCompletionInfoGivenTaskId:(NSUInteger)sessionTaskId;

- (BOXURLSessionUploadTaskAndCompletionInfo *)retrieveUrlSessionUploadTaskAndCompletionInfoGivenTaskId:(NSUInteger)sessionTaskId;

- (void)taskDelegate:(id<BOXURLSessionTaskDelegate>)taskDelegate becomesDelegateForSessionTaskId:(NSUInteger)sessionTaskId;

/**
 * Remove association of taskDelegate with corresponding sessionTaskId.
 * Internally, it might result in checking the state of the sessionTask and cleaning up its completion info accordingly
 */
- (void)taskDelegate:(id<BOXURLSessionTaskDelegate>)taskDelegate stopsBeingDelegateForSessionTaskId:(NSUInteger)sessionTaskId;

- (BOXURLSessionTaskCompletionInfo *)retrieveCompletionInfoForSessionTaskId:(NSUInteger)sessionTaskId;

- (void)removeCompletionInfoForSessionTaskId:(NSUInteger)sessionTaskId;

@end

NS_ASSUME_NONNULL_END
