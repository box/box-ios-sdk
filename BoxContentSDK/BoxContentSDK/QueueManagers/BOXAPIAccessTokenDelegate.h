//
//  BOXAPIAccessTokenDelegate.h
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/6/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

/**
 * BOXAPIAccessTokenDelegate allows users to apply a series of network calls to retrieve an access token
 * outside of the normal means of authentication (OAuth2). 
 *
 * This method of authetication is known as Box Developer Edition and more documentation can be found in
 * the link below.
 * https://developers.box.com/developer-edition/#app_users
 *
 * BOXAPIAccessTokenDelegate is a protocol that should only be conformed to if AppUsers is being used.
 */
@protocol BOXAPIAccessTokenDelegate <NSObject>

/**
 * The method is meant to be used to make network requests to acquire access tokens and access token expiration dates.
 */
- (void)fetchAccessTokenWithCompletion:(void (^)(NSString *, NSDate *, NSError *))completion;

@end