//
//  AppDelegate.m
//  BoxContentSDKSampleApp
//
//  Created on 1/5/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXSampleAppDelegate.h"
#import "BOXAuthenticationPickerViewController.h"
#import "BOXSampleAppSessionManager.h"

@interface BOXSampleAppDelegate () <BOXNSURLSessionManagerDelegate>

@property (nonatomic, strong, readwrite) NSMutableDictionary *sessionIdToRequest;

@end

@implementation BOXSampleAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [BOXContentClient setClientID:@"666hanme8zg4f7am8zqyewyv2d5lhyku" clientSecret:@"9YinUc54qsQVWuSkyMr25wT7GU9FXP6q"];
    
    BOXAuthenticationPickerViewController *authenticationController = [[BOXAuthenticationPickerViewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:authenticationController];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    self.sessionIdToRequest = [[NSMutableDictionary alloc] init];
    [self setUpSessionManager];

    return YES;
}

- (void)setUpSessionManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BOXNSURLSessionManager *manager = [BOXContentClient defaultClient].session.urlSessionManager;
        [manager setUpWithDefaultDelegate:self];
    });
}

- (void)recoverDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    BOXContentClient *client = [BOXContentClient defaultClient];
    BOXSampleAppSessionManager *appSessionManager = [BOXSampleAppSessionManager defaultManager];
    BOXSampleAppSessionInfo *info = [appSessionManager getSessionTaskInfo:downloadTask.taskIdentifier];

    if (info != nil) {
        NSLog(@"reconnect download task info %@", info);

        BOXFileDownloadRequest *request = [client fileDownloadRequestWithID:info.associateId toLocalFilePath:info.destinationPath downloadTask:downloadTask downloadTaskReplacedBlock:^(NSURLSessionTask *oldSessionTask, NSURLSessionTask *newSessionTask) {
            //persist info for background download task so we can reconnect delegate to handle the download task's callbacks
            if (oldSessionTask != nil) {
                [[BOXSampleAppSessionManager defaultManager] removeSessionTaskId:oldSessionTask.taskIdentifier];
            }
            if (newSessionTask != nil) {
                NSUInteger sessionTaskId = newSessionTask.taskIdentifier;
                BOXSampleAppSessionInfo *info = [[BOXSampleAppSessionInfo alloc] initWithAssociateId:info.associateId destinationPath:info.destinationPath];
                [[BOXSampleAppSessionManager defaultManager] saveSessionTaskId:sessionTaskId withInfo:info];
            }
        }];
        //register download task and its equivalent request to allow cancelling of request
        //if download task finishes before request starts and becomes its delegate
        @synchronized (self.sessionIdToRequest) {
            self.sessionIdToRequest[@(downloadTask.taskIdentifier)] = request;
        }
        [request performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
            NSLog(@"download request progress %lld/%lld, info (%@, %@)", totalBytesTransferred, totalBytesExpectedToTransfer, info.associateId, info.destinationPath);
        } completion:^(NSError *error) {
            NSLog(@"download request completed, error: %@, info (%@, %@)", error, info.associateId, info.destinationPath);
            [appSessionManager removeSessionTaskId:downloadTask.taskIdentifier];
        }];
    } else {
        NSLog(@"unrecognized downloadTask %lu", downloadTask.taskIdentifier);
    }
}

- (void)downloadTask:(NSURLSessionDownloadTask *)downloadTask
   totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"sessionTaskId %lu, totalBytesWritten %lld, totalBytesExpectedToWrite %lld", (unsigned long)downloadTask.taskIdentifier, totalBytesWritten, totalBytesExpectedToWrite);
    [self recoverDownloadTask:downloadTask];
}

- (void)downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"downloadTask sessionTaskId %lu location %@", (unsigned long)downloadTask.taskIdentifier, location);
    @synchronized (self.sessionIdToRequest) {
        if (self.sessionIdToRequest[@(downloadTask.taskIdentifier)] != nil) {
            BOXFileDownloadRequest *request = self.sessionIdToRequest[@(downloadTask.taskIdentifier)];
            [request cancel];
            [self.sessionIdToRequest removeObjectForKey:@(downloadTask.taskIdentifier)];
        }
    }
}

- (void)uploadTask:(NSURLSessionDataTask *)sessionTask
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    NSLog(@"uploadTask sessionTaskId %lu", sessionTask.taskIdentifier);
}

- (void)finishURLSessionTask:(NSURLSessionTask *)sessionTask withResponse:(NSURLResponse *)response error:(NSError *)error
{
    //could be called to handle any session task whose delegate might have gone away like thumbnail requests if scrolled past them
    NSLog(@"sessionTaskId %lu, response %@, error %@", sessionTask.taskIdentifier, response, error);
    @synchronized (self.sessionIdToRequest) {
        if (self.sessionIdToRequest[@(sessionTask.taskIdentifier)] != nil) {
            BOXFileDownloadRequest *request = self.sessionIdToRequest[@(sessionTask.taskIdentifier)];
            [request cancel];
            [self.sessionIdToRequest removeObjectForKey:@(sessionTask.taskIdentifier)];
        }
    }
    [[BOXSampleAppSessionManager defaultManager] removeSessionTaskId:sessionTask.taskIdentifier];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    NSLog(@"handleEventsForBackgroundURLSession identifier %@", identifier);
    [self setUpSessionManager];
    completionHandler();
}

@end
