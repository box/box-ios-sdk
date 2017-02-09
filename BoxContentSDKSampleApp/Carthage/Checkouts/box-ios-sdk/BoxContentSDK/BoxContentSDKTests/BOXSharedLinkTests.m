//
//  BOXSharedLinkTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/12/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXModelTestCase.h"
#import "BOXSharedLink.h"

@interface BOXSharedLinkTests : BOXModelTestCase
@end

@implementation BOXSharedLinkTests

- (void)test_that_shared_link_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"shared_link"];
    BOXSharedLink *sharedLink = [[BOXSharedLink alloc] initWithJSON:dictionary];
    
    XCTAssertEqualObjects([NSURL URLWithString:@"https://www.box.com/s/aaa"], sharedLink.url);
    XCTAssertEqualObjects([NSURL URLWithString:@"https://www.box.com/s/bbb"], sharedLink.downloadURL);
    XCTAssertEqualObjects([NSURL URLWithString:@"https://www.box.com/s/ccc"], sharedLink.vanityURL);
    XCTAssertEqual(BOXAPIBooleanYES, sharedLink.isPasswordEnabled);
    XCTAssertEqual(BOXAPIBooleanYES, sharedLink.canDownload);
    XCTAssertEqual(BOXAPIBooleanYES, sharedLink.canPreview);
    XCTAssertEqualObjects(@"collaborators", sharedLink.accessLevel);
    XCTAssertEqualObjects(@"collaborators", sharedLink.effectiveAccessLevel);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2012-12-12T10:53:43-08:00"], sharedLink.expirationDate);
    XCTAssertEqualObjects([NSNumber numberWithInt:123], sharedLink.downloadCount);
    XCTAssertEqualObjects([NSNumber numberWithInt:456], sharedLink.previewCount);
}

@end
