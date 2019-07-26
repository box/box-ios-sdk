//
//  BOXClient+User.h
//  BoxContentSDK
//
//  Created on 11/14/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXContentClient.h"
#import "BOXContentSDKConstants.h"

@class BOXUserRequest;
@class BOXUserAvatarRequest;

@interface BOXContentClient (UserAPI)

/**
 *  Generate a request to retrieve the current user.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXUserRequest *)currentUserRequest;

/**
 *  Generate a request to retrieve the user by user ID.
 *
 *  @param userID   The ID of the user whose avatar is being fetched.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXUserRequest *)userInfoRequestWithID:(NSString *)userID;

/**
 *  Generate a request to retrieve the avatar of a user.
 *
 *  @param userID   The ID of the user whose avatar is being fetched.
 *  @param type     The avatar size type (small, large, profile, etc.).
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXUserAvatarRequest *)userAvatarRequestWithID:(NSString *)userID
                                             type:(BOXAvatarType)type;

@end
