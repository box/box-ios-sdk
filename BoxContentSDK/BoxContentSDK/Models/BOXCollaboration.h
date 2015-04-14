//
//  BOXCollaboration.h
//  BoxContentSDK
//
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXModel.h"
#import "BOXContentSDKConstants.h"

@class BOXUserMini;
@class BOXFolderMini;

/**
 *  Represents a Collaboration.
 */
@interface BOXCollaboration : BOXModel

/**
 *  The user that created the collaboration.
 */
@property (nonatomic, readwrite, strong) BOXUserMini *creator;

/**
 *  The date the collaboration was created.
 */
@property (nonatomic, readwrite, strong) NSDate *createdDate;

/**
 *  The date the collaboration was last modified.
 */
@property (nonatomic, readwrite, strong) NSDate *modificationDate;

/**
 *  The expiration date of the collaboration.
 */
@property (nonatomic, readwrite, strong) NSDate *expirationDate;

/**
 *  Status of the collaboration.
 */
@property (nonatomic, readwrite, strong) BOXCollaborationStatus *status;

/**
 *  The role of the user that was collaborated into the folder.
 */
@property (nonatomic, readwrite, strong) BOXCollaborationRole *role;

/**
 *  When the status of this collab was changed
 */
@property (nonatomic, readwrite, strong) NSDate *acknowledgedDate;

/**
 *  The folder that this collaboration applies to.
 */
@property (nonatomic, readwrite, strong) BOXFolderMini *folder;

/**
 *  The user or group who the collaboration applies to. Will be either a BOXUserMini or BOXGroup object.
 */
@property (nonatomic, readwrite, strong) BOXModel *accessibleBy;

@end
