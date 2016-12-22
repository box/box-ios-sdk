//
//  BOXNSURLSessionDelegate.m
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 12/15/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import "BOXNSURLSessionDelegate.h"
#import "BOXAPIDataOperation.h"

NS_ASSUME_NONNULL_BEGIN

/**
    FIXME: implement details for the callbacks of interfaces
     NSURLSessionDelegate
     NSURLSessionTaskDelegate
     NSURLSessionDataDelegate
     NSURLSessionDownloadDelegate
     NSURLSessionStreamDelegate
 */


@interface BOXNSURLSessionDelegate()

//a map to associate a session with its BOXAPIOperation
//during session/task's delegate callbacks, we call appropriate methods on operation
@property (nonatomic, readwrite, strong) NSMutableDictionary *sessionIdToOperation;

@end

@implementation BOXNSURLSessionDelegate

- (NSMutableDictionary *)sessionIdToOperation
{
    if (_sessionIdToOperation == nil) {
        _sessionIdToOperation = [NSMutableDictionary new];
    }
    return _sessionIdToOperation;
}

- (void)mapSessionTaskId:(NSUInteger)sessionTaskId withOperation:(BOXAPIOperation *)operation
{
    [self.sessionIdToOperation setObject:operation forKey:@(sessionTaskId)];
}

#pragma mark - NSURLSessionDownloadDelegate

/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    BOXAPIOperation *operation = [self.sessionIdToOperation objectForKey:@(downloadTask.taskIdentifier)];
    if (operation != nil && [operation isKindOfClass:[BOXAPIDataOperation class]]) {
        BOXAPIDataOperation *dataOperation = (BOXAPIDataOperation *)operation;
        [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:dataOperation.destinationPath error:nil];
    }
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    BOXAPIOperation *operation = [self.sessionIdToOperation objectForKey:@(downloadTask.taskIdentifier)];
    if (operation != nil && [operation isKindOfClass:[BOXAPIDataOperation class]]) {
        BOXAPIDataOperation *dataOperation = (BOXAPIDataOperation *)operation;
        if (dataOperation.progressBlock != nil) {
            dataOperation.progressBlock(totalBytesExpectedToWrite, totalBytesWritten);
        }
    }
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    BOXAPIOperation *operation = [self.sessionIdToOperation objectForKey:@(dataTask.taskIdentifier)];
    if (operation != nil && [operation isKindOfClass:[BOXAPIDataOperation class]]) {
        BOXAPIDataOperation *dataOperation = (BOXAPIDataOperation *)operation;
        [dataOperation processIntermediateResponse:response];
    }

    if (completionHandler != nil) {
        completionHandler(NSURLSessionResponseAllow);
    }
}

/* Sent when data is available for the delegate to consume.  It is
 * assumed that the delegate will retain and not copy the data.  As
 * the data may be discontiguous, you should use
 * [NSData enumerateByteRangesUsingBlock:] to access it.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    BOXAPIOperation *operation = [self.sessionIdToOperation objectForKey:@(dataTask.taskIdentifier)];
    if (operation != nil && [operation isKindOfClass:[BOXAPIDataOperation class]]) {
        BOXAPIDataOperation *dataOperation = (BOXAPIDataOperation *)operation;
        [dataOperation processIntermediateData:data];
    }
}

#pragma mark - NSURLSessionTaskDelegate

/* Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    BOXAPIOperation *operation = [self.sessionIdToOperation objectForKey:@(task.taskIdentifier)];
    if (operation != nil && [operation isKindOfClass:[BOXAPIDataOperation class]]) {
        BOXAPIDataOperation *dataOperation = (BOXAPIDataOperation *)operation;
        [dataOperation finishURLSessionTaskWithData:nil response:task.response error:error];
    }
}

@end

NS_ASSUME_NONNULL_END
