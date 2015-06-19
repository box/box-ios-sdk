//
//  BOXContentClient+File.h
//  BoxContentSDK
//
//  Created by Rico Yao on 1/16/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXContentSDKConstants.h"
#import "BOXContentClient.h"

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
@class BOXFileThumbnailRequest;
@class ALAsset;
@class ALAssetsLibrary;

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
 *  Generate a request to upload an ALAsset to Box.
 *
 *  @param folderID      Folder ID of the folder to upload the file into.
 *  @param asset         ALAsset to be uploaded.
 *  @param assetsLibrary ALAssetsLibrary.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileUploadRequest *)fileUploadRequestToFolderWithID:(NSString *)folderID
                                              fromALAsset:(ALAsset *)asset
                                        withAssetsLibrary:(ALAssetsLibrary *)assetsLibrary;

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
 *  Generate a request to upload a new version of a file from ALAsset.
 *
 *  @param fileID        File ID.
 *  @param asset         ALAsset.
 *  @param assetsLibrary ALAssetsLibrary.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileUploadNewVersionRequest *)fileUploadNewVersionRequestWithID:(NSString *)fileID
                                                          fromALAsset:(ALAsset *)asset withAssetsLibrary:(ALAssetsLibrary *)assetsLibrary;

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
 *  Generate a request to retrieve information of a file in the trash.
 *
 *  @param fileID File ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileRequest *)trashedFileInfoRequestWithID:(NSString *)fileID;

/**
 *  Generate a request to permanently delete a file in the trash.
 *
 *  @param fileID File ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileDeleteRequest *)trashedFileDeleteFromTrashRequestWithID:(NSString *)fileID;

/**
 *  Generate a request to restore a file in the trash.
 *
 *  @param fileID File ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXTrashedFileRestoreRequest *)trashedFileRestoreRequestWithID:(NSString *)fileID;

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

@end
