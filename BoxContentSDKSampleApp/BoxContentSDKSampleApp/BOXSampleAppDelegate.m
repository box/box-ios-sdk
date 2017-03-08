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

#import <BoxContentSDK/BOXContentSDK.h>

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

    return YES;
}

- (void)recoverDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    //FIXME: NOTE the sample app does NOT use the default client, need to grab the current active client.
    BOXContentClient *client = [BOXContentClient defaultClient];
    BOXSampleAppSessionManager *appSessionManager = [BOXSampleAppSessionManager defaultManager];
    BOXSampleAppSessionInfo *info = [appSessionManager getSessionTaskInfo:downloadTask.taskIdentifier];

    if (info != nil) {
        NSLog(@"reconnect download task info %@", info);
        //FIXME: retrieve associateId from cache
        NSString *associateId = @"";
        BOXFileDownloadRequest *request = [client fileDownloadRequestWithID:info.associateId toLocalFilePath:info.destinationPath associateId:associateId];

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
    //FIXME: Need to get the BOXContentClient for the currently logged in user and set up its URL session manager
//    BOXURLSessionManager *manager = client.session.urlSessionManager;
//    [manager setUpWithDefaultDelegate:self];
    completionHandler();
}

@end
