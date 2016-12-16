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

@property (nonatomic, readwrite, strong) NSURLSession *defaultSession;
@property (nonatomic, readwrite, strong) NSURLSession *backgroundSession;
@property (nonatomic, readwrite, strong) BOXNSURLSessionDelegate *sessionDelegate;

@end

@implementation BOXNSURLSessionManager

- (NSURLSession *)defaultSession
{
    if (_defaultSession == nil) {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.name = @"Default NSURLSession queue";
        queue.maxConcurrentOperationCount = 100;
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        _defaultSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:queue];
    }
    return _defaultSession;
}

- (NSURLSession *)backgroundSession
{
    if (_backgroundSession == nil) {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.name = @"Background NSURLSession queue";
        queue.maxConcurrentOperationCount = 100; //not important given there's a limit on number of concurrent operations on queues
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
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

- (NSURLSessionDataTask *)createLoginDataTask:(NSURL *)url
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
