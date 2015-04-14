//
//  BOXClient+UserAPI.h
//  BoxContentSDK
//
//  Created on 11/14/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXContentClient.h"

@class BOXUserRequest;

@interface BOXContentClient (UserAPI)

/**
 *  Generate a request to retrieve the current user.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXUserRequest *)currentUserRequest;

@end
