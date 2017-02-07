//
//  BOXSampleAppSessionManager.m
//  BoxContentSDKSampleApp
//
//  Created by Thuy Nguyen on 1/13/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import "BOXSampleAppSessionManager.h"

@implementation BOXSampleAppSessionInfo

- (id)initWithAssociateId:(NSString *)associateId destinationPath:(NSString *)destinationPath
{
    self = [super init];
    if (self != nil) {
        _associateId = associateId;
        _destinationPath = destinationPath;
    }
    return self;
}

- (id)initWithAssociateId:(NSString *)associateId folderId:(NSString *)folderId tempUploadFilePath:(NSString *)tempUploadFilePath
{
    self = [super init];
    if (self != nil) {
        _associateId = associateId;
        _folderId = folderId;
        _tempUploadFilePath = tempUploadFilePath;
    }
    return self;
}

- (id)initWithAssociateId:(NSString *)associateId fileId:(NSString *)fileId tempUploadFilePath:(NSString *)tempUploadFilePath
{
    self = [super init];
    if (self != nil) {
        _associateId = associateId;
        _fileId = fileId;
        _tempUploadFilePath = tempUploadFilePath;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        self.associateId = [aDecoder decodeObjectForKey:@"associateId"];
        self.destinationPath = [aDecoder decodeObjectForKey:@"destinationPath"];
        self.folderId = [aDecoder decodeObjectForKey:@"folderId"];
        self.fileId = [aDecoder decodeObjectForKey:@"fileId"];
        self.tempUploadFilePath = [aDecoder decodeObjectForKey:@"tempUploadFilePath"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.associateId forKey:@"associateId"];
    [aCoder encodeObject:self.destinationPath forKey:@"destinationPath"];
    [aCoder encodeObject:self.folderId forKey:@"folderId"];
    [aCoder encodeObject:self.folderId forKey:@"fileId"];
    [aCoder encodeObject:self.tempUploadFilePath forKey:@"tempUploadFilePath"];
}

@end

@interface BOXSampleAppSessionManager()

@property (nonatomic, strong, readwrite) NSMutableDictionary <NSNumber *, BOXSampleAppSessionInfo *> *urlSessionTaskIdMap;
@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, NSNumber *> *requestIdToUrlSessionTaskIdMap;
@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, BOXSampleAppSessionInfo *> *requestIdToUrlSessionInfoMap;
@end


static NSString *sessionTaskIdToAssociateIdKey = @"sessionTaskIdToAssociateId";

@implementation BOXSampleAppSessionManager

+ (id)defaultManager {
    static BOXSampleAppSessionManager *defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [[self alloc] init];
    });
    return defaultManager;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        [self populateSessionTaskIdMap];
    }
    return self;
}

- (void)removeRequestId:(NSString *)requestId
{
    NSUInteger urlSessionTaskId = 0;
    if (self.requestIdToUrlSessionTaskIdMap[requestId] != nil) {
        urlSessionTaskId = [self.requestIdToUrlSessionTaskIdMap[requestId] unsignedIntegerValue];
    }
    @synchronized (self.requestIdToUrlSessionTaskIdMap) {
        [self.requestIdToUrlSessionTaskIdMap removeObjectForKey:requestId];
    }
    [self removeSessionTaskId:urlSessionTaskId];
}

- (void)saveSessionInfo:(BOXSampleAppSessionInfo *)sessionInfo withRequestId:(NSString *)requestId
{
    @synchronized (self.urlSessionTaskIdMap) {
        //FIXME: persist connection between requestId and sessionInfo, and sessionTaskId if exists
        [self persistSessionTaskMap];
    }
}

- (void)saveUrlSessionTaskId:(NSUInteger)urlSessionTaskId withRequestId:(NSString *)requestId
{
    @synchronized (self.requestIdToUrlSessionTaskIdMap) {
        self.requestIdToUrlSessionTaskIdMap[requestId] = @(urlSessionTaskId);
    }
}

- (void)removeSessionTaskId:(NSUInteger)sessionTaskId
{
    @synchronized (self.urlSessionTaskIdMap) {
        [self.urlSessionTaskIdMap removeObjectForKey:@(sessionTaskId)];
        [self persistSessionTaskMap];
    }
}

- (BOXSampleAppSessionInfo *)getSessionTaskInfo:(NSUInteger)sessionTaskId
{
    return self.urlSessionTaskIdMap[@(sessionTaskId)];
}

- (void)persistSessionTaskMap
{
    @synchronized (self.urlSessionTaskIdMap) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *encodedMap = [NSKeyedArchiver archivedDataWithRootObject:self.urlSessionTaskIdMap];
        [defaults setObject:encodedMap forKey:sessionTaskIdToAssociateIdKey];
    }
}

- (void)populateSessionTaskIdMap
{
    @synchronized (self.urlSessionTaskIdMap) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *encodedMap = [defaults objectForKey:sessionTaskIdToAssociateIdKey];
        self.urlSessionTaskIdMap = [NSKeyedUnarchiver unarchiveObjectWithData:encodedMap];

        if (self.urlSessionTaskIdMap == nil) {
            self.urlSessionTaskIdMap = [NSMutableDictionary new];
        }
    }
}


@end

