    //
//  BOXRequestWithSharedLinkHeadersTests.m
//  BoxContentSDK
//
//  Created by Clement Rousselle on 1/26/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXFileRequest.h"
#import "BOXContentClient+File.h"
#import "BOXContentClient.h"
#import "BOXSharedLinkHeadersHelper.h"
#import "BOXSharedLinkHeadersDefaultManager.h"
#import "BOXUser.h"

@interface BOXSharedLinkHeadersHelper ()

- (NSString *)userID;

@end

@interface BOXRequestWithSharedLinkHeadersTests : BOXRequestTestCase
@end

@implementation BOXRequestWithSharedLinkHeadersTests


- (void)test_headers_are_created_correctly
{
    NSString *sharedLinkURL = @"http://mysharedLinkURL.com";
    NSString *sharedLinkPassword = @"mySharedLinkPassword";
    NSString *fileID = @"1234556";
    NSString *userID = @"976876";
    
    BOXSharedLinkHeadersDefaultManager *defaultManager = [[BOXSharedLinkHeadersDefaultManager alloc] init];
    [defaultManager storeSharedLink:sharedLinkURL forItemWithIDKey:fileID itemTypeKey:@"file" password:sharedLinkPassword userIDKey:userID];
    id sharedLinkHelperMock = [OCMockObject partialMockForObject:[[BOXSharedLinkHeadersHelper alloc] init]];//:[[BOXSharedLinkHeadersHelper alloc] init]];
    [[[sharedLinkHelperMock stub] andReturn:userID] userID];
    [[[sharedLinkHelperMock stub] andReturn:defaultManager] delegate];
        
    BOXFileRequest *fileRequest = [[BOXFileRequest alloc] initWithFileID:fileID];
    fileRequest.sharedLinkHeadersHelper = sharedLinkHelperMock;
    
    NSURLRequest *urlRequest = fileRequest.urlRequest;
    NSDictionary *dictionary = [urlRequest allHTTPHeaderFields];
    NSString *boxAPIHeaders = dictionary[@"BoxApi"];
    XCTAssertTrue(boxAPIHeaders.length > 0);
    
    
    NSArray *array = [boxAPIHeaders componentsSeparatedByString:@"&"];
    
    for (NSString *keyValue in array) {
        NSArray *tmp = [keyValue componentsSeparatedByString:@"="];
        
        if ([tmp[0] isEqualToString:@"shared_link"]) {
            XCTAssertEqualObjects(tmp[1], sharedLinkURL);
        } else if ([tmp[0] isEqualToString:@"shared_link_password"]) {
            XCTAssertEqualObjects(tmp[1], sharedLinkPassword);
        } else {
            XCTAssertTrue(NO);
        }
    }
}

@end