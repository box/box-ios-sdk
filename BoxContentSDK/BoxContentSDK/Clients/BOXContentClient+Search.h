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

/**
 * Generate a request to search for files and folders in a user's account using metadata tags. You can customize
 * the search by setting properties of the BOXSearchRequest before executing it.
 *
 * @param templateKey The template to search for metadata tags in
 * @param scope The scope to search for metadata templates in
 * @param filters The metadata tags to filter for
 * @param range An offset (NSRange location) and limit (NSRange limit). The maximum limit allowed is 200, default is 30.
 *
 * @return A request that can be customized and then executed.
 */
- (BOXSearchRequest *)searchMetadataRequestWithTemplateKey:(NSString *)templateKey
                                                     scope:(NSString *)scope
                                                   filters:(NSArray *)filters
                                                   inRange:(NSRange)range;

@end
