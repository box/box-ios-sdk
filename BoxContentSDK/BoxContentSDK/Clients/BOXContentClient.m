//
//  BOXContentClient.m
//  BoxContentSDK
//
//  Created by Scott Liu on 11/4/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXContentClient_Private.h"
#import "BOXContentClient+Authentication.h"
#import "BOXAPIQueueManager.h"
#import "BOXContentSDKConstants.h"
#import "BOXParallelOAuth2Session.h"
#import "BOXAppUserSession.h"
#import "BOXParallelAPIQueueManager.h"
#import "BOXUser.h"
#import "BOXRequestWithSharedLinkHeader.h"
#import "BOXSharedItemRequest.h"
#import "BOXSharedLinkHeadersHelper.h"
#import "BOXSharedLinkHeadersDefaultManager.h"
#import "BOXContentSDKErrors.h"
#import "BOXRequest_Private.h"
#import "BOXUserRequest.h"
#import "BOXContentClient+User.h"
#import "BOXURLSessionManager.h"

// Default API URLs
/*
 NOTE:  Currently when unversioned URLs are derived from the base URL,
        it removes the last component of the URL path if and only if
        the component begins with a number.
        (e.g. "https://api.box.com/2.0" shortens to "https://api.box.com")
        If we change the base URL to not end with the API version,
        or change the API version to begin with a non-numerical character,
        the "baseURLWithoutVersion" implementation will need to be updated
        as well.
*/
NSString *const BOXDefaultAPIBaseURL = @"https://api.box.com/2.0";
NSString *const BOXDefaultOAuth2BaseURL = @"https://api.box.com/oauth2";
NSString *const BOXDefaultAPIAuthBaseURL = @"https://account.box.com/api";
NSString *const BOXDefaultAPIUploadBaseURL = @"https://upload.box.com/api/2.1";
NSString *const BOXContentClientBackgroundTempFolder = @"TempBackgroundContentClient";
NSString *const BOXSessionManagerCacheClientFolder = @"SessionManagerCacheClient";

@interface BOXContentClient ()

@property (nonatomic, readwrite, strong) BOXSharedLinkHeadersHelper *sharedLinksHeaderHelper;

@property (nonnull, nonatomic, readwrite, copy) ServerAuthFetchTokenBlock fetchTokenBlock;

+ (void)resetInstancesForTesting;

@end

@implementation BOXContentClient

@synthesize OAuth2Session = _OAuth2Session;
@synthesize appSession = _appSession;
@synthesize queueManager = _queueManager;

static NSString *staticAPIBaseURL;
static NSString *staticAPIBaseURLWithoutVersion;
static NSString *staticOAuth2BaseURL;
static NSString *staticAPIAuthBaseURL;
static NSString *staticAPIUploadBaseURL;
static NSString *staticClientID;
static NSString *staticClientSecret;
static NSString *staticRedirectURIString;
static BOOL staticAppToAppBoxAuthenticationEnabled = NO;
static NSMutableDictionary *_SDKClients;
static dispatch_once_t onceTokenForDefaultClient = 0;
static BOXContentClient *defaultInstance = nil;

+ (BOXContentClient *)defaultClient
{
    dispatch_once(&onceTokenForDefaultClient, ^{
        if (defaultInstance == nil) {
            NSArray *storedUsers = [self users];
            if (storedUsers.count > 1)
            {
                [NSException raise:@"You cannot use 'defaultClient' if multiple users have established a session."
                            format:@"Specify a user through clientForUser:"];
            }
            else if (storedUsers.count == 1)
            {
                id<UniqueSDKUser> storedUser = [storedUsers firstObject];
                defaultInstance = [[[self class] SDKClients] objectForKey:storedUser.uniqueId];
                if (defaultInstance == nil) {
                    defaultInstance = [[self alloc] initWithBOXUser:storedUser];
                    [[[self class] SDKClients] setObject:defaultInstance forKey:storedUser.uniqueId];
                }
            }
            else
            {
                defaultInstance = [[self alloc] init];
            }
        }
    });
    return defaultInstance;
}

+ (void)refreshDefaultClientFromKeychain
{
    NSArray *usersFromKeychain = [BOXAbstractSession usersInKeychain];
    
    if (usersFromKeychain.count == 0)
    {
        [defaultInstance logOut];
    }
    else if (usersFromKeychain.count == 1)
    {
        id<UniqueSDKUser> storedUser = [usersFromKeychain firstObject];
        [defaultInstance.session restoreCredentialsFromKeychainForUserWithID:storedUser.uniqueId];
    }
    else {
        [NSException raise:@"You cannot use 'defaultClient' if multiple users have established a session."
                    format:@"Specify a user through clientForUser:"];
    }
}

+ (BOXContentClient *)clientForNewSession
{
    return [[self alloc] init];
}

+ (BOXContentClient *)clientForUser:(BOXUserMini *)user
{
    if (user == nil)
    {
        return [self clientForNewSession];
    }
    
    static NSString *synchronizer = @"synchronizer";
    @synchronized(synchronizer)
    {
        BOXContentClient *client = [[[self class] SDKClients] objectForKey:user.uniqueId];
        
        if (client == nil) {
            client = [[self alloc] initWithBOXUser:user];
            [[[self class] SDKClients] setObject:client forKey:user.uniqueId];
        }
        
        return client;
    }
}

+ (BOXContentClient *)clientForServerAuthUser:(nonnull ServerAuthUser *)serverAuthUser
                                 initialToken:(nullable NSString *)token
                          fetchTokenBlockInfo:(nullable NSDictionary *)fetchTokenBlockInfo
                              fetchTokenBlock:(nonnull ServerAuthFetchTokenBlock)fetchTokenBlock
{
    BOXContentClient *client = [BOXContentClient clientForNewSession];
    
    [client setAccessTokenDelegate:client serverAuthUser:serverAuthUser];
    [client session].credentialsPersistenceEnabled = NO;
    [client session].accessToken = token;
    
    client.fetchTokenBlockInfo = fetchTokenBlockInfo;
    client.fetchTokenBlock = fetchTokenBlock;
    
    return client;
}

+ (void)setClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret
{
    if (clientID.length == 0) {
        [NSException raise:@"Invalid client ID." format:@"%@ is not a valid client ID", clientID];
        return;
    }
    if (clientSecret.length == 0) {
        [NSException raise:@"Invalid client secret." format:@"%@ is not a valid client secret", clientSecret];
        return;
    }
    if (staticClientID.length > 0 && ![staticClientID isEqualToString:clientID]) {
        [NSException raise:@"Changing the client ID is not allowed." format:@"Cannot change client ID from %@ to %@", staticClientID, clientID];
        return;
    }
    if (staticClientSecret.length > 0 && ![staticClientSecret isEqualToString:clientSecret]) {
        [NSException raise:@"Changing the client secret is not allowed." format:@"Cannot change client secret from %@ to %@", staticClientSecret, clientSecret];
        return;
    }
    
    staticClientID = clientID;
    staticClientSecret = clientSecret;
}

+ (void)setClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret redirectURIString:(NSString *)redirectURIString
{
    [self setClientID:clientID clientSecret:clientSecret];
    
    if (staticRedirectURIString.length > 0 && ![staticRedirectURIString isEqualToString:redirectURIString]) {
        [NSException raise:@"Changing the redirect uri is not allowed." format:@"Cannot change redirect uri from %@ to %@", staticRedirectURIString, redirectURIString];
        return;
    }
    
    if (redirectURIString.length > 0) {
        staticRedirectURIString = redirectURIString;
    }
}

+ (void)setAppToAppBoxAuthenticationEnabled:(BOOL)enabled
{
    staticAppToAppBoxAuthenticationEnabled = enabled;
}

- (instancetype)init
{
    if (self = [super init])
    {
        // the circular reference between the queue manager and the session is necessary
        // because sessions enqueue API operations to fetch access tokens and the queue
        // manager uses the session as a lock object when enqueuing operations.
        _queueManager = [[BOXParallelAPIQueueManager alloc] init];

        _urlSessionManager = [BOXURLSessionManager sharedInstance];

        _OAuth2Session = [[BOXParallelOAuth2Session alloc] initWithClientID:staticClientID
                                                                     secret:staticClientSecret
                                                               queueManager:_queueManager
                                                          urlSessionManager:_urlSessionManager];
        _queueManager.session = self.session;
        
        if (staticRedirectURIString.length > 0) {
            _OAuth2Session.redirectURIString = staticRedirectURIString;
        }
        
        // Initialize our sharedlink helper with the default protocol implementation
        _sharedLinksHeaderHelper = [[BOXSharedLinkHeadersHelper alloc] initWithClient:self];
        [self setSharedLinkStorageDelegate:[[BOXSharedLinkHeadersDefaultManager alloc] init]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveSessionDidBecomeAuthenticatedNotification:)
                                                     name:BOXSessionDidBecomeAuthenticatedNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveSessionWasRevokedNotification:)
                                                     name:BOXSessionWasRevokedNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveUserWasLoggedOutNotification:)
                                                     name:BOXUserWasLoggedOutDueToErrorNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveAccessTokenRefreshedNotification:)
                                                     name:BOXSessionDidRefreshTokensNotification
                                                   object:nil];
    }
    return self;
}

- (instancetype)initWithBOXUser:(id<UniqueSDKUser>)user
{
    //this will only be called internally when we're dealing with a BOXUserMini instance of user, not with a ServerAuthUser
    if (self = [self init])
    {
        [self.session restoreCredentialsFromKeychainForUserWithID:user.uniqueId];
    }
    return self;
}

- (void)didReceiveAccessTokenRefreshedNotification:(NSNotification *)notification
{
    BOXAbstractSession *session = nil;
    // Separate assignment to avoid an unused variable warning in release builds
    session = (BOXAbstractSession *)notification.object;
    if ([self.session isEqual: session]) {
        BOXAssert(!self.user.uniqueId || !session.user.uniqueId || [self.user.uniqueId isEqualToString:session.user.uniqueId], @"ClientUser: %@, does not match Session User: %@", self.user.uniqueId, session.user.uniqueId);
    }
}

- (void)didReceiveUserWasLoggedOutNotification:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *userInfo = (NSDictionary *)notification.object;
        NSString *userID = [userInfo objectForKey:BOXUserIDKey];
        if ([userID isEqualToString:self.user.uniqueId]) {
            [self logOut];
        }
    }
}

- (void)didReceiveSessionDidBecomeAuthenticatedNotification:(NSNotification *)notification
{
    // We should never have more than one session pointing to the same user.
    // When a session becomes authenticated, any SDK clients that may have had a session for the same
    // user should update to the most recently authenticated one.
    BOXAbstractSession *session = (BOXAbstractSession *)notification.object;
    
    if ([session.user.uniqueId isEqualToString:self.session.user.uniqueId] && session != self.session) {
        // In case there are any pending operations in the old session's queue, give them the latest tokens so they have
        // a good chance of succeeding.
        [self.session reassignTokensFromSession:session];
        
        self.session = session;
        self.queueManager = self.session.queueManager;
    }
}

- (void)didReceiveSessionWasRevokedNotification:(NSNotification *)notification
{
    NSString *userIDRevoked = [notification.userInfo objectForKey:BOXUserIDKey];
    if (userIDRevoked.length > 0)
    {
        [[[self class] SDKClients] removeObjectForKey:userIDRevoked];
    }
}

- (void)fetchAccessTokenWithCompletion:(void (^)(NSString *, NSDate *, NSError *))completion
{
    if(_fetchTokenBlock)
    {
        _fetchTokenBlock(self.session.user.uniqueId, _fetchTokenBlockInfo, completion);
    }
    else
    {
        [NSException raise:@"No fetchTokenBlock specified." format:@"You must specify a fetchTokenBlock when using a BOXContentClient configured for server-based auth"];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (NSArray *)users
{
    return [BOXAbstractSession usersInKeychain];
}

- (id<UniqueSDKUser>)user
{
    return self.session.user;
}

- (BOOL)appToAppBoxAuthenticationEnabled
{
    return staticAppToAppBoxAuthenticationEnabled;
}

- (void)setUserAgentPrefix:(NSString *)userAgentPrefix
{
    _userAgentPrefix = userAgentPrefix;
    self.session.userAgentPrefix = _userAgentPrefix;
}

// Load the ressources bundle.
+ (NSBundle *)resourcesBundle
{
    static NSBundle *frameworkBundle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSURL *ressourcesBundleURL = [[NSBundle mainBundle] URLForResource:@"BoxContentSDKResources" withExtension:@"bundle"];
        frameworkBundle = [NSBundle bundleWithURL:ressourcesBundleURL];
    });

    return frameworkBundle;
}

- (void)setSharedLinkStorageDelegate:(id <BOXSharedLinkStorageProtocol>)delegate
{
    self.sharedLinksHeaderHelper.delegate = delegate;
}

- (BOXAbstractSession *)session
{
    if (self.OAuth2Session) {
        return self.OAuth2Session;
    } else {
        return self.appSession;
    }
}

- (void)setSession:(BOXAbstractSession *)session
{
    if ([session isKindOfClass:[BOXOAuth2Session class]]) {
        _OAuth2Session = (BOXOAuth2Session *)session;
        _appSession = nil;
    } else {
        _appSession = (BOXAppUserSession *)session;
        _OAuth2Session = nil;
    }
    self.queueManager.session = self.session;
}

- (void)setUpTemporaryCacheDirectory:(NSString *)folderPath
{
    BOOL success = YES;
    
    NSString *tempPath = [folderPath stringByAppendingPathComponent:BOXContentClientBackgroundTempFolder];
    if(![[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
        NSError * error = nil;
        
        success = [[NSFileManager defaultManager] createDirectoryAtPath:tempPath
                                                 withIntermediateDirectories:YES
                                                                  attributes:nil
                                                                       error:&error];
    }
    if (success == YES) {
        _tempCacheDir = tempPath;
    } else {
        _tempCacheDir = nil;
    }
}

- (NSString*)tempCacheDir
{
    BOOL success = YES;
    
    if (_tempCacheDir == nil) {
        _tempCacheDir = [NSTemporaryDirectory() stringByAppendingPathComponent:BOXContentClientBackgroundTempFolder];
        if(![[NSFileManager defaultManager] fileExistsAtPath:_tempCacheDir]) {
            NSError * error = nil;
            
            success = [[NSFileManager defaultManager] createDirectoryAtPath:_tempCacheDir
                                                withIntermediateDirectories:YES
                                                                 attributes:nil
                                                                      error:&error];
        }
        if (success == NO) {
            _tempCacheDir = NSTemporaryDirectory();
        }
    }
    
    return _tempCacheDir;
}

#pragma mark - access token delegate
- (id<BOXAPIAccessTokenDelegate>)accessTokenDelegate
{
    return self.queueManager.delegate;
}

- (void)setAccessTokenDelegate:(id<BOXAPIAccessTokenDelegate>)accessTokenDelegate
                serverAuthUser:(ServerAuthUser *)serverAuthUser
{
    BOXAssert(self.OAuth2Session.refreshToken == nil, @"BOXContentClients that use OAuth2 cannot have a delegate set.");
    BOXAssert(accessTokenDelegate != nil, @"delegate must be non-nil when calling setAccessTokenDelegate:");
    
    // Switch from OAuth2Session to AppUserSession
    // Since BOXContentClient instances are defaulted to OAuth2 instead of App Users, a BOXAppUserSession must be initialized.
    // The OAuth2Session must be nil-ed out because "session" returns the first non-nil session instance (chosen between AppSession and OAuth2Session).
    if ([self.session isKindOfClass:[BOXOAuth2Session class]]) {
        self.session = [[BOXAppUserSession alloc] initWithQueueManager:self.queueManager
                                                     urlSessionManager:self.urlSessionManager
                                                        serverAuthUser:serverAuthUser];
        
        self.session.userAgentPrefix = self.userAgentPrefix;
    }
    
    // Since the OAuth2Session instance was nil-ed out, the queueManager now needs a new session instance which will be appSession.
    self.queueManager.delegate = accessTokenDelegate;
}

# pragma mark - background tasks support

+ (void)oneTimeSetUpInAppToSupportBackgroundTasksWithDelegate:(id<BOXURLSessionManagerDelegate>)delegate rootCacheDir:(nonnull NSString *)rootCacheDir completion:(void (^)(NSError *error))completionBlock;
{
    [[BOXContentClient defaultClient] setUpTemporaryCacheDirectory:rootCacheDir];
    rootCacheDir = [rootCacheDir stringByAppendingPathComponent:BOXSessionManagerCacheClientFolder];
    [[BOXURLSessionManager sharedInstance] oneTimeSetUpInAppToSupportBackgroundTasksWithDelegate:delegate rootCacheDir:rootCacheDir completion:completionBlock];
}

+ (void)oneTimeSetUpInExtensionToSupportBackgroundTasksWithDelegate:(id<BOXURLSessionManagerDelegate>)delegate rootCacheDir:(nonnull NSString *)rootCacheDir sharedContainerIdentifier:(NSString *)sharedContainerIdentifier completion:(void (^)(NSError *error))completionBlock;
{
    
    [[BOXContentClient defaultClient] setUpTemporaryCacheDirectory:rootCacheDir];
    rootCacheDir = [rootCacheDir stringByAppendingPathComponent:BOXSessionManagerCacheClientFolder];
    [[BOXURLSessionManager sharedInstance] oneTimeSetUpInExtensionToSupportBackgroundTasksWithDelegate:delegate
                                                                                          rootCacheDir:rootCacheDir
                                                                             sharedContainerIdentifier:sharedContainerIdentifier
                                                                                            completion:completionBlock];
}

+ (void)reconnectWithBackgroundSessionIdFromExtension:(NSString *)backgroundSessionId completion:(void (^)(NSError *error))completionBlock;
{
    [[BOXURLSessionManager sharedInstance] reconnectWithBackgroundSessionIdFromExtension:backgroundSessionId completion:completionBlock];
}

#pragma mark - helper methods

- (void)prepareRequest:(BOXRequest *)request
{
    //Note: Queue Manager and Cache Client are from the BOXRequest_private header
    request.queueManager = self.queueManager;
    request.cacheClient = self.cacheClient;
    request.userAgentPrefix = self.userAgentPrefix;

    if ([request conformsToProtocol:@protocol(BOXSharedLinkItemSource)]) {
        BOXRequestWithSharedLinkHeader *requestWithSharedLink = (BOXRequestWithSharedLinkHeader *)request;
        requestWithSharedLink.sharedLinkHeadersHelper = self.sharedLinksHeaderHelper;
    } else if ([request isKindOfClass:[BOXSharedItemRequest class]]) {
        BOXSharedItemRequest *shareItemRequest = (BOXSharedItemRequest *)request;
        shareItemRequest.sharedLinkHeadersHelper = self.sharedLinksHeaderHelper;
    }
    
    if (self.OAuth2Session.refreshToken && (self.OAuth2Session.clientID.length == 0 || self.OAuth2Session.clientSecret.length == 0)) {
        [NSException raise:@"Set client ID and client secret first." format:@"You must set a client ID and client secret first."];
    }
}

+ (NSMutableDictionary *)SDKClients
{
    if (_SDKClients == nil) {
        _SDKClients = [NSMutableDictionary dictionary];
    }
    return _SDKClients;
}

+ (void)resetInstancesForTesting
{
    defaultInstance = nil;
    onceTokenForDefaultClient = 0;
    [_SDKClients removeAllObjects];
}

#pragma mark - API URLs

+ (NSString *)APIBaseURL
{
    if (staticAPIBaseURL.length == 0) {
        staticAPIBaseURL = BOXDefaultAPIBaseURL;
    }
    return staticAPIBaseURL;
}

//NOTE: Right now we assume that version-portion of the URL string is specified by the last component in the URL path and it also starts with a number
+ (NSString *)APIBaseURLWithoutVersion
{
    if (staticAPIBaseURLWithoutVersion.length == 0) {
        NSString *versionedURL = [BOXContentClient APIBaseURL];
        NSString *unversionedURL = nil;
        NSString *lastComponent = [versionedURL lastPathComponent];
        if (lastComponent.length > 0 && isnumber([lastComponent characterAtIndex:0])) {
            //NOTE: NSString's stringByDeletingLastPathComponent also deletes a slash in "https://" so was not suitable here
            NSRange range = [versionedURL rangeOfString: lastComponent options:NSBackwardsSearch];
            unversionedURL = [versionedURL substringToIndex:range.location];
        }
        else {
            unversionedURL = versionedURL;
        }
        staticAPIBaseURLWithoutVersion = unversionedURL;
    }
    return staticAPIBaseURLWithoutVersion;
}

+ (NSString *)OAuth2BaseURL
{
    if (staticOAuth2BaseURL.length == 0) {
        staticOAuth2BaseURL = BOXDefaultOAuth2BaseURL;
    }
    return staticOAuth2BaseURL;
}

+ (NSString *)APIAuthBaseURL
{
    if (staticAPIAuthBaseURL.length == 0) {
        staticAPIAuthBaseURL = BOXDefaultAPIAuthBaseURL;
    }
    return staticAPIAuthBaseURL;
}

+ (NSString *)APIUploadBaseURL
{
    if (staticAPIUploadBaseURL.length == 0) {
        staticAPIUploadBaseURL = BOXDefaultAPIUploadBaseURL;
    }
    return staticAPIUploadBaseURL;
}

+ (void)setAPIBaseURL:(NSString *)APIBaseURL
{
    staticAPIBaseURL = APIBaseURL;
    staticAPIBaseURLWithoutVersion = nil;
}

+ (void)setOAuth2BaseURL:(NSString *)OAuth2BaseURL
{
    staticOAuth2BaseURL = OAuth2BaseURL;
}

+ (void)setAPIAuthBaseURL:(NSString *)APIAuthBaseURL
{
    staticAPIAuthBaseURL = APIAuthBaseURL;
}

+ (void)setAPIUploadBaseURL:(NSString *)APIUploadBaseURL
{
    staticAPIUploadBaseURL = APIUploadBaseURL;
}


@end
