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

@end

@implementation BOXSampleAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#warning Set the client ID and client secret that can be retrieved by creating an application at http://developers.box.com
    [BOXContentClient setClientID:@"your_client_id" clientSecret:@"your_client_secret"];
    
    BOXAuthenticationPickerViewController *authenticationController = [[BOXAuthenticationPickerViewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:authenticationController];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];

    [self setUpSessionManager];

    return YES;
}

- (void)setUpSessionManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BOXNSURLSessionManager *manager = [BOXContentClient defaultClient].session.urlSessionManager;
        manager.delegate = self;

        [manager pendingBackgroundDownloadUploadSessionTasks:^(NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
            [self recoverDownloadTasks:downloadTasks];
        }];

    });
}

- (void)recoverDownloadTasks:(NSArray<NSURLSessionDownloadTask *> *)downloadTasks
{
    BOXContentClient *client = [BOXContentClient defaultClient];
    BOXSampleAppSessionManager *appSessionManager = [BOXSampleAppSessionManager defaultManager];

    for (NSURLSessionDownloadTask *downloadTask in downloadTasks) {
        BOXSampleAppSessionInfo *info = [appSessionManager getSessionTaskInfo:downloadTask.taskIdentifier];

        NSLog(@"reconnect download task info %@", info);
        if (info != nil) {
            BOXFileDownloadRequest *request = [client fileDownloadRequestWithID:info.associateId toLocalFilePath:info.destinationPath downloadTask:downloadTask downloadTaskReplacedBlock:^(NSURLSessionTask *oldSessionTask, NSURLSessionTask *newSessionTask) {
                [[BOXSampleAppSessionManager defaultManager] removeSessionTaskId:oldSessionTask.taskIdentifier];
                NSUInteger sessionTaskId = newSessionTask.taskIdentifier;
                BOXSampleAppSessionInfo *info = [[BOXSampleAppSessionInfo alloc] initWithAssociateId:info.associateId destinationPath:info.destinationPath];
                [[BOXSampleAppSessionManager defaultManager] saveSessionTaskId:sessionTaskId withInfo:info];
            }];

            [request performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                NSLog(@"download request info (%@, %@): %lld/%lld", info.associateId, info.destinationPath, totalBytesTransferred, totalBytesExpectedToTransfer);
            } completion:^(NSError *error) {
                NSLog(@"download request info (%@, %@) error: %@", info.associateId, info.destinationPath, error);
                [appSessionManager removeSessionTaskId:downloadTask.taskIdentifier];
            }];
        }
    }
}

- (void)downloadTask:(NSUInteger)sessionTaskId didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"sessionTaskId %lu location %@", (unsigned long)sessionTaskId, location);
}

- (void)finishURLSessionTask:(NSUInteger)sessionTaskId withResponse:(NSURLResponse *)response error:(NSError *)error
{
    NSLog(@"sessionTaskId %lu, response %@, error %@", sessionTaskId, response, error);
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
