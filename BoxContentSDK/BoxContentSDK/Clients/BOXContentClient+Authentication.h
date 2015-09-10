//
//  BOXClient+Authentication.h
//  BoxContentSDK
//
//  Created by Rico Yao on 11/12/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXContentClient.h"
#import <UIKit/UIKit.h>

@class BOXUser;

@interface BOXContentClient (Authentication)

/**
 *  Authenticate a user. If necessary, this will present a UIViewController to allow the user to enter their credentials,
 *  or launch the Box app to allow the user to automatically be authenticated to that account (if possible).
 *  If a user is already authenticated, then a UIViewController will not be presented and the completionBlock will be called.
 *
 *  @param completionBlock Called when the authentication has completed.
 */
- (void)authenticateWithCompletionBlock:(void (^)(BOXUser *user, NSError *error))completion;

/**
 *  Authenticate a user. If necessary, this will present a UIViewController to allow the user to enter their credentials.
 *  If a user is already authenticated, then a UIViewController will not be presented and the completionBlock will be called.
 *
 *  @param completionBlock Called when the authentication has completed.
 */
- (void)authenticateInAppWithCompletionBlock:(void (^)(BOXUser *user, NSError *error))completion;

/**
 *  Authenticate a user. If necessary and possible, this will launch the Box app to allow the user to autmatically
 *  be authenticated to that account.
 *  If App-To-App authentication is not possible, an error is returned in the completion block.
 *  If a user is already authenticated, then a UIViewController will not be presented and the completionBlock will be called.
 *
 *  @param completionBlock Called when the authentication has completed.
 */
- (void)authenticateAppToAppWithCompletionBlock:(void (^)(BOXUser *user, NSError *error))completion;

/**
 *  Discerns whether a launch URL is associated with Box App-to-App authentication - if it is the return URL that should be used
 *  to complete the user's authentication in the case of authenticating App-to-App using the Box app.
 *
 *  @param authenticationURL    The URL with which the app was launched.
 */
+ (BOOL)canCompleteAppToAppAuthenticationWithURL:(NSURL *)authenticationURL;

/**
 *  Complete the user's authentication to the account that is in use in the Box app. (App-to-App)
 *  On completion, the original completionBlock will be called.
 *
 *  @param authenticationURL    The URL with which the app was launched.
 */
+ (void)completeAppToAppAuthenticationWithURL:(NSURL *)authenticationURL;

/**
 *  Log out the user associated with this BOXContentClient. It is a good practice to call this when the user's session is no longer necessary.
 */
- (void)logOut;

/**
 *  Log out all users that have ever been authenticated.
 */
+ (void)logOutAll;

/**
 *  By default, the Content SDK stores some information in the keychain to persist the user's session with a default prefix.
 *  You can override this prefix.
 *
 *  @param keychainIdentifierPrefix prefix for keychain entries.
 */
+ (void)setKeychainIdentifierPrefix:(NSString *)keychainIdentifierPrefix;

/**
 *  By default, the Content SDK stores some information in the keychain to persist the user's session with no access group defined.
 *  You may need to set this if you need to use the SDK in multiple processes (e.g. extensions)
 *
 *  @param keychainAccessGroup keychain access group
 */
+ (void)setKeychainAccessGroup:(NSString *)keychainAccessGroup;

@end
