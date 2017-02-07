//
//  BOXSampleAppSessionManager.h
//  BoxContentSDKSampleApp
//
//  Created by Thuy Nguyen on 1/13/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOXSampleAppSessionInfo : NSObject <NSCoding>

@property (nonatomic, strong, readwrite) NSString *associateId; //could be fileID for download task, or filePath for upload task

//applicable for download task
@property (nonatomic, strong, readwrite) NSString *destinationPath;

//applicable for upload task
@property (nonatomic, strong, readwrite) NSString *folderId; //for first upload
@property (nonatomic, strong, readwrite) NSString *fileId; //for new version upload
@property (nonatomic, strong, readwrite) NSString *tempUploadFilePath;

- (id)initWithAssociateId:(NSString *)associateId destinationPath:(NSString *)destinationPath;
- (id)initWithAssociateId:(NSString *)associateId folderId:(NSString *)folderId tempUploadFilePath:(NSString *)tempUploadFilePath;
- (id)initWithAssociateId:(NSString *)associateId fileId:(NSString *)fileId tempUploadFilePath:(NSString *)tempUploadFilePath;

@end

@interface BOXSampleAppSessionManager : NSObject

+ (id)defaultManager;

- (void)saveSessionInfo:(BOXSampleAppSessionInfo *)sessionInfo withRequestId:(NSString *)requestId;
- (void)saveUrlSessionTaskId:(NSUInteger)urlSessionTaskId withRequestId:(NSString *)requestId;
- (void)removeRequestId:(NSString *)requestId;
- (BOXSampleAppSessionInfo *)getSessionTaskInfo:(NSUInteger)sessionTaskId;
- (void)removeSessionTaskId:(NSUInteger)sessionTaskId;

@end
