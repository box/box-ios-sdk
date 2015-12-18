//
//  BOXAuthorizationViewController.h
//  BoxContentSDK
//
//  Created on 2/20/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BOXContentClient;
@class BOXUser;

/**
 * BOXAuthorizationViewController is a UIViewController that displays a UIWebview
 * that loads the OAuth2 authorize URL. An app may present this view controller to
 * log a user in to Box.
 *
 * This view controller also has extra logic to handle various Single Sign-ON (SSO)
 * configurations which require special handling beyond what a web view provides.
 * SSO is a session/user authentication process that allows a user to provide his
 * or her credentials once in order to access multiple applications. It is widely
 * used by corporations and institutions to secure and simplify the authentication
 * process for their users.
 *
 * **Important**: This controller performs valuable cookie-related operations on deallocation,
 * as such it should not be kept it memory after it is dismissed.
 *
 * @warning This is the only part of the Box SDK that is specific to iOS. If you wish to
 *   include the Box SDK in an OS X project, remove this source file.
 */
@interface BOXAuthorizationViewController : UIViewController <UIWebViewDelegate>

/** @name Initializers */

/**
 * Designated initializer.
 * @param SDKClient         The SDKClient to use to authenticate a new account session.
 * @param completionBlock   You will likely want to dismiss the authorizationViewController. If successful, a BoxUser object will be returned, otherwise an NSError will be returned.
 * @param completionBlock   You will likely want to dismiss the authorizationViewController through this block.
 */
- (instancetype)initWithSDKClient:(BOXContentClient *)SDKClient
                  completionBlock:(void (^)(BOXAuthorizationViewController *authorizationViewController, BOXUser *user, NSError *error))completionBlock
                      cancelBlock:(void (^)(BOXAuthorizationViewController *authorizationViewController))cancelBlock;

/**
 * Advanced initializer.
 * @param SDKClient         The SDKClient to use to authenticate a new account session.
 * @param authorizeURL      The authorization URL to be used. Optional, a default value is used when nil.
 * @param redirectURI       The redirect URI to be used, this has to match the redirect URI. Optional, a default value is used when nil.
 * @param headers           Custom headers to use in the authorization request. Optional, defaults to nil.
 * @param completionBlock   You will likely want to dismiss the authorizationViewController. If successful, a BoxUser object will be returned, otherwise an NSError will be returned.
 * @param completionBlock   You will likely want to dismiss the authorizationViewController through this block.
 */
- (instancetype)initWithSDKClient:(BOXContentClient *)SDKClient
                     authorizeURL:(NSURL *)authorizeURL
                      redirectURI:(NSString *)redirectURI
                          headers:(NSDictionary *)headers
                  completionBlock:(void (^)(BOXAuthorizationViewController *authorizationViewController, BOXUser *user, NSError *error))completionBlock
                      cancelBlock:(void (^)(BOXAuthorizationViewController *authorizationViewController))cancelBlock;

@end
