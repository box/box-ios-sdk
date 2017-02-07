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

@interface BOXSampleAppDelegate () <BOXURLSessionManagerDelegate>

@property (nonatomic, strong, readwrite) NSMutableDictionary *sessionIdToRequest;

@end

@implementation BOXSampleAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#warning Set the client ID and client secret that can be retrieved by creating an application at http://developers.box.com
    [BOXContentClient setClientID:@"your_client_id" clientSecret:@"your_client_secret"];
    
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
        BOXURLSessionManager *manager = [BOXContentClient defaultClient].session.urlSessionManager;
        //FIXME: set up manager
    });
}

- (void)recoverDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    BOXContentClient *client = [BOXContentClient defaultClient];
    BOXSampleAppSessionManager *appSessionManager = [BOXSampleAppSessionManager defaultManager];
    BOXSampleAppSessionInfo *info = [appSessionManager getSessionTaskInfo:downloadTask.taskIdentifier];

    if (info != nil) {
        NSLog(@"reconnect download task info %@", info);
        NSString *requestId = [NSString stringWithFormat:@"%08X", arc4random()];

        BOXFileDownloadRequest *request = [client fileDownloadRequestWithID:info.associateId toLocalFilePath:info.destinationPath downloadTask:downloadTask downloadTaskReplacedBlock:^(NSURLSessionTask *oldSessionTask, NSURLSessionTask *newSessionTask) {
            //cache info for background download task so we can reconnect delegate to handle the download task's callbacks
            if (newSessionTask == nil) {
                [appSessionManager removeRequestId:requestId];
            } else {
                BOXSampleAppSessionInfo *info = [[BOXSampleAppSessionInfo alloc] initWithAssociateId:info.associateId destinationPath:info.destinationPath];
                [appSessionManager saveSessionInfo:info withRequestId:requestId];
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
            [appSessionManager removeRequestId:requestId];
        }];
    } else {
        NSLog(@"unrecognized downloadTask %lu", downloadTask.taskIdentifier);
    }
}

- (void)recoverUploadTask:(NSURLSessionUploadTask *)uploadTask
{
    BOXContentClient *client = [BOXContentClient defaultClient];
    BOXSampleAppSessionManager *appSessionManager = [BOXSampleAppSessionManager defaultManager];
    BOXSampleAppSessionInfo *info = [appSessionManager getSessionTaskInfo:uploadTask.taskIdentifier];

    if (info != nil) {
        NSLog(@"reconnect upload task info %@", info);
        NSString *requestId = [NSString stringWithFormat:@"%08X", arc4random()];

        BOXFileUploadRequest *request = [client fileUploadRequestInBackgroundToFolderWithID:info.folderId fromLocalFilePath:info.associateId uploadMultipartCopyFilePath:info.tempUploadFilePath];

        //register download task and its equivalent request to allow cancelling of request
        //if download task finishes before request starts and becomes its delegate
        @synchronized (self.sessionIdToRequest) {
            self.sessionIdToRequest[@(uploadTask.taskIdentifier)] = request;
        }
        [request performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
            NSLog(@"upload request progress %lld/%lld, info (%@, %@)", totalBytesTransferred, totalBytesExpectedToTransfer, info.associateId, info.folderId);
        } completion:^(BOXFile *file, NSError *error) {
            NSLog(@"upload request completed,file: %@, error: %@, info (%@, %@)", file, error, info.associateId, info.folderId);
            [[NSFileManager defaultManager] removeItemAtPath:info.tempUploadFilePath error:nil];
            [appSessionManager removeRequestId:requestId];
        }];
    } else {
        NSLog(@"unrecognized upload %lu", uploadTask.taskIdentifier);
    }
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
