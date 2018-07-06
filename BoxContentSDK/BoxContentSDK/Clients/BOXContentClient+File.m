//
//  BOXContentClient+File.m
//  BoxContentSDK
//
//  Created by Rico Yao on 1/16/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXContentClient_Private.h"
#import "BOXContentClient+File.h"
#import "BOXFileRequest.h"
#import "BOXFileCopyRequest.h"
#import "BOXFileDeleteRequest.h"
#import "BOXFileDownloadRequest.h"
#import "BOXFileUpdateRequest.h"
#import "BOXFileUploadRequest.h"
#import "BOXFileDownloadRequest.h"
#import "BOXTrashedFileRestoreRequest.h"
#import "BOXFileThumbnailRequest.h"
#import "BOXPreflightCheckRequest.h"
#import "BOXFileUploadNewVersionRequest.h"
#import "BOXFileRepresentationDownloadRequest.h"
#import "BOXRepresentationInfoRequest.h"

@implementation BOXContentClient (File)

- (BOXFileRequest *)fileInfoRequestWithID:(NSString *)fileID
{
    BOXFileRequest *request = [[BOXFileRequest alloc] initWithFileID:fileID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileRequest *)fileInfoRequestWithID:(NSString *)fileID
                              associateID:(NSString *)associateID
{
    BOXFileRequest *request = [[BOXFileRequest alloc] initWithFileID:fileID];
    request.associateID = associateID;
    request.requestDirectoryPath = self.tempCacheDir;
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileUpdateRequest *)fileRenameRequestWithID:(NSString *)fileID
                                          newName:(NSString *)newName
{
    BOXFileUpdateRequest *request = [[BOXFileUpdateRequest alloc] initWithFileID:fileID];
    request.fileName = newName;
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileUpdateRequest *)fileUpdateRequestWithID:(NSString *)fileID
{
    BOXFileUpdateRequest *request = [[BOXFileUpdateRequest alloc] initWithFileID:fileID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileUpdateRequest *)fileUpdateRequestWithID:(NSString *)fileID
                                      associateID:(NSString *)associateID {
    BOXFileUpdateRequest *request = [[BOXFileUpdateRequest alloc] initWithFileID:fileID];
    request.associateID = associateID;
    request.requestDirectoryPath = self.tempCacheDir;
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileUpdateRequest *)fileMoveRequestWithID:(NSString *)fileID
                            destinationFolderID:(NSString *)destinationFolderID
{
    BOXFileUpdateRequest *request = [[BOXFileUpdateRequest alloc] initWithFileID:fileID];
    request.parentID = destinationFolderID;
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileCopyRequest *)fileCopyRequestWithID:(NSString *)fileID
                          destinationFolderID:(NSString *)destinationFolderID
{
    BOXFileCopyRequest *request = [[BOXFileCopyRequest alloc] initWithFileID:fileID
                                                         destinationFolderID:destinationFolderID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileDeleteRequest *)fileDeleteRequestWithID:(NSString *)fileID
{
    BOXFileDeleteRequest *request = [[BOXFileDeleteRequest alloc] initWithFileID:fileID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileDeleteRequest *)fileDeleteRequestWithID:(NSString *)fileID
                                      associateID:(NSString *)associateID
{
    BOXFileDeleteRequest *request = [[BOXFileDeleteRequest alloc] initWithFileID:fileID];
    request.associateId = associateID;
    request.requestDirectoryPath = self.tempCacheDir;
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileDownloadRequest *)fileDownloadRequestWithID:(NSString *)fileID
                                      toLocalFilePath:(NSString *)localFilePath
{
    BOXFileDownloadRequest *request = [[BOXFileDownloadRequest alloc] initWithLocalDestination:localFilePath fileID:fileID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileDownloadRequest *)fileDownloadRequestWithID:(NSString *)fileID
                                      toLocalFilePath:(NSString *)localFilePath
                                          associateId:(NSString *)associateId
{
    BOXFileDownloadRequest *request = [[BOXFileDownloadRequest alloc] initWithLocalDestination:localFilePath fileID:fileID associateId:associateId];
    [self prepareRequest:request];

    return request;
}

- (BOXFileDownloadRequest *)fileDownloadRequestWithID:(NSString *)fileID
                                       toOutputStream:(NSOutputStream *)outputStream
{
    BOXFileDownloadRequest *request = [[BOXFileDownloadRequest alloc] initWithOutputStream:outputStream fileID:fileID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileThumbnailRequest *)fileThumbnailRequestWithID:(NSString *)fileID
                                                   size:(BOXThumbnailSize)size
{
    BOXFileThumbnailRequest *request = [[BOXFileThumbnailRequest alloc] initWithFileID:fileID size:size];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileThumbnailRequest *)fileThumbnailRequestWithID:(NSString *)fileID
                                                   size:(BOXThumbnailSize)size
                                        toLocalFilePath:(NSString *)localFilePath
{
    BOXFileThumbnailRequest *request = [[BOXFileThumbnailRequest alloc] initWithFileID:fileID size:size localDestination:localFilePath];
    [self prepareRequest:request];

    return request;
}

- (BOXFileUploadRequest *)fileUploadRequestToFolderWithID:(NSString *)folderID
                                        fromLocalFilePath:(NSString *)localFilePath
{
    return [self fileUploadRequestInBackgroundToFolderWithID:folderID fromLocalFilePath:localFilePath uploadMultipartCopyFilePath:nil associateId:nil];
}

- (BOXFileUploadRequest *)fileUploadRequestInBackgroundToFolderWithID:(NSString *)folderID
                                                    fromLocalFilePath:(NSString *)localFilePath
                                          uploadMultipartCopyFilePath:(NSString *)uploadMultipartCopyFilePath
                                                          associateId:(NSString *)associateId
{
    BOXFileUploadRequest *request = [[BOXFileUploadRequest alloc] initWithPath:localFilePath targetFolderID:folderID uploadMultipartCopyFilePath:uploadMultipartCopyFilePath associateId:associateId];
    [self prepareRequest:request];

    return request;
}

- (BOXFileUploadRequest *)fileUploadRequestToFolderWithID:(NSString *)folderID
                                                 fromData:(NSData *)data
                                                 fileName:(NSString *)fileName
{
    BOXFileUploadRequest *request = [[BOXFileUploadRequest alloc] initWithName:fileName targetFolderID:folderID data:data];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileUploadNewVersionRequest *)fileUploadNewVersionRequestWithID:(NSString *)fileID
                                                    fromLocalFilePath:(NSString *)localFilePath
{
    return [self fileUploadNewVersionRequestInBackgroundWithFileID:fileID fromLocalFilePath:localFilePath uploadMultipartCopyFilePath:nil associateId:nil];
}

- (BOXFileUploadNewVersionRequest *)fileUploadNewVersionRequestInBackgroundWithFileID:(NSString *)fileID
                                                                fromLocalFilePath:(NSString *)localFilePath
                                                      uploadMultipartCopyFilePath:(NSString *)uploadMultipartCopyFilePath
                                                                      associateId:(NSString *)associateId
{
    BOXFileUploadNewVersionRequest *request = [[BOXFileUploadNewVersionRequest alloc] initWithFileID:fileID localPath:localFilePath uploadMultipartCopyFilePath:uploadMultipartCopyFilePath associateId:associateId];
    [self prepareRequest:request];

    return request;
}

- (BOXFileUploadNewVersionRequest *)fileUploadNewVersionRequestWithID:(NSString *)fileID
                                                             fromData:(NSData *)data
{
    BOXFileUploadNewVersionRequest *request = [[BOXFileUploadNewVersionRequest alloc] initWithFileID:fileID data:data];
    [self prepareRequest:request];
    
    return request;
}

- (BOXPreflightCheckRequest *)fileUploadPreflightCheckRequestForNewFileInFolderWithID:(NSString *)folderID
                                                                                 name:(NSString *)fileName
                                                                                 size:(NSUInteger)fileSize
{
    BOXPreflightCheckRequest *request = [[BOXPreflightCheckRequest alloc] initWithFileName:fileName parentFolderID:folderID];
    request.fileSize = fileSize;
    [self prepareRequest:request];
    
    return request;
}

- (BOXPreflightCheckRequest *)fileUploadPreflightCheckRequestForNewFileVersionWithID:(NSString *)fileID
                                                                                name:(NSString *)fileName
                                                                                size:(NSUInteger)fileSize
{
    BOXPreflightCheckRequest *request = [[BOXPreflightCheckRequest alloc] initWithFileName:fileName fileID:fileID];
    request.fileSize = fileSize;
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileRequest *)trashedFileInfoRequestWithID:(NSString *)fileID
{
    BOXFileRequest *request = [[BOXFileRequest alloc] initWithFileID:fileID isTrashed:YES];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileRequest *)trashedFileInfoRequestWithID:(NSString *)fileID
                                     associateID:(NSString *)associateID
{
    BOXFileRequest *request = [[BOXFileRequest alloc] initWithFileID:fileID isTrashed:YES];
    request.associateID = associateID;
    request.requestDirectoryPath = self.tempCacheDir;
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileDeleteRequest *)trashedFileDeleteFromTrashRequestWithID:(NSString *)fileID
{
    BOXFileDeleteRequest *request = [[BOXFileDeleteRequest alloc] initWithFileID:fileID isTrashed:YES];
    [self prepareRequest:request];
    
    return request;
}


- (BOXFileDeleteRequest *)trashedFileDeleteFromTrashRequestWithID:(NSString *)fileID
                                                      associateID:(NSString *)associateID
{
    BOXFileDeleteRequest *request = [[BOXFileDeleteRequest alloc] initWithFileID:fileID isTrashed:YES];
    request.associateId = associateID;
    request.requestDirectoryPath = self.tempCacheDir;
    [self prepareRequest:request];
    
    return request;
}

- (BOXTrashedFileRestoreRequest *)trashedFileRestoreRequestWithID:(NSString *)fileID
{
    BOXTrashedFileRestoreRequest *request = [[BOXTrashedFileRestoreRequest alloc] initWithFileID:fileID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXTrashedFileRestoreRequest *)trashedFileRestoreRequestWithID:(NSString *)fileID
                                                      associateID:(NSString *)associateID
{
    BOXTrashedFileRestoreRequest *request = [[BOXTrashedFileRestoreRequest alloc] initWithFileID:fileID];
    request.associateId = associateID;
    request.requestDirectoryPath = self.tempCacheDir;
    [self prepareRequest:request];
    
    return request;
}

- (BOXFileRepresentationDownloadRequest *)fileRepresentationDownloadRequestWithID:(NSString *)fileID
                                                                  toLocalFilePath:(NSString *)localFilePath
                                                                   representation:(BOXRepresentation *)representation
{
    BOXFileRepresentationDownloadRequest *request = [[BOXFileRepresentationDownloadRequest alloc] initWithLocalDestination:localFilePath
                                                                                                                    fileID:fileID
                                                                                                            representation:representation];
    [self prepareRequest:request];
    return request;
}

- (BOXFileRepresentationDownloadRequest *)fileRepresentationDownloadRequestWithID:(NSString *)fileID
                                                                  toLocalFilePath:(NSString *)localFilePath
                                                                   representation:(BOXRepresentation *)representation
                                                                      associateID:(NSString *)associateID
{
    BOXFileRepresentationDownloadRequest *request = [[BOXFileRepresentationDownloadRequest alloc] initWithLocalDestination:localFilePath
                                                                                                                    fileID:fileID
                                                                                                            representation:representation
                                                                                                               associateId:associateID];
    [self prepareRequest:request];
    return request;
}

- (BOXFileRepresentationDownloadRequest *)fileRepresentationDownloadRequestWithID:(NSString *)fileID
                                                                   toOutputStream:(NSOutputStream *)outputStream
                                                                   representation:(BOXRepresentation *)representation
{
    BOXFileRepresentationDownloadRequest *request = [[BOXFileRepresentationDownloadRequest alloc] initWithOutputStream:outputStream
                                                                                                                fileID:fileID
                                                                                                        representation:representation];
    [self prepareRequest:request];
    return request;
}

- (BOXRepresentationInfoRequest *)fileRepresentationInfoRequestWithFileID:(NSString *)fileID
                                                           representation:(BOXRepresentation *)representation
{
    BOXRepresentationInfoRequest *request = [[BOXRepresentationInfoRequest alloc] initWithFileID:fileID
                                                                                  representation:representation];
    [self prepareRequest:request];
    return request;
}

@end
