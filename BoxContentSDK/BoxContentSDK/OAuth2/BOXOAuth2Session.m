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
#import "BOXAbstractSession_Private.h"

#define keychainRefreshTokenKey @"refresh_token"

@interface BOXOAuth2Session ()

/**
 * The randomly generated nonce used to prevent spoofing attack during login
 */
@property (nonatomic, readwrite, strong) NSString *nonce;

@end

@implementation BOXOAuth2Session

#pragma mark - Initialization

- (instancetype)initWithClientID:(NSString *)ID
                          secret:(NSString *)secret
                      APIBaseURL:(NSString *)baseURL
                  APIAuthBaseURL:(NSString *)authBaseURL
                    queueManager:(BOXAPIQueueManager *)queueManager
{
    if ([self initWithAPIBaseURL:baseURL queueManager:queueManager]) {
        _clientID = ID;
        _clientSecret = secret;
        _redirectURIString = [NSString stringWithFormat:@"boxsdk-%@://boxsdkoauth2redirect", _clientID];
        _APIAuthBaseURLString = authBaseURL;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveRevokeSessionNotification:)
                                                     name:BOXSessionWasRevokedNotification
                                                   object:nil];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Authorization

- (void)performAuthorizationCodeGrantWithReceivedURL:(NSURL *)URL withCompletionBlock:(void (^)(BOXAbstractSession *session, NSError *error))block
{
    NSDictionary *URLQueryParams = [URL box_queryDictionary];
    NSString *serverNonce = [URLQueryParams valueForKey:BOXAuthURLParameterAuthorizationStateKey];
    NSString *authorizationCode = [URLQueryParams valueForKey:BOXAuthURLParameterAuthorizationCodeKey];
    NSString *authorizationError = [URLQueryParams valueForKey:BOXAuthURLParameterErrorCodeKey];

    NSString *authenticationRedirectURIScheme = [[NSURL URLWithString:self.redirectURIString] scheme];
    if ([[URL scheme] isEqualToString:authenticationRedirectURIScheme]) {
        if ((_nonce || serverNonce) && [serverNonce isEqualToString:_nonce] == NO) {
            NSError *error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain
                                                        code:BOXContentSDKAuthErrorAccessTokenNonceMismatch
                                                    userInfo:nil];
            if (block) {
                block(nil, error);
            }
            return;
        }
    }
    
    if (authorizationError != nil || authorizationCode == nil) {
        NSInteger errorCode = BOXContentSDKAPIErrorUnknownStatusCode;
        if ([authorizationError isEqualToString:BOXAuthErrorAccessDenied]) {
            errorCode = BOXContentSDKAPIErrorUserDeniedAccess;
        }
        NSError *error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:errorCode userInfo:nil];
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:error
                                                              forKey:BOXAuthenticationErrorKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:BOXSessionDidReceiveAuthenticationErrorNotification
                                                            object:self
                                                          userInfo:errorInfo];
        if (block) {
            block(nil, error);
        }
        return;
    }

    NSMutableDictionary *POSTParams = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      BOXAuthTokenRequestGrantTypeKey : BOXAuthTokenRequestGrantTypeAuthorizationCode,
                                                                                      BOXAuthTokenRequestAuthorizationCodeKey : authorizationCode,
                                                                                      BOXAuthTokenRequestClientIDKey : self.clientID,
                                                                                      BOXAuthTokenRequestClientSecretKey : self.clientSecret,
                                                                                      BOXAuthTokenRequestRedirectURIKey : self.redirectURIString,
                                                                                      }];
    if (self.additionalTokenGrantParameters.count > 0) {
        [POSTParams addEntriesFromDictionary:self.additionalTokenGrantParameters];
    }
    
    BOXAPIOAuth2ToJSONOperation *operation = [[BOXAPIOAuth2ToJSONOperation alloc] initWithURL:[self grantTokensURL]
                                                                                   HTTPMethod:BOXAPIHTTPMethodPOST
                                                                                         body:POSTParams
                                                                                  queryParams:nil
                                                                                session:self];

    operation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary)
    {
        self.accessToken = [JSONDictionary valueForKey:BOXAuthTokenJSONAccessTokenKey];
        self.refreshToken = [JSONDictionary valueForKey:BOXAuthTokenJSONRefreshTokenKey];
        
        NSTimeInterval accessTokenExpiresIn = [[JSONDictionary valueForKey:BOXAuthTokenJSONExpiresInKey] integerValue];
        BOXAssert(accessTokenExpiresIn >= 0, @"accessTokenExpiresIn value is negative");
        self.accessTokenExpiration = [NSDate dateWithTimeIntervalSinceNow:accessTokenExpiresIn];
        
        BOXUserRequest *userRequest = [[BOXUserRequest alloc] init];
        userRequest.queueManager = self.queueManager;
        [userRequest performRequestWithCompletion:^(BOXUser *user, NSError *error) {
            if (user && !error)
            {
                self.user = [[BOXUserMini alloc] initWithUserID:user.modelID name:user.name login:user.login];
                [self storeCredentialsToKeychain];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BOXSessionDidBecomeAuthenticatedNotification object:self];
                
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
                                                              forKey:BOXAuthenticationErrorKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:BOXSessionDidReceiveAuthenticationErrorNotification
                                                            object:self
                                                          userInfo:errorInfo];
        
        if (block) {
            block(self, error);
        }
    };

    [self.queueManager enqueueOperation:operation];
}

- (NSString *)nonce
{    
    if (_nonce == nil) {
        NSMutableData * data = [[NSMutableData alloc] initWithLength:32];
        SecRandomCopyBytes(kSecRandomDefault, 32, data.mutableBytes);
        NSData *encodedData = [data base64EncodedDataWithOptions:0];
        _nonce = [[NSString alloc] initWithData:encodedData encoding:NSUTF8StringEncoding];
    }
    
    return _nonce;
}

- (NSURL *)authorizeURL
{
    NSString *encodedRedirectURI = [NSString box_stringWithString:self.redirectURIString URLEncoded:YES];
    NSString *authorizeURLString = [NSString stringWithFormat:
                                    @"%@/oauth2/authorize?response_type=code&client_id=%@&state=%@&redirect_uri=%@",
                                    self.APIAuthBaseURLString, self.clientID, self.nonce, encodedRedirectURI];
    return [NSURL URLWithString:authorizeURLString];
}

- (NSURL *)grantTokensURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth2/token", self.APIBaseURLString]];
}

#pragma mark - Token Refresh
- (void)performRefreshTokenGrant:(NSString *)expiredAccessToken withCompletionBlock:(void (^)(BOXOAuth2Session *session, NSError *error))block
{
    if (!self.refreshToken || !self.clientID || !self.clientSecret) {
        if (block) {
            NSDictionary *userInfo = @{
                                       NSUnderlyingErrorKey : @"No authenticated user associated with the request",
                                       };
            NSError *error = [NSError errorWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKAPIErrorUnauthorized userInfo:userInfo];
            block(nil, error);
        }
        
        return;
    }
    
    NSDictionary *POSTParams = @{
                                 BOXAuthTokenRequestGrantTypeKey : BOXAuthTokenRequestGrantTypeRefreshToken,
                                 BOXAuthTokenRequestRefreshTokenKey : self.refreshToken,
                                 BOXAuthTokenRequestClientIDKey : self.clientID,
                                 BOXAuthTokenRequestClientSecretKey : self.clientSecret,
                                 };
    
    BOXAPIOAuth2ToJSONOperation *operation = [[BOXAPIOAuth2ToJSONOperation alloc] initWithURL:self.grantTokensURL
                                                                                   HTTPMethod:BOXAPIHTTPMethodPOST
                                                                                         body:POSTParams
                                                                                  queryParams:nil
                                                                                session:self];
    
    operation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary)
    {
        self.accessToken = [JSONDictionary valueForKey:BOXAuthTokenJSONAccessTokenKey];
        self.refreshToken = [JSONDictionary valueForKey:BOXAuthTokenJSONRefreshTokenKey];
        
        NSTimeInterval accessTokenExpiresIn = [[JSONDictionary valueForKey:BOXAuthTokenJSONExpiresInKey] integerValue];
        BOXAssert(accessTokenExpiresIn >= 0, @"accessTokenExpiresIn value is negative");
        self.accessTokenExpiration = [NSDate dateWithTimeIntervalSinceNow:accessTokenExpiresIn];
        
        [self storeCredentialsToKeychain];
        
        // send success notification
        [[NSNotificationCenter defaultCenter] postNotificationName:BOXSessionDidRefreshTokensNotification object:self];
        
        if (block) {
            block(self, nil);
        }
    };
    
    operation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary)
    {
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:error
                                                              forKey:BOXAuthenticationErrorKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:BOXSessionDidReceiveRefreshErrorNotification
                                                            object:self
                                                          userInfo:errorInfo];
        
        if (block) {
            block(self, error);
        }
    };
    
    [self.queueManager enqueueOperation:operation];
}

#pragma mark - Token revoke

- (void)revokeCredentials
{
    // Call this before '[super revokeCredentials]' otherwise we would have already lost our accessToken.
    [self sendRevokeRequest];
    
    [super revokeCredentials];
}

/**
 *  Send API request to revoke tokens. We don't care about the response to this request.
 *  This will be called when we're about to wipe the token from keychain+memory, so we could not do anything
 *  about successes/failures anyway.
 */
- (void)sendRevokeRequest
{
    // We don't go through any of our regular queues/operations because those get shut down upon logout.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth2/revoke", BOXAPIBaseURL]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData *postData = [[NSString stringWithFormat:@"client_id=%@&client_secret=%@&token=%@", self.clientID, self.clientSecret, self.accessToken] dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:nil];
    [connection start];
}

#pragma mark Token Helpers

- (void)reassignTokensFromSession:(BOXOAuth2Session *)session
{
    [super reassignTokensFromSession:session];
    self.refreshToken = session.refreshToken;
}

#pragma mark - Keychain

- (void)didReceiveRevokeSessionNotification:(NSNotification *)notification
{
    NSString *userIDRevoked = [notification.userInfo objectForKey:BOXUserIDKey];
    if ([userIDRevoked isEqualToString:self.user.modelID])
    {
        BOXKeychainItemWrapper *keychainWrapper = [[self class] keychainItemWrapperForUserWithID:self.user.modelID];
        [keychainWrapper resetKeychainItem];
        
        [self clearCurrentSessionWithUserID:self.user.modelID];
    }
}

#pragma mark Keychain Helpers

- (NSDictionary *)keychainDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:[super keychainDictionary]];
    [dictionary setObject:self.refreshToken forKey:keychainRefreshTokenKey];
    return dictionary;
}

- (void)restoreSessionWithKeyChainDictionary:(NSDictionary *)dictionary
{
    [super restoreSessionWithKeyChainDictionary:dictionary];
    NSString *refreshTokenFromKeychain = [dictionary objectForKey:keychainRefreshTokenKey];
    
    if (refreshTokenFromKeychain.length > 0) {
        self.refreshToken = refreshTokenFromKeychain;
    }
}

- (void)clearCurrentSessionWithUserID:(NSString *)userID
{
    [super clearCurrentSessionWithUserID:userID];
    self.refreshToken = nil;
}

@end
