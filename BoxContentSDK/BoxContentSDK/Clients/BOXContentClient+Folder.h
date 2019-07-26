//
//  BOXClient+Folder.h
//  BoxContentSDK
//
//  Created by Rico Yao on 1/16/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXContentClient.h"
#import "BOXContentSDKConstants.h"

@class BOXFolderRequest;
@class BOXFolderCopyRequest;
@class BOXFolderCreateRequest;
@class BOXFolderDeleteRequest;
@class BOXFolderUpdateRequest;
@class BOXItemArrayRequest;
@class BOXFolderItemsRequest;
@class BOXFolderPaginatedItemsRequest;
@class BOXTrashedFolderRestoreRequest;
@class BOXTrashedItemArrayRequest;

NS_ASSUME_NONNULL_BEGIN

@interface BOXContentClient (Folder)

/**
 *  Generate a request to retrieve information about a folder.
 *
 *  @param folderID Folder ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderRequest *)folderInfoRequestWithID:(NSString *)folderID;


/**
 *  Generate a background request to retrieve information about a folder.
 *
 *  @param folderID Folder ID.
 *  @param associateId Unique ID to associate with the operation to manage when in the background queue.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderRequest *)folderInfoRequestWithID:(NSString *)folderID
                                  associateId:(nullable NSString *)associateId;

/**
 *  Generate a request to create a new folder.
 *
 *  @param folderName     Name of folder to be created.
 *  @param parentFolderID The ID of the folder in which the new folder will be created.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderCreateRequest *)folderCreateRequestWithName:(NSString *)folderName
                                         parentFolderID:(NSString *)parentFolderID;

/**
 *  Generate a background request to create a new folder.
 *
 *  @param folderName     Name of folder to be created.
 *  @param parentFolderID The ID of the folder in which the new folder will be created.
 *  @param associateId Unique ID to associate with the operation to manage when in the background queue.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderCreateRequest *)folderCreateRequestWithName:(NSString *)folderName
                                         parentFolderID:(NSString *)parentFolderID
                                            associateId:(nullable NSString *)associateId;

/**
 *  Generate a request to rename a folder.
 *
 *  @param folderID Folder ID.
 *  @param newName  New folder name.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderUpdateRequest *)folderRenameRequestWithID:(NSString *)folderID
                                              newName:(NSString *)newName;

/**
 *  Generate a request to update properties of a folder. Configure properties of the BOXFolderUpdateRequest
 *  before executing it.
 *
 *  @param folderID Folder ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderUpdateRequest *)folderUpdateRequestWithID:(NSString *)folderID;

/**
 *  Generate a request to update properties of a folder. Configure properties of the BOXFolderUpdateRequest
 *  before executing it.
 *
 *  @param folderID Folder ID.
 *  @param associateID Unique ID to associate with the operation to manage when in the background queue.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderUpdateRequest *)folderUpdateRequestWithID:(NSString *)folderID
                                          associateID:(nullable NSString *)associateID;

/**
 *  Generate a request to move a folder into another folder.
 *
 *  @param folderID            Folder ID of the folder to be moved.
 *  @param destinationFolderID Folder ID of the destination folder.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderUpdateRequest *)folderMoveRequestWithID:(NSString *)folderID
                                destinationFolderID:(NSString *)destinationFolderID;

/**
 *  Generate a request to copy a folder into another folder.
 *
 *  @param folderID            Folder ID of the folder to be copied.
 *  @param destinationFolderID Folder ID of the destination folder.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderCopyRequest *)folderCopyRequestWithID:(NSString *)folderID
                              destinationFolderID:(NSString *)destinationFolderID;

/**
 *  Generate a request to delete a folder.
 *
 *  @param folderID Folder ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderDeleteRequest *)folderDeleteRequestWithID:(NSString *)folderID;

/**
 *  Generate a request to delete a folder.
 *
 *  @param folderID Folder ID.
 *  @param associateId   A unique ID used to recover background tasks. Providing an ID associated with a running background
 *  task will cause the request to reconnect to that task, rather than making a new one.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderDeleteRequest *)folderDeleteRequestWithID:(NSString *)folderID
                                          associateId:(nullable NSString *)associateId;

/**
 *  Generate a request to permanently delete a folder in the trash.
 *
 *  @param folderID Folder ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderDeleteRequest *)trashedFolderDeleteFromTrashRequestWithID:(NSString *)folderID;

/**
 *  Generate a request to permanently delete a folder in the trash.
 *
 *  @param folderID Folder ID.
 *  @param associateId   A unique ID used to recover background tasks. Providing an ID associated with a running background
 *  task will cause the request to reconnect to that task, rather than making a new one.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderDeleteRequest *)trashedFolderDeleteFromTrashRequestWithID:(NSString *)folderID
                                                          associateId:(nullable NSString *)associateId;

/**
 *  Generate a request to restore a folder from the trash.
 *
 *  @param folderID Folder ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXTrashedFolderRestoreRequest *)trashedFolderRestoreRequestWithID:(NSString *)folderID;

/**
 *  Generate a background request to restore a folder from the trash.
 *
 *  @param folderID Folder ID.
 *  @param associateID A unique ID used to recover background tasks. Providing an ID associated with a running background
 *  task will cause the request to reconnect to that task, rather than making a new one.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXTrashedFolderRestoreRequest *)trashedFolderRestoreRequestWithID:(NSString *)folderID
                                                          associateID:(nullable NSString *)associateID;

/**
 *  Generate a request to retrieve all items in the folder
 *
 *  @param folderID Folder ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderItemsRequest *)folderItemsRequestWithID:(NSString *)folderID;

/**
 *  Generate a request to retrieve the items in a folder.
 *
 *  @param folderID Folder ID.
 *  @param metadataTemplateKey  The template key for specific metadata template
 *  @param metadataScope    The scope of the metadata
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderItemsRequest *)folderItemsRequestWithID:(NSString *)folderID
                                metadataTemplateKey:(NSString *)metadataTemplateKey
                                      metadataScope:(BOXMetadataScope)metadataScope;

/**
 *  Generate a request to retrieve the items in a folder.
 *
 *  @param folderID Folder ID.
 *  @param range    An offset (NSRange location) and limit (NSRange limit). The maximum limit allowed is 1000.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderPaginatedItemsRequest *)folderPaginatedItemsRequestWithID:(NSString *)folderID
                                                              inRange:(NSRange)range;

/**
 *  Generate a request to retrieve the items in a folder.
 *
 *  @param folderID Folder ID.
 *  @param metadataTemplateKey  The template key for specific metadata template
 *  @param metadataScope    The scope of the metadata
 *  @param range    An offset (NSRange location) and limit (NSRange limit). The maximum limit allowed is 1000.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderPaginatedItemsRequest *)folderPaginatedItemsRequestWithID:(NSString *)folderID
                                                  metadataTemplateKey:(NSString *)metadataTemplateKey
                                                        metadataScope:(BOXMetadataScope)metadataScope
                                                              inRange:(NSRange)range;

/**
 *  Generate a request to retrieve the items in a folder in the trash.
 *
 *  @param range An offset (NSRange location) and limit (NSRange limit). The maximum limit allowed is 1000.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXTrashedItemArrayRequest *)trashedItemsRequestInRange:(NSRange)range;

/**
 *  Generate a request to retrieve information about a folder in the trash.
 *
 *  @param folderID Folder ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderRequest *)trashedFolderInfoRequestWithID:(NSString *)folderID;

/**
 *  Generate a background request to retrieve information about a folder in the trash.
 *
 *  @param folderID Folder ID.
 *  @param associateID   A unique ID used to recover background tasks. Providing an ID associated with a running background
 *  task will cause the request to reconnect to that task, rather than making a new one.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderRequest *)trashedFolderInfoRequestWithID:(NSString *)folderID
                                         associateID:(nullable NSString *)associateID;


@end

NS_ASSUME_NONNULL_END
