//
//  BOXClient+FileVersion.m
//  BoxContentSDK
//
//  Created by Rico Yao on 1/16/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXContentClient+FileVersion.h"
#import "BOXContentClient_Private.h"
#import "BOXFileVersionsRequest.h"
#import "BOXFileVersionPromoteRequest.h"

@implementation BOXContentClient (FileVersion)

- (BOXFileVersionsRequest *)fileVersionsRequestForFileWithID:(NSString *)fileID
{
    BOXFileVersionsRequest *request = [[BOXFileVersionsRequest alloc] initWithFileID:fileID];
    [self prepareRequest:request];
    return request;
}

- (BOXFileVersionPromoteRequest *)fileVersionPromoteRequestForVersionWithID:(NSString *)versionID fileID:(NSString *)fileID
{
    BOXFileVersionPromoteRequest *request = [[BOXFileVersionPromoteRequest alloc] initWithFileID:fileID targetVersionID:versionID];
    [self prepareRequest:request];
    return request;
}

@end
