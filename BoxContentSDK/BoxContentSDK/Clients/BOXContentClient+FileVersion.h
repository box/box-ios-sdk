//
//  BOXClient+FileVersion.h
//  BoxContentSDK
//
//  Created by Rico Yao on 1/16/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXContentClient.h"

@class BOXFileVersionsRequest;
@class BOXFileVersionPromoteRequest;

@interface BOXContentClient (FileVersion)

/**
 *  Generate a request to retrieve the versions of a file.
 *
 *  @param fileID File ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileVersionsRequest *)fileVersionsRequestForFileWithID:(NSString *)fileID;

/**
 *  Generate a request to promote a version of a file to be the current version.
 *
 *  @param versionID Version ID to be made current.
 *  @param fileID    File ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileVersionPromoteRequest *)fileVersionPromoteRequestForVersionWithID:(NSString *)versionID fileID:(NSString *)fileID;

@end
