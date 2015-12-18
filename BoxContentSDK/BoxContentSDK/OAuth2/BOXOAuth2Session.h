//
//  BOXOAuth2Session.h
//  BoxContentSDK
//
//  Created on 2/19/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BOXAPIQueueManager.h"
#import "BOXUser.h"
#import "BOXAbstractSession.h"

/**
 * BOXOAuth2Session is an abstract class you can use to encapsulate managing a set of OAuth2
 * credentials, an access token and a refresh token. Because this class is abstract, you should
 * not instantiate it directly. You can either use the provided BOXParallelOAuth2Session or implement your
 * own subclass (see subclassing notes). This class does enforce its abstractness via calls to the
 * `BOXAbstract` macro, which will raise an `NSAssert` when `DEBUG=1`.
 *
 * This class provides support for the [Authorization Code Grant](http://tools.ietf.org/html/rfc6749#section-4.1)
 * and [refreshing an access token](http://tools.ietf.org/html/rfc6749#section-6). See
 * [RFC 6749](http://tools.ietf.org/html/rfc6749) for more information about the OAuth2 spec.
 *
 * The Authorization Code Grant requires a web view to allow the user to authenticate with Box and Authorize your
 * application. Upon successful authorization, the webview will launch a custom URL scheme. Your app must capture
 * this open in request in your App delegate and forward the URL to performAuthorizationCodeGrantWithReceivedURL:.
 *
 * NSNotifications
 * ===============
 * An OAuth2 session will issue the following notifications when the authorization state changes:
 *
 * - `BOXAuthSessionDidBecomeAuthenticatedNotification` upon successfully exchanging an authorization code for a
 *   set of tokens.
 * - `BOXAuthSessionDidReceiveAuthenricationErrorNotification` when the authorization code grant fails.
 * - `BOXAuthSessionDidRefreshTokensNotification` upon successfully refreshing an access token.
 * - `BOXAuthSessionDidReceiveRefreshErrorNotification` when a refresh attempt has failed (for example because
 *   the refresh token has been revoked or is expired).
 *
 * Subclassing Notes
 * =================
 * Subclasses must implement all abstract methods in this class. These include:
 *
 * - performAuthorizationCodeGrantWithReceivedURL:
 * - grantTokensURL
 * - authorizeURL
 * - redirectURIString
 * - performRefreshTokenGrant
 * - isAuthorized
 *
 * Service Settings on Box
 * =======================
 * **Note**: When setting up your service on Box, make sure to set the OAuth2 redirect URI
 * to the following format: boxsdk-YOUR_API_KEY_HERE://boxsdkoauth2redirect.
 * The SDK will expect that redirect URI when issuing OAuth2 calls; doing so requires
 * that the redirect URI is set correctly in your service settings (found under
 * "My Applications" at developers.box.com).
 */
@interface BOXOAuth2Session : BOXAbstractSession

/** @name Service settings */

/**
 * The client identifier described in [Section 2.2 of the OAuth2 spec](http://tools.ietf.org/html/rfc6749#section-2.2)
 *
 * This is also known as an API key on Box. See the [Box OAuth2 documentation](http://developers.box.com/oauth/) for
 * information on where to find this value.
 */
@property (nonatomic, readonly, strong) NSString *clientID;

/**
 * The client secret. This value is used during the authorization code grant and when refreshing tokens.
 * This value should be a secret. DO NOT publish this value.
 *
 * See the [Box OAuth2 documentation](http://developers.box.com/oauth/) for
 * information on where to find this value.
 */
@property (nonatomic, readonly, strong) NSString *clientSecret;

/** @name OAuth2 credentials */

/**
 * This token may be exchanged for a new access token and refresh token. Refresh tokens expire
 * 14 days from when they are issued.
 *
 * refreshToken is never stored by the SDK. If you choose to persis the access token, do so in
 * secure storage such as the Keychain.
 *
 * If a refresh token is expired, it cannot be exchanged for new tokens, and the user is effectively
 * logged out of Box.
 *
 * @see performRefreshTokenGrant:
 */
@property (nonatomic, readwrite, strong) NSString *refreshToken;

#pragma mark - Initialization
/** @name Initialization */

/**
 * Designated initializer. Returns a BOXOAuth2Session capable of authorizing a user and signing requests.
 *
 * @param ID your client ID, also known as API key.
 * @param secret your client secret. DO NOT publish this secret.
 * @param baseURL The base URL String for accessing the Box API.
 * @param authBaseURL The base URL String for authenticating with the Box API.
 * @param queueManager The queue manager on which to enqueue [BOXAPIOAuth2ToJSONOperations](BOXAPIOAuth2ToJSONOperation).
 *
 * @return A BOXOAuth2Session capable of authorizing a user and signing requests.
 */
- (instancetype)initWithClientID:(NSString *)ID
                          secret:(NSString *)secret
                      APIBaseURL:(NSString *)baseURL
                  APIAuthBaseURL:(NSString *)authBaseURL
                    queueManager:(BOXAPIQueueManager *)queueManager;

#pragma mark - Authorization
/** @name Authorization */

/**
 * The base URL for API requests.
 * @see BOXAPIAuthBaseURL
 */
@property (nonatomic, readwrite, strong) NSString *APIAuthBaseURLString;

/**
 * Exchange an authorization code for an access token and a refresh token.
 * 
 * This method should send the `BOXAuthSessionDidBecomeAuthenticatedNotification` notification when an
 * authorization code is successfully exchanged for an access token and a refresh
 * token.
 * 
 * This method should send the `BOXAuthSessionDidReceiveAuthenricationErrorNotification` notification
 * if an authorization code is not obtained from the authorization webview flow
 * (for example if the user denies authorizing your application).
 *
 * @param URL The URL received as a result of the OAuth2 server invoking the redirect URI. This URL will
 * contain query string params needed to complete the authorization_code grant type.
 *
 * @param Completion block with an updated BOXOAuth2Session.
 *
 * @warning This method is intended to be called from your application delegate in response to
 * `application:openURL:sourceApplication:annotation:`.
 */
- (void)performAuthorizationCodeGrantWithReceivedURL:(NSURL *)URL withCompletionBlock:(void (^)(BOXAbstractSession *session, NSError *error))block;

/**
 * Returns the URL to POST to for exchanging an authorization code or refresh token for a new set of tokens.
 * @return The URL to POST to for exchanging an authorization code or refresh token for a new set of tokens.
 */
- (NSURL *)grantTokensURL;

/**
 * Returns the URL to load in a webview to start the authentication and authorization flow with Box.
 * @return The URL to load in a webview to start the authentication and authorization flow with Box.
 */
- (NSURL *)authorizeURL;

/**
 * A string containing the URI to load after the user completes the webview authorization flow.
 * This URI allows Box to redirect back to your app with an authorization code.
 *
 * @warning This should be a custom url scheme registered to your app.
 * @warning Do not set this to a custom value, unless you are also setting a custom redirect URI in your app's developer settings.
 *
 * @return Redirect URI string
 */
@property (nonatomic, readwrite, strong) NSString *redirectURIString;

/**
 * Custom parameters to use in the token grant request. Optional, defaults to nil.
 */
@property (nonatomic, readwrite, strong) NSDictionary *additionalTokenGrantParameters;

/**
 * Returns the randomly generated nonce used to prevent spoofing attack during login
 * @return generated nonce
 */
- (NSString *)nonce;

#pragma mark - Token Refresh
/** @name Token Refresh */

/**
 * This method exchanges a refresh token for a new access token and refresh token.
 *
 * This method may be called automatically by the SDK framework upon a failed API call.
 *
 * This method should send the `BOXAuthSessionDidRefreshTokensNotification` notification upon successfully
 * exchanging a refresh token for a new access token and refresh token.
 *
 * This method should send the `BOXAuthSessionDidReceiveRefreshErrorNotification` notification if a refresh
 * token cannot be exchanged for a new set of tokens (for example if it has been revoked or is expired)
 *
 * @param expiredAccessToken The access token that expired.
 */
- (void)performRefreshTokenGrant:(NSString *)expiredAccessToken withCompletionBlock:(void(^)(BOXOAuth2Session *session, NSError *error))block;

#pragma mark Token Helpers
/** @name Token Helpers */

/**
 * Copies tokens from the given parameter's session to the current session instance.
 *
 * @param session The session to copy tokens from.
 */
- (void)reassignTokensFromSession:(BOXOAuth2Session *)session;

@end
