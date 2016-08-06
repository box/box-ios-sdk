//
//  BOXContentSDK.h
//  BoxContentSDK
//
//  Created on 2/19/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

@import Foundation;

// constants and logging
#import <BoxContentSDK/BOXContentSDKConstants.h>
#import <BoxContentSDK/BOXContentSDKErrors.h>
#import <BoxContentSDK/BOXLog.h>

// Client
#import <BoxContentSDK/BOXContentClient.h>

#import <BoxContentSDK/BOXContentClient+Authentication.h>
#import <BoxContentSDK/BOXContentClient+Bookmark.h>
#import <BoxContentSDK/BOXContentClient+Collaboration.h>
#import <BoxContentSDK/BOXContentClient+Collection.h>
#import <BoxContentSDK/BOXContentClient+Comment.h>
#import <BoxContentSDK/BOXContentClient+Event.h>
#import <BoxContentSDK/BOXContentClient+File.h>
#import <BoxContentSDK/BOXContentClient+FileVersion.h>
#import <BoxContentSDK/BOXContentClient+Folder.h>
#import <BoxContentSDK/BOXContentClient+Metadata.h>
#import <BoxContentSDK/BOXContentClient+Search.h>
#import <BoxContentSDK/BOXContentClient+SharedLink.h>
#import <BoxContentSDK/BOXContentClient+User.h>

// Content Cache
#import <BoxContentSDK/BOXContentCacheClientProtocol.h>

// Session
#import <BoxContentSDK/BOXAbstractSession.h>
#import <BoxContentSDK/BOXAppUserSession.h>
#import <BoxContentSDK/BOXAuthorizationViewController.h>
#import <BoxContentSDK/BOXOAuth2Session.h>
#import <BoxContentSDK/BOXParallelOAuth2Session.h>

// AppToApp
//#import <BoxContentSDK/BOXAppToAppAnnotationBuilder.h>
//#import <BoxContentSDK/BOXAppToAppAnnotationKeys.h>
//#import <BoxContentSDK/BOXAppToAppApplication.h>
//#import <BoxContentSDK/BOXAppToAppFileMetadata.h>
//#import <BoxContentSDK/BOXAppToAppMessage.h>

// Requests
#import <BoxContentSDK/BOXBookmarkCommentsRequest.h>
#import <BoxContentSDK/BOXBookmarkCopyRequest.h>
#import <BoxContentSDK/BOXBookmarkCreateRequest.h>
#import <BoxContentSDK/BOXBookmarkDeleteRequest.h>
#import <BoxContentSDK/BOXBookmarkRequest.h>
#import <BoxContentSDK/BOXBookmarkShareRequest.h>
#import <BoxContentSDK/BOXBookmarkUnshareRequest.h>
#import <BoxContentSDK/BOXBookmarkUpdateRequest.h>
#import <BoxContentSDK/BOXCollaborationCreateRequest.h>
#import <BoxContentSDK/BOXCollaborationPendingRequest.h>
#import <BoxContentSDK/BOXCollaborationRemoveRequest.h>
#import <BoxContentSDK/BOXCollaborationRequest.h>
#import <BoxContentSDK/BOXCollaborationUpdateRequest.h>
#import <BoxContentSDK/BOXCollectionFavoritesRequest.h>
#import <BoxContentSDK/BOXCollectionItemsRequest.h>
#import <BoxContentSDK/BOXCollectionListRequest.h>
#import <BoxContentSDK/BOXCommentAddRequest.h>
#import <BoxContentSDK/BOXCommentDeleteRequest.h>
#import <BoxContentSDK/BOXCommentRequest.h>
#import <BoxContentSDK/BOXCommentUpdateRequest.h>
#import <BoxContentSDK/BOXEventsAdminLogsRequest.h>
#import <BoxContentSDK/BOXEventsRequest.h>
#import <BoxContentSDK/BOXFileCommentsRequest.h>
#import <BoxContentSDK/BOXFileCopyRequest.h>
#import <BoxContentSDK/BOXFileDeleteRequest.h>
#import <BoxContentSDK/BOXFileDownloadRequest.h>
#import <BoxContentSDK/BOXFileRequest.h>
#import <BoxContentSDK/BOXFileShareRequest.h>
#import <BoxContentSDK/BOXFileThumbnailRequest.h>
#import <BoxContentSDK/BOXFileUnshareRequest.h>
#import <BoxContentSDK/BOXFileUpdateRequest.h>
#import <BoxContentSDK/BOXFileUploadNewVersionRequest.h>
#import <BoxContentSDK/BOXFileUploadRequest.h>
#import <BoxContentSDK/BOXFileVersionPromoteRequest.h>
#import <BoxContentSDK/BOXFileVersionsRequest.h>
#import <BoxContentSDK/BOXFolderCollaborationsRequest.h>
#import <BoxContentSDK/BOXFolderCopyRequest.h>
#import <BoxContentSDK/BOXFolderCreateRequest.h>
#import <BoxContentSDK/BOXFolderDeleteRequest.h>
#import <BoxContentSDK/BOXFolderItemsRequest.h>
#import <BoxContentSDK/BOXFolderPaginatedItemsRequest.h>
#import <BoxContentSDK/BOXFolderRequest.h>
#import <BoxContentSDK/BOXFolderShareRequest.h>
#import <BoxContentSDK/BOXFolderUnshareRequest.h>
#import <BoxContentSDK/BOXFolderUpdateRequest.h>
#import <BoxContentSDK/BOXItemSetCollectionsRequest.h>
#import <BoxContentSDK/BOXItemShareRequest.h>
#import <BoxContentSDK/BOXMetadataCreateRequest.h>
#import <BoxContentSDK/BOXMetadataDeleteRequest.h>
#import <BoxContentSDK/BOXMetadataRequest.h>
#import <BoxContentSDK/BOXMetadataTemplateRequest.h>
#import <BoxContentSDK/BOXMetadataUpdateRequest.h>
#import <BoxContentSDK/BOXPreflightCheckRequest.h>
#import <BoxContentSDK/BOXRequest.h>
#import <BoxContentSDK/BOXSearchRequest.h>
#import <BoxContentSDK/BOXSharedItemRequest.h>
#import <BoxContentSDK/BOXTrashedFileRestoreRequest.h>
#import <BoxContentSDK/BOXTrashedFolderRestoreRequest.h>
#import <BoxContentSDK/BOXTrashedItemArrayRequest.h>
#import <BoxContentSDK/BOXUserRequest.h>

// API Operation queues
#import <BoxContentSDK/BOXAPIAccessTokenDelegate.h>
#import <BoxContentSDK/BOXAPIQueueManager.h>
#import <BoxContentSDK/BOXParallelAPIQueueManager.h>
#import <BoxContentSDK/BOXSerialAPIQueueManager.h>

// API Operations
#import <BoxContentSDK/BOXAPIAppUsersAuthOperation.h>
#import <BoxContentSDK/BOXAPIAuthenticatedOperation.h>
#import <BoxContentSDK/BOXAPIDataOperation.h>
#import <BoxContentSDK/BOXAPIJSONOperation.h>
#import <BoxContentSDK/BOXAPIJSONPatchOperation.h>
#import <BoxContentSDK/BOXAPIMultipartToJSONOperation.h>
#import <BoxContentSDK/BOXAPIOAuth2ToJSONOperation.h>
#import <BoxContentSDK/BOXAPIOperation.h>

// API models
#import <BoxContentSDK/BOXAssetInputStream.h>
#import <BoxContentSDK/BOXBookmark.h>
#import <BoxContentSDK/BOXCollaboration.h>
#import <BoxContentSDK/BOXCollection.h>
#import <BoxContentSDK/BOXComment.h>
#import <BoxContentSDK/BOXEvent.h>
#import <BoxContentSDK/BOXFile.h>
#import <BoxContentSDK/BOXFileLock.h>
#import <BoxContentSDK/BOXFileVersion.h>
#import <BoxContentSDK/BOXFolder.h>
#import <BoxContentSDK/BOXGroup.h>
#import <BoxContentSDK/BOXItem.h>
#import <BoxContentSDK/BOXMetadata.h>
#import <BoxContentSDK/BOXMetadataKeyValue.h>
#import <BoxContentSDK/BOXMetadataTemplate.h>
#import <BoxContentSDK/BOXMetadataTemplateField.h>
#import <BoxContentSDK/BOXMetadataUpdateTask.h>
#import <BoxContentSDK/BOXSharedLink.h>
#import <BoxContentSDK/BOXUser.h>

