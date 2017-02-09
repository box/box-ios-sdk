//
//  BOXComment.h
//  BoxContentSDK
//
//  Created by Clement Rousselle on 12/9/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXModel.h"

@class BOXItemMini;
@class BOXUserMini;

/**
 *  Represents a Comment.
 */
@interface BOXComment : BOXModel

/**
 *  Comment message.
 */
@property (nonatomic, readwrite, strong) NSString *message;

/**
 *  The string representing the comment text with @mentions included. @mention format is @[id:username].
 */
@property (nonatomic, readwrite, strong) NSString *taggedMessage;

/**
 *  Date the comment was created.
 */
@property (nonatomic, readwrite, strong) NSDate *createdDate;

/**
 *  Date the comment was last modified.
 */
@property (nonatomic, readwrite, strong) NSDate *modifiedDate;

/**
 *  The file or bookmark that the comment applies to.
 */
@property (nonatomic, readwrite, strong) BOXItemMini *item;

/**
 *  The user that created the comment.
 */
@property (nonatomic, readwrite, strong) BOXUserMini *creator;

/**
 *  Whether or not this comment is a reply to another comment.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean isReplyComment;

@end
