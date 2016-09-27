//
//  BOXClient+Bookmark.m
//  BoxContentSDK
//
//  Created by Rico Yao on 1/16/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <BoxContentSDK/BOXBookmarkCopyRequest.h>
#import <BoxContentSDK/BOXBookmarkCreateRequest.h>
#import <BoxContentSDK/BOXBookmarkDeleteRequest.h>
#import <BoxContentSDK/BOXBookmarkRequest.h>
#import <BoxContentSDK/BOXBookmarkUpdateRequest.h>

#import <BoxContentSDK/BOXContentClient+Bookmark.h>

#import "BOXContentClient_Private.h"

@implementation BOXContentClient (Bookmark)

- (BOXBookmarkRequest *)bookmarkInfoRequestWithID:(NSString *)bookmarkID
{
    BOXBookmarkRequest *request = [[BOXBookmarkRequest alloc] initWithBookmarkID:bookmarkID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXBookmarkCreateRequest *)bookmarkCreateRequestInFolderID:(NSString *)folderID
                                                          URL:(NSURL *)URL
{
    BOXBookmarkCreateRequest *request = [[BOXBookmarkCreateRequest alloc] initWithURL:URL parentFolderID:folderID];
    [self prepareRequest:request];
    return request;
}

- (BOXBookmarkDeleteRequest *)bookmarkDeleteRequestWithID:(NSString *)bookmarkID
{
    BOXBookmarkDeleteRequest *request = [[BOXBookmarkDeleteRequest alloc] initWithBookmarkID:bookmarkID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXBookmarkDeleteRequest *)trashedBookmarkDeleteFromTrashRequestWithID:(NSString *)bookmarkID
{
    BOXBookmarkDeleteRequest *request = [[BOXBookmarkDeleteRequest alloc] initWithBookmarkID:bookmarkID isTrashed:YES];
    [self prepareRequest:request];
    
    return request;
}

- (BOXBookmarkUpdateRequest *)bookmarkRenameRequestWithID:(NSString *)bookmarkID
                                                  newName:(NSString *)newName
{
    BOXBookmarkUpdateRequest *request = [[BOXBookmarkUpdateRequest alloc] initWithBookmarkID:bookmarkID];
    request.bookmarkName = newName;
    [self prepareRequest:request];
    
    return request;
}

- (BOXBookmarkUpdateRequest *)bookmarkUpdateRequestWithID:(NSString *)bookmarkID
{
    BOXBookmarkUpdateRequest *request = [[BOXBookmarkUpdateRequest alloc] initWithBookmarkID:bookmarkID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXBookmarkUpdateRequest *)bookmarkMoveRequestWithID:(NSString *)bookmarkID
                                    destinationFolderID:(NSString *)destinationFolderID
{
    BOXBookmarkUpdateRequest *request = [[BOXBookmarkUpdateRequest alloc] initWithBookmarkID:bookmarkID];
    request.parentID = destinationFolderID;
    [self prepareRequest:request];
    
    return request;
}

- (BOXBookmarkCopyRequest *)bookmarkCopyRequestWithID:(NSString *)bookmarkID
                                  destinationFolderID:(NSString *)destinationFolderID
{
    BOXBookmarkCopyRequest *request = [[BOXBookmarkCopyRequest alloc] initWithBookmarkID:bookmarkID destinationFolderID:destinationFolderID];
    [self prepareRequest:request];
    
    return request;
}


@end
