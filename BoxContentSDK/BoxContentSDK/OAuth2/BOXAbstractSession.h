//
//  BOXAppSession.h
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/3/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOXAPIQueueManager.h"
#import "BOXUser.h"

#pragma mark Notifications
extern NSString *const BOXSessionDidBecomeAuthenticatedNotification;
extern NSString *const BOXSessionDidReceiveAuthenticationErrorNotification;
extern NSString *const BOXSessionDidRefreshTokensNotification;
extern NSString *const BOXSessionDidReceiveRefreshErrorNotification;
extern NSString *const BOXSessionWasRevokedNotification;

#pragma mark Keys
extern NSString *const BOXAuthenticationErrorKey;
extern NSString *const BOXUserIDKey;

/**
 * BOXAbstractSession is an abstract class you can use to encapsulate managing a set of
 * credentials, an access token and a refresh token. Because this class is abstract, you should
 * not instantiate it directly. It is advised you use BOXAppUserSession or BOXParallelOAuth2Session,
 * but subclassing is possible (see subclassing notes). This class does enforce its abstractness via calls to the
 * `BOXAbstract` macro, which will assert on debug builds.
 *
 * Subclassing Notes
 * =================
 * Subclasses must implement all abstract methods in this class. These include:
 *
 * - performAuthorizationCodeGrantWithReceivedURL:withCompletionBlock:
 * - performRefreshTokenGrant:withCompletionBlock:
 * - revokeAllCredentials
 * - isAuthorized
 *
 * Optional Subclassing Notes
 * ==========================
 * Subclasses have the option of implementing these methods in case they want to store/restore more information to/from the keychain and or session.
 * Must call super class's method at the beginning of the overridden method.
 *
 * - keychainDictionary
 * - restoreSessionWithKeychainDictionary:
 * - clearCurrentSessionWithUserID:
 * - copyTokensFromSession:
 *
 */
@interface BOXAbstractSession : NSObject

#pragma mark Framework Properties
/** @name SDK framework objects */

/**
 * The base URL for API requests.
 * @see BOXAPIBaseURL
 */
@property (nonatomic, readwrite, strong) NSString *APIBaseURLString;

/**
 * The BOXAPIQueueManager on which to enqueue [BOXAPIOAuth2ToJSONOperation](BOXAPIOAuth2ToJSONOperation) or [BOXAPIAppAuthOperation](BOXAPIAppAuthOperation).
 */
@property (nonatomic, readwrite, weak) BOXAPIQueueManager *queueManager;

#pragma mark Authorization Properties
/** @name Authorization Properties */

/**
 * This token identifies a user on Box. This token is included in every request in the
 * Authorization header as a Bearer token. Access tokens expire 60 minutes from when they are issued.
 *
 * accessToken is never stored by the SDK. If you choose to persist the access token, do so in
 * secure storage such as the Keychain.
 *
 * An access token of `accesstoken` is transformed into the following Authorization header:
 *
 * <pre><code>Authorization: Bearer accesstoken</code></pre>
 *
 * @see addAuthorizationParametersToRequest:
 */
@property (nonatomic, readwrite, strong) NSString *accessToken;

/**
 * When an access token is expected to expire. There is no guarantee the access token will be valid
 * until this date. Tokens may be revoked by a user at any time.
 */
@property (nonatomic, readwrite, strong) NSDate *accessTokenExpiration;

/**
 * By default, credentials are stored in the keychain so they can be re-used when your app restarts.
 * Set this to false to disable this behavior, which will force users to log in every time.
 */
@property (nonatomic, readwrite, assign) BOOL credentialsPersistenceEnabled;

/**
 * Box user associated with the credentials.
 */
@property (nonatomic, readonly , strong) BOXUserMini *user;

#pragma mark Initializers
/** @name Initialization */

/**
 * Designated initializer. Returns a BOXAbstractSession capable of authorizing a user and signing requests.
 *
 * @param baseURL The base URL String for accessing the Box API.
 * @param queueManager The queue manager on which to enqueue [BOXAPIToJSONOperations](BOXAPIToJSONOperation).
 *
 * @return A BOXAbstractSession capable of authorizing a user and signing requests.
 */
- (instancetype)initWithAPIBaseURL:(NSString *)baseURL queueManager:(BOXAPIQueueManager *)queueManager;

#pragma mark Access Token Authorization
/** @name Token Authorization */

/**
 * This method authorizes a access token.
 *
 * This method may be called automatically by the SDK framework upon a failed API call.
 *
 * @param URL The URL received will authorize an access token. (Optional)
 * @param block The completion block to run after authorization of an access token succeeds/fails
 */
- (void)performAuthorizationCodeGrantWithReceivedURL:(NSURL *)URL withCompletionBlock:(void (^)(BOXAbstractSession *session, NSError *error))block;

#pragma mark Access Token Refresh
/** @name Token Refresh */

/**
 * This method refreshes the access token.
 *
 * This method may be called automatically by the SDK framework upon a failed API call.
 *
 * @param expiredAccessToken The access token that expired.
 * @param block The completion block to run after refreshing the expired access token.
 */
- (void)performRefreshTokenGrant:(NSString *)expiredAccessToken withCompletionBlock:(void (^)(BOXAbstractSession *session, NSError *error))block;

/**
 * Compares accessTokenExpiration to the current time to determine if an access token may be valid.
 *
 * This is not a guarantee that an access token is valid as it may have been revoked or already refreshed.
 *
 * @return A BOOL indicating whether the access token may be valid.
 */
- (BOOL)isAuthorized;

#pragma mark Request Authorization
/** @name Request Signing */

/**
 * Add the Authorization header to a request.
 *
 * @param request The API request that should be modified with an Authorization header and Bearer token.
 *
 * @see accessToken
 */
- (void)addAuthorizationParametersToRequest:(NSMutableURLRequest *)request;

#pragma mark Token Helpers
/** @name Token Helpers */

/**
 * Copies tokens from the given parameter's session to the current session instance.
 * 
 * @param session The session to copy tokens from.
 */
- (void)reassignTokensFromSession:(BOXAbstractSession *)session;

#pragma mark Keychain
/** @name Keychain */

/**
 * This method sets the keychain identifier prefix. Default is "BoxCredential_".
 *
 * @param keychainIdentifierPrefix The prefix to add to all keychain items.
 */
+ (void)setKeychainIdentifierPrefix:(NSString *)keychainIdentifierPrefix;

/**
 * This method sets the keychain access group.
 *
 * If you need to allow access to Box credentials to multiple processes (e.g. extensions) then you
 * must set the keychain access group.
 *
 * @param keychainAccessGroup The name of the keychain access group.
 */
+ (void)setKeychainAccessGroup:(NSString *)keychainAccessGroup;

/**
 * Stores the current session's user credentials to the keychain.
 */
- (void)storeCredentialsToKeychain;

/**
 * Restores a user's credentials from the keychain.
 *
 * @param userID The ID to restore based on in the keychain.
 */
- (void)restoreCredentialsFromKeychainForUserWithID:(NSString *)userID;

/**
 * Revoke's the current user's credentials from the keychain.
 */
- (void)revokeCredentials;

/**
 * Revoke all users' credentials from the keychain.
 */
+ (void)revokeAllCredentials;

/**
 * Returns all users currently in the keychain.
 *
 * @return An array of users in the keychain.
 */
+ (NSArray *)usersInKeychain;

#pragma mark Keychain Helpers
/** @name Keychain Helpers */

/**
 * Retrieves the information to store into the keychain.
 *
 * @return A dictioanry with all necessary information to store into the keychain about a given user.
 */
- (NSDictionary *)keychainDictionary;

/**
 * Restores the current session instance with proper credentials retrieved from the keychain.
 * 
 * @param dictionary Credentials retrieved from the keychain.
 */
- (void)restoreSessionWithKeyChainDictionary:(NSDictionary *)dictionary;

/**
 * Clears the current session instance's user credentials.
 *
 * @param userID The ID of the current session holder.
 */
- (void)clearCurrentSessionWithUserID:(NSString *)userID;

@end
