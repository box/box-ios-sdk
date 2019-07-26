//
//  BOXDefaultSharedLinkHeadersManager.m
//  BoxContentSDK
//
//  Created on 12/22/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXSharedLinkHeadersDefaultManager.h"

@interface BOXSharedLinkHeadersDefaultManager ()

/**
 * Dictionary containing the links 
 * Key : link_[USER_ID]_[ITEM_TYPE]_[ITEM_ID] for shared links or password_[USER_ID]_[ITEM_TYPE]_[ITEM_ID] for passwords
 * Value : the shared link URL as an NSString or the password as an NSString
 **/
@property (nonatomic, readwrite, strong) NSMutableDictionary *storageDictionary;

@end

@implementation BOXSharedLinkHeadersDefaultManager

- (instancetype)init
{
    if (self = [super init]) {
        _storageDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - BOXSharedLinkStorageProtocol implementation

- (void)storeSharedLink:(NSString *)sharedLink 
       forItemWithIDKey:(NSString *)itemIDKey 
            itemTypeKey:(NSString *)itemTypeKey
               password:(NSString *)password 
              userIDKey:(NSString *)userIDKey
{
    if (sharedLink) {
        [self.storageDictionary setObject:sharedLink forKey:[self sharedLinkKeyForItemID:itemIDKey itemType:itemTypeKey userID:userIDKey]];
    }
    if (password) {
        [self.storageDictionary setObject:password forKey:[self passwordKeyForItemID:itemIDKey itemType:itemTypeKey userID:userIDKey]];
    }
}

- (void)removeStoredInformationForItemWithID:(NSString *)itemID itemType:(NSString *)itemType userID:(NSString *)userID
{   
    [self.storageDictionary removeObjectForKey:[self sharedLinkKeyForItemID:itemID itemType:itemType userID:userID]];
    [self.storageDictionary removeObjectForKey:[self passwordKeyForItemID:itemID itemType:itemType userID:userID]];
}

- (void)removeStoredInformationForUserWithID:(NSString *)userID
{
    [self.storageDictionary removeAllObjects];
}

- (NSString *)sharedLinkForItemWithID:(NSString *)itemID itemType:(NSString *)itemType userID:(NSString *)userID
{
    return [self.storageDictionary objectForKey:[self sharedLinkKeyForItemID:itemID itemType:itemType userID:userID]];
}

- (NSString *)passwordForSharedItemWithID:(NSString *)itemID itemType:(NSString *)itemType userID:(NSString *)userID
{
    return [self.storageDictionary objectForKey:[self passwordKeyForItemID:itemID itemType:itemType userID:userID]];
}

#pragma mark - Private Helpers 

- (NSString *)sharedLinkKeyForItemID:(NSString *)itemID itemType:(NSString *)itemType userID:(NSString *)userID
{
    return [NSString stringWithFormat:@"link_%@_%@_%@", userID, itemType, itemID];
}

- (NSString *)passwordKeyForItemID:(NSString *)itemID itemType:(NSString *)itemType userID:(NSString *)userID
{
    return [NSString stringWithFormat:@"password_%@_%@_%@", userID, itemType, itemID];
}

@end
