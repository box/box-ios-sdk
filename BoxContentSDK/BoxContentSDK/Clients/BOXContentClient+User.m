//
//  BOXClient+UserAPI.m
//  BoxContentSDK
//
//  Created on 11/14/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXContentClient+User.h"
#import "BOXUserRequest.h"

@implementation BOXContentClient (User)

- (BOXUserRequest *)currentUserRequest
{
    BOXUserRequest *request = nil;

    request = [[BOXUserRequest alloc] init];
    request.queueManager = self.queueManager;

    return request;
}

@end
