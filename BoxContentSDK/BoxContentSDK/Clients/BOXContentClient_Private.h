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

@interface BOXContentClient ()

@property (nonatomic, readwrite, strong) BOXOAuth2Session *OAuth2Session;
@property (nonatomic, readwrite, strong) BOXAppUserSession *appSession;
@property (nonatomic, readwrite, strong) BOXAbstractSession *session;

+ (NSMutableDictionary *)SDKClients;
- (void)prepareRequest:(BOXRequest *)request;

@end

@interface BOXContentClient (AuthenticationPrivate)

/**
 *  Complete the user's authentication from the URL with which the app was launched.
 *
 *  @param authenticationURL    The URL with which the app was launched.
 *  @param completionBlock      Called when the authentication has completed.
 */
- (void)completeAuthenticationWithURL:(NSURL *)authenticationURL completionBlock:(void (^)(BOXUser *user, NSError *error))completion;

@end