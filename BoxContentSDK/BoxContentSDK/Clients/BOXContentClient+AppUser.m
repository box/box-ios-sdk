//
//  BOXContentClient+AppUser.m
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/8/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXContentClient_Private.h"
#import "BOXContentClient+AppUser.h"
#import "BOXAppUserSession.h"

@implementation BOXContentClient (AppUsers)

- (void)autheticateAppUserWithCompletionBlock:(void (^)(BOXUser *user, NSError *error))completion
{
    __weak BOXContentClient *weakSelf = self;
    [self.appSession performAuthorizationWithCompletionBlock:^(BOXAbstractSession *session, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (completion) {
                    completion(nil, error);
                }
            } else {
                BOXUserRequest *userRequest = [weakSelf currentUserRequest];
                [userRequest performRequestWithCompletion:^(BOXUser *user, NSError *error) {
                    if (completion) {
                        completion(user, error);
                    }
                }];
            }
        });
    }];
}


- (void)setAccessTokenDelegate:(id)delegate
{
    
    BOXAssert(self.OAuth2Session.refreshToken == nil, @"BOXContentClients that use OAuth2 cannot have a delegate set.");
    BOXAssert(delegate != nil, @"delegate must be non-nil when calling setAccessTokenDelegate:");
    
    // Switch from OAuth2Session to AppUserSession
    // Since BOXContentClient instances are defaulted to OAuth2 instead of AppUsers, a BOXAppUserSession must be initialized.
    // The OAuth2Session must be nil-ed out because "session" returns the first non-nil session instance (chosen between AppSession and OAuth2Session).
    if ([self.session isKindOfClass:[BOXOAuth2Session class]]) {
        self.session = [[BOXAppUserSession alloc]initWithAPIBaseURL:self.APIBaseURL queueManager:self.queueManager];
    }
    
    // Since the OAuth2Session instance was nil-ed out, the queueManager now needs a new session instance which will be appSession.
    self.queueManager.delegate = delegate;
}

@end
