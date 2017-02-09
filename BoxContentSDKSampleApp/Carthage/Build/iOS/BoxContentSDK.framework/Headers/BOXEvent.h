//
//  BOXEvent.h
//  BoxContentSDK
//
//  Created on 12/16/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXModel.h"

@class BOXUser;

/**
 *  Represents an Event.
 */
@interface BOXEvent : BOXModel

/**
 *  The user that triggered the event.
 */
@property (nonatomic, readwrite, strong) BOXUser *creator;

/**
 *  The date the event was created.
 */
@property (nonatomic, readwrite, strong) NSDate *createdDate;

/**
 *  The type of the event.
 *  Full list of types: https://developers.box.com/docs/#events
 */
@property (nonatomic, readwrite, strong) NSString *eventType;

/**
 *  The session of the user that performed the action
 */
@property (nonatomic, readwrite, strong) NSString *sessionID;

/**
 *  The object that was modified. Ex: BOXFile, BOXFolder, BOXComment, etc.
 *  Not all events have a source object.
 */
@property (nonatomic, readwrite, strong) BOXModel *source;

@end
