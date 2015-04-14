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

@implementation BOXContentClient(EventAPI)

- (BOXEventsRequest *)eventsRequestForCurrentUser
{
    BOXEventsRequest *request = [[BOXEventsRequest alloc] init];
    request.queueManager = self.queueManager;
    
    return request;
}

- (BOXEventsAdminLogsRequest *)eventsRequestForEnterprise
{
    BOXEventsAdminLogsRequest *request = [[BOXEventsAdminLogsRequest alloc] init];
    request.queueManager = self.queueManager;
    
    return request;
}

@end
