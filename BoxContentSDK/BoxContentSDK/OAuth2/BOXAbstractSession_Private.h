//
//  BOXAbstractSession_Private.h
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/3/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXAbstractSession.h"
#import "BOXKeychainItemWrapper.h"

#define keychainUserIDKey @"user_id"
#define keychainUserNameKey @"user_name"
#define keychainAccessTokenKey @"access_token"
#define keychainAccessTokenExpirationKey @"access_token_expiration"
#define keychainUserLoginKey @"user_login"

@interface BOXAbstractSession ()

@property (nonatomic, readwrite, strong) BOXUserMini *user;

+ (NSString *)keychainIdentifierPrefix;
+ (NSString *)keychainAccessGroup;

+ (NSString *)keychainIdentifierForUserWithID:(NSString *)userID;
+ (NSString *)userIDFromKeychainIdentifier:(NSString *)identifier;

+ (BOXKeychainItemWrapper *)keychainItemWrapperForUserWithID:(NSString *)userID;

@end