//
//  BOXFileLock.h
//  BoxContentSDK
//
//  Created by Scott Liu on 12/2/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXModel.h"

@class BOXUserMini;

/**
 *  Represents a lock that is held on a file.
 */
@interface BOXFileLock : BOXModel

/**
 *  The user that is holding the lock.
 */
@property (nonatomic, readwrite, strong) BOXUserMini *creator;

/**
 *  Date the lock was created.
 */
@property (nonatomic, readwrite, strong) NSDate *createdDate;

/**
 *  Date that the lock expires.
 */
@property (nonatomic, readwrite, strong) NSDate *expirationDate;

/**
 *  Whether or not the lock prevents users from downloading the file (in addition to preventing uploads).
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean isDownloadPrevented;

@end
