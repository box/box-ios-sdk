//
//  BOXClient+UserAPI.m
//  BoxContentSDK
//
//  Created on 11/14/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import <BoxContentSDK/BOXUserRequest.h>

#import <BoxContentSDK/BOXContentClient+User.h>

#import "BOXContentClient_Private.h"

@implementation BOXContentClient (User)

- (BOXUserRequest *)currentUserRequest
{
    BOXUserRequest *request = nil;

    request = [[BOXUserRequest alloc] init];
    [self prepareRequest:request];

    return request;
}

@end
