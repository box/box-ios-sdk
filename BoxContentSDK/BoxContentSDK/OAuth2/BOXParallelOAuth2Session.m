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

@interface BOXParallelOAuth2Session ()

@property (atomic, readwrite, strong) NSMutableSet *expiredOAuth2Tokens;

@end

@implementation BOXParallelOAuth2Session

@synthesize expiredOAuth2Tokens = _expiredOAuth2Tokens;

- (id)initWithClientID:(NSString *)ID
                secret:(NSString *)secret
            APIBaseURL:(NSString *)baseURL
        APIAuthBaseURL:(NSString *)authBaseURL
          queueManager:(BOXAPIQueueManager *)queueManager
{
    self = [super initWithClientID:ID secret:secret APIBaseURL:baseURL APIAuthBaseURL:authBaseURL queueManager:queueManager];
    if (self != nil)
    {
        _expiredOAuth2Tokens = [NSMutableSet set];
    }
    
    return self;
}

- (void)performRefreshTokenGrant:(NSString *)expiredAccessToken withCompletionBlock:(void(^)(BOXOAuth2Session *session, NSError *error))block
{
    @synchronized(self)
    {
        if ([self.expiredOAuth2Tokens containsObject:expiredAccessToken])
        {
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
            [self.expiredOAuth2Tokens addObject:expiredAccessToken];
        }
        
        [super performRefreshTokenGrant:expiredAccessToken withCompletionBlock:^(BOXAbstractSession *session, NSError *error) {
            if (expiredAccessToken.length > 0 && error != nil && ![self isInvalidGrantError:error]) {
                // If there was an error, remove from 'expiredOAuth2Tokens' so that we can try again. For example, if there was a network
                // error, then we would not want to block ourselves from trying to refresh the tokens again later.
                // The exception to this is if we get 'invalid_grant' in which case the token is not just expired, but is just dead. In that
                // case, we don't want to ever try refreshing that again.
                [self.expiredOAuth2Tokens removeObject:expiredAccessToken];
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

@end
