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

- (BOXFolderCollaborationsRequest *)collaborationsRequestForFolderWithID:(NSString *)folderID
{
    BOXFolderCollaborationsRequest *request = [[BOXFolderCollaborationsRequest alloc] initWithFolderID:folderID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXCollaborationCreateRequest *)collaborationAddRequestToFolderWithID:(NSString *)folderID userID:(NSString *)userID role:(BOXCollaborationRole *)role
{
    BOXCollaborationCreateRequest *request = [[BOXCollaborationCreateRequest alloc] initWithFolderID:folderID];
    request.userID = userID;
    request.role = role;
    [self prepareRequest:request];
    
    return request;
}

- (BOXCollaborationCreateRequest *)collaborationAddRequestToFolderWithID:(NSString *)folderID userLogin:(NSString *)userLogin role:(BOXCollaborationRole *)role
{
    BOXCollaborationCreateRequest *request = [[BOXCollaborationCreateRequest alloc] initWithFolderID:folderID];
    request.login = userLogin;
    request.role = role;
    [self prepareRequest:request];
    
    return request;
}

- (BOXCollaborationCreateRequest *)collaborationAddRequestToFolderWithID:(NSString *)folderID groupID:(NSString *)groupID role:(BOXCollaborationRole *)role
{
    BOXCollaborationCreateRequest *request = [[BOXCollaborationCreateRequest alloc] initWithFolderID:folderID];
    request.groupID = groupID;
    request.role = role;
    [self prepareRequest:request];
    
    return request;
}

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
