//
//  BOXClient+CollectionAPI.m
//  BoxContentSDK
//
//  Created by Clement Rousselle on 12/15/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXContentClient+Collection.h"
#import "BOXCollectionListRequest.h"
#import "BOXCollectionItemsRequest.h"
#import "BOXItemSetCollectionsRequest.h"
#import "BOXCollectionFavoritesRequest.h"
#import "BOXContentClient_Private.h"

@implementation BOXContentClient (CollectionAPI)

- (BOXCollectionFavoritesRequest *)collectionInfoRequestForFavorites
{
    BOXCollectionFavoritesRequest *request = [[BOXCollectionFavoritesRequest alloc] init];
    [self prepareRequest:request];
    return request;
}

- (BOXCollectionListRequest *)collectionsRequestForCurrentUser
{
    BOXCollectionListRequest *request = [[BOXCollectionListRequest alloc] init];
    [self prepareRequest:request];
    
    return request;
}

- (BOXCollectionItemsRequest *)collectionItemsRequestWithID:(NSString *)collectionID inRange:(NSRange)range
{
    BOXCollectionItemsRequest *request = [[BOXCollectionItemsRequest alloc] initWithCollectionID:collectionID inRange:range];
    [self prepareRequest:request];

    return request;
}

- (BOXItemSetCollectionsRequest *)collectionsSetRequestForFileWithID:(NSString *)fileID collectionIDs:(NSArray *)collectionIDs
{
    BOXItemSetCollectionsRequest *request = [[BOXItemSetCollectionsRequest alloc] initFileSetCollectionsRequestForFileWithID:fileID collectionIDs:collectionIDs];
    [self prepareRequest:request];
    
    return request;
}

- (BOXItemSetCollectionsRequest *)collectionsSetRequestForFolderWithID:(NSString *)folderID collectionIDs:(NSArray *)collectionIDs
{
    BOXItemSetCollectionsRequest *request = [[BOXItemSetCollectionsRequest alloc] initFolderSetCollectionsRequestForFolderWithID:folderID collectionIDs:collectionIDs];
    [self prepareRequest:request];
    
    return request;
}

- (BOXItemSetCollectionsRequest *)collectionsSetRequestForBookmarkWithID:(NSString *)bookmarkID collectionIDs:(NSArray *)collectionIDs
{
    BOXItemSetCollectionsRequest *request = [[BOXItemSetCollectionsRequest alloc] initBookmarkSetCollectionsRequestForBookmarkWithID:bookmarkID collectionIDs:collectionIDs];
    [self prepareRequest:request];
    
    return request;
}



@end
