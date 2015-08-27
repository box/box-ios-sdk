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

#define CACHE_FOLDER @"boxRequestCache"

@interface BOXRequestCache ()

@property (nonatomic, readwrite, copy) NSString *cachePath;
@property (nonatomic, readwrite, strong) PINCache *cache;

@end

@implementation BOXRequestCache

- (instancetype)initWithUserID:(NSString *)userID
{
    return [self initWithUserID:userID cacheDirectory:nil];
}

- (instancetype)initWithUserID:(NSString *)userID cacheDirectory:(NSURL *)cacheDirectory
{
    BOOL isDirectory;
    NSError *error = nil;
    
    self = [super init];
    
    if (self) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (!cacheDirectory) {
            cacheDirectory = [NSURL URLWithString:[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
        }
        
        _cachePath = [[cacheDirectory path] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", CACHE_FOLDER, userID]];
        
        if (![fileManager fileExistsAtPath:_cachePath isDirectory:&isDirectory]) {
            [fileManager createDirectoryAtPath:_cachePath
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
        _cache = [[PINCache alloc] initWithName:@"BoxRequestCache" rootPath:_cachePath];
    }
    
    return self;
}

- (void)fetchCacheResponseForRequest:(BOXRequest *)request cacheBlock:(void(^)(NSDictionary *dictionary))cacheBlock
{
    if (cacheBlock) {
        PINCacheObjectBlock localCacheBlock = ^void(PINCache *cache, NSString *key, id __nullable object) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                cacheBlock(object);
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
    return [[request.operation requestURLWithURL:request.operation.baseRequestURL queryStringParameters:[queryParams copy]] absoluteString];
}

@end
