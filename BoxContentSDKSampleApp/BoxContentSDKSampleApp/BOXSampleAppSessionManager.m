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

@interface BOXSampleAppSessionManager()

@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, NSMutableDictionary <NSString *, BOXSampleAppSessionInfo *> *> *userIdToAssociateIdAndSessionTaskInfo;

@property (nonatomic, strong, readwrite) NSString *boxURLRequestCacheDir;

@end


static NSString *userIdToAssociateIdAndSessionTaskInfoKey = @"userIdToAssociateIdAndSessionTaskInfo";

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

- (id)init
{
    self = [super init];
    if (self != nil) {
        _userIdToAssociateIdAndSessionTaskInfo = [NSMutableDictionary new];
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

- (void)saveUserId:(NSString *)userId associateId:(NSString *)associateId withInfo:(BOXSampleAppSessionInfo *)info
{
    if (self.userIdToAssociateIdAndSessionTaskInfo[userId] == nil) {
        @synchronized (self.userIdToAssociateIdAndSessionTaskInfo) {
            self.userIdToAssociateIdAndSessionTaskInfo[userId] = [NSMutableDictionary new];
        }
    }
    @synchronized (self.userIdToAssociateIdAndSessionTaskInfo[userId]) {
        self.userIdToAssociateIdAndSessionTaskInfo[userId][associateId] = info;
        [self persistSessionTaskMap];
    }
}

- (void)removeUserId:(NSString *)userId associateId:(NSString *)associateId
{
    @synchronized (self.userIdToAssociateIdAndSessionTaskInfo[userId]) {
        [self.userIdToAssociateIdAndSessionTaskInfo[userId] removeObjectForKey:associateId];
        [self persistSessionTaskMap];
    }
}

- (void)cleanUpForUserId:(NSString *)userId
{
    @synchronized (self.userIdToAssociateIdAndSessionTaskInfo) {
        [self.userIdToAssociateIdAndSessionTaskInfo removeObjectForKey:userId];
        [self persistSessionTaskMap];
    }
}

- (BOXSampleAppSessionInfo *)getSessionTaskInfoForUserId:(NSString *)userId associateId:(NSString *)associateId
{
    @synchronized (self.userIdToAssociateIdAndSessionTaskInfo[userId]) {
        return self.userIdToAssociateIdAndSessionTaskInfo[userId][associateId];
    }
}

- (NSDictionary *)associateIdToSessionTaskInfoForUserId:(NSString *)userId
{
    @synchronized (self.userIdToAssociateIdAndSessionTaskInfo) {
        return self.userIdToAssociateIdAndSessionTaskInfo[userId];
    }
}

- (void)persistSessionTaskMap
{
    @synchronized (self.userIdToAssociateIdAndSessionTaskInfo) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *encodedMap = [NSKeyedArchiver archivedDataWithRootObject:self.userIdToAssociateIdAndSessionTaskInfo];
        [defaults setObject:encodedMap forKey:userIdToAssociateIdAndSessionTaskInfoKey];
    }
}

- (void)populateSessionTaskIdMap
{
    @synchronized (self.userIdToAssociateIdAndSessionTaskInfo) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *encodedMap = [defaults objectForKey:userIdToAssociateIdAndSessionTaskInfoKey];
        self.userIdToAssociateIdAndSessionTaskInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedMap];

        if (self.userIdToAssociateIdAndSessionTaskInfo == nil) {
            self.userIdToAssociateIdAndSessionTaskInfo = [NSMutableDictionary new];
        }
    }
}

@end

