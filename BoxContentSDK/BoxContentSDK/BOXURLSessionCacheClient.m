//
//  BOXURLSessionCacheClient.m
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 3/3/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import "BOXURLSessionCacheClient.h"
#import "BOXContentSDKConstants.h"
#import "BOXLog.h"
#import "BOXContentSDKErrors.h"

@interface BOXURLBackgroundSessionIdAndSessionTaskId : NSObject

@property (nonatomic, strong, readwrite) NSString *backgroundSessionId;
@property (nonatomic, assign, readwrite) NSUInteger sessionTaskId;

@end

@interface BOXURLSessionCacheClient()

@property (nonatomic, strong, readwrite) NSString *cacheDir;

@end

@implementation BOXURLSessionCacheClient

- (id)initWithCacheRootDir:(NSString *)cacheRootDir
{
    self = [super init];
    if (self != nil) {
        BOOL isDir = NO;
        NSString *cacheDir = [cacheRootDir stringByAppendingPathComponent:BOXURLSessionTaskCacheDirName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:cacheDir isDirectory:&isDir] == NO || isDir == NO) {
            NSError *error;
            [[NSFileManager defaultManager] createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:&error];
            BOXAssert(error != nil, @"Failed to create cacheDir %@ with error %@", cacheDir, error);
        }
        self.cacheDir = cacheDir;
    }
    return self;
}

- (BOOL)cacheUserId:(NSString *)userId associateId:(NSString *)associateId backgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId error:(NSError **)outError
{
    //persist users/$userId/$associateId/$backgroundSessionId-$sessionTaskId
    BOOL success = [self createFileForUserId:userId associateId:associateId backgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId error:outError];

    if (success == YES) {
        //persist sessions/$backgroundSessionId/$sessionTaskId
        success = [self createDirForBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId error:outError];
    }

    return success;
}

- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId destinationFilePath:(NSString *)destinationFilePath error:(NSError **)error
{
    NSData *data = [destinationFilePath dataUsingEncoding:NSUTF8StringEncoding];
    return [self cacheBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId data:data type:BOXURLSessionTaskCacheFileTypeDestinationFilePath error:error];
}

- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId responseData:(NSData *)responseData error:(NSError **)error
{
    return [self cacheBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId data:responseData type:BOXURLSessionTaskCacheFileTypeResponseData error:error];
}

- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId resumeData:(NSData *)resumeData error:(NSError **)error
{
    return [self cacheBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId data:resumeData type:BOXURLSessionTaskCacheFileTypeResumeData error:error];
}

- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId response:(NSURLResponse *)response error:(NSError **)error
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:response];
    return [self cacheBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId data:data type:BOXURLSessionTaskCacheFileTypeResponse error:error];
}

- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId taskError:(NSData *)taskError error:(NSError **)error
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:taskError];
    return [self cacheBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId data:data type:BOXURLSessionTaskCacheFileTypeError error:error];
}

- (BOXURLSessionTaskCachedInfo *)getCacheForUserId:(NSString *)userId associateId:(NSString *)associateId error:(NSError **)error
{
    BOXURLBackgroundSessionIdAndSessionTaskId *backgroundSessionIdAndSessionTaskId = [self backgroundSessionIdAndSessionTaskIdGivenUserId:userId associateId:associateId];

    if (backgroundSessionIdAndSessionTaskId == nil) {
        if (error != nil) {
        (*error) = [[NSError alloc] initWithDomain:BOXURLSessionTaskCacheError code:BOXContentSDKSCacheErrorNoValidSessionTaskGivenUserIdAssociateId userInfo:nil];
        }
        return nil;
    }

    NSString *backgroundSessionId = backgroundSessionIdAndSessionTaskId.backgroundSessionId;
    NSUInteger sessionTaskId = backgroundSessionIdAndSessionTaskId.sessionTaskId;

    NSString *dir = [self dirPathOfSessionTaskWithBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId];

    BOXURLSessionTaskCachedInfo *cachedInfo = [[BOXURLSessionTaskCachedInfo alloc] init];

    //get all files under sessions/$backgroundSessionId/$sessionTaskId
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:error];
    for (int i = 0; i < files.count; i++) {
        NSString *fileName = files[i];
        NSString *filePath = [dir stringByAppendingPathComponent:fileName];

        //decrypt data found at filePath
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if ([self.delegate respondsToSelector:@selector(decryptData:)]) {
            data = [self.delegate decryptData:data];
        }

        //parse decrypted data based on its file name
        if ([fileName isEqualToString:BOXURLSessionTaskCacheDestinationFilePath]) {
            cachedInfo.destinationFilePath = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        } else if ([fileName isEqualToString:BOXURLSessionTaskCacheResumeData]) {
            cachedInfo.resumeData = data;
        } else if ([fileName isEqualToString:BOXURLSessionTaskCacheResponse]) {
            cachedInfo.response = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        } else if ([fileName isEqualToString:BOXURLSessionTaskCacheResponseData]) {
            cachedInfo.responseData = data;
        } else if ([fileName isEqualToString:BOXURLSessionTaskCacheError]) {
            cachedInfo.error = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return cachedInfo;
}

- (BOOL)deleteCachedInfoForUserId:(NSString *)userId associateId:(NSString *)associateId error:(NSError **)error
{
    BOXURLBackgroundSessionIdAndSessionTaskId *backgroundSessionIdAndSessionTaskId = [self backgroundSessionIdAndSessionTaskIdGivenUserId:userId associateId:associateId];
    if (backgroundSessionIdAndSessionTaskId == nil) {
        return YES;
    }

    NSString *backgroundSessionId = backgroundSessionIdAndSessionTaskId.backgroundSessionId;
    NSUInteger sessionTaskId = backgroundSessionIdAndSessionTaskId.sessionTaskId;

    //clean up sessions/$backgroundSessionId/$sessionTaskId/*
    NSString *dir = [self dirPathOfSessionTaskWithBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId];
    BOOL success = [self deleteDirectory:dir error:error];

    if (success == YES) {
        //clean up users/$userId/$associateId/*
        dir = [self dirPathOfUserSessionTaskGivenUserId:userId associateId:associateId];
        success = [self deleteDirectory:dir error:error];
    }
    return success;
}

#pragma mark - private helpers

- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId data:(NSData *)data type:(BOXURLSessionTaskCacheFileType)type error:(NSError **)outError
{
    NSError *error;

    //persist sessions/$backgroundSessionId/$sessionTaskId
    BOOL success = [self createDirForBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId error:&error];

    if (success == YES && error == nil) {
        NSString *path = [self dirPathOfSessionTaskWithBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId];
        //persist data to sessions/$backgroundSessionId/$sessionTaskId/$fileType

        switch (type) {
            case BOXURLSessionTaskCacheFileTypeDestinationFilePath:
                path = [path stringByAppendingPathComponent:BOXURLSessionTaskCacheDestinationFilePath];
                break;
            case BOXURLSessionTaskCacheFileTypeResumeData:
                path = [path stringByAppendingPathComponent:BOXURLSessionTaskCacheResumeData];
                break;
            case BOXURLSessionTaskCacheFileTypeResponse:
                path = [path stringByAppendingPathComponent:BOXURLSessionTaskCacheResponse];
                break;
            case BOXURLSessionTaskCacheFileTypeResponseData:
                path = [path stringByAppendingPathComponent:BOXURLSessionTaskCacheResponseData];
                break;
            case BOXURLSessionTaskCacheFileTypeError:
                path = [path stringByAppendingPathComponent:BOXURLSessionTaskCacheError];
                break;
        }

        success = [self cacheAndEncryptData:data atPath:path error:&error];
    }

    if (outError != nil) {
        (*outError) = error;
    }
    return success;
}

- (BOOL)cacheAndEncryptData:(NSData *)data atPath:(NSString *)path error:(NSError **)outError
{
    NSData *finalData = data;
    if ([self.delegate respondsToSelector:@selector(encryptData:)]) {
        finalData = [self.delegate encryptData:data];
    }
    return [finalData writeToFile:path options:NSDataWritingWithoutOverwriting error:outError];
}

// create if not exists, users/$userId/$associateId/$backgroundSessionId-$sessionTaskId
- (BOOL)createFileForUserId:(NSString *)userId associateId:(NSString *)associateId backgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId error:(NSError **)error
{
    NSString *path = [self filePathOfUserSessionTaskGivenUserId:userId associateId:associateId backgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId];
    return [self createFile:path error:error];
}

// create if not exists, sessions/$backgroundSessionId/$sessionTaskId
- (BOOL)createDirForBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId error:(NSError **)error
{
    NSString *path = [self dirPathOfSessionTaskWithBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId];
    return [self createDirectory:path error:error];
}

- (BOOL)createDirectory:(NSString *)path error:(NSError **)error
{
    BOOL isDir = NO;
    BOOL success = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] == NO || isDir == NO) {
        success = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
    }
    return success;
}

- (BOOL)deleteDirectory:(NSString *)directoryPath error:(NSError **)error
{
    BOOL isDir = NO;
    BOOL success = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir] == YES && isDir == YES) {
        success = [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:error];
    }
    return success;
}

- (BOOL)createFile:(NSString *)path error:(NSError **)error
{
    BOOL success = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    if (success == NO && error != nil) {
        (*error) = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKSCacheErrorFileCreateFailed userInfo:nil];
    }
    return success;
}

// path sessions/$backgroundSessionId/$sessionTaskId
- (NSString *)dirPathOfSessionTaskWithBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId
{
    return [[[self.cacheDir stringByAppendingPathComponent:BOXURLSessionTaskCacheSessionsDirName] stringByAppendingPathComponent:backgroundSessionId] stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu", (unsigned long)sessionTaskId]];
}

// path users/$userId/$associateId/$backgroundSessionId-$sessionTaskId
- (NSString *)dirPathOfUserSessionTaskGivenUserId:(NSString *)userId associateId:(NSString *)associateId
{
    return [[[self.cacheDir stringByAppendingPathComponent:BOXURLSessionTaskCacheUsersDirName] stringByAppendingPathComponent:userId] stringByAppendingPathComponent:associateId];
}

- (NSString *)filePathOfUserSessionTaskGivenUserId:(NSString *)userId associateId:(NSString *)associateId backgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId
{
    NSString *path = [self dirPathOfUserSessionTaskGivenUserId:userId associateId:associateId];
    NSString *fileName = [self fileNameGivenBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId];
    return [path stringByAppendingPathComponent:fileName];
}

- (NSString *)fileNameGivenBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId
{
    return [NSString stringWithFormat:@"%@-%lu", backgroundSessionId, (unsigned long)sessionTaskId];
}

- (BOXURLBackgroundSessionIdAndSessionTaskId *)parseBackgroundSessionIdAndSessionTaskIdFileName:(NSString *)name
{
    NSArray *arr = [name componentsSeparatedByString:@"-"];
    BOXURLBackgroundSessionIdAndSessionTaskId *res = nil;
    if (arr.count == 2) {
        res.backgroundSessionId = arr[0];
        res.sessionTaskId = [arr[1] unsignedIntegerValue];
    }
    return res;
}

- (BOXURLBackgroundSessionIdAndSessionTaskId *)backgroundSessionIdAndSessionTaskIdGivenUserId:(NSString *)userId associateId:(NSString *)associateId
{
    NSString *dir = [self dirPathOfUserSessionTaskGivenUserId:userId associateId:associateId];
    NSError *error;
    BOXURLBackgroundSessionIdAndSessionTaskId *res = nil;
    NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:&error];
    if (error == nil && arr.count > 0) {
        NSString *filePath = arr[0];
        NSString *fileName = [filePath lastPathComponent];
        res = [self parseBackgroundSessionIdAndSessionTaskIdFileName:fileName];
    } else {
        BOXAssertFail(@"Failed to list content of dir %@", dir);
    }
    return res;
}

@end
