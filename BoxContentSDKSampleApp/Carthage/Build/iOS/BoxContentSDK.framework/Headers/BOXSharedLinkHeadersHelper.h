//
//  BOXSharedLinkHeadersHelper.h
//  BoxContentSDK
//
//  Created on 12/19/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOXSharedLinkStorageProtocol.h"

@class BOXContentClient;

@interface BOXSharedLinkHeadersHelper : NSObject

/**
 * The object that will receive the BOXSharedLinkStorageProtocol callbacks. 
 * The BOX SDK provides a default implementation that can be overiden via BOXClient.
 **/
@property (nonatomic,readwrite, strong) id <BOXSharedLinkStorageProtocol> delegate;

- (instancetype)initWithClient:(BOXContentClient *)client;

- (void)storeHeadersForItemWithID:(NSString *)itemID itemType:(NSString *)itemType sharedLink:(NSString *)sharedLink password:(NSString *)password;
/**
 * Associates the provided itemID with an eventual inherithed sharedLink/password combination.
 * @param itemID  Unique identifier of the BOXItem.
 * @param ancestors  An array of BOXFolderMini containing the ancestors of the BOXItem identified by itemID.
 **/
- (void)storeHeadersFromAncestorsIfNecessaryForItemWithID:(NSString *)itemID itemType:(NSString *)itemType ancestors:(NSArray *)ancestors;
- (void)removeStoredInformationForItemWithID:(NSString *)itemID itemType:(NSString *)itemType;
- (void)removeStoredInformationForUserWithID:(NSString *)userID;

- (NSString *)sharedLinkForItemID:(NSString *)itemID itemType:(NSString *)itemType;
- (NSString *)passwordForItemForItemWithID:(NSString *)itemID itemType:(NSString *)itemType;


@end
