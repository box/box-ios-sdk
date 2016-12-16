//
//  BOXURLSessionDelegate.m
//  BoxContentSDK
//
//  Created by James Lawton on 12/15/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import "BOXURLSessionDelegate.h"
#import "BOXURLSessionIdentifier.h"
#import "BOXLog.h"

NS_ASSUME_NONNULL_BEGIN

@interface BOXURLSessionDelegate ()
@property (nonatomic, readonly) NSMutableDictionary<NSNumber *, NSString *> *taskIdentifiers;
@end

@implementation BOXURLSessionDelegate

- (instancetype)initWithAbstractSession:(BOXAbstractSession *)abstractSession
{
    self = [super init];
    if (self) {
        _abstractSession = abstractSession;
        _taskIdentifiers = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Task ID

- (void)associateTask:(NSURLSessionTask *)task withIdentifier:(NSString *)identifier
{
    @synchronized (self.taskIdentifiers) {
        self.taskIdentifiers[@(task.taskIdentifier)] = [identifier copy];
    }
}

- (nullable NSString *)popIdentifierForTask:(NSURLSessionTask *)task
{
    @synchronized (self.taskIdentifiers) {
        NSString *taskID = self.taskIdentifiers[@(task.taskIdentifier)];
        [self.taskIdentifiers removeObjectForKey:@(task.taskIdentifier)];
        return taskID;
    }
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error
{
    // The last call we will see for the session
    @synchronized (self.taskIdentifiers) {
        [self.taskIdentifiers removeAllObjects];
    }
    self.downloadDidComplete = nil;
    self.uploadDidComplete = nil;
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    // If we don't own this session (maybe it was created by an App Extension, and we're in the App)
    // dispose of it once all of the events have been delivered. Then the extension can reuse the session ID.
    // If we own this session, we can just keep it around for future work.
    NSString *sessionID = session.configuration.identifier;
    if (sessionID) {
        BOXURLSessionIdentifier *identifier = [[BOXURLSessionIdentifier alloc] initWithIdentifierString:sessionID];
        BOXAssert(identifier != nil, @"Unknown session identifier");
        if (!identifier.wasCreatedFromCurrentBundle) {
            [session finishTasksAndInvalidate];
        }
    }
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    // The last call we will see from a given task
    NSString *taskID = [self popIdentifierForTask:task];
    if (taskID) {
        if (error && [task isKindOfClass:[NSURLSessionDownloadTask class]]) {
            BOXURLSessionDownloadCompletion completion = self.downloadDidComplete;
            if (completion) {
                completion(taskID, nil, task.response, error);
            }
        }
    }
}

#pragma mark - NSURLSessionDataDelegate



#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString *taskID = [self popIdentifierForTask:downloadTask];
    BOXURLSessionDownloadCompletion completion = self.downloadDidComplete;
    if (taskID && completion) {
        completion(taskID, location, downloadTask.response, downloadTask.error);
    }
}

@end

NS_ASSUME_NONNULL_END
