//
//  BOXClient+Authentication.m
//  BoxContentSDK
//
//  Created by Rico Yao on 11/12/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import <objc/runtime.h>
#import "BOXContentClient_Private.h"
#import "BOXContentClient+Authentication.h"
#import "BOXContentClient+User.h"
#import "BOXContentSDKErrors.h"
#import "BOXAuthorizationViewController.h"
#import "BOXUser.h"
#import "BOXSharedLinkHeadersHelper.h"
#import "BOXAppToAppApplication.h"
#import "BOXAppToAppMessage.h"
#import "BOXUserRequest.h"
#import "BOXAppUserSession.h"

#define keychainDefaultIdentifier @"BoxCredential"
#define keychainRefreshTokenKey @"refresh_token"
#define keychainAccessTokenKey @"access_token"
#define keychainAccessTokenExpirationKey @"access_token_expiration"

@interface BOXContentClient ()

@end

@implementation BOXContentClient (Authentication)

#pragma mark - Authentication


- (void)authenticateWithCompletionBlock:(void (^)(BOXUser *user, NSError *error))completion
{
    [self authenticateWithCompletionBlock:completion forceInApp:NO];
}

- (void)authenticateInAppWithCompletionBlock:(void (^)(BOXUser *user, NSError *error))completion
{
    [self authenticateWithCompletionBlock:completion forceInApp:YES];
}

- (void)authenticateWithCompletionBlock:(void (^)(BOXUser *user, NSError *error))completion forceInApp:(BOOL)forceInApp
{
    if ([self.session isKindOfClass:[BOXOAuth2Session class]] && !self.queueManager.delegate) {
        [self authenticateOAuth2WithCompletionBlock:completion forceInApp:forceInApp];
    } else {
        [self autheticateAppUserWithCompletionBlock:completion];
    }
}

- (void)authenticateOAuth2WithCompletionBlock:(void (^)(BOXUser *user, NSError *error))completion forceInApp:(BOOL)forceInApp
{
    if (self.OAuth2Session.refreshToken.length > 0 && self.OAuth2Session.accessToken.length > 0) {
        BOXUserRequest *userRequest = [self currentUserRequest];
        [userRequest performRequestWithCompletion:^(BOXUser *user, NSError *error) {
            if (error) { //FIXME: This may cause problems offline
                if (forceInApp) {
                    [self showWebViewAuthenticationViewControllerWithCompletionBlock:completion];
                } else {
                    [self presentDefaultAuthenticationWithCompletionBlock:completion];
                }
            } else  if (completion) {
                completion(user, nil);
            }
        }];
    } else {
        if (forceInApp) {
            [self showWebViewAuthenticationViewControllerWithCompletionBlock:completion];
        } else {
            [self presentDefaultAuthenticationWithCompletionBlock:completion];
        }
    }
}

- (void)authenticateAppToAppWithCompletionBlock:(void (^)(BOXUser *user, NSError *error))completion
{
    if (self.OAuth2Session.refreshToken.length > 0 && self.OAuth2Session.accessToken.length > 0) {
        __weak BOXContentClient *weakSelf = self;
        BOXUserRequest *userRequest = [self currentUserRequest];
        [userRequest performRequestWithCompletion:^(BOXUser *user, NSError *error) {
            if (error) { //FIXME: This may cause problems offline
                BOOL didAuthenticate = [weakSelf performAppToAppAuthenticationWithCompletionBlock:completion];
                if (didAuthenticate == NO && completion != nil) {
                    completion(nil, [NSError errorWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKAuthErrorNotPossible userInfo:nil]);
                }
            } else  if (completion) {
                completion(user, nil);
            }
        }];
    } else {
        BOOL didAuthenticate = [self performAppToAppAuthenticationWithCompletionBlock:completion];
        if (didAuthenticate == NO && completion != nil) {
            completion(nil, [NSError errorWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKAuthErrorNotPossible userInfo:nil]);
        }
    }
}

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

+ (BOOL)canCompleteAppToAppAuthenticationWithURL:(NSURL *)authenticationURL
{
    BOXContentClient *client = [[self SDKClients] objectForKey:BOXOAuth2AuthDelegationNewClientKey];
    BOOL authInProgress = (client != nil);

    BOXAppToAppMessage *message = [BOXAppToAppMessage appToAppMessageWithOpenURL:authenticationURL sourceApplication:nil currentApplication:nil annotation:nil];
    BOOL URLIsAuthenticationCompletion = [message isAuthorizationForRedirectURLScheme:[client authenticationRedirectURIScheme]];

    return (authInProgress && URLIsAuthenticationCompletion);
}

+ (void)completeAppToAppAuthenticationWithURL:(NSURL *)authenticationURL
{
    BOXContentClient *client = [[self SDKClients] objectForKey:BOXOAuth2AuthDelegationNewClientKey];
    if (client != nil) {
        [[self SDKClients] removeObjectForKey:BOXOAuth2AuthDelegationNewClientKey];
        void (^authCompletionBlock)(BOXUser *user, NSError *error) = client.authenticationCompletionBlock;
        client.authenticationCompletionBlock = nil;

        [client completeAuthenticationWithURL:authenticationURL completionBlock:authCompletionBlock];
    }
}

- (void)logOut
{
    [self.sharedLinksHeaderHelper removeStoredInformationForUserWithID:self.user.modelID];
    [self.session revokeCredentials];
    [self.queueManager cancelAllOperations];
}

+ (void)logOutAll
{
    NSArray *users = [BOXContentClient users];
    for (BOXUser *user in users) {
        BOXContentClient *client = [BOXContentClient clientForUser:user];
        [client logOut];
    }
    [BOXAbstractSession revokeAllCredentials];
}

#pragma mark - Private Helpers

- (void)presentDefaultAuthenticationWithCompletionBlock:(void (^)(BOXUser *user, NSError *error))completion
{
    BOOL didPresentDefaultAuthentication = [self performAppToAppAuthenticationWithCompletionBlock:completion];
    if (didPresentDefaultAuthentication == NO) {
        [self showWebViewAuthenticationViewControllerWithCompletionBlock:completion];
    }
}

// The completion block only gets called if App-To-App authentication is possible and attempted,
// in which case the return value is YES. If the return value is NO, the completion block will not
// get called.
- (BOOL)performAppToAppAuthenticationWithCompletionBlock:(void (^)(BOXUser *user, NSError *error))completion
{
    BOOL didPerformAppToAppAuthentication = NO;

    if (self.appToAppBoxAuthenticationEnabled && [[BOXAppToAppApplication BoxApplication] isInstalled]) {
        NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
        NSString *authURLScheme = [self authenticationRedirectURIScheme];
        BOXAppToAppApplication *currentApplication = [BOXAppToAppApplication appToAppApplicationWithName:[bundleID pathExtension]
                                                                                                bundleID:bundleID
                                                                                                clientID:self.OAuth2Session.clientID
                                                                                               URLScheme:authURLScheme
                                                                                   authRedirectURIString:self.OAuth2Session.redirectURIString];
        BOXAppToAppMessage *authMessage = [BOXAppToAppMessage boxAppAuthorizationMessageWithState:self.OAuth2Session.nonce
                                                                               currentApplication:currentApplication];
        BOXAppToAppStatus messageDidSend = [authMessage execute];

        didPerformAppToAppAuthentication = (messageDidSend == BOXAppToAppStatusSuccess);
    }

    if (didPerformAppToAppAuthentication) {
        self.authenticationCompletionBlock = completion;
        [[[self class] SDKClients] setObject:self forKey:BOXOAuth2AuthDelegationNewClientKey];
    }

    return didPerformAppToAppAuthentication;
}

- (void)showWebViewAuthenticationViewControllerWithCompletionBlock:(void (^)(BOXUser *user, NSError *error))completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        BOXAuthorizationViewController *authorizationController = [[BOXAuthorizationViewController alloc] initWithSDKClient:self completionBlock:^(BOXAuthorizationViewController *authViewController, BOXUser *user, NSError *error) {
            [[authViewController navigationController] dismissViewControllerAnimated:YES completion:nil];
            if (completion) {
                completion(user, error);
            }
        } cancelBlock:^(BOXAuthorizationViewController *authViewController) {
            [[authViewController navigationController] dismissViewControllerAnimated:YES completion:nil];
            if (completion) {
                NSError *error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKAPIUserCancelledError userInfo:nil];
                completion(nil, error);
            }
        }];
        UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:authorizationController];
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        // if there are presented view controllers, we need to present the auth controller on the topmost presented view controller
        UIViewController *viewControllerToPresentOn = rootViewController;
        while (viewControllerToPresentOn.presentedViewController) {
            viewControllerToPresentOn = viewControllerToPresentOn.presentedViewController;
        }
        [viewControllerToPresentOn presentViewController:navController animated:YES completion:nil];
    });
}

- (NSString *)authenticationRedirectURIScheme
{
    return [[NSURL URLWithString:self.OAuth2Session.redirectURIString] scheme];
}

#pragma mark - Keychain

+ (void)setKeychainIdentifierPrefix:(NSString *)keychainIdentifierPrefix
{
    [BOXAbstractSession setKeychainIdentifierPrefix:keychainIdentifierPrefix];
}

+ (void)setKeychainAccessGroup:(NSString *)keychainAccessGroup
{
    [BOXAbstractSession setKeychainAccessGroup:keychainAccessGroup];
}

@end

@implementation BOXContentClient (AuthenticationPrivate)

- (void)completeAuthenticationWithURL:(NSURL *)authenticationURL completionBlock:(void (^)(BOXUser *user, NSError *error))completion
{
    [self.OAuth2Session performAuthorizationCodeGrantWithReceivedURL:authenticationURL withCompletionBlock:^(BOXAbstractSession *session, NSError *error) {
        if (error) {
            if (completion) {
                completion(nil, error);
            }
        } else {
            BOXUserRequest *userRequest = [self currentUserRequest];
            [userRequest performRequestWithCompletion:^(BOXUser *user, NSError *error) {
                if (completion) {
                    completion(user, error);
                }
            }];
        }
    }];
}

@end
