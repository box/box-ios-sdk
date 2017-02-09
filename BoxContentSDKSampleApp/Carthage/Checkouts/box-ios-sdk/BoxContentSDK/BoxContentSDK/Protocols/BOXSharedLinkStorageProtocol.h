//
//  BOXSharedLinkStorageProtocol.h
//  BoxContentSDK
//
//  Created on 12/22/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BOXSharedLinkStorageProtocol <NSObject>

/** 
 * Stores the sharedLink and password related to the item represented by itemID
 * @param sharedLink  The URL repenting the BOXItem identified by itemID.
 * @param itemIDKey  Unique identifier of the BOXItem that is represented by the sharedLink. Will be used as part of the key to store the shared links and passwords.
 * @param itemTypeKey  Identifier of the type of the item. Files, Folders and Bookmarks can have similar IDs. Will be used as part of the key to store the shared links and passwords. 
 * @param password  Optional password for the sharedLink.
 * @param userIDKey  Unique identifier of the user that is using this shared link. Will be used as part of the key to store the shared links and passwords.
 **/
- (void)storeSharedLink:(NSString *)sharedLink 
          forItemWithIDKey:(NSString *)itemIDKey 
               itemTypeKey:(NSString *)itemTypeKey
               password:(NSString *)password 
                 userIDKey:(NSString *)userIDKey;
/**
 * Removes the stored information that are related to the item represented by the provided identifier
 * @param itemID  Unique identifier of the BOXItem
 * @param itemType  Identifier of the type of the item. Files, Folders and Bookmarks can have similar IDs
 * @param userID  Unique identifier of the BOXUser
 **/
- (void)removeStoredInformationForItemWithID:(NSString *)itemID itemType:(NSString *)itemType userID:(NSString *)userID;

/**
 * Removes the stored information that are related to the user represented by the provided identifier
 * @param userID  Unique identifier of the BOXUser
 **/
- (void)removeStoredInformationForUserWithID:(NSString *)userID;

/**
 * Retrieves the sharedLink associated to the modelID
 * @param itemID  Unique identifier of the BOXItem.
 * @param itemType  Identifier of the type of the item. Files, Folders and Bookmarks can have similar IDs
 * @return  the sharedLink if found, nil otherwise.
 **/
- (NSString *)sharedLinkForItemWithID:(NSString *)itemID itemType:(NSString *)itemType userID:(NSString *)userID;
/**
 * Retrieves the password associated to the item identified by the provided ID
 * @param itemID  Unique idenfitier of the BOXItem
 * @param itemType  Identifier of the type of the item. Files, Folders and Bookmarks can have similar IDs
 * @return  the password if found, nil otherwise.
 **/
- (NSString *)passwordForSharedItemWithID:(NSString *)itemID itemType:(NSString *)itemType userID:(NSString *)userID;


@end
