//
//  BOXContentClient+RecentItems.h
//  Pods
//
//  Created by Andrew Dempsey on 12/19/16.
//
//

#import <BoxContentSDK/BOXContentSDK.h>

@class BOXRecentItemsRequest;

@interface BOXContentClient (RecentItems)

/**
 Generate a request to retrieve recent items for the current user.

 @return A request that can be customized and then executed.
 */
- (BOXRecentItemsRequest *)recentItemsRequestForCurrentUser;
- (BOXRecentItemsRequest *)recentItemsRequestForCurrentUserWithMetadata:(NSString *)metadataTemplateKey metadataScope:(NSString *)metadataScope;

@end
