//
//  BOXAPIAccessTokenDelegate.h
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/6/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

/**
 * App Users are full-featured enterprise Box accounts that belong to your application not a Box user. Unlike typical Box accounts, 
 * these accounts do not have an associated login and can only be accessed through the Content API by the controlling application 
 * and associated Box User ID. This new user model allows your application to take advantage of groups, permissions, collaborations, 
 * comments, tasks, and the many other features offered by the Box platform.
 *
 * For more information the documentation is linked below.
 * https://developers.box.com/developer-edition/#app_users
 *
 * BOXAPIAccessTokenDelegate allows developers to make network calls to their own servers to retrieve an access token
 * outside of the normal means of authentication (OAuth2).
 *
 * BOXAPIAccessTokenDelegate is a protocol that should only be conformed to if App Users is being used.
 */
@protocol BOXAPIAccessTokenDelegate <NSObject>

/**
 * The method is meant to be used to make network requests to acquire access tokens and access token expiration dates.
 */
- (void)fetchAccessTokenWithCompletion:(void (^)(NSString *accessToken, NSDate *accessTokenExpiration, NSError *error))completion;

@end