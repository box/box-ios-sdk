//
//  BOXClient+Folder.m
//  BoxContentSDK
//
//  Created by Rico Yao on 1/16/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <BoxContentSDK/BOXFolderCollaborationsRequest.h>
#import <BoxContentSDK/BOXFolderCopyRequest.h>
#import <BoxContentSDK/BOXFolderCreateRequest.h>
#import <BoxContentSDK/BOXFolderDeleteRequest.h>
#import <BoxContentSDK/BOXFolderItemsRequest.h>
#import <BoxContentSDK/BOXFolderPaginatedItemsRequest.h>
#import <BoxContentSDK/BOXFolderRequest.h>
#import <BoxContentSDK/BOXFolderUpdateRequest.h>
#import <BoxContentSDK/BOXTrashedFolderRestoreRequest.h>
#import <BoxContentSDK/BOXTrashedItemArrayRequest.h>

#import <BoxContentSDK/BOXContentClient+Folder.h>

#import "BOXContentClient_Private.h"

@implementation BOXContentClient (Folder)

- (BOXFolderRequest *)folderInfoRequestWithID:(NSString *)folderID
{
    BOXFolderRequest *request = nil;
    request = [[BOXFolderRequest alloc] initWithFolderID:folderID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFolderCreateRequest *)folderCreateRequestWithName:(NSString *)folderName
                                         parentFolderID:(NSString *)parentFolderID
{
    BOXFolderCreateRequest *request = [[BOXFolderCreateRequest alloc] initWithFolderName:folderName parentFolderID:parentFolderID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFolderUpdateRequest *)folderRenameRequestWithID:(NSString *)folderID
                                              newName:(NSString *)newName
{
    BOXFolderUpdateRequest *request = [[BOXFolderUpdateRequest alloc] initWithFolderID:folderID];
    request.folderName = newName;
    [self prepareRequest:request];
    
    return request;
}

- (BOXFolderUpdateRequest *)folderUpdateRequestWithID:(NSString *)folderID
{
    BOXFolderUpdateRequest *request = [[BOXFolderUpdateRequest alloc] initWithFolderID:folderID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFolderUpdateRequest *)folderMoveRequestWithID:(NSString *)folderID
                                destinationFolderID:(NSString *)destinationFolderID
{
    BOXFolderUpdateRequest *request = [[BOXFolderUpdateRequest alloc] initWithFolderID:folderID];
    request.parentID = destinationFolderID;
    [self prepareRequest:request];
    
    return request;
}

- (BOXFolderCopyRequest *)folderCopyRequestWithID:(NSString *)folderID
                              destinationFolderID:(NSString *)destinationFolderID
{
    BOXFolderCopyRequest *request = [[BOXFolderCopyRequest alloc] initWithFolderID:folderID destinationFolderID:destinationFolderID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFolderDeleteRequest *)folderDeleteRequestWithID:(NSString *)folderID
{
    BOXFolderDeleteRequest *request = nil;
    request = [[BOXFolderDeleteRequest alloc] initWithFolderID:folderID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFolderItemsRequest *)folderItemsRequestWithID:(NSString *)folderID
{
    BOXFolderItemsRequest *request = nil;
    request = [[BOXFolderItemsRequest alloc] initWithFolderID:folderID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFolderPaginatedItemsRequest *)folderPaginatedItemsRequestWithID:(NSString *)folderID
                                                              inRange:(NSRange)range
{
    BOXFolderPaginatedItemsRequest *request = nil;
    request = [[BOXFolderPaginatedItemsRequest alloc] initWithFolderID:folderID inRange:range];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFolderRequest *)trashedFolderInfoRequestWithID:(NSString *)folderID
{
    BOXFolderRequest *request = [[BOXFolderRequest alloc] initWithFolderID:folderID isTrashed:YES];
    [self prepareRequest:request];
    
    return request;
}

- (BOXFolderDeleteRequest *)trashedFolderDeleteFromTrashRequestWithID:(NSString *)folderID
{
    BOXFolderDeleteRequest *request = [[BOXFolderDeleteRequest alloc] initWithFolderID:folderID
                                                                             isTrashed:YES];
    [self prepareRequest:request];
    
    return request;
}

- (BOXTrashedItemArrayRequest *)trashedItemsRequestInRange:(NSRange)range
{
    BOXTrashedItemArrayRequest *request = [[BOXTrashedItemArrayRequest alloc] initWithRange:range];
    [self prepareRequest:request];
    
    return request;
}

- (BOXTrashedFolderRestoreRequest *)trashedFolderRestoreRequestWithID:(NSString *)folderID
{
    BOXTrashedFolderRestoreRequest *request = [[BOXTrashedFolderRestoreRequest alloc] initWithFolderID:folderID];
    [self prepareRequest:request];
    
    return request;
}


@end
