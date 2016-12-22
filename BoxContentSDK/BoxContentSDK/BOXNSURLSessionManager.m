//
//  BOXNSURLSessionManager.m
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 12/15/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import "BOXNSURLSessionManager.h"
#import "BOXNSURLSessionDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface BOXNSURLSessionManager()

//Default NSURLSession to be used by NSURLSessionTask which does not need to be run in the background
@property (nonatomic, readwrite, strong) NSURLSession *defaultSession;

//Advanced NSURLSession to be used by NSURLSessionTask which needs a delegate to handle specific tasks
//during the life of a session/task, and to be run in the background e.g. download, upload
@property (nonatomic, readwrite, strong) NSURLSession *advancedSession;

//Delegate for background NSURLSession to handle its callbacks
@property (nonatomic, readwrite, strong) BOXNSURLSessionDelegate *sessionDelegate;

@end

static const NSString *backgroundSessionIdentifier = @"com.box.BOXNSURLSessionManager.backgroundSessionIdentifier";

@implementation BOXNSURLSessionManager

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

- (NSURLSession *)backgroundSession
{
    if (_advancedSession == nil) {
        //FIXME: revisit configuration for url session and its operation queue
        //arbitrary maxConcurrentOperationCount given that the number should not go above
        //the max number of concurrent Box api operations
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:backgroundSessionIdentifier];

        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.name = @"com.box.BOXNSURLSessionManager.advanced";
        queue.maxConcurrentOperationCount = 8;

        _advancedSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self.sessionDelegate delegateQueue:queue];
    }
    return _advancedSession;
}

- (BOXNSURLSessionDelegate *)sessionDelegate
{
    if (_sessionDelegate == nil) {
        _sessionDelegate = [[BOXNSURLSessionDelegate alloc] init];
    }
    return _sessionDelegate;
}

- (NSURLSessionDataTask *)createDataTask:(NSURLRequest *)request completionHandler:(void (^)(NSData * data, NSURLResponse * response, NSError * error))completionHandler
{
    return [self.defaultSession dataTaskWithRequest:request completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)createDataTaskForDownload:(NSURLRequest *)request operation:(BOXAPIDataOperation *)operation
{
    NSURLSessionTask *task = [self.backgroundSession dataTaskWithRequest:request];
    [self.sessionDelegate mapSessionTaskId:task.taskIdentifier withOperation:operation];
    return task;
}

- (NSURLSessionDownloadTask *)createDownloadTaskWithRequest:(NSURLRequest *)request operation:(BOXAPIDataOperation *)operation
{
    NSURLSessionTask *task = [self.backgroundSession downloadTaskWithRequest:request];
    [self.sessionDelegate mapSessionTaskId:task.taskIdentifier withOperation:operation];
    return task;
}

- (NSURLSessionDownloadTask *)createDownloadTaskWithResumeData:(NSData *)resumeData
{
    return [self.backgroundSession downloadTaskWithResumeData:resumeData];
}

- (NSURLSessionUploadTask *)createUploadTask:(NSURLRequest *)request fromFile:(NSURL *)fileURL
{
    return [self.backgroundSession uploadTaskWithRequest:request fromFile:fileURL];
}

@end

NS_ASSUME_NONNULL_END
