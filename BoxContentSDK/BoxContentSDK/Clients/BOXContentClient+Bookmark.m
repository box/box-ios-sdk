//
//  BOXClient+Bookmark.m
//  BoxContentSDK
//
//  Created by Rico Yao on 1/16/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXContentClient_Private.h"
#import "BOXContentClient+Bookmark.h"
#import "BOXBookmarkRequest.h"
#import "BOXBookmarkUpdateRequest.h"
#import "BOXBookmarkCopyRequest.h"
#import "BOXBookmarkCreateRequest.h"
#import "BOXBookmarkDeleteRequest.h"

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
    request.queueManager = self.queueManager;
    [self prepareRequest:request];
    
    return request;
}

- (BOXBookmarkUpdateRequest *)bookmarkUpdateRequestWithID:(NSString *)bookmarkID
{
    BOXBookmarkUpdateRequest *request = [[BOXBookmarkUpdateRequest alloc] initWithBookmarkID:bookmarkID];
    request.queueManager = self.queueManager;
    [self prepareRequest:request];
    
    return request;
}

- (BOXBookmarkUpdateRequest *)bookmarkMoveRequestWithID:(NSString *)bookmarkID
                                    destinationFolderID:(NSString *)destinationFolderID
{
    BOXBookmarkUpdateRequest *request = [[BOXBookmarkUpdateRequest alloc] initWithBookmarkID:bookmarkID];
    request.parentID = destinationFolderID;
    request.queueManager = self.queueManager;
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
