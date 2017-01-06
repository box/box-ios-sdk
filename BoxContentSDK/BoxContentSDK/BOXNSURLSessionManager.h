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

/**
 * To be called to report ongoing progress of the task
 */
- (void)progressWithExpectedTotalBytes:(long long)expectedTotalBytes totalBytesReceived:(unsigned long long)totalBytesReceived;

@end

@protocol BOXNSURLSessionDownloadTaskDelegate <NSObject>

@optional
- (NSString *)destinationPath;
- (NSOutputStream *)outputStream;

@end

/**
 This class is responsible for creating different NSURLSessionTask
 */
@interface BOXNSURLSessionManager : NSObject

/**
 Create a NSURLSessionDataTask which does not need to be run in background,
 and its completionHandler will be called upon completion of the task
 */
- (NSURLSessionDataTask *)createDataTask:(NSURLRequest *)request completionHandler:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler;

/**
 Create a NSURLSessionDownloadTask which can be run in the background and download to an outputstream
 */
- (NSURLSessionDownloadTask *)createDownloadTaskWithRequest:(NSURLRequest *)request taskDelegate:(id <BOXNSURLSessionTaskDelegate, BOXNSURLSessionDownloadTaskDelegate>)taskDelegate;

/**
 Create a NSURLSessionDataTask which can be run to download data into a destination path but not run in the background
 */
- (NSURLSessionDataTask *)createDataTaskForDownload:(NSURLRequest *)request taskDelegate:(id <BOXNSURLSessionTaskDelegate, BOXNSURLSessionDownloadTaskDelegate>)taskDelegate;

/**
 Create a NSURLSessionDownloadTask to be resumed
 */
- (NSURLSessionDownloadTask *)createDownloadTaskWithResumeData:(NSData *)resumeData;

/**
 Create a NSURLSessionUploadTask which can be run in background
 */
- (NSURLSessionUploadTask *)createUploadTask:(NSURLRequest *)request fromFile:(NSURL *)fileURL;

@end

NS_ASSUME_NONNULL_END
