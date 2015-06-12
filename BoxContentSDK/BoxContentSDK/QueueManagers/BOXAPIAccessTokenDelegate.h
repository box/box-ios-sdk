//
//  BOXAPIAccessTokenDelegate.h
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/6/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

/**
 * The method of authetication through AppUsers is known as Box Developer Edition. AppUsers allow developers
 * to bypass the OAuth2 aspect of authentication by allowing them to retrieve access tokens through their own
 * servers. The official documentation of AppUsers can be found in the link below.
 * https://developers.box.com/developer-edition/#app_users
 *
 * BOXAPIAccessTokenDelegate allows developers to make network calls to their own servers to retrieve an access token
 * outside of the normal means of authentication (OAuth2).
 *
 * BOXAPIAccessTokenDelegate is a protocol that should only be conformed to if AppUsers is being used.
 */
@protocol BOXAPIAccessTokenDelegate <NSObject>

/**
 * The method is meant to be used to make network requests to acquire access tokens and access token expiration dates.
 */
- (void)fetchAccessTokenWithCompletion:(void (^)(NSString *, NSDate *, NSError *))completion;

@end