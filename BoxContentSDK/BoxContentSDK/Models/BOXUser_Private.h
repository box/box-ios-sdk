//
//  BOXUser_Private.h
//  BoxContentSDK
//
//  Created by Rico Yao on 12/5/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXUser.h"

@interface BOXUserMini ()

/**
 *  Initialize a BOXUserMini.
 *
 *  @param userID User ID.
 *  @param name   User name.
 *  @param login  User login (usually email address)
 *
 *  @return BOXUserMini
 */
- (instancetype)initWithUserID:(NSString *)userID name:(NSString *)name login:(NSString *)login;

@end
