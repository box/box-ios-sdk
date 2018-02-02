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


@implementation BOXURLSessionTaskCachedInfo
@end

@implementation BOXURLBackgroundSessionIdAndSessionTaskId

- (id)initWithBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId
{
    self = [super init];
    if (self != nil) {
        self.backgroundSessionId = backgroundSessionId;
        self.sessionTaskId = sessionTaskId;
    }
    return self;
}

@end

@interface BOXUserIdAndAssociateId : NSObject
@property (nonatomic, copy, readwrite) NSString *userId;
@property (nonatomic, copy, readwrite) NSString *associateId;
- (id)initWithUserId:(NSString *)userId associateId:(NSString *)associateId;

@end

@implementation BOXUserIdAndAssociateId

- (id)initWithUserId:(NSString *)userId associateId:(NSString *)associateId
{
    self = [super init];
    if (self != nil) {
        self.userId = userId;
        self.associateId = associateId;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.associateId = [aDecoder decodeObjectForKey:@"associateId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.associateId forKey:@"associateId"];
}

@end

@interface BOXURLSessionCacheClient()

@property (nonatomic, copy, readwrite) NSString *cacheDir;

@end


@implementation BOXURLSessionCacheClient

- (id)initWithCacheRootDir:(NSString *)cacheRootDir
{
    self = [super init];
    if (self != nil) {
        BOOL isDir = NO;
        if (cacheRootDir != nil) {
            NSString *cacheDir = [cacheRootDir stringByAppendingPathComponent:BOXURLSessionTaskCacheDirectoryName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:cacheDir isDirectory:&isDir] == NO || isDir == NO) {
                NSError *error = nil;
                BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:cacheDir
                                                         withIntermediateDirectories:YES
                                                                          attributes:nil
                                                                               error:&error];
                BOXAssert(success, @"Failed to create cacheDir %@ with error %@", cacheDir, error);
            }
            self.cacheDir = cacheDir;
        }
    }
    return self;
}

- (BOOL)cacheUserId:(NSString *)userId
        associateId:(NSString *)associateId
backgroundSessionId:(NSString *)backgroundSessionId
      sessionTaskId:(NSUInteger)sessionTaskId
              error:(NSError **)error
{
    if (userId == nil || associateId == nil) {
        if (error != nil) {
            *error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain
                                                code:BOXContentSDKURLSessionCacheErrorInvalidUserIdOrAssociateId
                                            userInfo:nil];
        }
        return NO;
    }
    
    if (backgroundSessionId == nil) {
        if (error != nil) {
            *error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain
                                                code:BOXContentSDKURLSessionCacheErrorInvalidBackgroundSessionId
                                            userInfo:nil];
        }
        return NO;
    }
    
    //persist users/$userId/$associateId/$backgroundSessionId-$sessionTaskId
    BOOL success = [self createFileForUserId:userId
                                 associateId:associateId
                         backgroundSessionId:backgroundSessionId
                               sessionTaskId:sessionTaskId
                                       error:error];

    if (success == YES) {
        //persist onGoingSessionTasks/$backgroundSessionId/$sessionTaskId/userIdAndAssociateId
        success = [self cacheBackgroundSessionId:backgroundSessionId
                                   sessionTaskId:sessionTaskId
                                          userId:userId
                                     associateId:associateId
                                           error:error];
    }

    return success;
}

- (NSFileCoordinator *)createFileCoordinator {
    NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] init];
   
    coordinator.purposeIdentifier = @"com.box.BOXURLSessionCacheClient.urlSessionCache";
    
    return coordinator;
}

- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId
                   sessionTaskId:(NSUInteger)sessionTaskId
             destinationFilePath:(NSString *)destinationFilePath
                           error:(NSError **)error
{
    if (backgroundSessionId == nil) {
        if (error != nil) {
            *error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain
                                                code:BOXContentSDKURLSessionCacheErrorInvalidBackgroundSessionId
                                            userInfo:nil];
        }
        
        return NO;
    }
    
    NSData *data = destinationFilePath == nil ? nil : [destinationFilePath dataUsingEncoding:NSUTF8StringEncoding];
    
    return [self cacheBackgroundSessionId:backgroundSessionId
                            sessionTaskId:sessionTaskId
                                     data:data
                                     type:BOXURLSessionTaskCacheFileTypeDestinationFilePath
                                    error:error];
}

- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId
                   sessionTaskId:(NSUInteger)sessionTaskId
                    responseData:(NSData *)responseData
                           error:(NSError **)error
{
    if (backgroundSessionId == nil) {
        if (error != nil) {
            *error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain
                                                code:BOXContentSDKURLSessionCacheErrorInvalidBackgroundSessionId
                                            userInfo:nil];
        }
        return NO;
    }
    
    return [self cacheBackgroundSessionId:backgroundSessionId
                            sessionTaskId:sessionTaskId
                                     data:responseData
                                     type:BOXURLSessionTaskCacheFileTypeResponseData
                                    error:error];
}

- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId
                   sessionTaskId:(NSUInteger)sessionTaskId
                      resumeData:(NSData *)resumeData
                           error:(NSError **)error
{
    if (backgroundSessionId == nil) {
        if (error != nil) {
            *error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain
                                                code:BOXContentSDKURLSessionCacheErrorInvalidBackgroundSessionId
                                            userInfo:nil];
        }
        return NO;
    }
    
    return [self cacheBackgroundSessionId:backgroundSessionId
                            sessionTaskId:sessionTaskId
                                     data:resumeData
                                     type:BOXURLSessionTaskCacheFileTypeResumeData
                                    error:error];
}

- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId
                   sessionTaskId:(NSUInteger)sessionTaskId
                        response:(NSURLResponse *)response
                           error:(NSError **)error
{
    if (backgroundSessionId == nil) {
        if (error != nil) {
            *error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain
                                                code:BOXContentSDKURLSessionCacheErrorInvalidBackgroundSessionId
                                            userInfo:nil];
        }
        
        return NO;
    }
    
    NSData *data = response == nil ? nil : [NSKeyedArchiver archivedDataWithRootObject:response];
    
    return [self cacheBackgroundSessionId:backgroundSessionId
                            sessionTaskId:sessionTaskId
                                     data:data
                                     type:BOXURLSessionTaskCacheFileTypeResponse
                                    error:error];
}

- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId
                   sessionTaskId:(NSUInteger)sessionTaskId
                       taskError:(NSError *)taskError
                           error:(NSError **)error
{
    if (backgroundSessionId == nil) {
        if (error != nil) {
            *error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain
                                                code:BOXContentSDKURLSessionCacheErrorInvalidBackgroundSessionId
                                            userInfo:nil];
        }
        return NO;
    }
    
    NSData *data = taskError == nil ? nil : [NSKeyedArchiver archivedDataWithRootObject:taskError];
    
    return [self cacheBackgroundSessionId:backgroundSessionId
                            sessionTaskId:sessionTaskId
                                     data:data
                                     type:BOXURLSessionTaskCacheFileTypeError
                                    error:error];
}

//Call to complete a session task by moving its cached info from on-going session tasks' subdir into users' completed subdir
- (BOOL)completeSessionTaskForBackgroundSessionId:(NSString *)backgroundSessionId
                                    sessionTaskId:(NSUInteger)sessionTaskId
                                            error:(NSError **)outError
{
    if (backgroundSessionId == nil) {
        
        return YES;
    }

    BOOL success = YES;
    BOXUserIdAndAssociateId *userIdAndAssociateId = [self userIdAndAssociateIdForBackgroundSessionId:backgroundSessionId
                                                                                       sessionTaskId:sessionTaskId];

    if (userIdAndAssociateId != nil) {
        NSString *userId = userIdAndAssociateId.userId;
        NSString *associateId = userIdAndAssociateId.associateId;

        NSString *onGoingSessionTaskDir = [self dirPathOfSessionTaskWithBackgroundSessionId:backgroundSessionId
                                                                              sessionTaskId:sessionTaskId];
        NSString *completedDir = [self completedDirForSessionTaskOfUserId:userId associateId:associateId];

        //move session task info from on-going session task at onGoingSessionTasks/$backgroundSessionId/$sessionTaskId
        //to completed dir under users/$userId/$associateId/completed/
        success = [[NSFileManager defaultManager] moveItemAtPath:onGoingSessionTaskDir toPath:completedDir error:outError];
    } else {
        NSString *onGoingSessionTaskDir = [self dirPathOfSessionTaskWithBackgroundSessionId:backgroundSessionId
                                                                              sessionTaskId:sessionTaskId];
        BOOL isDir = NO;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:onGoingSessionTaskDir isDirectory:&isDir] == YES && isDir == YES) {
            success = [[NSFileManager defaultManager] removeItemAtPath:onGoingSessionTaskDir error:outError];
        }
    }
    
    return success;
}

- (NSArray *)onGoingSessionTasksForBackgroundSessionId:(NSString *)backgroundSessionId error:(NSError **)outError
{
    NSString *dirPath = [self dirPathOfSessionTaskWithBackgroundSessionId:backgroundSessionId];
    BOOL isDir = NO;
    NSMutableArray *sessionTaskIds = [NSMutableArray new];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir] == YES && isDir == YES) {
        NSArray *sessionTaskIdStrings = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:outError];
        for (NSString *sessionTaskIdString in sessionTaskIdStrings) {
            NSUInteger sessionTaskId = [self stringToUnsignedInteger:sessionTaskIdString];
            [sessionTaskIds addObject:@(sessionTaskId)];
        }
    }
    
    return [sessionTaskIds copy];
}

- (BOOL)completeOnGoingSessionTasksForBackgroundSessionId:(NSString *)backgroundSessionId
                                  excludingSessionTaskIds:(NSSet *)excludingSessionTaskIds
                                                    error:(NSError **)outError
{
    if (backgroundSessionId == nil || excludingSessionTaskIds == nil) {
        
        return YES;
    }
    NSError *finalError = nil;
    NSArray *sessionTaskIds = [self onGoingSessionTasksForBackgroundSessionId:backgroundSessionId error:&finalError];
    BOOL finalSuccess = finalError == nil;

    //go through each on-going session tasks which are not excluded, and complete them
    //this indicates those tasks completed but we failed to transfer them to completed dir
    for (NSNumber *sessionTaskIdNumber in sessionTaskIds) {
        if ([excludingSessionTaskIds containsObject:sessionTaskIdNumber] == NO) {
            NSError *error = nil;
            NSUInteger sessionTaskId = [sessionTaskIdNumber unsignedIntegerValue];
            BOOL success = [self completeSessionTaskForBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId error:&error];
            if (success == NO) {
                finalSuccess = NO;
            }
            if (error != nil && finalError == nil) {
                finalError = error;
            }
        }
    }
    
    if (outError != nil) {
        *outError = finalError;
    }
    
    return finalSuccess;
}

- (BOOL)isSessionTaskCompletedForUserId:(NSString *)userId associateId:(NSString *)associateId
{
    NSString *dir = [self completedDirForSessionTaskOfUserId:userId associateId:associateId];
    BOOL isDir = NO;
    
    return [[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&isDir] == YES && isDir == YES;
}

- (NSString *)completedDirForSessionTaskOfUserId:(NSString *)userId associateId:(NSString *)associateId
{
    return [[self dirPathOfSessionTaskGivenUserId:userId associateId:associateId] stringByAppendingPathComponent:@"completed"];
}

- (BOXURLSessionTaskCachedInfo *)completedCachedInfoForUserId:(NSString *)userId
                                                  associateId:(NSString *)associateId
                                                        error:(NSError **)outError
{
    if ([self isSessionTaskCompletedForUserId:userId associateId:associateId] == NO) {
       
        return nil;
    }

    //session task has completed
    NSError *error = nil;
    BOXURLSessionTaskCachedInfo *cachedInfo = nil;

    BOXURLBackgroundSessionIdAndSessionTaskId *backgroundSessionIdAndSessionTaskId = [self backgroundSessionIdAndSessionTaskIdForUserId:userId
                                                                                                                            associateId:associateId
                                                                                                                                  error:&error];

    if (backgroundSessionIdAndSessionTaskId != nil && error == nil) {
        //has valid background session id and session task id, retrieve cache
        NSString *backgroundSessionId = backgroundSessionIdAndSessionTaskId.backgroundSessionId;
        NSUInteger sessionTaskId = backgroundSessionIdAndSessionTaskId.sessionTaskId;
        NSString *completeDir = [self completedDirForSessionTaskOfUserId:userId associateId:associateId];

        cachedInfo = [self cachedInfoFromDir:completeDir forBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId error:&error];
    } else if (error == nil) {
        //do not have valid background session id and session task id, do not retrieve cache
        error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain
                                           code:BOXContentSDKURLSessionCacheErrorInvalidCompletedSessionTaskForUserId
                                       userInfo:nil];
    }
    
    if (outError != nil) {
        *outError = error;
    }

    return cachedInfo;
}

- (BOXURLSessionTaskCachedInfo *)cachedInfoFromDir:(NSString *)dir
                            forBackgroundSessionId:(NSString *)backgroundSessionId
                                     sessionTaskId:(NSUInteger)sessionTaskId
                                             error:(NSError **)error
{
    BOXURLSessionTaskCachedInfo *cachedInfo = [[BOXURLSessionTaskCachedInfo alloc] init];
    cachedInfo.backgroundSessionId = backgroundSessionId;
    cachedInfo.sessionTaskId = sessionTaskId;

    //get all files under onGoingSessionTasks/$backgroundSessionId/$sessionTaskId
    NSArray *filePaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:error];
    
    for (int i = 0; i < filePaths.count; i++) {
        NSString *fileName = filePaths[i];
        NSString *filePath = [dir stringByAppendingPathComponent:fileName];

        //decrypt data found at filePath
        NSData *data = [self unencryptedDataAtFilePath:filePath];

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

- (NSString *)destinationFilePathForBackgroundSessionId:(NSString *)backgroundSessionId
                                          sessionTaskId:(NSUInteger)sessionTaskId
{
    NSString *filePath = [self filePathForBackgroundSessionId:backgroundSessionId
                                                sessionTaskId:sessionTaskId
                                                         type:BOXURLSessionTaskCacheFileTypeDestinationFilePath];

    //decrypt data found at filePath
    NSData *data = [self unencryptedDataAtFilePath:filePath];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSData *)responseDataForBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId
{
    NSString *filePath = [self filePathForBackgroundSessionId:backgroundSessionId
                                                sessionTaskId:sessionTaskId
                                                         type:BOXURLSessionTaskCacheFileTypeResponseData];
    //decrypt data found at filePath
    return [self unencryptedDataAtFilePath:filePath];
}

- (NSData *)resumeDataForUserId:(NSString *)userId associateId:(NSString *)associateId
{
    NSString *dirPath = [self completedDirForSessionTaskOfUserId:userId associateId:associateId];
    NSString *filePath = [dirPath stringByAppendingPathComponent:BOXURLSessionTaskCacheResumeData];
    
    //decrypt data found at filePath
    return [self unencryptedDataAtFilePath:filePath];
}

- (BOOL)resumeCompletedDownloadSessionTaskForUserId:(NSString *)userId
                                        associateId:(NSString *)associateId
                                              error:(NSError **)error
{
    //delete completed dir under users/$userId/$associateId/completed
    NSString *dirPath = [self completedDirForSessionTaskOfUserId:userId associateId:associateId];
    
    return [self deleteDirectory:dirPath error:error];
}

- (BOXUserIdAndAssociateId *)userIdAndAssociateIdForBackgroundSessionId:(NSString *)backgroundSessionId
                                                          sessionTaskId:(NSUInteger)sessionTaskId
{
    NSString *filePath = [self filePathForBackgroundSessionId:backgroundSessionId
                                                sessionTaskId:sessionTaskId
                                                         type:BOXURLSessionTaskCacheFileTypeUserIdAndAssociateId];

    //decrypt data found at filePath
    NSData *data = [self unencryptedDataAtFilePath:filePath];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSData *)unencryptedDataAtFilePath:(NSString *)filePath
{
    __block NSData *data = nil;
    
    NSFileCoordinator *coordinator = [self createFileCoordinator];
    
    [coordinator coordinateReadingItemAtURL:[NSURL fileURLWithPath:filePath]
                                    options:NSFileCoordinatorReadingWithoutChanges
                                      error:nil
                                 byAccessor:^(NSURL * _Nonnull newURL) {
                                     BOOL isDir = NO;
                                     BOOL isValidFilePath = YES;
                                     isValidFilePath = [[NSFileManager defaultManager] fileExistsAtPath:newURL.path isDirectory:&isDir] == YES &&
                                                        isDir == NO;
                                     
                                     if (isValidFilePath) {
                                         data = [NSData dataWithContentsOfFile:newURL.path];
                                     }
                                 }];
    
    if ([self.delegate respondsToSelector:@selector(decryptData:)]) {
        data = [self.delegate decryptData:data];
    }
    
    return data;
}

- (BOOL)deleteCachedInfoForUserId:(NSString *)userId
                      associateId:(NSString *)associateId
                            error:(NSError **)outError
{
    if (userId == nil || associateId == nil) {
        if (outError != nil) {
            *outError = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain
                                                   code:BOXContentSDKURLSessionCacheErrorInvalidUserIdOrAssociateId
                                               userInfo:nil];
        }
        
        return NO;
    }

    //delete both on-going and completed cached info

    BOOL success = YES;
    NSError *error = nil;

    success = [self cleanUpOnGoingSessionTaskOfUserId:userId associateId:associateId error:&error];

    if (success == YES) {
        //clean up users/$userId/$associateId/*
        NSString *dir = [self dirPathOfSessionTaskGivenUserId:userId associateId:associateId];
        success = [self deleteDirectory:dir error:&error];
    }
    
    if (outError != nil) {
        *outError = error;
    }
    
    return success;
}

- (BOOL)cleanUpOnGoingSessionTaskOfUserId:(NSString *)userId
                              associateId:(NSString *)associateId
                                    error:(NSError **)outError
{
    BOOL success = YES;
    NSError *error = nil;

    if ([self isSessionTaskCompletedForUserId:userId associateId:associateId] == NO) {
        //find backgroundSessionId and sessionTaskId associated with userId and associateId
        BOXURLBackgroundSessionIdAndSessionTaskId *backgroundSessionIdAndSessionTaskId = [self backgroundSessionIdAndSessionTaskIdForUserId:userId
                                                                                                                                associateId:associateId
                                                                                                                                      error:&error];

        if (backgroundSessionIdAndSessionTaskId == nil) {
            if (error != nil) {
                //failed to retrieve backgroundSessionId and sessionTaskId for userId and associateId
                if (outError != nil) {
                    *outError = error;
                }
                return NO;
            }
        }

        //clean up onGoingSessionTasks/$backgroundSessionId/$sessionTaskId/*
        NSString *backgroundSessionId = backgroundSessionIdAndSessionTaskId.backgroundSessionId;
        NSUInteger sessionTaskId = backgroundSessionIdAndSessionTaskId.sessionTaskId;

        NSString *dir = [self dirPathOfSessionTaskWithBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId];
        success = [self deleteDirectory:dir error:&error];
    }
    
    if (outError != nil) {
        *outError = error;
    }
    
    return success;
}

- (BOOL)cleanUpForUserIdIfEmpty:(NSString *)userId error:(NSError **)outError
{
    NSString *dirPath = [self dirPathOfUserId:userId];
    BOOL isDir = NO;
    NSError *error = nil;
    BOOL success = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir] == YES && isDir == YES) {
        NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:&error];

        if (fileNames != nil && error == nil && fileNames.count == 0) {
            //only remove users/$userId dir if it is empty
            success = [[NSFileManager defaultManager] removeItemAtPath:dirPath error:&error];

        } else {
            if (fileNames.count > 0) {
                error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain
                                                   code:BOXContentSDKURLSessionCacheErrorDirectoryIsNotEmpty
                                               userInfo:nil];
            }
            success = NO;
        }
    }
    
    if (outError != nil) {
        *outError = error;
    }
    
    return success;
}

- (NSDictionary *)associateIdToBackgroundSessionIdAndSessionTaskIdsForUserId:(NSString *)userId error:(NSError **)outError
{
    if (userId == nil) {
        return nil;
    }

    NSError *finalError = nil;
    NSArray *associateIds = [self associateIdsForUserId:userId error:&finalError];
    NSMutableDictionary *associateIdToBackgroundSessionIdAndSessionTaskIds = [NSMutableDictionary new];

    //iterate through users/$userId/$associateId subdirs to get its backgroundSessionId and sessionTaskId
    for (NSString *associateId in associateIds) {
        NSError *error = nil;
        BOXURLBackgroundSessionIdAndSessionTaskId *backgroundSessionIdAndSessionTaskId = [self backgroundSessionIdAndSessionTaskIdForUserId:userId
                                                                                                                                associateId:associateId
                                                                                                                                      error:&error];

        if (backgroundSessionIdAndSessionTaskId != nil) {
            associateIdToBackgroundSessionIdAndSessionTaskIds[associateId] = backgroundSessionIdAndSessionTaskId;
        } else if (error == nil) {
            //we do not have valid backgroundSessionId and sessionTaskId for a previously seen userId and associateId,
            //something must have failed, clean up the cache dir for future usage
            [self deleteCachedInfoForUserId:userId associateId:associateId error:&error];
        }

        if (error != nil && finalError == nil) {
            finalError = error;
        }
    }
    
    if (outError != nil) {
        *outError = finalError;
    }
    
    return [associateIdToBackgroundSessionIdAndSessionTaskIds copy];
}

// Return associateIds under users/$userId dir
- (NSArray *)associateIdsForUserId:(NSString *)userId error:(NSError **)error
{
    NSString *dirPath = [self dirPathOfUserId:userId];
    NSArray *associateIds = nil;

    BOOL isDir = NO;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir] == YES && isDir == YES) {
        associateIds = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:error];
    }
    
    return associateIds;
}

#pragma mark - private helpers

- (BOOL)cleanUpOnGoingCachedInfoOfBackgroundSessionId:(NSString *)backgroundSessionId error:(NSError **)error
{
    NSString *dirPath = [self dirPathOfSessionTaskWithBackgroundSessionId:backgroundSessionId];
    BOOL success = [self deleteDirectory:dirPath error:error];
    
    if (success == YES) {
        success = [self cleanUpExtensionBackgrounSessionIdIfExists:backgroundSessionId error:error];
    }
    
    return success;
}

- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId
                   sessionTaskId:(NSUInteger)sessionTaskId
                          userId:(NSString *)userId
                     associateId:(NSString *)associateId
                           error:(NSError **)error
{
    BOXUserIdAndAssociateId *userIdAndAssociateId = [[BOXUserIdAndAssociateId alloc] initWithUserId:userId associateId:associateId];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userIdAndAssociateId];
    
    return [self cacheBackgroundSessionId:backgroundSessionId
                            sessionTaskId:sessionTaskId
                                     data:data
                                     type:BOXURLSessionTaskCacheFileTypeUserIdAndAssociateId
                                    error:error];
}

- (BOOL)cacheBackgroundSessionId:(NSString *)backgroundSessionId
                   sessionTaskId:(NSUInteger)sessionTaskId
                            data:(NSData *)data
                            type:(BOXURLSessionTaskCacheFileType)type
                           error:(NSError **)outError
{
    if (data == nil) {
        //do not cache nil data
        return YES;
    }
    NSError *error;

    //persist onGoingSessionTasks/$backgroundSessionId/$sessionTaskId
    BOOL success = [self createDirForBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId error:&error];

    if (success == YES && error == nil) {
        //persist data to onGoingSessionTasks/$backgroundSessionId/$sessionTaskId/$fileType
        NSString *path = [self filePathForBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId type:type];
        success = [self cacheAndAttemptToEncryptData:data atPath:path error:&error];
    }

    if (outError != nil) {
        (*outError) = error;
    }
    
    return success;
}

// Return file path of onGoingSessionTasks/$backgroundSessionId/$sessionTaskId/$fileType
- (NSString *)filePathForBackgroundSessionId:(NSString *)backgroundSessionId
                               sessionTaskId:(NSUInteger)sessionTaskId
                                        type:(BOXURLSessionTaskCacheFileType)type
{
    NSString *path = [self dirPathOfSessionTaskWithBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId];

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
        case BOXURLSessionTaskCacheFileTypeUserIdAndAssociateId:
            path = [path stringByAppendingPathComponent:BOXURLSessionTaskCacheUserIdAndAssociateId];

    }
    
    return path;
}

- (BOOL)cacheAndAttemptToEncryptData:(NSData *)data atPath:(NSString *)path error:(NSError **)outError
{
    NSData *finalData = data;
    
    if ([self.delegate respondsToSelector:@selector(encryptData:)]) {
        finalData = [self.delegate encryptData:data];
    }
    
    __block BOOL success = NO;
    
    NSFileCoordinator *coordinator = [self createFileCoordinator];
    [coordinator coordinateWritingItemAtURL:[NSURL fileURLWithPath:path]
                                    options:NSFileCoordinatorWritingForReplacing
                                      error:outError
                                 byAccessor:^(NSURL * _Nonnull newURL) {
                                     success = [finalData writeToURL:newURL options:NSDataWritingAtomic error:outError];
                                 }];
    
    return success;
}

// Delete file extensionSessions/$backgroundSessionId if backgroundSessionId is from extension
- (BOOL)cleanUpExtensionBackgrounSessionIdIfExists:(NSString *)backgroundSessionId error:(NSError **)outError
{
    NSString *filePath = [self filePathOfExtensionBackgrounSessionId:backgroundSessionId];
    BOOL success = YES;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] == YES) {
        success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:outError];
    }
    
    return success;
}

- (BOOL)cacheBackgroundSessionIdFromExtension:(NSString *)backgroundSessionId error:(NSError **)outError
{
    NSString *filePath = [self filePathOfExtensionBackgrounSessionId:backgroundSessionId];
    
    return [self createFile:filePath error:outError];
}

- (NSString *)filePathOfExtensionBackgrounSessionId:(NSString *)backgroundSessionId
{
    NSString *dirPath = [self dirPathOfExtensionSessions];
    
    return [dirPath stringByAppendingPathComponent:backgroundSessionId];
}

- (NSArray *)backgroundSessionIdsFromExtensionsWithError:(NSError **)error
{
    NSString *dirPath = [self dirPathOfExtensionSessions];
    BOOL isDir = NO;
    NSArray *ids = [NSArray new];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir] == YES && isDir == YES) {
        ids = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self dirPathOfExtensionSessions] error:error];
    }
    
    return ids;
}

// Create dir if not exists, users/$userId/$associateId/$backgroundSessionId-$sessionTaskId
- (BOOL)createFileForUserId:(NSString *)userId
                associateId:(NSString *)associateId
        backgroundSessionId:(NSString *)backgroundSessionId
              sessionTaskId:(NSUInteger)sessionTaskId
                      error:(NSError **)error
{
    NSString *path = [self filePathOfUserSessionTaskGivenUserId:userId
                                                    associateId:associateId
                                            backgroundSessionId:backgroundSessionId
                                                  sessionTaskId:sessionTaskId];
    
    return [self createFile:path error:error];
}

// Create dir if not exists, onGoingSessionTasks/$backgroundSessionId/$sessionTaskId
- (BOOL)createDirForBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId error:(NSError **)error
{
    NSString *path = [self dirPathOfSessionTaskWithBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId];
    
    return [self createDirectory:path error:error];
}

// Return onGoingSessionTasks/$backgroundSessionId/$sessionTaskId/$userId-$associateId
- (NSString *)filePathOfUserInfoForBackgroundSessionId:(NSString *)backgroundSessionId
                                         sessionTaskId:(NSUInteger)sessionTaskId
                                                userId:(NSString *)userId
                                           associateId:(NSString *)associateId
{
    NSString *path = [self dirPathOfSessionTaskWithBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId];
    NSString *fileName = [NSString stringWithFormat:@"%@-%@", userId, associateId];
    
    return [path stringByAppendingPathComponent:fileName];
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

- (BOOL)deleteDirectory:(NSString *)directoryPath error:(NSError **)outError
{
    BOOL isDir = NO;
    BOOL success = YES;
    NSError *error = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir] == YES && isDir == YES) {
        success = [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
        if (error != nil) {
            NSError *underlyingError = error.userInfo[NSUnderlyingErrorKey];
            if (underlyingError.domain == NSCocoaErrorDomain && underlyingError.code == NSFileNoSuchFileError) {
                //if cannot remove because of no such file or directory, consider that a success
                success = YES;
                error = nil;
            }
        }
    }
    
    if (outError != nil) {
        *outError = error;
    }
    
    return success;
}

- (BOOL)createFile:(NSString *)path error:(NSError **)error
{
    NSString *dir = [path stringByDeletingLastPathComponent];
    BOOL success = [self createDirectory:dir error:error];
    
    if (success == YES) {
        BOOL isDir = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] == NO || isDir == YES) {
            success = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
            if (success == NO && error != nil) {
                *error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain
                                                    code:BOXContentSDKURLSessionCacheErrorFileCreateFailed
                                                userInfo:nil];
            }
        }
    }
    
    return success;
}

// Return dir path onGoingSessionTasks/$backgroundSessionId/$sessionTaskId
- (NSString *)dirPathOfSessionTaskWithBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId
{
    return [[self dirPathOfSessionTaskWithBackgroundSessionId:backgroundSessionId] stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu", (unsigned long)sessionTaskId]];
}

// Return dir path onGoingSessionTasks/$backgroundSessionId
- (NSString *)dirPathOfSessionTaskWithBackgroundSessionId:(NSString *)backgroundSessionId
{
    return [[self.cacheDir stringByAppendingPathComponent:BOXURLSessionTaskCacheOnGoingSessionTasksDirectoryName] stringByAppendingPathComponent:backgroundSessionId];
}

// Return dir path extensionSessions/
- (NSString *)dirPathOfExtensionSessions
{
    return [self.cacheDir stringByAppendingPathComponent:BOXURLSessionTaskCacheExtensionSessionsDirectoryName];
}

// Return dir path users/$userId/$associateId
- (NSString *)dirPathOfSessionTaskGivenUserId:(NSString *)userId associateId:(NSString *)associateId
{
    return [[self dirPathOfUserId:userId] stringByAppendingPathComponent:associateId];
}

// Return dir path users/$userId/$associateId/info
- (NSString *)dirPathOfSessionTaskFileGivenUserId:(NSString *)userId associateId:(NSString *)associateId
{
    return [[self dirPathOfSessionTaskGivenUserId:userId associateId:associateId] stringByAppendingPathComponent:@"info"];
}

- (NSString *)filePathOfUserSessionTaskGivenUserId:(NSString *)userId
                                       associateId:(NSString *)associateId
                               backgroundSessionId:(NSString *)backgroundSessionId
                                     sessionTaskId:(NSUInteger)sessionTaskId
{
    NSString *path = [self dirPathOfSessionTaskFileGivenUserId:userId associateId:associateId];
    NSString *fileName = [self fileNameGivenBackgroundSessionId:backgroundSessionId sessionTaskId:sessionTaskId];
    
    return [path stringByAppendingPathComponent:fileName];
}

- (NSString *)dirPathOfUsers
{
    return [self.cacheDir stringByAppendingPathComponent:BOXURLSessionTaskCacheUsersDirectoryName];
}

- (NSString *)dirPathOfUserId:(NSString *)userId
{
    return [[self dirPathOfUsers] stringByAppendingPathComponent:userId];
}

- (NSString *)fileNameGivenBackgroundSessionId:(NSString *)backgroundSessionId sessionTaskId:(NSUInteger)sessionTaskId
{
    return [NSString stringWithFormat:@"%@-%lu", backgroundSessionId, (unsigned long)sessionTaskId];
}

- (BOXURLBackgroundSessionIdAndSessionTaskId *)parseBackgroundSessionIdAndSessionTaskIdFileName:(NSString *)name
{
    NSArray *arr = [name componentsSeparatedByString:@"-"];
    BOXURLBackgroundSessionIdAndSessionTaskId *backgroundSessionIdAndSessionTaskId = nil;
    
    if (arr.count == 2) {
        NSString *backgroundSessionId = arr[0];
        NSUInteger sessionTaskId = [self stringToUnsignedInteger:arr[1]];
        backgroundSessionIdAndSessionTaskId = [[BOXURLBackgroundSessionIdAndSessionTaskId alloc] initWithBackgroundSessionId:backgroundSessionId
                                                                                                               sessionTaskId:sessionTaskId];
    }
    
    return backgroundSessionIdAndSessionTaskId;
}

- (BOXURLBackgroundSessionIdAndSessionTaskId *)backgroundSessionIdAndSessionTaskIdForUserId:(NSString *)userId
                                                                                associateId:(NSString *)associateId
                                                                                      error:(NSError **)error
{
    if (userId == nil || associateId == nil) {
        if (error != nil) {
            *error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain
                                                code:BOXContentSDKURLSessionCacheErrorInvalidUserIdOrAssociateId
                                            userInfo:nil];
        }
        
        return nil;
    }

    NSString *dir = [self dirPathOfSessionTaskFileGivenUserId:userId associateId:associateId];
    BOXURLBackgroundSessionIdAndSessionTaskId *backgroundSessionIdAndSessionTaskId = nil;
    BOOL isDir = NO;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&isDir] == YES && isDir == YES) {
        NSError *err;
        NSArray *filePaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:&err];
        
        if (err == nil && filePaths.count > 0) {
            NSString *fileName = filePaths[0];
            backgroundSessionIdAndSessionTaskId = [self parseBackgroundSessionIdAndSessionTaskIdFileName:fileName];
        } else {
            //if the error is different than "No such file or directory"
            BOXAssertFail(@"Failed to list content of dir %@", dir);
        }
        
        if (error != nil) {
            *error = err;
        }
    }
    
    return backgroundSessionIdAndSessionTaskId;
}

- (NSUInteger)stringToUnsignedInteger:(NSString *)string
{
    return [[NSNumber numberWithLongLong:string.longLongValue] unsignedIntegerValue];
}

@end
