//
//  BOXParallelOAuth2Session.m
//  BoxContentSDK
//
//  Created on 5/11/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXParallelOAuth2Session.h"
#import "BOXAPIOAuth2ToJSONOperation.h"
#import "BOXLog.h"
#import "BOXContentSDKConstants.h"
#import "BOXContentSDKErrors.h"
#import <os/log.h>

@interface BOXParallelOAuth2Session ()

@property (atomic, readwrite, strong) NSMutableSet *expiredOAuth2Tokens;

@end

@implementation BOXParallelOAuth2Session

@synthesize expiredOAuth2Tokens = _expiredOAuth2Tokens;

- (id)initWithClientID:(NSString *)ID
                secret:(NSString *)secret
          queueManager:(BOXAPIQueueManager *)queueManager
     urlSessionManager:(BOXURLSessionManager *)urlSessionManager
{
    self = [super initWithClientID:ID
                            secret:secret
                      queueManager:queueManager
		 urlSessionManager:urlSessionManager];
    if (self != nil)
    {
        _expiredOAuth2Tokens = [NSMutableSet set];
    }
    
    return self;
}

- (void)performRefreshTokenGrant:(NSString *)expiredAccessToken withCompletionBlock:(void(^)(BOXOAuth2Session *session, NSError *error))block
{
    [self performRefreshTokenGrant:expiredAccessToken
        newAccessTokenExpirationAt:nil
       newRefreshTokenExpirationAt:nil
               withCompletionBlock:block];
}

- (void)performRefreshTokenGrant:(NSString *)expiredAccessToken
      newAccessTokenExpirationAt:(NSNumber *)accessTokenExpirationTimestamp
     newRefreshTokenExpirationAt:(NSNumber *)refreshTokenExpirationTimestamp
             withCompletionBlock:(void (^)(BOXOAuth2Session *session, NSError *error))block
{
    @synchronized(self)
    {
        if ([self.expiredOAuth2Tokens containsObject:expiredAccessToken])
        {
            os_log(OS_LOG_DEFAULT, "*****ParOAuthSess: !!!do not create op, return error alreadyInProgress expiredAccessToken %{public}@ in self.expiredOAuth2Tokens %{public}@ \n current access %{public}@, refresh %{public}@", expiredAccessToken, self.expiredOAuth2Tokens, self.accessToken, self.refreshToken);
            // Only attempt to refresh the token if this is the first time this access
            // token has expired
            
            // TODO We need to ensure that completion block gets called, but we don't want to trigger duplicate attempts to refresh the same token.
            // We should have an observer-notifier pattern to hook up this block into the existing refresh operation in progress.
            // Without that, the best we can do is return this error.
            if (block) {
                block(self, [NSError errorWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKAuthErrorTokenRefreshAlreadyInProgress userInfo:nil]);
            }
            return;
        }
        
        if (expiredAccessToken.length > 0)
        {
            os_log(OS_LOG_DEFAULT, "*****ParOAuthSess: !!!record expiredAccessToken %{public}@\n self.expiredOAuth2Tokens %{public}@", expiredAccessToken, self.expiredOAuth2Tokens);
            [self.expiredOAuth2Tokens addObject:expiredAccessToken];
        }
        
        [super performRefreshTokenGrant:expiredAccessToken
             newAccessTokenExpirationAt:accessTokenExpirationTimestamp
            newRefreshTokenExpirationAt:refreshTokenExpirationTimestamp
                    withCompletionBlock:^(BOXOAuth2Session *session, NSError *error) {

            BOOL notInvalid = ![self isInvalidGrantError:error];
            os_log(OS_LOG_DEFAULT, "*****ParOAuthSess: !!!completed refresh expiredAccessToken %{public}@, notInvalidGrant %{public}@, error %{public}@", expiredAccessToken, notInvalid?@"YES":@"NO", error);
            if (expiredAccessToken.length > 0 && error != nil && notInvalid) {
                // If there was an error, remove from 'expiredOAuth2Tokens' so that we can try again. For example, if there was a network
                // error, then we would not want to block ourselves from trying to refresh the tokens again later.
                // The exception to this is if we get 'invalid_grant' in which case the token is not just expired, but is just dead. In that
                // case, we don't want to ever try refreshing that again.

                os_log(OS_LOG_DEFAULT, "*****ParOAuthSess: !!!removed expiredAccessToken %{public}@, current access %{public}@, refresh %{public}@\n self.expiredOAuth2Tokens %{public}@", expiredAccessToken, self.accessToken, self.refreshToken, self.expiredOAuth2Tokens);
                [self.expiredOAuth2Tokens removeObject:expiredAccessToken];
            }
                        
            if (block) {
                block(session, error);
            }
        }];
    }
}

- (BOOL)isInvalidGrantError:(NSError *)error
{
    BOOL isInvalidGrantError = NO;
    if ([error.domain isEqualToString:BOXContentSDKErrorDomain]) {
        NSDictionary *errorInfo = [error.userInfo objectForKey:BOXJSONErrorResponseKey];
        NSString *errorType = [errorInfo objectForKey:BOXAuthURLParameterErrorCodeKey];
        if ([errorType isEqualToString:BOXAuthTokenRequestErrorInvalidGrant]) {
            isInvalidGrantError = YES;
        }
    }
    return isInvalidGrantError;
}

#pragma mark - Access/Refresh token consistency

// Overrides below are to make atomic updating and storing access/refresh token pair.
//
// This is a fragile pattern, but doing better would require refactoring. Currently the BOXAbstractSession
// owns the accessToken and BOXOAuth2Session owns the refreshToken. It's unclear why the OAuth class doesn't
// also own the accessToekn, since the accessToken concept implies some for of authentication, while no
// authentication is implied by the base BOXAbstractSession.

- (void)storeCredentialsToKeychain
{
    @synchronized(self)
    {
        [super storeCredentialsToKeychain];
    }
}

- (void)reassignTokensFromSession:(BOXOAuth2Session *)session
{
    @synchronized(self)
    {
        [super reassignTokensFromSession:session];
    }
}

- (void)restoreCredentialsFromKeychainForUserWithID:(NSString *)userID
{
    @synchronized(self)
    {
        [super restoreCredentialsFromKeychainForUserWithID:userID];
    }
}

@end
