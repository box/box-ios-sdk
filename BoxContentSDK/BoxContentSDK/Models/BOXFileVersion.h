//
//  BOXFileVersion.h
//  BoxContentSDK
//
//  Created by Rico Yao on 12/31/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXModel.h"
#import "BOXUser.h"

/**
 *  Represents a version of a file.
 */
@interface BOXFileVersion : BOXModel

/**
 *  The name of the file at this version.
 */
@property (nonatomic, readwrite, strong) NSString *name;

/**
 *  The SHA1 hash of the file at this version.
 */
@property (nonatomic, readwrite, strong) NSString *sha1;

/**
 *  The size of the file at this version.
 */
@property (nonatomic, readwrite, strong) NSNumber *size;

/**
 *  The creation date of the file at this version.
 */
@property (nonatomic, readwrite, strong) NSDate *createdDate;

/**
 *  The modification date of the file at this version.
 */
@property (nonatomic, readwrite, strong) NSDate *modifiedDate;

/**
 *  The user who last modified the file at this version.
 */
@property (nonatomic, readwrite, strong) BOXUserMini *lastModifier;

@end
