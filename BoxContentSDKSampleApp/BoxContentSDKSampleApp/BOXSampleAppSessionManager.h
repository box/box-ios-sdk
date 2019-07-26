//
//  BOXSampleAppSessionManager.h
//  BoxContentSDKSampleApp
//
//  Created by Thuy Nguyen on 1/13/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOXSampleAppSessionInfo : NSObject <NSCoding>

@property (nonatomic, copy, readwrite) NSString *fileID; //applicable for new version upload request, or download request
@property (nonatomic, copy, readwrite) NSString *destinationPath; //applicable for download task
@property (nonatomic, copy, readwrite) NSString *folderID; //applicable for first time upload request
@property (nonatomic, copy, readwrite) NSString *uploadFromLocalFilePath; //applicable for upload request
@property (nonatomic, copy, readwrite) NSString *uploadMultipartCopyFilePath; //applicable for upload request

@end

@interface BOXSampleAppSessionManager : NSObject

+ (id)defaultManager;
+ (NSString *)rootCacheDirGivenSharedContainerId:(NSString *)sharedContainerId;
+ (NSString *)generateRandomStringWithLength:(NSInteger)length;

- (NSString *)boxURLRequestCacheDir;

- (BOXSampleAppSessionInfo *)getSessionTaskInfoForUserId:(NSString *)userId associateId:(NSString *)associateId;

- (void)saveUserId:(NSString *)userId associateId:(NSString *)associateId withInfo:(BOXSampleAppSessionInfo *)info;

- (void)removeUserId:(NSString *)userId associateId:(NSString *)associateId;

- (NSDictionary *)associateIdToSessionTaskInfoForUserId:(NSString *)userId;

- (void)cleanUpForUserId:(NSString *)userId;

@end
