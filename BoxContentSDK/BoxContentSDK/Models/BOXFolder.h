//
//  BOXFolder.h
//  BoxContentSDK
//
//  Created on 12/3/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXItem.h"

/**
 *  A compact representation of a Folder with only a few properties.
 *  Some API requests will return these representations to reduce bandiwdth, especially when many
 *  instances are being returned.
 */
@interface BOXFolderMini : BOXItemMini

/**
 *  Whether or not the folder is the "root" folder of the user.
 *  Root folders always have an ID of BOXAPIFolderIDRoot which is the string "0".
 */
@property (nonatomic, readonly, assign) BOOL isRoot;

@end

/**
 *  Represents a Folder on Box.
 */
@interface BOXFolder : BOXItem

/**
 *  The access level for the email-to-upload address.
 */
@property (nonatomic, readwrite, strong) BOXFolderUploadEmailAccessLevel *folderUploadEmailAccess;

/**
 *  If set, the folder accepts uploads through this email address.
 */
@property (nonatomic, readwrite, strong) NSString *folderUploadEmailAddress;

/**
 *  Whether this folder will be synced by the Box sync clients or not.
 *  Can be synced, not_synced, or partially_synced.
 *  Warning: By default, the Box API does not return this value, and it will be nil.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, strong) NSString *syncState;

/**
 *  Whether this folder has at least on collaboration.
 *  Can be synced, not_synced, or partially_synced.
 *  Warning: By default, the Box API does not return this value, and it will be nil.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean hasCollaborations;

/**
 *  Whether this folder is owned by an external company.
 *  Can be synced, not_synced, or partially_synced.
 *  Warning: By default, the Box API does not return this value, and it will be nil.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean isExternallyOwned;

/**
 *  Indicates permission for the current user to download items in the folder.
 *  Warning: By default, the Box API does not return this value, and it will be nil.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean canDownload;

/**
 *  Indicates permission for the current user to upload into this folder.
 *  Warning: By default, the Box API does not return this value, and it will be nil.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean canUpload;

/**
 *  Indicates permission for the current user can invite users into the folder as collaborators.
 *  Warning: By default, the Box API does not return this value, and it will be nil.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean canInviteCollaborator;

/**
 *  Whether non-owners can invite collaborators to this folder.
 *  Warning: By default, the Box API does not return this value, and it will be nil.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean canNonOwnersInvite;

/**
 *  The possible roles that can be given to collaborators who are added into this folder.
 *  Warning: By default, the Box API does not return this value, and it will be nil.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, strong) NSArray *allowedInviteeRoles;

/**
 *  Whether or not the folder is the "root" folder of the user.
 *  Root folders always have an ID of BOXAPIFolderIDRoot which is the string "0".
 */
@property (nonatomic, readonly, assign) BOOL isRoot;

@end
