//
//  BOXAppSession.m
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/3/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXAbstractSession_Private.h"
#import "BOXAppUserSession.h"
#import "BOXAPIAccessTokenDelegate.h"
#import "BOXUserRequest.h"
#import "BOXUser_Private.h"
#import "BOXAPIAppUsersAuthOperation.h"
#import "BOXAPIOperation_Private.h"

@implementation BOXAppUserSession

- (void)performAuthorizationCodeGrantWithReceivedURL:(NSURL *)URL withCompletionBlock:(void (^)(BOXAppUserSession *, NSError *))block
{
    __weak BOXAppUserSession *weakSelf = self;
    BOXAPIAppUsersAuthOperation *operation = [[BOXAPIAppUsersAuthOperation alloc] initWithSession:self];
    operation.success = ^(NSString *accessToken, NSDate *accessTokenExpiration) {
        weakSelf.accessToken = accessToken;
        weakSelf.accessTokenExpiration = accessTokenExpiration;
        
        BOXUserRequest *userRequest = [[BOXUserRequest alloc] init];
        userRequest.queueManager = weakSelf.queueManager;
        [userRequest performRequestWithCompletion:^(BOXUser *user, NSError *error) {
            if (user && !error) {
                weakSelf.user = [[BOXUserMini alloc] initWithUserID:user.modelID name:user.name login:user.login];
                [weakSelf storeCredentialsToKeychain];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BOXSessionDidRefreshTokensNotification object:weakSelf];
                
                if (block) {
                    block(weakSelf, nil);
                }
            } else {
                if (block) {
                    block(self, error);
                }
            }
        }];
    };
    
    operation.failure = ^(NSError *error) {
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

- (void)performAuthorizationWithCompletionBlock:(void (^)(BOXAppUserSession *, NSError *))block
{
    [self performAuthorizationCodeGrantWithReceivedURL:nil withCompletionBlock:block];
}

- (void)performRefreshTokenGrant:(NSString *)expiredAccessToken withCompletionBlock:(void (^)(BOXAppUserSession *, NSError *))block
{
    @synchronized(self) {
        [self performAuthorizationWithCompletionBlock:block];
    }
}

@end
