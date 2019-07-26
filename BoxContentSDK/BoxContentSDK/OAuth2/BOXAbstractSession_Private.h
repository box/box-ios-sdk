//
//  BOXAbstractSession_Private.h
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/3/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXAbstractSession.h"
#import "BOXKeychainItemWrapper.h"

@class BOXRequest;

#define keychainUserIDKey @"user_id"
#define keychainUserNameKey @"user_name"
#define keychainAccessTokenKey @"access_token"
#define keychainAccessTokenExpirationKey @"access_token_expiration"
#define keychainUserLoginKey @"user_login"

@interface BOXAbstractSession ()

@property (nonatomic, readwrite, strong) id<UniqueSDKUser> user;

+ (NSString *)keychainIdentifierPrefix;
+ (NSString *)keychainAccessGroup;

+ (NSString *)keychainIdentifierForUserWithID:(NSString *)userID;
+ (NSString *)userIDFromKeychainIdentifier:(NSString *)identifier;

+ (BOXKeychainItemWrapper *)keychainItemWrapperForUserWithID:(NSString *)userID;

/**
 *  This method should mirror BOXContentClient's prepareRequest: for when the session needs to create a request.
 *
 *  @param request request to prepare.
 */
- (void)prepareRequest:(BOXRequest *)request;

@end
