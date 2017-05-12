//
//  BOXSampleAppSessionManager.m
//  BoxContentSDKSampleApp
//
//  Created by Thuy Nguyen on 1/13/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import "BOXSampleAppSessionManager.h"
@import BoxContentSDK;

@implementation BOXSampleAppSessionInfo

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        self.fileID = [aDecoder decodeObjectForKey:@"fileID"];
        self.destinationPath = [aDecoder decodeObjectForKey:@"destinationPath"];
        self.folderID = [aDecoder decodeObjectForKey:@"folderID"];
        self.uploadFromLocalFilePath = [aDecoder decodeObjectForKey:@"uploadFromLocalFilePath"];
        self.uploadMultipartCopyFilePath = [aDecoder decodeObjectForKey:@"uploadMultipartCopyFilePath"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.fileID forKey:@"fileID"];
    [aCoder encodeObject:self.destinationPath forKey:@"destinationPath"];
    [aCoder encodeObject:self.folderID forKey:@"folderID"];
    [aCoder encodeObject:self.uploadFromLocalFilePath forKey:@"uploadFromLocalFilePath"];
    [aCoder encodeObject:self.uploadMultipartCopyFilePath forKey:@"uploadMultipartCopyFilePath"];
}

@end


static NSString *backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfoKey = @"backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo";

static NSString *sharedContainerIdentifierKey = @"group.BoxContentSDKSampleApp";

@interface BOXSampleAppSessionManager()

@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, NSMutableDictionary <NSString *, NSMutableDictionary <NSString *, BOXSampleAppSessionInfo *> *> *> *backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo;

@property (nonatomic, strong, readwrite) NSString *boxURLRequestCacheDir;

@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, NSArray *> *extensionIdToBackgroundSessionIds;

@property (nonatomic, strong, readwrite) NSString *extensionId;

@end

@implementation BOXSampleAppSessionManager

+ (id)defaultManager {
    static BOXSampleAppSessionManager *defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [[self alloc] init];
    });
    return defaultManager;
}

+ (NSString *)rootCacheDirGivenSharedContainerId:(NSString *)sharedContainerId
{
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:sharedContainerId];
    return containerURL.path;
}

+ (NSString *)generateRandomStringWithLength:(NSInteger)length
{
    NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];

    for (NSInteger i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }

    return randomString;
}

+ (NSArray *)allExtensionIdsGivenSharedContainerId:(NSString *)sharedContainerId
{
    NSString *dir = [BOXSampleAppSessionManager extensionIdsDirGivenSharedContainerId:sharedContainerId];
    BOOL isDir = NO;
    NSMutableArray *ids = [NSMutableArray new];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&isDir] == YES && isDir == YES) {
        NSError *error = nil;
        NSArray *filePaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:&error];
        BOXAssert(error == nil, @"Failed to get content of dir %@: %@", dir, error);
        for (int i = 0; i < filePaths.count; i++) {
            NSString *fileName = filePaths[i];
            [ids addObject:fileName];
        }
    }
    return [ids copy];
}

+ (NSString *)extensionIdsDirGivenSharedContainerId:(NSString *)sharedContainerId
{
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:sharedContainerId];
    NSString *dir = [containerURL.path stringByAppendingPathComponent:@"extensionIds"];
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&isDir] == NO || isDir == NO) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return dir;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        _backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo = [NSMutableDictionary new];
        _extensionIdToBackgroundSessionIds = [NSMutableDictionary new];
        _extensionId = nil;
        _boxURLRequestCacheDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"urlRequestCache"];
        [self setUpCache];
        [self populateSessionTaskIdMap];
    }
    return self;
}

- (void)setUpCache
{
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.boxURLRequestCacheDir isDirectory:&isDir] == NO) {
        NSError *error = nil;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:self.boxURLRequestCacheDir
                                                 withIntermediateDirectories:YES
                                                                  attributes:nil
                                                                       error:&error];
        BOXAssert(success, @"Failed to create cacheDir %@ with error %@", self.boxURLRequestCacheDir, error);
    }
}

- (void)setUpForApp
{
    [self populateSessionTaskIdMap];
}

- (void)setUpForExtension
{
    self.extensionId = [BOXSampleAppSessionManager generateRandomStringWithLength:32];
    [self persistExtensionId:self.extensionId];

    [self populateSessionTaskIdMap];
}

- (void)persistExtensionId:(NSString *)extensionId
{
    NSString *dir = [BOXSampleAppSessionManager extensionIdsDirGivenSharedContainerId:sharedContainerIdentifierKey];
    NSString *filePath = [dir stringByAppendingPathComponent:extensionId];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
}

- (void)removeInfoForExtensionId:(NSString *)extensionId
{
    NSArray *backgroundSessionIds = self.extensionIdToBackgroundSessionIds[extensionId];
    for (NSString *backgroundSessionId in backgroundSessionIds) {
        [self removeBackgroundSessionId:backgroundSessionId];
    }
    NSString *dir = [BOXSampleAppSessionManager extensionIdsDirGivenSharedContainerId:sharedContainerIdentifierKey];
    NSString *filePath = [dir stringByAppendingPathComponent:extensionId];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    if (error != nil) {
        BOXLog(@"Failed to remove extensionId %@", extensionId);
    }
}

- (void)removeBackgroundSessionId:(NSString *)backgroundSessionId
{
    @synchronized (self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo) {
        [self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo removeObjectForKey:backgroundSessionId];
    }
    [self persistSessionTaskMap];
}

- (void)populateInfoForExtensionId:(NSString *)extensionId
{
    NSString *key = [self dictionaryKeyGivenExtensionId:extensionId];

    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:sharedContainerIdentifierKey];
    NSData *encodedMap = [defaults objectForKey:key];
    NSDictionary *backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfoForExtension = [NSKeyedUnarchiver unarchiveObjectWithData:encodedMap];

    //iterate through the map of session tasks from extension
    //and copy them to the current map

    for (NSString *backgroundSessionId in backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfoForExtension.allKeys) {
        NSDictionary *userIdToAssociateIdAndSessionTaskInfoForExtension = backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfoForExtension[backgroundSessionId];

        for (NSString *userId in userIdToAssociateIdAndSessionTaskInfoForExtension.allKeys) {
            NSDictionary *associateIdAndSessionTaskInfoForExtension = userIdToAssociateIdAndSessionTaskInfoForExtension[userId];

            for (NSString *associateId in associateIdAndSessionTaskInfoForExtension.allKeys) {
                [self saveBackgroundSessionId:backgroundSessionId userId:userId associateId:associateId withInfo:associateIdAndSessionTaskInfoForExtension[associateId]];
            }
        }
    }

    @synchronized (self.extensionIdToBackgroundSessionIds) {
        self.extensionIdToBackgroundSessionIds[extensionId] = backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfoForExtension.allKeys;
    }
}

- (void)saveBackgroundSessionId:(NSString *)backgroundSessionId userId:(NSString *)userId associateId:(NSString *)associateId withInfo:(BOXSampleAppSessionInfo *)info
{
    if (self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo[backgroundSessionId] == nil) {
        @synchronized (self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo) {
            self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo[backgroundSessionId] = [NSMutableDictionary new];
        }
        if (self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo[backgroundSessionId][userId] == nil) {
            @synchronized (self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo[backgroundSessionId]) {
                self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo[backgroundSessionId][userId] = [NSMutableDictionary new];
            }
        }
    }
    @synchronized (self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo[backgroundSessionId][userId]) {
        self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo[backgroundSessionId][userId][associateId] = info;
    }

    [self persistSessionTaskMap];
}

- (void)removeBackgroundSessionId:(NSString *)backgroundSessionId userId:(NSString *)userId associateId:(NSString *)associateId
{
    if (self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo[backgroundSessionId] != nil
        && self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo[backgroundSessionId][userId] != nil
        && self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo[backgroundSessionId][userId][associateId] != nil) {

        @synchronized (self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo[backgroundSessionId][userId]) {
            [self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo[backgroundSessionId][userId] removeObjectForKey:associateId];
        }

        [self persistSessionTaskMap];
    }
}

- (void)cleanUpForUserId:(NSString *)userId
{
    @synchronized (self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo) {

        for (NSString *backgroundSessionId in self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo.allKeys) {
            [self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo[backgroundSessionId] removeObjectForKey:userId];
        }
        [self persistSessionTaskMap];
    }
}

- (NSDictionary *)backgroundSessionIdToAssociateIdAndSessionTaskInfoForUserId:(NSString *)userId
{
    @synchronized (self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo) {
        NSMutableDictionary *dict = [NSMutableDictionary new];

        for (NSString *backgroundSessionId in self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo.allKeys) {
            NSMutableDictionary *userIdToAssociateIdAndSessionTaskInfo = self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo[backgroundSessionId];
            if (userIdToAssociateIdAndSessionTaskInfo[userId] != nil) {
                [dict setObject:userIdToAssociateIdAndSessionTaskInfo[userId] forKey:backgroundSessionId];
            }
        }
        return [dict copy];
    }
}

- (NSDictionary *)associateIdToSessionTaskInfoForBackgroundSessionId:(NSString *)backgroundSessionId userId:(NSString *)userId
{
    @synchronized (self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo) {
        if (self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo[backgroundSessionId] != nil && self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo[backgroundSessionId][userId] != nil) {
            return self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo[backgroundSessionId][userId];
        } else {
            return nil;
        }
    }
}

- (NSString *)infoKey
{
    return self.extensionId == nil ? backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfoKey : [self dictionaryKeyGivenExtensionId:self.extensionId];
}

- (NSString *)dictionaryKeyGivenExtensionId:(NSString *)extensionId
{
    return [NSString stringWithFormat:@"%@For%@", backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfoKey, extensionId];
}

- (void)persistSessionTaskMap
{
    @synchronized (self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo) {
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:sharedContainerIdentifierKey];
        NSData *encodedMap = [NSKeyedArchiver archivedDataWithRootObject:self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo];
        [defaults setObject:encodedMap forKey:[self infoKey]];
    }
}

- (void)populateSessionTaskIdMap
{
    @synchronized (self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo) {
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:sharedContainerIdentifierKey];
        NSData *encodedMap = [defaults objectForKey:[self infoKey]];
        self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedMap];

        if (self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo == nil) {
            self.backgroundSessionIdToUserIdToAssociateIdAndSessionTaskInfo = [NSMutableDictionary new];
        }
    }
}

@end

