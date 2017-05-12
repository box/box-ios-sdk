//
//  BOXSampleAppBackgroundTasksRecovery.m
//  BoxContentSDKSampleApp
//
//  Created by Thuy Nguyen on 5/12/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import "BOXSampleAppBackgroundTasksRecovery.h"
#import "BOXSampleAppSessionManager.h"
@import BoxContentSDK;


@implementation BOXSampleAppBackgroundTasksRecovery

+ (void)reconnectBackgroundTasks:(BOXContentClient *)client
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        BOXSampleAppSessionManager *sessionManager = [BOXSampleAppSessionManager defaultManager];

        NSString *sharedContainerIdentifier = @"group.BoxContentSDKSampleApp";
        NSArray *extensionIds = [BOXSampleAppSessionManager allExtensionIdsGivenSharedContainerId:sharedContainerIdentifier];

        for (NSString *extensionId in extensionIds) {
            [sessionManager populateInfoForExtensionId:extensionId];
        }

        NSString *userId = client.user.modelID;
        NSDictionary *backgroundSessionIdToAssociateIdAndSessionTaskInfo = [sessionManager backgroundSessionIdToAssociateIdAndSessionTaskInfoForUserId:userId];

        for (NSString *backgroundSessionId in backgroundSessionIdToAssociateIdAndSessionTaskInfo.allKeys) {
            BOXSampleAppSessionManager *appSessionManager = [BOXSampleAppSessionManager defaultManager];
            NSDictionary *associateIdToSessionTaskInfo = backgroundSessionIdToAssociateIdAndSessionTaskInfo[backgroundSessionId];

            for (NSString *associateId in associateIdToSessionTaskInfo.allKeys) {
                BOXSampleAppSessionInfo *info = associateIdToSessionTaskInfo[associateId];
                if (info.destinationPath != nil) {
                    //recreate download task
                    BOXFileDownloadRequest *downloadRequest = [client fileDownloadRequestWithID:info.fileID toLocalFilePath:info.destinationPath associateId:associateId];

                    [downloadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                        BOXLog(@"download request progress %lld/%lld, info (%@, %@)", totalBytesTransferred, totalBytesExpectedToTransfer, info.fileID, info.destinationPath);
                    } completion:^(NSError *error) {
                        BOXLog(@"download request completed, error: %@, info (%@, %@)", error, info.fileID, info.destinationPath);
                        [appSessionManager removeBackgroundSessionId:backgroundSessionId userId:userId associateId:associateId];
                    }];
                } else {
                    //Note: for simulator testing purposes, we need to re-create the path to the dummy upload file
                    //instead of the previous simulator path which no longer exists after app restarts
                    NSString *dummyImageName = @"Logo_Box_Blue_Whitebg_480x480.jpg";
                    NSString *path = [[NSBundle mainBundle] pathForResource:dummyImageName ofType:nil];

                    NSString *tempFileName = [BOXSampleAppSessionManager generateRandomStringWithLength:32];
                    NSString *tempPath = [[[BOXSampleAppSessionManager defaultManager] boxURLRequestCacheDir] stringByAppendingPathComponent:tempFileName];

                    if (info.fileID != nil) {

                        //recreate new version upload task
                        BOXFileUploadNewVersionRequest *newVersionRequest = [client fileUploadNewVersionRequestInBackgroundWithFileID:info.fileID fromLocalFilePath:path uploadMultipartCopyFilePath:tempPath associateId:associateId];

                        [newVersionRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                            BOXLog(@"new version upload request progress %lld/%lld, info (%@, %@, %@)", totalBytesTransferred, totalBytesExpectedToTransfer, info.fileID, info.uploadFromLocalFilePath, info.uploadMultipartCopyFilePath);
                        } completion:^(BOXFile *file, NSError *error) {
                            BOXLog(@"new version upload request completed with file %@, error %@", file, error);
                            [appSessionManager removeBackgroundSessionId:backgroundSessionId userId:userId associateId:associateId];
                        }];
                    } else {

                        //recreate new file upload task
                        BOXFileUploadRequest *uploadRequest = [client fileUploadRequestInBackgroundToFolderWithID:info.folderID fromLocalFilePath:path uploadMultipartCopyFilePath:tempPath associateId:associateId];

                        [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                            BOXLog(@"new file upload request progress %lld/%lld, info (%@, %@, %@)", totalBytesTransferred, totalBytesExpectedToTransfer, info.folderID, info.uploadFromLocalFilePath, info.uploadMultipartCopyFilePath);
                        } completion:^(BOXFile *file, NSError *error) {
                            BOXLog(@"new file upload request completed with file %@, error %@", file, error);
                            [appSessionManager removeBackgroundSessionId:backgroundSessionId userId:userId associateId:associateId];
                        }];
                    }
                }
            }
        }
    });
}

@end
