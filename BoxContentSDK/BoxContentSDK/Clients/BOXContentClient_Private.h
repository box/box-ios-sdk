//
//  BOXClient_Private.h
//  BoxContentSDK
//
//  Created on 12/12/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXContentClient.h"

@class BOXOAuth2Session;
@class BOXAbstractSession;
@class BOXAppUserSession;
@class BOXRequest;
@class BOXURLSessionManager;

@interface BOXContentClient ()

@property (nonatomic, readwrite, strong) BOXOAuth2Session *OAuth2Session;
@property (nonatomic, readwrite, strong) BOXAppUserSession *appSession;
@property (nonatomic, readwrite, strong) BOXAbstractSession *session;
@property (nonatomic, readonly, strong) BOXURLSessionManager *urlSessionManager;
@property (nonatomic, readwrite, copy) NSString *tempCacheDir;

+ (NSMutableDictionary *)SDKClients;
- (void)prepareRequest:(BOXRequest *)request;

@end

@interface BOXContentClient (AuthenticationPrivate)

/**
 *  Complete the user's authentication from the URL with which the app was launched.
 *
 *  @param authenticationURL    The URL with which the app was launched.
 *  @param completion           Called when the authentication has completed.
 */
- (void)completeAuthenticationWithURL:(NSURL *)authenticationURL
                      completionBlock:(void (^)(BOXUser *user, NSError *error))completion;

@end
