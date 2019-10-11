//
//  BOXClient+User.m
//  BoxContentSDK
//
//  Created on 11/14/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXContentClient+User.h"
#import "BOXUserRequest.h"
#import "BOXUserAvatarRequest.h"
#import "BOXContentClient_Private.h"

@implementation BOXContentClient (User)

- (BOXUserRequest *)currentUserRequest
{
    BOXUserRequest *request = [[BOXUserRequest alloc] init];
    [self prepareRequest:request];

    return request;
}

- (BOXUserRequest *)userInfoRequestWithID:(NSString *)userID
{
    BOXUserRequest *request = [[BOXUserRequest alloc] initWithUserID:userID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXUserAvatarRequest *)userAvatarRequestWithID:(NSString *)userID
                                             type:(BOXAvatarType)type
{
    BOXUserAvatarRequest *request = [[BOXUserAvatarRequest alloc] initWithUserID:userID];
    request.avatarType = type;
    [self prepareRequest:request];
    
    return request;
}

@end
