//
//  BOXClient+Search.h
//  BoxContentSDK
//
//  Created by Rico Yao on 1/16/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXContentClient.h"

@class BOXSearchRequest;

@interface BOXContentClient (Search)

/**
 *  Generate a request to search for files and folders in the user's account. You can customize the search
 *  by setting properties of the BOXSearchRequest before executing it.
 *
 *  @param query Search query string.
 *  @param range An offset (NSRange location) and limit (NSRange limit). The maximum limit allowed is 1000.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXSearchRequest *)searchRequestWithQuery:(NSString *)query
                                     inRange:(NSRange)range;

@end
