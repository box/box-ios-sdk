//
//  BOXAppSession.m
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/3/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXAbstractSession_Private.h"
#import "BOXKeychainItemWrapper.h"
#import "BOXUser.h"
#import "BOXUser_Private.h"

#define keychainDefaultIdentifierPrefix @"BoxCredential_"
#define keychainDefaultAccessGroup nil

NSString *const BOXSessionDidBecomeAuthenticatedNotification = @"BOXSessionDidBecomeAuthenticated";
NSString *const BOXSessionDidReceiveAuthenticationErrorNotification = @"BOXSessionDidReceiveAuthenticationError";
NSString *const BOXSessionDidRefreshTokensNotification = @"BOXSessionDidRefreshTokens";
NSString *const BOXSessionDidReceiveRefreshErrorNotification = @"BOXSessionDidReceiveRefreshError";
NSString *const BOXSessionWasRevokedNotification = @"BOXSessionWasRevokeSession";

NSString *const BOXAuthenticationErrorKey = @"BOXAuthenticationError";
NSString *const BOXUserIDKey = @"BOXUserID";

static NSString *staticKeychainIdentifierPrefix;
static NSString *staticKeychainAccessGroup;

@interface BOXAbstractSession ()

@end

@implementation BOXAbstractSession

- (instancetype)init
{
    if (self = [super init]) {
        _credentialsPersistenceEnabled = YES;
    }
    
    return self;
}

- (instancetype)initWithAPIBaseURL:(NSString *)baseURL queueManager:(BOXAPIQueueManager *)queueManager
{
    if ([self init])
    {
        _APIBaseURLString = baseURL;
        _queueManager = queueManager;
    }
    
    return self;
}

#pragma mark - Access Token Authorization

- (void)performAuthorizationCodeGrantWithReceivedURL:(NSURL *)URL withCompletionBlock:(void (^)(BOXAbstractSession *, NSError *))block
{
    BOXAbstract();
}

#pragma mark - Token Refresh

- (void)performRefreshTokenGrant:(NSString *)expiredAccessToken withCompletionBlock:(void (^)(BOXAbstractSession *, NSError *))block
{
    BOXAbstract();
}

#pragma mark - Token Helpers

- (void)reassignTokensFromSession:(BOXAbstractSession *)session
{
    self.accessToken = session.accessToken;
    self.accessTokenExpiration = session.accessTokenExpiration;
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
        NSDictionary *dictionary = [self keychainDictionary];
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
            [self restoreSessionWithKeyChainDictionary:dictionary];
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
        
        [self clearCurrentSessionWithUserID:userID];
        
        // There may be other instances of BOXAbstractSession that are linked to this account. Let them know that they need to wipe credentials as well.
        // (see didReceiveRevokeSessionNotification:)
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:BOXSessionWasRevokedNotification
                                                                                             object:nil
                                                                                           userInfo:@{BOXUserIDKey : userID}]];
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
            
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:BOXSessionWasRevokedNotification
                                                                                                 object:nil
                                                                                               userInfo:@{BOXUserIDKey : user.modelID}]];
        }
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
            NSObject *object = [dict objectForKey:((__bridge id)kSecAttrGeneric)];
            if (![object isKindOfClass:[NSString class]]) {
                continue;
            }
            
            NSString *keychainIdentifier = (NSString *) object;
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

#pragma mark Keychain Helpers

- (NSDictionary *)keychainDictionary
{
    NSDictionary *dictionary = @{keychainUserIDKey : self.user.modelID,
                                 keychainUserNameKey : self.user.name,
                                 keychainAccessTokenKey : self.accessToken,
                                 keychainUserLoginKey : self.user.login,
                                 keychainAccessTokenExpirationKey : [self.accessTokenExpiration box_ISO8601String]};
    
    return dictionary;
}

- (void)restoreSessionWithKeyChainDictionary:(NSDictionary *)dictionary
{
    NSString *userIDFromKeychain = [dictionary objectForKey:keychainUserIDKey];
    NSString *userNameFromKeychain = [dictionary objectForKey:keychainUserNameKey];
    NSString *userLoginFromKeychain = [dictionary objectForKey:keychainUserLoginKey];
    NSString *accessTokenFromKeychain = [dictionary objectForKey:keychainAccessTokenKey];
    NSString *accessTokenExpirationAsStringFromKeychain = [dictionary objectForKey:keychainAccessTokenExpirationKey];
    
    if (userIDFromKeychain.length > 0 &&
        userLoginFromKeychain.length > 0 &&
        accessTokenFromKeychain.length > 0 &&
        accessTokenExpirationAsStringFromKeychain != nil)
    {
        self.user = [[BOXUserMini alloc] initWithUserID:userIDFromKeychain
                                                   name:userNameFromKeychain
                                                  login:userLoginFromKeychain];
        
        self.accessToken = accessTokenFromKeychain;
        self.accessTokenExpiration = [NSDate box_dateWithISO8601String:accessTokenExpirationAsStringFromKeychain];
    }
}

- (void)clearCurrentSessionWithUserID:(NSString *)userID
{
    self.accessToken = nil;
    self.accessTokenExpiration = nil;
    self.user = nil;
}

@end
