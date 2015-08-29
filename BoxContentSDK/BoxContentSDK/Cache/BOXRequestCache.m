//
//  BOXRequestCache.m
//  BoxContentSDK
//
//  Created on 8/25/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXRequestCache.h"
#import "BOXContentClient.h"
#import "BOXUser.h"
#import "BOXRequest_Private.h"
#import "BOXFolderItemsRequest.h"
#import "PINCache.h"
#import <CommonCrypto/CommonDigest.h>

#define CACHE_FOLDER @"boxRequestCache"

@interface BOXRequestCache ()

@property (nonatomic, readwrite, strong) PINCache *cache;
@property (nonatomic, readwrite, copy) NSString *userID;
@property (nonatomic, readwrite, strong) NSURL *cacheDirectory;

@end

@implementation BOXRequestCache

- (instancetype)initWithUserID:(NSString *)userID
{
    return [self initWithUserID:userID cacheDirectory:nil];
}

- (instancetype)initWithUserID:(NSString *)userID cacheDirectory:(NSURL *)cacheDirectory
{
    self = [super init];
    
    if (self) {
        _userID = userID;
        
        if (!cacheDirectory) {
            cacheDirectory = [NSURL URLWithString:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
        }
        
        self.cacheDirectory = cacheDirectory;
    }

    return self;
}

- (PINCache *)cache
{
    if (_cache == nil) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDirectory;
        NSError *error = nil;
        
        if (![fileManager fileExistsAtPath:self.cachePath isDirectory:&isDirectory]) {
            [fileManager createDirectoryAtPath:self.cachePath
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:&error];
            if (error) {
                BOXLog(@"Unable to create BOXRequestCache directory: %@", error);
                return nil;
            }
        } else if (!isDirectory) {
            BOXLog(@"Unable to create BOXRequestCache directory at %@ because a file already exists at that location.", _cachePath);
            return nil;
        }
        
        _cache = [[PINCache alloc] initWithName:@"BoxRequestCache" rootPath:self.cachePath];
        
        // This will allow the cache to be automatically be trimmed whenever it exceeds the byte limit.
        // In the future we can expose an interface to customize this.
        _cache.diskCache.byteLimit = 500*1024*1024;
        
        _cache.diskCache.didAddObjectBlock = ^(PINDiskCache *cache, NSString *key, id <NSCoding>  __nullable object, NSURL *fileURL) {
            [fileURL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
            NSString *protectionLevel = NSFileProtectionComplete;
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSDictionary *existingAttributes = [fileManager attributesOfItemAtPath:[fileURL path] error:nil];
            
            if (![[existingAttributes objectForKey:NSFileProtectionKey] isEqualToString:protectionLevel]) {
                NSMutableDictionary *newAttributes = [existingAttributes mutableCopy];
                [newAttributes setObject:protectionLevel forKey:NSFileProtectionKey];
                [fileManager setAttributes:newAttributes ofItemAtPath:[fileURL path] error:nil];
            }
        };
    }
    
    return _cache;
}

- (void)setCacheDirectory:(NSURL *)cacheDirectory
{
    if (_cacheDirectory != cacheDirectory) {
        _cacheDirectory = cacheDirectory;
        
        // This will clear and delete the old cache. The new one will be created next time the cache is referenced.
        [self clearForLogout];
    }
}

- (NSString *)cachePath
{
    return [[self.cacheDirectory path] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", CACHE_FOLDER, self.userID]];
}

- (void)fetchCacheResponseForRequest:(BOXRequest *)request cacheBlock:(void(^)(NSDictionary *dictionary))cacheBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    
    if (cacheBlock) {
        PINCacheObjectBlock localCacheBlock = ^void(PINCache *cache, NSString *key, id __nullable object) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                [BOXDispatchHelper callCompletionBlock:^{
                    cacheBlock(object);
                } onMainThread:isMainThread];
            }
        };
        [self.cache objectForKey:[self keyForRequest:request] block:localCacheBlock];
    }
}

- (void)removeCacheResponseForRequest:(BOXRequest *)request
{
    [self.cache removeObjectForKey:[self keyForRequest:request]];
}

- (void)updateCacheForRequest:(BOXRequest *)request withResponse:(NSDictionary *)JSONDictionary
{
    [self.cache setObject:JSONDictionary forKey:[self keyForRequest:request] block:nil];
}

- (NSString *)keyForRequest:(BOXRequest *)request
{
    NSMutableDictionary *queryParams = [NSMutableDictionary dictionaryWithDictionary:request.operation.queryStringParameters];
    if ([request isKindOfClass:[BOXFolderItemsRequest class]]) {
        // We need to differentiate between fetching all items and an explicit paginated request.
        [queryParams removeObjectForKey:BOXAPIParameterKeyLimit];
        [queryParams removeObjectForKey:BOXAPIParameterKeyOffset];
    }
    
    return [self sha1:[[request.operation requestURLWithURL:request.operation.baseRequestURL queryStringParameters:[queryParams copy]] absoluteString]];
}

- (void)removeAllCachedResponses
{
    [self.cache removeAllObjects];
}

- (void)clearForLogout
{
    if (_cache) {
        [self.cache removeAllObjects];
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // This will require the cache to be re-initialized before it is used again.
        [fileManager removeItemAtPath:[self.cachePath stringByDeletingLastPathComponent] error:&error];
        if (error) {
            BOXLog(@"Failed to remove BOXRequestCache directory: %@", error);
        }
        self.cache = nil;
    }
}

#pragma mark - Private Helpers

-(NSString *)sha1:(NSString *)input
{
    if (!input) {
        return nil;
    }
    
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH *2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",digest[i]];
    }
    
    return output;
}

@end
