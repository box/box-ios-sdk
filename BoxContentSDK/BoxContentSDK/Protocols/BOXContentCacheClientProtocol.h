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
@class BOXBookmarkShareRequest;
@class BOXBookmarkUnshareRequest;

@class BOXFileRequest;
@class BOXFileCopyRequest;
@class BOXFileCollaborationsRequest;
@class BOXFileDeleteRequest;
@class BOXFileDownloadRequest;
@class BOXFileShareRequest;
@class BOXFileUnshareRequest;
@class BOXFileUpdateRequest;
@class BOXFileVersionsRequest;
@class BOXFileVersionRequest;
@class BOXFileVersionPromoteRequest;
@class BOXTrashedFileRestoreRequest;
@class BOXFileUploadRequest;
@class BOXFileUploadNewVersionRequest;

@class BOXFolderRequest;
@class BOXFolderCreateRequest;
@class BOXFolderCopyRequest;
@class BOXFolderDeleteRequest;
@class BOXFolderUpdateRequest;
@class BOXFolderCollaborationsRequest;
@class BOXFolderPaginatedItemsRequest;
@class BOXFolderItemsRequest;
@class BOXTrashedFolderRestoreRequest;
@class BOXFolderShareRequest;
@class BOXFolderUnshareRequest;

@class BOXBookmarkCommentsRequest;
@class BOXCommentRequest;
@class BOXCommentAddRequest;
@class BOXCommentDeleteRequest;
@class BOXCommentUpdateRequest;
@class BOXFileCommentsRequest;

@class BOXSharedItemRequest;

@class BOXUserRequest;
@class BOXUserAvatarRequest;

@class BOXCollaborationRequest;
@class BOXCollaborationCreateRequest;
@class BOXCollaborationPendingRequest;
@class BOXCollaborationRemoveRequest;
@class BOXCollaborationUpdateRequest;

@class BOXCollectionListRequest;
@class BOXItemSetCollectionsRequest;
@class BOXCollectionItemsRequest;
@class BOXCollectionFavoritesRequest;

@class BOXRecentItemsRequest;

@class BOXSearchRequest;

@protocol BOXContentCacheClientProtocol <NSObject>

@optional

#pragma mark - Users

- (void)cacheUserRequest:(BOXUserRequest *)request
                withUser:(BOXUser *)user
                   error:(NSError *)error;

- (void)retrieveCacheForUserRequest:(BOXUserRequest *)request
                         completion:(BOXUserBlock)completionRequest;

- (void)cacheUserAvatarRequest:(BOXUserAvatarRequest *)request
                    withAvatar:(UIImage *)avatar
                         error:(NSError *)error;

- (void)retrieveCacheForUserAvatarRequest:(BOXUserAvatarRequest *)request
                               completion:(BOXImageBlock)completionBlock;

#pragma mark - Shared Item

- (void)cacheSharedItemRequest:(BOXSharedItemRequest *)request
                      withItem:(BOXItem *)item
                         error:(NSError *)error;

- (void)retrieveCacheForSharedItemRequest:(BOXSharedItemRequest *)request
                               completion:(BOXItemBlock)completionBlock;

- (void)cacheFileShareRequest:(BOXFileShareRequest *)request
                     withFile:(BOXFile *)file
                        error:(NSError *)error;

- (void)cacheFileUnshareRequest:(BOXFileUnshareRequest *)request
                       withFile:(BOXFile *)file
                          error:(NSError *)error;

- (void)cacheFolderShareRequest:(BOXFolderShareRequest *)request
                     withFolder:(BOXFolder *)folder
                          error:(NSError *)error;

- (void)cacheFolderUnshareRequest:(BOXFolderUnshareRequest *)request
                       withFolder:(BOXFolder *)folder
                            error:(NSError *)error;

- (void)cacheBookmarkShareRequest:(BOXBookmarkShareRequest *)request
                     withBookmark:(BOXBookmark *)bookmark
                            error:(NSError *)error;

- (void)cacheBookmarkUnshareRequest:(BOXBookmarkUnshareRequest *)request
                       withBookmark:(BOXBookmark *)bookmark
                              error:(NSError *)error;

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

- (void)cacheBoxFile:(BOXFile *)file;

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

- (void)cacheFileUpdateRequest:(BOXFileUpdateRequest *)request
                      withFile:(BOXFile *)file
                         error:(NSError *)error;

- (void)cacheFileVersionsRequest:(BOXFileVersionsRequest *)request
                    withVersions:(NSArray *)versions
                           error:(NSError *)error;

- (void)retrieveCacheForFileVersionsRequest:(BOXFileVersionsRequest *)request
                                 completion:(BOXObjectsArrayCompletionBlock)completionBlock;

- (void)cacheFileVersionRequest:(BOXFileVersionRequest *)request
                    withVersion:(BOXFileVersion *)version
                           error:(NSError *)error;

- (void)retrieveCacheForFileVersionRequest:(BOXFileVersionRequest *)request
                                 completion:(BOXFileVersionBlock)completionBlock;

- (void)cacheFileVersionPromoteRequest:(BOXFileVersionPromoteRequest *)request
                           withVersion:(BOXFileVersion *)fileVersion
                                 error:(NSError *)error;

- (void)cacheTrashedFileDeleteRequest:(BOXFileDeleteRequest *)request
                                error:(NSError *)error;

- (void)cacheTrashedFileRestoreRequest:(BOXTrashedFileRestoreRequest *)request
                              withFile:(BOXFile *)file
                                 error:(NSError *)error;

- (void)cacheFileUploadRequest:(BOXFileUploadRequest *)request
                      withFile:(BOXFile *)file
                         error:(NSError *)error;

- (void)cacheFileUploadNewVersionRequest:(BOXFileUploadNewVersionRequest *)request
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

- (void)cacheFileCollaborationsRequest:(BOXFileCollaborationsRequest *)request
                    withCollaborations:(NSArray *)collaborations
                            nextMarker:(NSString *)nextMarker
                                 error:(NSError *)error;

- (void)retrieveCacheForFileCollaborationsRequest:(BOXFileCollaborationsRequest *)request
                                       completion:(BOXFileCollaborationArrayCompletionBlock)completionBlock;

- (void)cacheFolderPaginatedItemsRequest:(BOXFolderPaginatedItemsRequest *)request
                               withItems:(NSArray *)items
                              totalCount:(NSUInteger)totalCount
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

- (void)cacheTrashedFolderDeleteRequest:(BOXFolderDeleteRequest *)request
                                error:(NSError *)error;

- (void)hasFinishedFolderItemsRequest:(BOXFolderItemsRequest *)request;

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

#pragma mark - Collaborations

- (void)cacheCollaborationRequest:(BOXCollaborationRequest *)request
                withCollaboration:(BOXCollaboration *)collaboration
                            error:(NSError *)error;

- (void)retrieveCacheForCollaborationRequest:(BOXCollaborationRequest *)request
                                  completion:(BOXCollaborationBlock)completionBlock;

- (void)cacheCollaborationCreateRequest:(BOXCollaborationCreateRequest *)request
                      withCollaboration:(BOXCollaboration *)collaboration
                                  error:(NSError *)error;

- (void)cacheCollaborationPendingRequest:(BOXCollaborationPendingRequest *)request
                      withCollaborations:(NSArray *)collaborations
                                  error:(NSError *)error;

- (void)retrieveCacheForCollaborationPendingRequest:(BOXCollaborationPendingRequest *)request
                                         completion:(BOXCollaborationArrayCompletionBlock)completionBlock;

- (void)cacheCollaborationRemoveRequest:(BOXCollaborationRemoveRequest *)request
                                  error:(NSError *)error;

- (void)cacheCollaborationUpdateRequest:(BOXCollaborationUpdateRequest *)request
                      withCollaboration:(BOXCollaboration *)collaboration
                                  error:(NSError *)error;

#pragma mark - Collections

- (void)cacheCollectionListRequest:(BOXCollectionListRequest *)request
                   withCollections:(NSArray *)collections
                             error:(NSError *)error;

- (void)retrieveCacheForCollectionListRequest:(BOXCollectionListRequest *)request
                                   completion:(BOXCollectionArrayBlock)completionBlock;

- (void)cacheItemSetCollectionsRequest:(BOXItemSetCollectionsRequest *)request
                       withUpdatedItem:(BOXItem *)item
                                 error:(NSError *)error;

- (void)cacheCollectionItemsRequest:(BOXCollectionItemsRequest *)request
                          withItems:(NSArray *)items
                              error:(NSError *)error;

- (void)retrieveCacheForCollectionItemsRequest:(BOXCollectionItemsRequest *)request
                                    completion:(BOXItemArrayCompletionBlock)completionBlock;

- (void)cacheFavoriteCollectionRequest:(BOXCollectionFavoritesRequest *)request
                        withCollection:(BOXCollection *)collection
                                 error:(NSError *)error;

- (void)retrieveCacheForFavoriteCollectionRequest:(BOXCollectionFavoritesRequest *)request
                                  completionBlock:(BOXCollectionBlock)completionBlock;

#pragma mark - Recent Items

- (void)cacheRecentItemsRequest:(BOXRecentItemsRequest *)request
                withRecentItems:(NSArray *)items
                          error:(NSError *)error;

- (void)retrieveCacheForRecentItemsRequest:(BOXRecentItemsRequest *)request
                           completionBlock:(BOXRecentItemsBlock)completionBLock;

#pragma mark - Search

- (void)cacheSearchRequest:(BOXSearchRequest *)request
                 withItems:(NSArray *)items
                     error:(NSError *)error;

- (void)retrieveCacheForSearchRequest:(BOXSearchRequest *)request
                      completionBlock:(BOXItemArrayCompletionBlock)completionBlock;

@end
