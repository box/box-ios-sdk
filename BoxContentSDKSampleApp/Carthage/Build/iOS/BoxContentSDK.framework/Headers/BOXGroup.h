//
//  BOXGroup.h
//  BoxContentSDK
//
//  Created by on 12/17/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXModel.h"

/**
 *  Represents a group. Groups can be added to folders as collaborators.
 */
@interface BOXGroup : BOXModel

/**
 *  Name of the group.
 */
@property (nonatomic, readwrite, strong) NSString *name;

/**
 *  Date the group was created.
 */
@property (nonatomic, readwrite, strong) NSDate *createdDate;

/**
 *  Date the group was modified.
 */
@property (nonatomic, readwrite, strong) NSDate *modifiedDate;

@end
