//
//  BOXItemCollectionService.m
//  BoxContentSDKSampleApp
//
//  Created by Jim DiZoglio on 7/30/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import "BOXItemCollectionService.h"

#define NOTIFICATION_USERINFOS_ITEM_KEY             @"item"
#define NOTIFICATION_ITEM_UPDATE                    @"itemUpdate"

@implementation BOXItemCollectionService

- (BOXItemSetCollectionsRequest *)collectionSetRequestForItem:(BOXItem *)item collectionIDs:(NSArray *)collectionIDs
{
    BOXItemSetCollectionsRequest *request = nil;
    
    NSString *udidString = [self generateGUID];
    if ([item isFile]) {
        request = [[BOXContentClient defaultClient] collectionsSetRequestForFileWithID:item.modelID collectionIDs:collectionIDs associateId:udidString];
    } else if ([item isFolder]) {
        request = [[BOXContentClient defaultClient] collectionsSetRequestForFolderWithID:item.modelID collectionIDs:collectionIDs associateId:udidString];
    } else if ([item isBookmark]) {
        request = [[BOXContentClient defaultClient] collectionsSetRequestForBookmarkWithID:item.modelID collectionIDs:collectionIDs associateId:udidString];
    }
    
    return request;
}

- (BOXRequest *)updateCollectionsWithItemRetrievalForItem:(BOXItem *)item
                                            collectionIDs:(NSArray *)collectionIDs
                                          completionBlock:(BOXItemBlock)completionBlock
{
    BOXItemSetCollectionsRequest *collectionRequest = [self collectionSetRequestForItem:item collectionIDs:collectionIDs];
    if (collectionRequest) {
        [collectionRequest performRequestWithCompletion:^(BOXItem *item, NSError *error) {
            if (completionBlock) {
                completionBlock(item, error);
            }
        }];
    }
    
    return collectionRequest;
}

- (BOXRequest *)addItem:(BOXItem *)item
     toCollectionWithID:(NSString *)collectionID
        completionBlock:(BOXItemBlock)completionBlock
{
    BOXItemBlock addCompletionBlock = ^(BOXItem * item, NSError *error) {
        if (completionBlock) {
            completionBlock(item, error);
        }
    };
    
    // Currently optimized for items only being able to belong to the favorites collection.
    return [self updateCollectionsWithItemRetrievalForItem:item
                                             collectionIDs:@[collectionID]
                                           completionBlock:addCompletionBlock];
}

- (BOXRequest *)removeItem:(BOXItem *)item
      fromCollectionWithID:(NSString *)collectionID
           completionBlock:(BOXItemBlock)completionBlock
{
    BOXItemBlock removeCompletionBlock = ^(BOXItem * item, NSError *error) {
        if (completionBlock) {
            completionBlock(item, error);
        }
    };
    
    // Currently optimized for items only being able to belong to the favorites collection.
    return [self updateCollectionsWithItemRetrievalForItem:item
                                             collectionIDs:@[]
                                           completionBlock:removeCompletionBlock];
}

- (NSString*)generateGUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [NSString stringWithFormat:@"%@", string];
}

@end
