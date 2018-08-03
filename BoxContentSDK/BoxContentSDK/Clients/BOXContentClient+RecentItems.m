//
//  BOXContentClient+RecentItems.m
//  Pods
//
//  Created by Andrew Dempsey on 12/19/16.
//
//

#import "BOXContentClient+RecentItems.h"
#import "BOXRecentItemsRequest.h"

@implementation BOXContentClient (RecentItems)

- (BOXRecentItemsRequest *)recentItemsRequestForCurrentUser
{
    BOXRecentItemsRequest *request = [[BOXRecentItemsRequest alloc] init];
    [self prepareRequest:request];

    return request;
}

- (BOXRecentItemsRequest *)recentItemsRequestForCurrentUserWithMetadata:(NSString *)metadataTemplateKey metadataScope:(NSString *)metadataScope
{
    BOXRecentItemsRequest *request = [[BOXRecentItemsRequest alloc] init];
    request.metadataScope = metadataScope;
    request.metadataTemplateKey = metadataTemplateKey;
    [self prepareRequest:request];
    
    return request;
}

@end
