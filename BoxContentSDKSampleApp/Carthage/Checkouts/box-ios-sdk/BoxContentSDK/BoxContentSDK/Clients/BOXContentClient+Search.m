//
//  BOXClient+Search.m
//  BoxContentSDK
//
//  Created by Rico Yao on 1/16/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXContentClient+Search.h"
#import "BOXContentClient_Private.h"
#import "BOXSearchRequest.h"

@implementation BOXContentClient (Search)

- (BOXSearchRequest *)searchRequestWithQuery:(NSString *)query inRange:(NSRange)range
{
    BOXSearchRequest *request = [[BOXSearchRequest alloc] initWithSearchQuery:query inRange:range];
    [self prepareRequest:request];
    
    return request;
}

- (BOXSearchRequest *)searchMetadataRequestWithTemplateKey:(NSString *)templateKey scope:(NSString *)scope filters:(NSArray *)filters inRange:(NSRange)range
{
    BOXSearchRequest *request = [[BOXSearchRequest alloc] initWithTemplateKey:templateKey scope:scope filters:filters inRange:range];
    [self prepareRequest:request];
    
    return request;
}

@end
