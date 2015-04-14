//
//  BOXSerialOAuth2Session.m
//  BoxContentSDK
//
//  Created on 2/20/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXSerialOAuth2Session.h"
#import "BOXAPIOAuth2ToJSONOperation.h"
#import "BOXLog.h"
#import "BOXContentSDKConstants.h"

@implementation BOXSerialOAuth2Session

#pragma mark - Authorization

#pragma mark - Token Refresh
- (void)performRefreshTokenGrant:(NSString *)expiredAccessToken withCompletionBlock:(void(^)(BOXOAuth2Session *session, NSError *error))block
{
    NSDictionary *POSTParams = @{
        BOXOAuth2TokenRequestGrantTypeKey : BOXOAuth2TokenRequestGrantTypeRefreshToken,
        BOXOAuth2TokenRequestRefreshTokenKey : self.refreshToken,
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

@end
