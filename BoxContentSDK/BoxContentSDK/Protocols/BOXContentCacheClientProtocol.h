//
//  BOXContentCacheClientProtocol.h
//  BoxContentSDK
//
//  Created by Scott Liu on 10/13/15.
//  Copyright © 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BOXBookmarkRequest;
@class BOXBookmarkCopyRequest;
@class BOXBookmarkCreateRequest;
@class BOXBookmarkDeleteRequest;
@class BOXBookmarkCopyRequest;
@class BOXBookmarkUpdateRequest;

@class BOXFileRequest;
@class BOXFileCopyRequest;
@class BOXFileDeleteRequest;
@class BOXFileDownloadRequest;
@class BOXFileThumbnailRequest;
@class BOXFileShareRequest;
@class BOXFileUnshareRequest;
@class BOXFileUpdateRequest;
@class BOXFileVersionsRequest;
@class BOXFileVersionPromoteRequest;
@class BOXTrashedFileRestoreRequest;

@class BOXFolderRequest;
@class BOXFolderCreateRequest;
@class BOXFolderCopyRequest;
@class BOXFolderDeleteRequest;
@class BOXFolderUpdateRequest;
@class BOXFolderCollaborationsRequest;
@class BOXFolderPaginatedItemsRequest;
@class BOXFolderItemsRequest;
@class BOXTrashedFolderRestoreRequest;

@class BOXBookmarkCommentsRequest;
@class BOXCommentRequest;
@class BOXCommentAddRequest;
@class BOXCommentDeleteRequest;
@class BOXCommentUpdateRequest;
@class BOXFileCommentsRequest;

@class BOXSharedItemRequest;

@class BOXUserRequest;

@protocol BOXContentCacheClientProtocol <NSObject>

@optional

#pragma mark - Users

- (void)cacheUserRequest:(BOXUserRequest *)request
                withUser:(BOXUser *)user
                   error:(NSError *)error;

- (void)retrieveCacheForUserRequest:(BOXUserRequest *)request
                         completion:(BOXUserBlock)completionRequest;

#pragma mark - Shared Item

- (void)cacheSharedItemRequest:(BOXSharedItemRequest *)request
                      withItem:(BOXItem *)item
                         error:(NSError *)error;

- (void)retrieveCacheForSharedItemRequest:(BOXSharedItemRequest *)request
                               completion:(BOXItemBlock)completionBlock;

#pragma mark - Bookmarks

- (void)cacheBookmarkRequest:(BOXBookmarkRequest *)request
                withBookmark:(BOXBookmark *)bookmark
                       error:(NSError *)error;

- (void)retrieveCacheForBookmarkRequest:(BOXBookmarkRequest *)request
                             completion:(BOXBookmarkBlock)completionBlock;

- (void)cacheBookmarkCopyRequest:(BOXBookmarkCopyRequest *)request
                    withBookmark:(BOXBookmark *)bookmark
                           error:(NSError *)error;

- (void)cacheBookmarkCreateRequest:(BOXBookmarkCreateRequest *)request
                      withBookmark:(BOXBookmark *)bookmark
                             error:(NSError *)error;

- (void)cacheBookmarkDeleteRequest:(BOXBookmarkDeleteRequest *)request
                             error:(NSError *)error;

- (void)cacheBookmarkUpdateRequest:(BOXBookmarkUpdateRequest *)request
                      withBookmark:(BOXBookmark *)bookmark
                             error:(NSError *)error;

#pragma mark - Files

- (void)cacheFileRequest:(BOXFileRequest *)request
                withFile:(BOXFile *)file
                   error:(NSError *)error;

- (void)retrieveCacheForFileRequest:(BOXFileRequest *)request
                         completion:(BOXFileBlock)completionBlock;

- (void)cacheFileCopyRequest:(BOXFileCopyRequest *)request
                    withFile:(BOXFile *)file
                       error:(NSError *)error;

- (void)cacheFileDeleteRequest:(BOXFileDeleteRequest *)request
                         error:(NSError *)error;

- (void)cacheFileThumbnailRequest:(BOXFileThumbnailRequest *)request
                    withThumbnail:(UIImage *)thumbnail
                            error:(NSError *)error;

- (void)retrieveCacheForFileThumbnailRequest:(BOXFileThumbnailRequest *)request
                                  completion:(BOXImageBlock)completionBlock;

- (void)cacheFileUpdateRequest:(BOXFileUpdateRequest *)request
                      withFile:(BOXFile *)file
                         error:(NSError *)error;

- (void)cacheFileVersionsRequest:(BOXFileVersionsRequest *)request
                    withVersions:(NSArray *)versions
                           error:(NSError *)error;

- (void)retrieveCacheForFileVersionsRequest:(BOXFileVersionsRequest *)request
                                 completion:(BOXObjectsArrayCompletionBlock)completionBlock;

- (void)cacheFileVersionPromoteRequest:(BOXFileVersionPromoteRequest *)request
                           withVersion:(BOXFileVersion *)fileVersion
                                 error:(NSError *)error;

- (void)cacheTrashedFileRestoreRequest:(BOXTrashedFileRestoreRequest *)request
                              withFile:(BOXFile *)file
                                 error:(NSError *)error;

#pragma mark - Folders

- (void)cacheFolderRequest:(BOXFolderRequest *)request
                withFolder:(BOXFolder *)folder
                     error:(NSError *)error;

- (void)retrieveCacheForFolderRequest:(BOXFolderRequest *)request
                           completion:(BOXFolderBlock)completionBlock;

- (void)cacheFolderCreateRequest:(BOXFolderCreateRequest *)request
                      withFolder:(BOXFolder *)folder
                           error:(NSError *)error;

- (void)cacheFolderCopyRequest:(BOXFolderCopyRequest *)request
                    withFolder:(BOXFolder *)folder
                         error:(NSError *)error;

- (void)cacheFolderDeleteRequest:(BOXFolderDeleteRequest *)request
                           error:(NSError *)error;

- (void)cacheFolderUpdateRequest:(BOXFolderUpdateRequest *)request
                      withFolder:(BOXFolder *)folder
                           error:(NSError *)error;

- (void)cacheFolderCollaborationsRequest:(BOXFolderCollaborationsRequest *)request
                      withCollaborations:(NSArray *)collaborations
                                   error:(NSError *)error;

- (void)retrieveCacheForFolderCollaborationsRequest:(BOXFolderCollaborationsRequest *)request
                                         completion:(BOXCollaborationArrayCompletionBlock)completionBlock;

- (void)cacheFolderPaginatedItemsRequest:(BOXFolderPaginatedItemsRequest *)request
                               withItems:(NSArray *)items
                                   limit:(NSUInteger)limit
                                  offset:(NSUInteger)offset
                                   error:(NSError *)error;

- (void)retrieveCacheForPaginatedItemsRequest:(BOXFolderPaginatedItemsRequest *)request
                                   completion:(BOXItemArrayCompletionBlock)completionBlock;

- (void)cacheFolderItemsRequest:(BOXFolderItemsRequest *)request
                      withItems:(NSArray *)items
                          error:(NSError *)error;

- (void)retrieveCacheForFolderItemsRequest:(BOXFolderItemsRequest *)request
                                completion:(BOXItemsBlock)completionBlock;

- (void)cacheTrashedFolderRestoreRequest:(BOXTrashedFolderRestoreRequest *)request
                              withFolder:(BOXFolder *)folder
                                   error:(NSError *)error;

#pragma mark - Comments

- (void)cacheBookmarkCommentsRequest:(BOXBookmarkCommentsRequest *)request
                        withComments:(NSArray *)comments
                               error:(NSError *)error;

- (void)retrieveCacheForBookmarkCommentsRequest:(BOXBookmarkCommentsRequest *)request
                                     completion:(BOXObjectsArrayCompletionBlock)completionBlock;

- (void)cacheCommentRequest:(BOXCommentRequest *)request
                withComment:(BOXComment *)comment
                      error:(NSError *)error;

- (void)retrieveCacheForCommentRequest:(BOXCommentRequest *)request
                            completion:(BOXCommentBlock)completionBlock;

- (void)cacheAddCommentRequest:(BOXCommentAddRequest *)request
                   withComment:(BOXComment *)comment
                         error:(NSError *)error;

- (void)cacheDeleteCommentRequest:(BOXCommentDeleteRequest *)request
                            error:(NSError *)error;

- (void)cacheUpdateCommentRequest:(BOXCommentUpdateRequest *)request
                      withComment:(BOXComment *)comment
                            error:(NSError *)error;

- (void)cacheFileCommentsRequest:(BOXFileCommentsRequest *)request
                    withComments:(NSArray *)comments
                           error:(NSError *)error;

- (void)retrieveCacheForFileCommentsRequest:(BOXFileCommentsRequest *)request
                                 completion:(BOXObjectsArrayCompletionBlock)completionBlock;

@end
