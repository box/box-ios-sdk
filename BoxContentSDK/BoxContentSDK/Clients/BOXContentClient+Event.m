//
//  BOXClient+EventAPI.m
//  BoxContentSDK
//
//  Created on 12/18/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXContentClient+Event.h"
#import "BOXEventsRequest.h"
#import "BOXEventsAdminLogsRequest.h"
#import "BOXContentClient_Private.h"

@implementation BOXContentClient(EventAPI)

- (BOXEventsRequest *)eventsRequestForCurrentUser
{
    BOXEventsRequest *request = [[BOXEventsRequest alloc] init];
    [self prepareRequest:request];
    
    return request;
}

- (BOXEventsAdminLogsRequest *)eventsRequestForEnterprise
{
    BOXEventsAdminLogsRequest *request = [[BOXEventsAdminLogsRequest alloc] init];
    [self prepareRequest:request];
    
    return request;
}

@end
