//
//  BOXNSURLSessionManager.m
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 12/15/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import "BOXNSURLSessionManager.h"
#import "BOXNSURLSessionDelegate.h"

@interface BOXNSURLSessionManager()

//Default NSURLSession to be used by NSURLSessionTask which does not need to be run in the background
@property (nonatomic, readwrite, strong) NSURLSession *defaultSession;

//Background NSURLSession to be used by NSURLSessionTask which needs to be run in the background e.g. download, upload
@property (nonatomic, readwrite, strong) NSURLSession *backgroundSession;

//Delegate for background NSURLSession to handle its callbacks
@property (nonatomic, readwrite, strong) BOXNSURLSessionDelegate *sessionDelegate;

@end

@implementation BOXNSURLSessionManager

- (NSURLSession *)defaultSession
{
    if (_defaultSession == nil) {
        //FIXME: revisit configuration for url session and its operation queue
        //arbitrary maxConcurrentOperationCount given that the number should not go above
        //the max number of concurrent Box api operations
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.name = @"Default NSURLSession queue";
        queue.maxConcurrentOperationCount = 100;

        _defaultSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:queue];
    }
    return _defaultSession;
}

- (NSURLSession *)backgroundSession
{
    if (_backgroundSession == nil) {
        //FIXME: revisit configuration for url session and its operation queue
        //arbitrary maxConcurrentOperationCount given that the number should not go above
        //the max number of concurrent Box api operations
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.name = @"Background NSURLSession queue";
        queue.maxConcurrentOperationCount = 100;

        _backgroundSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self.sessionDelegate delegateQueue:queue];
    }
    return _backgroundSession;
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

- (NSURLSessionDataTask *)createLoginTask:(NSURL *)url
{
    return [self.backgroundSession dataTaskWithURL:url];
}

- (NSURLSessionDownloadTask *)createDownloadTaskWithRequest:(NSURLRequest *)request
{
    return [self.backgroundSession downloadTaskWithRequest:request];
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
