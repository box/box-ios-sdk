//
//  BOXContentClient+File.h
//  BoxContentSDK
//
//  Created by Rico Yao on 1/16/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXContentSDKConstants.h"
#import "BOXContentClient.h"
#import "BOXAPIOperation.h"

@class BOXFileRequest;
@class BOXFileCopyRequest;
@class BOXFileDeleteRequest;
@class BOXFileDownloadRequest;
@class BOXFileThumbnailRequest;
@class BOXFileUpdateRequest;
@class BOXFileUploadRequest;
@class BOXFileUploadNewVersionRequest;
@class BOXTrashedFileRestoreRequest;
@class BOXPreflightCheckRequest;
@class BOXFileRepresentationDownloadRequest;
@class BOXRepresentation;
@class BOXRepresentationInfoRequest;

@interface BOXContentClient (File)

/**
 *  Generate a request to retrieve information about a file.
 *
 *  @param fileID File ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileRequest *)fileInfoRequestWithID:(NSString *)fileID;

/**
 *  Generate a background request to retrieve information about a file.
 *
 *  @param fileID File ID.
 *  @param associateID Unique ID to associate with the operation to manage when in the background queue.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileRequest *)fileInfoRequestWithID:(NSString *)fileID
                              associateID:(NSString *)associateID;

/**
 *  Generate a request to rename a file.
 *
 *  @param fileID  File ID.
 *  @param newName New name for the file.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileUpdateRequest *)fileRenameRequestWithID:(NSString *)fileID
                                          newName:(NSString *)newName;

/**
 *  Generate a request to update properties of a file. Set properties on the BOXFileUpdateRequest
 *  before executing it.
 *
 *  @param fileID File ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileUpdateRequest *)fileUpdateRequestWithID:(NSString *)fileID;

/**
 *  Generate a request to update properties of a file. Set properties on the BOXFileUpdateRequest
 *  before executing it.
 *
 *  @param fileID File ID.
 *  @param associateID   an Id to associate with this background upload task to reconnect to if needed
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileUpdateRequest *)fileUpdateRequestWithID:(NSString *)fileID
                                      associateID:(NSString *)associateID;

/**
 *  Generate a request to move a file to a folder.
 *
 *  @param fileID              File ID.
 *  @param destinationFolderID Folder ID of the folder that the file will be moved into.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileUpdateRequest *)fileMoveRequestWithID:(NSString *)fileID
                            destinationFolderID:(NSString *)destinationFolderID;

/**
 *  Generate a request to copy a file to a folder.
 *
 *  @param fileID              File ID.
 *  @param destinationFolderID Folder ID of the folder that the file will be copied into.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileCopyRequest *)fileCopyRequestWithID:(NSString *)fileID
                          destinationFolderID:(NSString *)destinationFolderID;

/**
 *  Generate a request to delete a file.
 *
 *  @param fileID File ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileDeleteRequest *)fileDeleteRequestWithID:(NSString *)fileID;

/**
 *  Generate a background request to delete a file.
 *
 *  @param fileID File ID.
 *  @param associateID   A unique ID used to recover background tasks. Providing an ID associated with a running background
 *  task will cause the request to reconnect to that task, rather than making a new one.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileDeleteRequest *)fileDeleteRequestWithID:(NSString *)fileID
                                      associateID:(NSString *)associateID;

/**
 *  Generate a request to upload a local file to Box.
 *
 *  @param folderID      Folder ID of the folder to upload the file into.
 *  @param localFilePath Path to local file to be uploaded.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileUploadRequest *)fileUploadRequestToFolderWithID:(NSString *)folderID
                                        fromLocalFilePath:(NSString *)localFilePath;
/**
 *  Generate a request to upload a local file to Box in background unless uploadMultipartCopyFilePath is not provided
 *
 *  @param folderID      Folder ID of the folder to upload the file into.
 *  @param localFilePath Path to local file to be uploaded.
 *  @param uploadMultipartCopyFilePath Path to write the multi-part formatted temporary file for upload in the background
 *  @param associateId   an Id to associate with this background upload task to reconnect to if needed
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileUploadRequest *)fileUploadRequestInBackgroundToFolderWithID:(NSString *)folderID
                                                    fromLocalFilePath:(NSString *)localFilePath
                                          uploadMultipartCopyFilePath:(NSString *)uploadMultipartCopyFilePath
                                                          associateId:(NSString *)associateId;

/**
 *  Generate a request to upload a byte-buffer to Box.
 *
 *  @param folderID Folder ID of the folder to upload the file into.
 *  @param data     File contents to be uploaded.
 *  @param fileName Name of the file to be uploaded.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileUploadRequest *)fileUploadRequestToFolderWithID:(NSString *)folderID
                                                 fromData:(NSData *)data
                                                 fileName:(NSString *)fileName;

/**
 *  Generate a request to upload a new version of a file from a local file.
 *
 *  @param fileID        File ID.
 *  @param localFilePath Path to local file.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileUploadNewVersionRequest *)fileUploadNewVersionRequestWithID:(NSString *)fileID
                                                    fromLocalFilePath:(NSString *)localFilePath;

/**
 *  Generate a request to upload a new version of a file from a local file in the background
 *  (continue running even if app terminates) unless uploadMultipartCopyFilePath is not provided.
 *
 *  @param fileID        File ID.
 *  @param localFilePath Path to local file to be uploaded.
 *  @param uploadMultipartCopyFilePath Path to write the multi-part formatted temporary file for upload in the background
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileUploadNewVersionRequest *)fileUploadNewVersionRequestInBackgroundWithFileID:(NSString *)fileID
                                                                    fromLocalFilePath:(NSString *)localFilePath
                                                          uploadMultipartCopyFilePath:(NSString *)uploadMultipartCopyFilePath
                                                                          associateId:(NSString *)associateId;

/**
 *  Generate a request to upload a new version of a file from a byte-buffer.
 *
 *  @param fileID File ID.
 *  @param data   Data to be uploaded.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileUploadNewVersionRequest *)fileUploadNewVersionRequestWithID:(NSString *)fileID
                                                             fromData:(NSData *)data;

/**
 *  Generate a request to download a file to a local filepath.
 *
 *  @param fileID        File ID.
 *  @param localFilePath Local filepath.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileDownloadRequest *)fileDownloadRequestWithID:(NSString *)fileID
                                      toLocalFilePath:(NSString *)localFilePath;

/**
 *  Generate a request to download a file to a local filepath with an existing downloadTask
 *
 *  @param fileID        File ID.
 *  @param localFilePath Path to local file.
 *  @param associateId   an Id to associate with this background upload task to reconnect to if needed
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileDownloadRequest *)fileDownloadRequestWithID:(NSString *)fileID
                                      toLocalFilePath:(NSString *)localFilePath
                                          associateId:(NSString *)associateId;

/**
 *  Generate a request to download a file to an outputstream.
 *
 *  @param fileID       File ID.
 *  @param outputStream Outputstream to which downloaded file data will be written.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileDownloadRequest *)fileDownloadRequestWithID:(NSString *)fileID
                                       toOutputStream:(NSOutputStream *)outputStream;

/**
 *  Generate a request to retrieve the thumbnail of a file.
 *
 *  @param fileID File ID.
 *  @param size   Thumbnail size.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileThumbnailRequest *)fileThumbnailRequestWithID:(NSString *)fileID
                                                   size:(BOXThumbnailSize)size;

/**
 *  Generate a request to retrieve the thumbnail of a file.
 *
 *  @param fileID           File ID.
 *  @param size             Thumbnail size.
 *  @param localFilePath    Thumbnail download destination path.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileThumbnailRequest *)fileThumbnailRequestWithID:(NSString *)fileID
                                                   size:(BOXThumbnailSize)size
                                        toLocalFilePath:(NSString *)localFilePath;

/**
 *  Generate a request to retrieve information about a file in the trash.
 *
 *  @param fileID File ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileRequest *)trashedFileInfoRequestWithID:(NSString *)fileID;

/**
 *  Generate a background request to retrieve information about a file in the trash.
 *
 *  @param fileID File ID.
 *  @param associateID Unique ID to associate with the operation to manage when in the background queue.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileRequest *)trashedFileInfoRequestWithID:(NSString *)fileID
                                     associateID:(NSString *)associateID;

/**
 *  Generate a request to permanently delete a file in the trash.
 *
 *  @param fileID File ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileDeleteRequest *)trashedFileDeleteFromTrashRequestWithID:(NSString *)fileID;

/**
 *  Generate a background request to permanently delete a file in the trash.
 *
 *  @param fileID File ID.
 *  @param associateID A unique ID used to recover background tasks. Providing an ID associated with a running background
 *  task will cause the request to reconnect to that task, rather than making a new one.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileDeleteRequest *)trashedFileDeleteFromTrashRequestWithID:(NSString *)fileID
                                                      associateID:(NSString *)associateID;

/**
 *  Generate a request to restore a file in the trash.
 *
 *  @param fileID File ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXTrashedFileRestoreRequest *)trashedFileRestoreRequestWithID:(NSString *)fileID;


/**
 *  Generate a background request to restore a file in the trash.
 *
 *  @param fileID File ID.
 *  @param associateID A unique ID used to recover background tasks. Providing an ID associated with a running background
 *  task will cause the request to reconnect to that task, rather than making a new one.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXTrashedFileRestoreRequest *)trashedFileRestoreRequestWithID:(NSString *)fileID
                                                      associateID:(NSString *)associateID;

/**
 *  Generate a request to do a "preflight" check to determine whether an upload is possible. You can use this
 *  before doing the actual file upload to check for conditions such as permissions problems, account size quota
 *  restrictions, etc.
 *
 *  @param folderID Folder ID.
 *  @param fileName File name.
 *  @param fileSize File size.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXPreflightCheckRequest *)fileUploadPreflightCheckRequestForNewFileInFolderWithID:(NSString *)folderID
                                                                                 name:(NSString *)fileName
                                                                                 size:(NSUInteger)fileSize;

/**
 *  Generate a request to do a "preflight" check to determine whether replacing a file with a new version is possible. You can use this
 *  before doing the actual file upload to check for conditions such as permissions problems, account size quota
 *  restrictions, etc.
 *
 *  @param fileID   File ID.
 *  @param fileName File name.
 *  @param fileSize File size.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXPreflightCheckRequest *)fileUploadPreflightCheckRequestForNewFileVersionWithID:(NSString *)fileID
                                                                                name:(NSString *)fileName
                                                                                size:(NSUInteger)fileSize;

/**
 *  Generate a request to download a given representation of a file to a local filepath.
 *
 *  @param fileID          File ID.
 *  @param localFilePath   Local filepath.
 *  @param representation  BOXRepresentation to be downloaded
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileRepresentationDownloadRequest *)fileRepresentationDownloadRequestWithID:(NSString *)fileID
                                                                  toLocalFilePath:(NSString *)localFilePath
                                                                   representation:(BOXRepresentation *)representation;

/**
 *  Generate a request to download a given representation of a file to a local filepath.
 *
 *  @param fileID          File ID.
 *  @param localFilePath   Local filepath.
 *  @param representation  BOXRepresentation to be downloaded
 *  @param associateID A unique ID used to recover background tasks. Providing an ID associated with a running background
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileRepresentationDownloadRequest *)fileRepresentationDownloadRequestWithID:(NSString *)fileID
                                                                  toLocalFilePath:(NSString *)localFilePath
                                                                   representation:(BOXRepresentation *)representation
                                                                      associateID:(NSString *)associateID;

/**
 *  Generate a request to download a given representation file to an outputstream.
 *
 *  @param fileID          File ID.
 *  @param outputStream    Outputstream to which downloaded file data will be written.
 *  @param representation  BOXRepresentation to be downloaded
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileRepresentationDownloadRequest *)fileRepresentationDownloadRequestWithID:(NSString *)fileID
                                                                   toOutputStream:(NSOutputStream *)outputStream
                                                                   representation:(BOXRepresentation *)representation;
/**
 *  Generate a request to get representation information for a file
 *
 *  @param fileID          File ID.
 *  @param representation  BOXRepresentation to get information on
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXRepresentationInfoRequest *)fileRepresentationInfoRequestWithFileID:(NSString *)fileID
                                                           representation:(BOXRepresentation *)representation;

@end
