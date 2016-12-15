//
//  BOXURLSessionIdentifier.h
//  BoxContentSDK
//
//  Created by James Lawton on 12/14/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BOXUserMini;

/**
 * Represents the identifier of an `NSURLSession` created by the Box Content SDK for background tasks.
 */
@interface BOXURLSessionIdentifier : NSObject

/**
 * Initialise a new identifier associated with the given user.
 */
- (instancetype)initWithUser:(BOXUserMini *)user;

/**
 * Initialise an identifier given the string value of an identifier. Use this to validate that a session was created by
 * this SDK, and also to discover if it was created during an execution of the current executable.
 */
- (nullable instancetype)initWithIdentifierString:(NSString *)identifier;

/**
 * The string which should be used to instantiate the `NSURLSession`.
 */
@property (nonatomic, readonly, copy) NSString *stringValue;

/**
 * The user ID associated with this identifier.
 */
@property (nonatomic, readonly, copy) NSString *userID;

/**
 * Whether the represented identifier was first created by the current executable. This is `NO` if the session was
 * originally created by an App Extension, and we are handling callbacks in the main app, after the extension was
 * terminated.
 */
@property (nonatomic, readonly) BOOL wasCreatedFromCurrentBundle;

@end

NS_ASSUME_NONNULL_END
