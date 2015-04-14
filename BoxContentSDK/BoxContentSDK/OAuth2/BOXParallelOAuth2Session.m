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

@interface BOXParallelOAuth2Session ()

@property (atomic, readwrite, strong) NSMutableSet *expiredOAuth2Tokens;

@end

@implementation BOXParallelOAuth2Session

@synthesize expiredOAuth2Tokens = _expiredOAuth2Tokens;

- (id)initWithClientID:(NSString *)ID secret:(NSString *)secret APIBaseURL:(NSString *)baseURL queueManager:(BOXAPIQueueManager *)queueManager
{
    self = [super initWithClientID:ID secret:secret APIBaseURL:baseURL queueManager:queueManager];
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
            return;
        }
        
        BOXLog(@"access token expired: %@", expiredAccessToken);
        BOXLog(@"refreshing tokens");
        if (expiredAccessToken)
        {
            [self.expiredOAuth2Tokens addObject:expiredAccessToken];
        }
        
        NSDictionary *POSTParams = @{
        BOXOAuth2TokenRequestGrantTypeKey : BOXOAuth2TokenRequestGrantTypeRefreshToken,
        BOXOAuth2TokenRequestRefreshTokenKey : (!self.refreshToken) ?   @"invalidToken" : self.refreshToken,
        BOXOAuth2TokenRequestClientIDKey : self.clientID,
        BOXOAuth2TokenRequestClientSecretKey : self.clientSecret,
        };
        
        BOXAPIOAuth2ToJSONOperation *operation = [[BOXAPIOAuth2ToJSONOperation alloc] initWithURL:self.grantTokensURL
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
            
            [self storeCredentialsToKeychain];
            
            // send success notification
            [[NSNotificationCenter defaultCenter] postNotificationName:BOXOAuth2SessionDidRefreshTokensNotification object:self];
            
            if (block) {
                block(self, nil);
            }
        };
        
        operation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary)
        {
            NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:error
                                                                  forKey:BOXOAuth2AuthenticationErrorKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:BOXOAuth2SessionDidReceiveRefreshErrorNotification
                                                                object:self
                                                              userInfo:errorInfo];
            
            if (block) {
                block(self, error);
            }
        };
        
        [self.queueManager enqueueOperation:operation];
    }
}


@end
