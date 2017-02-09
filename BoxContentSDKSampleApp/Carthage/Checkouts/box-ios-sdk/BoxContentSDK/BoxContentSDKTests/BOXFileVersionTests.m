//
//  BOXFileVersionTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/31/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXModelTestCase.h"
#import "BOXFileVersion.h"
#import "BOXUser.h"

@interface BOXFileVersionTests : BOXModelTestCase
@end

@implementation BOXFileVersionTests

- (void)test_that_file_version_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"file_version"];
    BOXFileVersion *fileVersion = [[BOXFileVersion alloc] initWithJSON:dictionary];
    
    XCTAssertEqualObjects(@"22648534753", fileVersion.modelID);
    XCTAssertEqualObjects(@"Borg Invasion Plan.pptx", fileVersion.name);
    XCTAssertEqualObjects(@"9bab16941f6b7c25d2e7c85df99550640ae944ff", fileVersion.sha1);
    XCTAssertEqualObjects([NSNumber numberWithLong:2678490], fileVersion.size);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-12-31T11:58:31-08:00"], fileVersion.createdDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-12-31T11:58:32-08:00"], fileVersion.modifiedDate);
    XCTAssertEqualObjects(@"205510680", fileVersion.lastModifier.modelID);
    XCTAssertEqualObjects(@"Captain Janeway", fileVersion.lastModifier.name);
    XCTAssertEqualObjects(@"janeway04@starfleet.com", fileVersion.lastModifier.login);
}

@end
