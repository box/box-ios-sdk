//
//  BOXNSURLSessionManager.h
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 12/15/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BOXAPIDataOperation;

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
 Create a NSURLSessionDownloadTask which can be run in the background
 */
- (NSURLSessionDownloadTask *)createDownloadTaskWithRequest:(NSURLRequest *)request operation:(BOXAPIDataOperation *)operation;

- (NSURLSessionDataTask *)createDataTaskForDownload:(NSURLRequest *)request operation:(BOXAPIDataOperation *)operation;
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
