//
//  BOXRequestCache.h
//  BoxContentSDK
//
//  Created on 8/25/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOXAPIJSONOperation.h"
#import "BOXRequest.h"

@interface BOXRequestCache : NSObject

@property (nonatomic, readonly, copy) NSString *userID;

/**
 *  Creates a BOXRequestCache for a given user ID.
 *
 *  @param userID id of the user for the cache.
 *
 *  @return BOXRequestCache for the user.
 */
- (instancetype)initWithUserID:(NSString *)userID;

/**
 *  Performs the cacheBlock with the value retrieved for the specified key.
 *
 *  @param key        key associated with the request to retrieve.
 *  @param cacheBlock block to be executed when the cached request has been retrieved.
 */
- (NSDictionary *)fetchCacheForKey:(NSString *)key;

/**
 *  Removes the cached response for the specified key.
 *
 *  @param key key for the request to remove from the cache.
 */
- (void)removeCacheForKey:(NSString *)key;

/**
 *  Updates the cached response for a key.
 *
 *  @param key            key associated with the response.
 *  @param JSONDictionary JSON dictionary for the response.
 */
- (void)updateCacheForKey:(NSString *)key withResponse:(NSDictionary *)JSONDictionary;

/**
 *  Removes all responses currently stored in the cache.
 */
- (void)removeAllCachedResponses;

/**
 *  Clears the cache for logout.
 */
- (void)clearForLogout;

@end
