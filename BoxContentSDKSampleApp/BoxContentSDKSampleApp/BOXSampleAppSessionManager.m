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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        self.associateId = [aDecoder decodeObjectForKey:@"associateId"];
        self.destinationPath = [aDecoder decodeObjectForKey:@"destinationPath"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.associateId forKey:@"associateId"];
    [aCoder encodeObject:self.destinationPath forKey:@"destinationPath"];
}

@end

@interface BOXSampleAppSessionManager()

@property (nonatomic, strong, readwrite) NSMutableDictionary <NSNumber *, BOXSampleAppSessionInfo *> *sessionTaskIdMap;

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

+ (NSString *)rootCacheDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
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
        [self populateSessionTaskIdMap];
    }
    return self;
}

- (void)saveSessionTaskId:(NSUInteger)sessionTaskId withInfo:(BOXSampleAppSessionInfo *)info;
{
    @synchronized (self.sessionTaskIdMap) {
        self.sessionTaskIdMap[@(sessionTaskId)] = info;
        [self persistSessionTaskMap];
    }
}

- (void)removeSessionTaskId:(NSUInteger)sessionTaskId
{
    @synchronized (self.sessionTaskIdMap) {
        [self.sessionTaskIdMap removeObjectForKey:@(sessionTaskId)];
        [self persistSessionTaskMap];
    }
}

- (BOXSampleAppSessionInfo *)getSessionTaskInfo:(NSUInteger)sessionTaskId
{
    return self.sessionTaskIdMap[@(sessionTaskId)];
}

- (void)persistSessionTaskMap
{
    @synchronized (self.sessionTaskIdMap) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *encodedMap = [NSKeyedArchiver archivedDataWithRootObject:self.sessionTaskIdMap];
        [defaults setObject:encodedMap forKey:sessionTaskIdToAssociateIdKey];
    }
}

- (void)populateSessionTaskIdMap
{
    @synchronized (self.sessionTaskIdMap) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *encodedMap = [defaults objectForKey:sessionTaskIdToAssociateIdKey];
        self.sessionTaskIdMap = [NSKeyedUnarchiver unarchiveObjectWithData:encodedMap];

        if (self.sessionTaskIdMap == nil) {
            self.sessionTaskIdMap = [NSMutableDictionary new];
        }
    }
}


@end

