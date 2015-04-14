//
//  BOXOAuth2Session.m
//  BoxContentSDK
//
//  Created on 2/21/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXOAuth2Session.h"
#import "BOXLog.h"
#import "BOXContentSDKConstants.h"
#import "BOXContentSDKErrors.h"
#import "BOXAPIOAuth2ToJSONOperation.h"
#import "NSString+BOXURLHelper.h"
#import "NSURL+BOXURLHelper.h"
#import "BOXKeychainItemWrapper.h"
#import "BOXUserRequest.h"
#import "BOXUser_Private.h"
#import "NSDate+BOXAdditions.h"

#define keychainDefaultIdentifierPrefix @"BoxCredential_"
#define keychainDefaultAccessGroup nil
#define keychainUserIDKey @"user_id"
#define keychainUserLoginKey @"user_login"
#define keychainUserNameKey @"user_name"
#define keychainRefreshTokenKey @"refresh_token"
#define keychainAccessTokenKey @"access_token"
#define keychainAccessTokenExpirationKey @"access_token_expiration"

NSString *const BOXOAuth2SessionDidBecomeAuthenticatedNotification = @"BOXOAuth2SessionDidBecomeAuthenticated";
NSString *const BOXOAuth2SessionDidReceiveAuthenticationErrorNotification = @"BOXOAuth2SessionDidReceiveAuthenticationError";
NSString *const BOXOAuth2SessionDidRefreshTokensNotification = @"BOXOAuth2SessionDidRefreshTokens";
NSString *const BOXOAuth2SessionDidReceiveRefreshErrorNotification = @"BOXOAuth2SessionDidReceiveRefreshError";
NSString *const BOXOAuth2SessionWasRevokedNotification = @"BOXOAuth2SessionWasRevokeSession";

NSString *const BOXOAuth2AuthenticationErrorKey = @"BOXOAuth2AuthenticationError";
NSString *const BOXOAuth2UserIDKey = @"BOXOAuth2UserID";

static NSString *staticKeychainIdentifierPrefix;
static NSString *staticKeychainAccessGroup;

@implementation BOXOAuth2Session

@synthesize APIBaseURLString = _APIBaseURLString;
@synthesize clientID = _clientID;
@synthesize clientSecret = _clientSecret;
@synthesize accessToken = _accessToken;
@synthesize refreshToken = _refreshToken;
@synthesize accessTokenExpiration = _accessTokenExpiration;
@synthesize queueManager = _queueManager;

#pragma mark - Initialization

- (instancetype)init
{
    if (self = [super init]) {
        _credentialsPersistenceEnabled = YES;
    }
    return self;
}

- (instancetype)initWithClientID:(NSString *)ID secret:(NSString *)secret APIBaseURL:(NSString *)baseURL queueManager:(BOXAPIQueueManager *)queueManager
{
    self = [self init];
    if (self != nil)
    {
        _clientID = ID;
        _clientSecret = secret;
        _APIBaseURLString = baseURL;
        _queueManager = queueManager;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveOAuth2RevokeSessionNotification:)
                                                     name:BOXOAuth2SessionWasRevokedNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Authorization
- (void)performAuthorizationCodeGrantWithReceivedURL:(NSURL *)URL withCompletionBlock:(void (^)(BOXOAuth2Session *session, NSError *error))block
{
    NSDictionary *URLQueryParams = [URL box_queryDictionary];
    NSString *authorizationCode = [URLQueryParams valueForKey:BOXOAuth2URLParameterAuthorizationCodeKey];
    NSString *authorizationError = [URLQueryParams valueForKey:BOXOAuth2URLParameterErrorCodeKey];

    if (authorizationError != nil)
    {
        NSInteger errorCode = BOXContentSDKAPIErrorUnknownStatusCode;
        if ([authorizationError isEqualToString:BOXOAuth2ErrorAccessDenied]) {
            errorCode = BOXContentSDKAPIErrorUserDeniedAccess;
        }
        NSError *error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:errorCode userInfo:nil];
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:error
                                                              forKey:BOXOAuth2AuthenticationErrorKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:BOXOAuth2SessionDidReceiveAuthenticationErrorNotification
                                                            object:self
                                                          userInfo:errorInfo];
        if (block) {
            block(nil, error);
        }
        return;
    }


    NSDictionary *POSTParams = @{
                                 BOXOAuth2TokenRequestGrantTypeKey : BOXOAuth2TokenRequestGrantTypeAuthorizationCode,
                                 BOXOAuth2TokenRequestAuthorizationCodeKey : authorizationCode,
                                 BOXOAuth2TokenRequestClientIDKey : self.clientID,
                                 BOXOAuth2TokenRequestClientSecretKey : self.clientSecret,
                                 BOXOAuth2TokenRequestRedirectURIKey : self.redirectURIString,
                                 };

    BOXAPIOAuth2ToJSONOperation *operation = [[BOXAPIOAuth2ToJSONOperation alloc] initWithURL:[self grantTokensURL]
                                                                                   HTTPMethod:BOXAPIHTTPMethodPOST
                                                                                         body:POSTParams
                                                                                  queryParams:nil
                                                                                OAuth2Session:self];

    operation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary)
    {
        self.accessToken = [JSONDictionary valueForKey:BOXOAuth2TokenJSONAccessTokenKey];
        self.refreshToken = [JSONDictionary valueForKey:BOXOAuth2TokenJSONRefreshTokenKey];
        
        NSTimeInterval accessTokenExpiresIn = [[JSONDictionary valueForKey:BOXOAuth2TokenJSONExpiresInKey] integerValue];
        BOXAssert(accessTokenExpiresIn >= 0, @"accessTokenExpiresIn value is negative");
        self.accessTokenExpiration = [NSDate dateWithTimeIntervalSinceNow:accessTokenExpiresIn];
        
        BOXUserRequest *userRequest = [[BOXUserRequest alloc] init];
        userRequest.queueManager = self.queueManager;
        [userRequest performRequestWithCompletion:^(BOXUser *user, NSError *error) {
            if (user && !error)
            {
                _user = [[BOXUserMini alloc] initWithUserID:user.modelID name:user.name login:user.login];
                [self storeCredentialsToKeychain];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BOXOAuth2SessionDidBecomeAuthenticatedNotification object:self];
                
                if (block)
                {
                    block(self, nil);
                }
            }
            else
            {
                if (block)
                {
                    block(self, error);
                }
            }
        }];
    };

    operation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary)
    {
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:error
                                                              forKey:BOXOAuth2AuthenticationErrorKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:BOXOAuth2SessionDidReceiveAuthenticationErrorNotification
                                                            object:self
                                                          userInfo:errorInfo];
        
        if (block) {
            block(self, error);
        }
    };

    [self.queueManager enqueueOperation:operation];
}

- (NSURL *)authorizeURL
{
    NSString *encodedRedirectURI = [NSString box_stringWithString:self.redirectURIString URLEncoded:YES];
    NSString *authorizeURLString = [NSString stringWithFormat:
                                    @"%@/oauth2/authorize?response_type=code&client_id=%@&state=ok&redirect_uri=%@",
                                    self.APIBaseURLString, self.clientID, encodedRedirectURI];
    return [NSURL URLWithString:authorizeURLString];
}

- (NSURL *)grantTokensURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth2/token", self.APIBaseURLString]];
}

- (NSString *)redirectURIString
{
    return [NSString stringWithFormat:@"boxsdk-%@://boxsdkoauth2redirect", self.clientID];
}

#pragma mark - Token Refresh
- (void)performRefreshTokenGrant:(NSString *)expiredAccessToken withCompletionBlock:(void (^)(BOXOAuth2Session *session, NSError *error))block
{
    BOXAbstract();
}

#pragma mark - Session info
- (BOOL)isAuthorized
{
    NSDate *now = [NSDate date];
    return [self.accessTokenExpiration timeIntervalSinceDate:now] > 0;
}

#pragma mark - Request Authorization
- (void)addAuthorizationParametersToRequest:(NSMutableURLRequest *)request
{
    NSString *bearerToken = [NSString stringWithFormat:@"Bearer %@", self.accessToken];
    [request addValue:bearerToken forHTTPHeaderField:BOXAPIHTTPHeaderAuthorization];
}

#pragma mark - Keychain

+ (void)setKeychainIdentifierPrefix:(NSString *)keychainIdentifierPrefix
{
    staticKeychainIdentifierPrefix = keychainIdentifierPrefix;
}

+ (NSString *)keychainIdentifierPrefix
{
    if (staticKeychainIdentifierPrefix.length == 0) {
        return keychainDefaultIdentifierPrefix;
    } else {
        return staticKeychainIdentifierPrefix;
    }
}

+ (void)setKeychainAccessGroup:(NSString *)keychainAccessGroup
{
    staticKeychainAccessGroup = keychainAccessGroup;
}

+ (NSString *)keychainAccessGroup
{
    if (staticKeychainAccessGroup.length == 0) {
        return keychainDefaultAccessGroup;
    } else {
        return staticKeychainAccessGroup;
    }
}

+ (NSString *)keychainIdentifierForUserWithID:(NSString *)userID
{
    NSString *identifier = [[self keychainIdentifierPrefix] stringByAppendingString:userID];
    return identifier;
}

+ (NSString *)userIDFromKeychainIdentifier:(NSString *)identifier
{
    NSString *userID = [identifier stringByReplacingOccurrencesOfString:[self keychainIdentifierPrefix] withString:@""];
    return userID;
}

+ (BOXKeychainItemWrapper *)keychainItemWrapperForUserWithID:(NSString *)userID
{
    NSString *identifier = [self keychainIdentifierForUserWithID:userID];
    NSString *accessGroup = [self keychainAccessGroup];
    BOXKeychainItemWrapper *keychainItemWrapper = [[BOXKeychainItemWrapper alloc] initWithIdentifier:identifier accessGroup:accessGroup];
    return keychainItemWrapper;
}

- (void)storeCredentialsToKeychain
{
    if (self.credentialsPersistenceEnabled) {
        NSDictionary *dictionary = @{keychainUserIDKey : self.user.modelID,
                                     keychainUserNameKey : self.user.name,
                                     keychainUserLoginKey : self.user.login,
                                     keychainRefreshTokenKey:self.refreshToken,
                                     keychainAccessTokenKey:self.accessToken,
                                     keychainAccessTokenExpirationKey:[self.accessTokenExpiration box_ISO8601String]};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        BOXKeychainItemWrapper *keychainItemWrapper = [[self class]keychainItemWrapperForUserWithID:self.user.modelID];
        [keychainItemWrapper resetKeychainItem];
        [keychainItemWrapper setObject:jsonString forKey:(__bridge id)kSecValueData];
    }
}

- (void)restoreCredentialsFromKeychainForUserWithID:(NSString *)userID
{
    if (self.credentialsPersistenceEnabled) {
        NSString *jsonString = [[[self class] keychainItemWrapperForUserWithID:userID] objectForKey:(__bridge id)kSecValueData];
        NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        if (!error) {
            NSString *userIDFromKeychain = [dictionary objectForKey:keychainUserIDKey];
            NSString *userNameFromKeychain = [dictionary objectForKey:keychainUserNameKey];
            NSString *userLoginFromKeychain = [dictionary objectForKey:keychainUserLoginKey];
            NSString *accessTokenFromKeychain = [dictionary objectForKey:keychainAccessTokenKey];
            NSString *accessTokenExpirationAsStringFromKeychain = [dictionary objectForKey:keychainAccessTokenExpirationKey];
            NSString *refreshTokenFromKeychain = [dictionary objectForKey:keychainRefreshTokenKey];
            
            if (userIDFromKeychain.length > 0 &&
                userLoginFromKeychain.length > 0 &&
                accessTokenFromKeychain.length > 0 &&
                accessTokenExpirationAsStringFromKeychain != nil &&
                refreshTokenFromKeychain.length > 0)
            {
                _user = [[BOXUserMini alloc] initWithUserID:userIDFromKeychain
                                                       name:userNameFromKeychain
                                                      login:userLoginFromKeychain];
                
                self.refreshToken = refreshTokenFromKeychain;
                self.accessToken = accessTokenFromKeychain;
                self.accessTokenExpiration = [NSDate box_dateWithISO8601String:accessTokenExpirationAsStringFromKeychain];
            }
        }
    }
}

- (void)revokeCredentials
{
    NSString *userID = self.user.modelID;
    if (userID.length > 0)
    {
        BOXKeychainItemWrapper *keychainWrapper = [[self class] keychainItemWrapperForUserWithID:self.user.modelID];
        [keychainWrapper resetKeychainItem];
        
        self.accessToken = nil;
        self.accessTokenExpiration = nil;
        self.refreshToken = nil;
        _user = nil;
        
        // There may be other instances of BOXOAuth2Session that are linked to this account. Let them know that they need to wipe credentials as well.
        // (see didReceiveOAuth2RevokeSessionNotification:)
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:BOXOAuth2SessionWasRevokedNotification
                                                                                             object:nil
                                                                                           userInfo:@{BOXOAuth2UserIDKey : userID}]];
    }
}

+ (void)revokeAllCredentials
{
    NSArray *users = [self usersInKeychain];
    for (BOXUserMini *user in users)
    {
        if (user.modelID.length > 0)
        {
            BOXKeychainItemWrapper *keychainWrapper = [self keychainItemWrapperForUserWithID:user.modelID];
            [keychainWrapper resetKeychainItem];
            
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:BOXOAuth2SessionWasRevokedNotification
                                                                                                 object:nil
                                                                                               userInfo:@{BOXOAuth2UserIDKey : user.modelID}]];
        }
    }
}

- (void)didReceiveOAuth2RevokeSessionNotification:(NSNotification *)notification
{
    NSString *userIDRevoked = [notification.userInfo objectForKey:BOXOAuth2UserIDKey];
    if ([userIDRevoked isEqualToString:self.user.modelID])
    {
        BOXKeychainItemWrapper *keychainWrapper = [[self class] keychainItemWrapperForUserWithID:self.user.modelID];
        [keychainWrapper resetKeychainItem];
        
        self.accessToken = nil;
        self.accessTokenExpiration = nil;
        self.refreshToken = nil;
        _user = nil;
    }
}

+ (NSArray *)usersInKeychain
{
    NSMutableArray *users = [NSMutableArray array];
    
    // Query the keychain for entries with an identifier that has our keychainIdentifierPrefix.
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionaryWithDictionary:@{(__bridge id)kSecReturnAttributes : (__bridge id)kCFBooleanTrue,
                                                                                         (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitAll,
                                                                                         (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword}];
    
    #if ! TARGET_IPHONE_SIMULATOR
    // Ignore the access group if running on the iPhone simulator.
    // Apps that are built for the simulator aren't signed, so there's no keychain access group
    // for the simulator to check.
    if ([self keychainAccessGroup].length > 0) {
        [keychainQuery setObject:[self keychainAccessGroup] forKey:(__bridge id)kSecAttrAccessGroup];
    }
    #endif
    
    CFArrayRef keychainQueryResult = NULL;
    OSStatus queryStatus =  SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keychainQueryResult);
    if (queryStatus == 0 && keychainQueryResult != NULL)
    {
        NSArray* keychainEntries = (__bridge_transfer NSArray*)keychainQueryResult;
        for (NSDictionary *dict in keychainEntries)
        {
            NSString *keychainIdentifier = [dict objectForKey:((__bridge NSString *)kSecAttrGeneric)];
            if ([keychainIdentifier hasPrefix:[self keychainIdentifierPrefix]])
            {
                NSString *userID = [self userIDFromKeychainIdentifier:keychainIdentifier];
                if (userID.length > 0)
                {
                    NSString *jsonString = [[self keychainItemWrapperForUserWithID:userID] objectForKey:(__bridge id)kSecValueData];
                    NSError *error = nil;
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
                    NSString *userIDFromKeychain = [dictionary objectForKey:keychainUserIDKey];
                    NSString *userNameFromKeychain = [dictionary objectForKey:keychainUserNameKey];
                    NSString *userLoginFromKeychain = [dictionary objectForKey:keychainUserLoginKey];
                    if ([userID isEqualToString:userIDFromKeychain]) {
                        BOXUserMini *miniUser = [[BOXUserMini alloc] initWithUserID:userIDFromKeychain
                                                                               name:userNameFromKeychain
                                                                              login:userLoginFromKeychain];
                        [users addObject:miniUser];
                    }
                }
            }
        }
    }
    
    NSArray *sortedUsers = [users sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        BOXUserMini *userA = (BOXUserMini *) a;
        BOXUserMini *userB = (BOXUserMini *) b;
        return [userA.login compare:userB.login options:NSCaseInsensitiveSearch];
    }];
    
    return sortedUsers;
}

@end
