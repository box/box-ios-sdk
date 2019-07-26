//
//  BOXClient+SharedLink.m
//  BoxContentSDK
//
//  Created by Rico Yao on 1/16/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXContentClient+SharedLink.h"
#import "BOXSharedItemRequest.h"
#import "BOXFolderShareRequest.h"
#import "BOXFolderUnshareRequest.h"
#import "BOXFileShareRequest.h"
#import "BOXFileUnshareRequest.h"
#import "BOXBookmarkShareRequest.h"
#import "BOXBookmarkUnshareRequest.h"

@implementation BOXContentClient (SharedLink)

- (BOXSharedItemRequest *)sharedItemInfoRequestWithSharedLinkURL:(NSURL *)URL password:(NSString *)password
{
    BOXSharedItemRequest *request = [[BOXSharedItemRequest alloc] initWithURL:URL password:password];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFolderShareRequest *)sharedLinkCreateRequestForFolderWithID:(NSString *)folderID
{
    BOXFolderShareRequest *request = [[BOXFolderShareRequest alloc] initWithFolderID:folderID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFolderUnshareRequest *)sharedLinkDeleteRequestForFolderWithID:(NSString *)folderID
{
    BOXFolderUnshareRequest *request = [[BOXFolderUnshareRequest alloc] initWithFolderID:folderID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileShareRequest *)sharedLinkCreateRequestForFileWithID:(NSString *)fileID
{
    BOXFileShareRequest *request = [[BOXFileShareRequest alloc] initWithFileID:fileID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileUnshareRequest *)sharedLinkDeleteRequestForFileWithID:(NSString *)fileID
{
    BOXFileUnshareRequest *request = [[BOXFileUnshareRequest alloc] initWithFileID:fileID];
    [self prepareRequest:request];
    
    return request;
}


- (BOXBookmarkShareRequest *)sharedLinkCreateRequestForBookmarkWithID:(NSString *)bookmarkID
{
    BOXBookmarkShareRequest *request = [[BOXBookmarkShareRequest alloc] initWithBookmarkID:bookmarkID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXBookmarkUnshareRequest *)sharedLinkDeleteRequestForBookmarkWithID:(NSString *)bookmarkID
{
    BOXBookmarkUnshareRequest *request = [[BOXBookmarkUnshareRequest alloc] initWithBookmarkID:bookmarkID];
    [self prepareRequest:request];
    
    return request;
}


@end
