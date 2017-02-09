//
//  BOXClient+SharedLink.h
//  BoxContentSDK
//
//  Created by Rico Yao on 1/16/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXContentClient_Private.h"

@class BOXSharedItemRequest;
@class BOXFolderShareRequest;
@class BOXFolderUnshareRequest;
@class BOXFileShareRequest;
@class BOXFileUnshareRequest;
@class BOXBookmarkShareRequest;
@class BOXBookmarkUnshareRequest;

@interface BOXContentClient (SharedLink)

/**
 *  Generate a request to retrieve the underlying Box Item (file, folder or bookmark) for a Share Link URL
 *
 *  @param URL      Shared link URL
 *  @param password Shared link password. Set to nil if there is no password for the link.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXSharedItemRequest *)sharedItemInfoRequestWithSharedLinkURL:(NSURL *)URL password:(NSString *)password;

/**
 *  Generate a request to create a shared link for a folder.
 *
 *  @param folderID Folder ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderShareRequest *)sharedLinkCreateRequestForFolderWithID:(NSString *)folderID;

/**
 *  Generate a request to delete the shared link of a folder.
 *
 *  @param folderID Folder ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderUnshareRequest *)sharedLinkDeleteRequestForFolderWithID:(NSString *)folderID;

/**
 *  Generate a request to create a shared link for a file.
 *
 *  @param fileID File ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileShareRequest *)sharedLinkCreateRequestForFileWithID:(NSString *)fileID;

/**
 *  Generate a request to delete a shared link of a file.
 *
 *  @param fileID File ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileUnshareRequest *)sharedLinkDeleteRequestForFileWithID:(NSString *)fileID;

/**
 *  Generate a request to create a shared link for a bookmark.
 *
 *  @param bookmarkID Bookmark ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXBookmarkShareRequest *)sharedLinkCreateRequestForBookmarkWithID:(NSString *)bookmarkID;

/**
 *  Generate a request to delete the shared link of a bookmark.
 *
 *  @param bookmarkID Bookmark ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXBookmarkUnshareRequest *)sharedLinkDeleteRequestForBookmarkWithID:(NSString *)bookmarkID;

@end
