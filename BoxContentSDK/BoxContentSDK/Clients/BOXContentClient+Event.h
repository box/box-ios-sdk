//
//  BOXClient+EventAPI.h
//  BoxContentSDK
//
//  Created on 12/18/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXContentClient.h"

@class BOXEventsRequest;
@class BOXEventsAdminLogsRequest;

@interface BOXContentClient(EventAPI)

/**
 *  Generate a request to retrieve events for the current user.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXEventsRequest *)eventsRequestForCurrentUser;

/**
 *  Generate a request to retrieve admin logs for the enterprise. The user must be an administrator to perform this.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXEventsAdminLogsRequest *)eventsRequestForEnterprise;

@end
