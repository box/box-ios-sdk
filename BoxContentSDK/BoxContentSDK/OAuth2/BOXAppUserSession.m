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
#import "BOXAPIAppAuthOperation.h"

@implementation BOXAppUserSession

- (void)performAuthorizationCodeGrantWithReceivedURL:(NSURL *)URL withCompletionBlock:(void (^)(BOXAppUserSession *, NSError *))block
{
    // NOTE: Will cause CFNetwork internal error because NSURLRequest HTTPMethod is nil.
    __weak BOXAppUserSession *weakSelf = self;
    BOXAPIAppAuthOperation *operation = [[BOXAPIAppAuthOperation alloc]initWithURL:nil HTTPMethod:nil body:nil queryParams:nil session:self];
    operation.success = ^(NSString *accessToken, NSDate *accessTokenExpiration) {
        weakSelf.accessToken = accessToken;
        weakSelf.accessTokenExpiration = accessTokenExpiration;
        
        BOXUserRequest *userRequest = [[BOXUserRequest alloc]init];
        userRequest.queueManager = weakSelf.queueManager;
        [userRequest performRequestWithCompletion:^(BOXUser *user, NSError *error) {
            if (user && !error) {
                weakSelf.user = [[BOXUserMini alloc]initWithUserID:user.modelID name:user.name login:user.login];
                [weakSelf storeCredentialsToKeychain];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:BOXSessionDidBecomeAuthenticatedNotification object:weakSelf];
                
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
        NSLog(@"AppUserSession Failed!");
    };
    
    [self.queueManager enqueueOperation:operation];
}

- (void)performAuthorizationWithCompletionBlock:(void (^)(BOXAppUserSession *, NSError *))block
{
    [self performAuthorizationCodeGrantWithReceivedURL:nil withCompletionBlock:block];
}

- (void)performRefreshTokenGrant:(NSString *)expiredAccessToken withCompletionBlock:(void (^)(BOXAppUserSession *, NSError *))block
{
    [self performAuthorizationWithCompletionBlock:block];
}

@end
