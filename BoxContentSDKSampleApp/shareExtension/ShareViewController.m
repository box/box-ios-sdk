//
//  ShareViewController.m
//  shareExtension
//
//  Created by Thuy Nguyen on 5/8/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import "ShareViewController.h"
#import <BoxContentSDK/BOXContentSDK.h>
#import "BOXSampleAppSessionManager.h"

@interface ShareViewController () <BOXURLSessionManagerDelegate>

@property (nonatomic, strong, readwrite) BOXContentClient *client;

@end

@implementation ShareViewController

- (void)setUp
{
#warning Set the client ID and client secret that can be retrieved by creating an application at http://developers.box.com

    [BOXContentClient setClientID:@"your_client_id" clientSecret:@"your_client_secret"];

    [BOXContentClient oneTimeSetUpInExtensionToSupportBackgroundTasksWithDelegate:self rootCacheDir:[BOXSampleAppSessionManager rootCacheDir] sharedContainerIdentifier:@"group.com.box.ios.dev" completion:^(NSError *error) {
        BOXAssert(error == nil, @"Failed to set up to support background tasks in ext with error %@", error);
    }];
    NSArray *users = [BOXContentClient users];
    if (users.count > 0) {
        BOXUser *user = users[0];
        self.client = [BOXContentClient clientForUser:user];
    }
}

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)upload:(NSURL *)url
{
    [self setUp];
    NSString *path = url.path;
    NSString *tempPath = [path stringByAppendingString:@".temp"];
    NSString *associateId = [BOXSampleAppSessionManager generateRandomStringWithLength:32];

    BOXFileUploadRequest *uploadRequest = [self.client fileUploadRequestInBackgroundToFolderWithID:@"6598717269" fromLocalFilePath:path uploadMultipartCopyFilePath:tempPath associateId:associateId];
    uploadRequest.enableCheckForCorruptionInTransit = YES;

    [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
        NSLog(@"----->>>>%lld, %lld", totalBytesTransferred, totalBytesExpectedToTransfer);
    } completion:^(BOXFile *file, NSError *error) {
        NSLog(@"----->>>>file %@, error %@", file, error);
    }];
}

- (void)didSelectPost {
    NSString *typeIdentifier = @"public.image";
    NSExtensionItem *item = self.extensionContext.inputItems.firstObject;
    NSItemProvider *itemProvider = item.attachments.firstObject;

    if ([itemProvider hasItemConformingToTypeIdentifier:typeIdentifier]) {
        [itemProvider loadItemForTypeIdentifier:typeIdentifier
                                        options:nil
                              completionHandler:^(NSURL *url, NSError *error) {
                                  [self upload:url];
                                  [self.extensionContext completeRequestReturningItems:@[]
                                                                     completionHandler:nil];
                              }];
    }
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
