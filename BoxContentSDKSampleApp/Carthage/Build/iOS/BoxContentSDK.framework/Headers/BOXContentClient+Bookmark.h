//
//  BOXClient+Bookmark.h
//  BoxContentSDK
//
//  Created by Rico Yao on 1/16/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXContentClient.h"

@class BOXBookmarkRequest;
@class BOXBookmarkCreateRequest;
@class BOXBookmarkUpdateRequest;
@class BOXBookmarkCopyRequest;
@class BOXBookmarkUpdateRequest;
@class BOXBookmarkDeleteRequest;
@class BOXTrashedBookmarkRestoreRequest;

@interface BOXContentClient (Bookmark)

/**
 *  Generate a request to retrieve information about a bookmark.
 *
 *  @param bookmarkID Bookmark ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXBookmarkRequest *)bookmarkInfoRequestWithID:(NSString *)bookmarkID;

/**
 *  Generate a request to rename a bookmark.
 *
 *  @param bookmarkID Bookmark ID.
 *  @param newName    New Bookmark name.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXBookmarkUpdateRequest *)bookmarkRenameRequestWithID:(NSString *)bookmarkID
                                                  newName:(NSString *)newName;

/**
 *  Generate a request to update properties of a bookmark. Update properties of the BOXBookmarkUpdateRequest
 *  before executing it.
 *
 *  @param bookmarkID Bookmark ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXBookmarkUpdateRequest *)bookmarkUpdateRequestWithID:(NSString *)bookmarkID;

/**
 *  Generate a request to move a bookmark into a folder.
 *
 *  @param bookmarkID          Bookmark ID.
 *  @param destinationFolderID Destination Folder ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXBookmarkUpdateRequest *)bookmarkMoveRequestWithID:(NSString *)bookmarkID
                                    destinationFolderID:(NSString *)destinationFolderID;

/**
 *  Generate a request to create a new Bookmark.
 *
 *  @param folderID Folder ID.
 *  @param URL      URL.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXBookmarkCreateRequest *)bookmarkCreateRequestInFolderID:(NSString *)folderID
                                                          URL:(NSURL *)URL;

/**
 *  Generate a request to copy a bookmark into a folder.
 *
 *  @param bookmarkID          Bookmark ID.
 *  @param destinationFolderID Destination Folder ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXBookmarkCopyRequest *)bookmarkCopyRequestWithID:(NSString *)bookmarkID
                                  destinationFolderID:(NSString *)destinationFolderID;

/**
 *  Generate a request to delete a bookmark.
 *
 *  @param bookmarkID Bookmark ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXBookmarkDeleteRequest *)bookmarkDeleteRequestWithID:(NSString *)bookmarkID;

/**
 *  Generate a request to permanently delete a bookmark from the trash.
 *
 *  @param bookmarkID Bookmark ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXBookmarkDeleteRequest *)trashedBookmarkDeleteFromTrashRequestWithID:(NSString *)bookmarkID;

@end
