//
//  BOXClient+CollaborationAPI.m
//  BoxContentSDK
//
//  Created on 12/16/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXContentClient_Private.h"
#import "BOXContentClient+Collaboration.h"
#import "BOXCollaborationRequest.h"
#import "BOXFileCollaborationsRequest.h"
#import "BOXFolderCollaborationsRequest.h"
#import "BOXCollaborationCreateRequest.h"
#import "BOXCollaborationRemoveRequest.h"
#import "BOXCollaborationUpdateRequest.h"
#import "BOXCollaborationPendingRequest.h"

@implementation BOXContentClient (CollaborationAPI)

- (BOXCollaborationRequest *)collaborationInfoRequestWithID:(NSString *)collaborationID
{
    BOXCollaborationRequest *request = [[BOXCollaborationRequest alloc] initWithCollaborationID:collaborationID];
    [self prepareRequest:request];
    
    return request;
}

#pragma mark - Folder Collaboration

- (BOXFolderCollaborationsRequest *)collaborationsRequestForFolderWithID:(NSString *)folderID
{
    BOXFolderCollaborationsRequest *request = [[BOXFolderCollaborationsRequest alloc] initWithFolderID:folderID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXCollaborationCreateRequest *)collaborationAddRequestToFolderWithID:(NSString *)folderID userID:(NSString *)userID role:(BOXCollaborationRole *)role
{
    BOXCollaborationCreateRequest *request = [[BOXCollaborationCreateRequest alloc] initWithItemType:BOXAPIItemTypeFolder
                                                                                              itemID:folderID];
    request.userID = userID;
    request.role = role;
    [self prepareRequest:request];
    
    return request;
}

- (BOXCollaborationCreateRequest *)collaborationAddRequestToFolderWithID:(NSString *)folderID userLogin:(NSString *)userLogin role:(BOXCollaborationRole *)role
{
    BOXCollaborationCreateRequest *request = [[BOXCollaborationCreateRequest alloc] initWithItemType:BOXAPIItemTypeFolder
                                                                                              itemID:folderID];
    request.login = userLogin;
    request.role = role;
    [self prepareRequest:request];
    
    return request;
}

- (BOXCollaborationCreateRequest *)collaborationAddRequestToFolderWithID:(NSString *)folderID groupID:(NSString *)groupID role:(BOXCollaborationRole *)role
{
    BOXCollaborationCreateRequest *request = [[BOXCollaborationCreateRequest alloc] initWithItemType:BOXAPIItemTypeFolder
                                                                                              itemID:folderID];
    request.groupID = groupID;
    request.role = role;
    [self prepareRequest:request];
    
    return request;
}

#pragma mark - File Collaboration

- (BOXFileCollaborationsRequest *)collaborationsRequestForFileWithID:(NSString *)fileID
{
    BOXFileCollaborationsRequest *request = [[BOXFileCollaborationsRequest alloc] initWithFileID:fileID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXCollaborationCreateRequest *)collaborationAddRequestToFileWithID:(NSString *)fileID
                                                                userID:(NSString *)userID
                                                                  role:(BOXCollaborationRole *)role
{
    BOXCollaborationCreateRequest *request = [[BOXCollaborationCreateRequest alloc] initWithItemType:BOXAPIItemTypeFile
                                                                                              itemID:fileID];
    request.userID = userID;
    request.role = role;
    [self prepareRequest:request];
    
    return request;
}

- (BOXCollaborationCreateRequest *)collaborationAddRequestToFileWithID:(NSString *)fileID
                                                             userLogin:(NSString *)userLogin
                                                                  role:(BOXCollaborationRole *)role
{
    BOXCollaborationCreateRequest *request = [[BOXCollaborationCreateRequest alloc] initWithItemType:BOXAPIItemTypeFile
                                                                                              itemID:fileID];
    request.login = userLogin;
    request.role = role;
    [self prepareRequest:request];
    
    return request;
}

- (BOXCollaborationCreateRequest *)collaborationAddRequestToFileWithID:(NSString *)fileID
                                                               groupID:(NSString *)groupID
                                                                  role:(BOXCollaborationRole *)role
{
    BOXCollaborationCreateRequest *request = [[BOXCollaborationCreateRequest alloc] initWithItemType:BOXAPIItemTypeFile
                                                                                              itemID:fileID];
    request.groupID = groupID;
    request.role = role;
    [self prepareRequest:request];
    
    return request;
}

#pragma mark - Collaboration Modification

- (BOXCollaborationRemoveRequest *)collaborationDeleteRequestWithID:(NSString *)collaborationID
{
    BOXCollaborationRemoveRequest *request = [[BOXCollaborationRemoveRequest alloc] initWithCollaborationID:collaborationID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXCollaborationUpdateRequest *)collaborationUpdateRequestWithID:(NSString *)collaborationID
{
    BOXCollaborationUpdateRequest *request = [[BOXCollaborationUpdateRequest alloc] initWithCollaborationID:collaborationID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXCollaborationPendingRequest *)pendingCollaborationsRequest
{
    BOXCollaborationPendingRequest *request = [[BOXCollaborationPendingRequest alloc] init];
    [self prepareRequest:request];

    return request;
}

@end
