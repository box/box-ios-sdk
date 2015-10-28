//
//  BOXClient.h
//  BoxContentSDK
//
//  Copyright (c) 2014 Box. All rights reserved.
//

@class BOXAbstractSession;
@class BOXUser;
@class BOXUserMini;
@class BOXAPIQueueManager;
@class BOXRequest;
@class BOXSharedLinkHeadersHelper;
@protocol BOXAPIAccessTokenDelegate;
@protocol BOXSharedLinkStorageProtocol;
@protocol BOXContentCacheClientProtocol;

@interface BOXContentClient : NSObject

/**
 *  Allows the SDK to associate shared links with Box Items.
 */
@property (nonatomic, readonly, strong) BOXSharedLinkHeadersHelper *sharedLinksHeaderHelper;

/**
 *  By setting the cache client, the BOXContentClient will now support caching for BoxRequests.
 */
@property (nonatomic, readwrite, weak) id<BOXContentCacheClientProtocol> cacheClient;

/**
 * The SDK's session instance.
 */
@property (nonatomic, readonly, strong) BOXAbstractSession *session;

/**
 *  The base URL for all API operations except for Authentication and Upload.
 */
@property (nonatomic, readwrite, strong) NSString *APIBaseURL;

/**
 *  The base URL for all API Authentication operations.
 */
@property (nonatomic, readwrite, strong) NSString *APIAuthBaseURL;

/**
 *  The client's queue manager. All API calls are scheduled by this queue manager.
 *  The queueManager is shared with the session (for making authorization and refresh
 *  calls) and the filesManager and foldersManager (for making API calls).
 */
@property (nonatomic, readwrite, strong) BOXAPIQueueManager *queueManager;

/**
 * This property reflects whether the client should attempt the authentication through the
 * Box app. It's default is NO and has to be set via the +setAppToAppBoxAuthenticationEnabled:
 * because of the associated configuration that has to be done.
 */
@property (nonatomic, readonly, assign) BOOL appToAppBoxAuthenticationEnabled;

/**
 * This property is used to temporarily hold the authentication completion block in the case of
 * App-to-App authentication through the Box app.
 */
@property (nonatomic, readwrite, copy) void (^authenticationCompletionBlock)(BOXUser *user, NSError *error);

/**
 *  The Box user associated with this SDK client. This will be nil if no user has been authenticated yet.
 */
@property (nonatomic, readonly, strong) BOXUserMini *user;

/**
 * The delegate for the BOXContentClient instance. Internally setting the BOXContentClient's delegate
 * will automatically set the BOXAPIQueueManager's delegate and getting the delegate will return the
 * BOXAPIQueueManager's delegate.
 *
 * Allows users to retrieve access tokens in a way that bypasses OAuth2 and uses App Users instead.
 */
@property (nonatomic, readwrite, weak) id<BOXAPIAccessTokenDelegate> accessTokenDelegate;

/**
 *  The list of Box users that have established a session through the SDK.
 *
 *  @return array of BOXUserMini model objects
 */
+ (NSArray *)users;

/**
 *  You may use this to retrieve a content client, only if your app allows for only one Box user to be authenticated at a time.
 *  If your app will support multiple Box users, use clientForUser: and clientForNewSession to retrieve content clients for each user.
 *  Treat this method as a singleton accessor.
 *
 *  @return An existing BOXContentClient if it already exists. Otherwise, a new BOXContentClient wil be created.
 */
+ (BOXContentClient *)defaultClient;

/**
 *  Get a BOXContentClient for a specific user that has an authenticated session. 
 *  You can obtain a list of users with through the 'users' method.
 *  NOTE: Unless you want to allow your app to manage multiple Box users at one time, it is simpler to use
 *  'defaultClient' instead of this method.
 *
 *  @param user A user with an existing session
 *
 *  @return BOXContentClient for the specified user
 */
+ (BOXContentClient *)clientForUser:(BOXUserMini *)user;

/**
 *  Get an unauthenticated BOXContentClient.
 *  NOTE: Unless you want to allow your app to manage multiple Box users at one time, it is simpler to use
 *  'defaultClient' instead of this method.
 *
 *  @return An unauthenticated BOXContentClient
 */
+ (BOXContentClient *)clientForNewSession;

/**
 * Client ID:
 * The client identifier described in [Section 2.2 of the OAuth2 spec](http://tools.ietf.org/html/rfc6749#section-2.2)
 * This is also known as an API key on Box. See the [Box OAuth2 documentation](http://developers.box.com/oauth/) for
 * information on where to find this value.
 *
 * Client Secret:
 * The client secret. This value is used during the authorization code grant and when refreshing tokens.
 * This value should be a secret. DO NOT publish this value.
 * See the [Box OAuth2 documentation](http://developers.box.com/oauth/) for
 * information on where to find this value.
 */
+ (void)setClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret;

/**
 * Client ID:
 * The client identifier described in [Section 2.2 of the OAuth2 spec](http://tools.ietf.org/html/rfc6749#section-2.2)
 * This is also known as an API key on Box. See the [Box OAuth2 documentation](http://developers.box.com/oauth/) for
 * information on where to find this value.
 *
 * Client Secret:
 * The client secret. This value is used during the authorization code grant and when refreshing tokens.
 * This value should be a secret. DO NOT publish this value.
 * See the [Box OAuth2 documentation](http://developers.box.com/oauth/) for
 * information on where to find this value.
 *
 * Redirect UR:
 * If you set a custom Redirect URI in your App's developer settings, set it here too.
 */
+ (void)setClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret redirectURIString:(NSString *)redirectURIString;

/**
 * This property controls whether clients should attempt authentication through the Box app
 * The default is NO and has to be set here because of the associated configuration that
 * has to be done.
 *
 *  @param enabled  Whether the client should attempt using the Box app for authenticating.
 *
 */
+ (void)setAppToAppBoxAuthenticationEnabled:(BOOL)enabled;

/**
 *  Resource bundle for loading images, etc.
 *
 *  @return NSBundle
 */
+ (NSBundle *)resourcesBundle;

/** 
 *  Overides the default sharedLink delegate with the provided object.
 *  By default the SDK persists shared link information in memory only. Override this to implement your own custom persistence logic.
 *  @param delegate The object that will receive the BOXSharedLinkStorageProtocol delegate callbacks.
 **/ 
- (void)setSharedLinkStorageDelegate:(id <BOXSharedLinkStorageProtocol>)delegate;

@end
