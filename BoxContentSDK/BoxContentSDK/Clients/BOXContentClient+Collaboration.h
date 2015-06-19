//
//  BOXClient+CollaborationAPI.h
//  BoxContentSDK
//
//  Created on 12/16/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXContentSDKConstants.h"
#import "BOXContentClient.h"

@class BOXCollaborationRequest;
@class BOXFolderCollaborationsRequest;
@class BOXCollaborationCreateRequest;
@class BOXCollaborationRemoveRequest;
@class BOXCollaborationUpdateRequest;
@class BOXCollaborationPendingRequest;

@interface BOXContentClient (CollaborationAPI)

/**
 *  Generate a request to retrieve information about a Collaboration.
 *
 *  @param collaborationID Collaboration ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXCollaborationRequest *)collaborationInfoRequestWithID:(NSString *)collaborationID;

/**
 *  Generate a request to retrieve the Collaborations in a folder.
 *
 *  @param folderID Folder ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFolderCollaborationsRequest *)collaborationsRequestForFolderWithID:(NSString *)folderID;

/**
 *  Generate a request to retrieve the pending collaborations that the user has not yet accepted.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXCollaborationPendingRequest *)pendingCollaborationsRequest;

/**
 *  Generate a request to collaborate an existing Box User by User-ID into a folder.
 *
 *  @param folderID Folder ID.
 *  @param userID   User ID of the Box user that will be added.
 *  @param role     Collaboration role.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXCollaborationCreateRequest *)collaborationAddRequestToFolderWithID:(NSString *)folderID userID:(NSString *)userID role:(BOXCollaborationRole *)role;

/**
 *  Generate a request to collaborate an someone (usually identified by email address) into a folder.
 *
 *  @param folderID  Folder ID.
 *  @param userLogin User-Login or email address of the person that will be added.
 *  @param role      Collaboration role.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXCollaborationCreateRequest *)collaborationAddRequestToFolderWithID:(NSString *)folderID userLogin:(NSString *)userLogin role:(BOXCollaborationRole *)role;

/**
 *  Generate a request to collaborate a group into a folder.
 *
 *  @param folderID Folder ID.
 *  @param groupID  Group ID to be added.
 *  @param role     Collaboration role.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXCollaborationCreateRequest *)collaborationAddRequestToFolderWithID:(NSString *)folderID groupID:(NSString *)groupID role:(BOXCollaborationRole *)role;

/**
 *  Generate a request to delete a Collaboration.
 *
 *  @param collaborationID Collaboration ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXCollaborationRemoveRequest *)collaborationDeleteRequestWithID:(NSString *)collaborationID;

/**
 *  Generate a request to update a Collaboration. Set properties of the BOXCollaborationUpdateRequest (e.g. role, status) before executing it.
 *
 *  @param collaborationID Collaboration ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXCollaborationUpdateRequest *)collaborationUpdateRequestWithID:(NSString *)collaborationID;

@end
