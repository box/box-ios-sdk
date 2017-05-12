//
//  BOXSampleAppSessionManager.h
//  BoxContentSDKSampleApp
//
//  Created by Thuy Nguyen on 1/13/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
@import BoxContentSDK;

@interface BOXSampleAppSessionInfo : NSObject <NSCoding>

@property (nonatomic, copy, readwrite) NSString *fileID; //applicable for new version upload request, or download request
@property (nonatomic, copy, readwrite) NSString *destinationPath; //applicable for download task
@property (nonatomic, copy, readwrite) NSString *folderID; //applicable for first time upload request
@property (nonatomic, copy, readwrite) NSString *uploadFromLocalFilePath; //applicable for upload request
@property (nonatomic, copy, readwrite) NSString *uploadMultipartCopyFilePath; //applicable for upload request

@end

@interface BOXSampleAppSessionManager : NSObject

@property (nonatomic, strong, readwrite) NSString *backgroundSessionId;

+ (id)defaultManager;
+ (NSString *)rootCacheDirGivenSharedContainerId:(NSString *)sharedContainerId;
+ (NSString *)generateRandomStringWithLength:(NSInteger)length;
+ (NSArray *)allExtensionIdsGivenSharedContainerId:(NSString *)sharedContainerId;

- (NSString *)boxURLRequestCacheDir;

- (void)setUpForApp;

- (void)setUpForExtension;

- (void)removeInfoForExtensionId:(NSString *)extensionId;

- (void)populateInfoForExtensionId:(NSString *)extensionId;

- (void)saveBackgroundSessionId:(NSString *)backgroundSessionId userId:(NSString *)userId associateId:(NSString *)associateId withInfo:(BOXSampleAppSessionInfo *)info;

- (void)removeBackgroundSessionId:(NSString *)backgroundSessionId userId:(NSString *)userId associateId:(NSString *)associateId;

- (NSDictionary *)associateIdToSessionTaskInfoForBackgroundSessionId:(NSString *)backgroundSessionId userId:(NSString *)userId;

- (void)cleanUpForUserId:(NSString *)userId;

- (NSDictionary *)backgroundSessionIdToAssociateIdAndSessionTaskInfoForUserId:(NSString *)userId;

@end
