//
//  BOXSharedLinkHeadersHelper.m
//  BoxContentSDK
//
//  Created on 12/19/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXSharedLinkHeadersHelper.h"
#import "BOXItem.h"
#import "BOXFolder.h"
#import "BOXUser.h"
#import "BOXContentClient.h"

@interface BOXSharedLinkHeadersHelper ()

@property (nonatomic, readwrite, strong) BOXContentClient *client;

@end

@implementation BOXSharedLinkHeadersHelper

- (instancetype)initWithClient:(BOXContentClient *)client
{
    if (self = [super init]) {
        _client = client;
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        _client = [BOXContentClient defaultClient];
    }
    return self;
}


- (NSString *)userID
{
    return self.client.user.modelID;
}

#pragma mark - Public Methods
 
- (void)storeHeadersForItemWithID:(NSString *)itemID itemType:(NSString *)itemType sharedLink:(NSString *)sharedLink password:(NSString *)password
{
    if (itemID == nil) {
        BOXLog(@"The provided model was nil. Please make sure the request that called this method implements itemID:");
    }
    
    [self.delegate storeSharedLink:sharedLink forItemWithIDKey:itemID itemTypeKey:itemType password:password userIDKey:self.userID];
}

- (void)storeHeadersFromAncestorsIfNecessaryForItemWithID:(NSString *)itemID itemType:(NSString *)itemType ancestors:(NSArray *)ancestors
{
    // Go from the direct parent to the most remote ancestor.
    for (NSInteger i = ancestors.count - 1; i >= 0; i --) {
        BOXFolderMini *folder = ancestors[i];
            
        NSString *link = [self.delegate sharedLinkForItemWithID:folder.modelID itemType:itemType userID:self.userID];
        // We found a link in one of the ancestors of the file, we need to store this file that now would need the headers of its ancestors in any API request
        if (link) {
            [self.delegate storeSharedLink:link forItemWithIDKey:itemID itemTypeKey:itemType password:nil userIDKey:self.userID];
            break;
        }
    }
}

- (void)removeStoredInformationForItemWithID:(NSString *)itemID itemType:(NSString *)itemType
{
    [self.delegate removeStoredInformationForItemWithID:itemID itemType:itemType userID:self.userID];
}

- (void)removeStoredInformationForUserWithID:(NSString *)userID
{
    [self.delegate removeStoredInformationForUserWithID:userID];
}

- (NSString *)sharedLinkForItemID:(NSString *)itemID itemType:(NSString *)itemType
{
    return [self.delegate sharedLinkForItemWithID:itemID itemType:itemType userID:self.userID];
}

- (NSString *)passwordForItemForItemWithID:(NSString *)itemID itemType:(NSString *)itemType
{
    return [self.delegate passwordForSharedItemWithID:itemID itemType:itemType userID:self.userID];
}

@end
