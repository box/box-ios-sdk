//
//  BOXUserTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/3/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXModelTestCase.h"
#import "BOXUser.h"

@interface BOXUserTests : BOXModelTestCase
@end

@implementation BOXUserTests

- (void)test_that_mini_user_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"user_mini_fields"];
    BOXUser *user = [[BOXUser alloc] initWithJSON:dictionary];
    
    XCTAssertEqualObjects(@"13338532", user.modelID);
    XCTAssertEqualObjects(@"Michelle Brown", user.name);
    XCTAssertEqualObjects(@"booxqa@gmail.com", user.login);
}

- (void)test_that_user_with_default_fields_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"user_default_fields"];
    BOXUser *user = [[BOXUser alloc] initWithJSON:dictionary];
    
    XCTAssertEqualObjects(@"13338532", user.modelID);
    XCTAssertEqualObjects(@"Michelle Brown", user.name);
    XCTAssertEqualObjects(@"booxqa@gmail.com", user.login);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2011-09-02T09:38:01-07:00"], user.createdDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-11-26T12:04:22-08:00"], user.modifiedDate);
    XCTAssertEqualObjects(@"en", user.language);
    XCTAssertEqualObjects(@"America/Los_Angeles", user.timeZone);
    XCTAssertEqual(53687091200l, [user.spaceAmount longLongValue]);
    XCTAssertEqual(6099293l, [user.spaceUsed longLongValue]);
    XCTAssertEqual(262144000l, [user.maxUploadSize longLongValue]);
    
    XCTAssertEqualObjects(@"active", user.status);
    XCTAssertEqualObjects(@"Professional Ultimate Frisbee Player", user.jobTitle);
    XCTAssertEqualObjects(@"604-423-4362", user.phone);
    XCTAssertEqualObjects(@"100 Main Street, Vancouver BC, Canada", user.address);
    XCTAssertEqualObjects([NSURL URLWithString:@"https://app.box.com/api/avatar/large/13338532"], user.avatarURL);
    
    XCTAssertNil(user.role);
    XCTAssertNil(user.trackingCodes);
    XCTAssertEqual(BOXAPIBooleanUnknown, user.canSeeManagedUsers);
    XCTAssertEqual(BOXAPIBooleanUnknown, user.isSyncEnabled);
    XCTAssertEqual(BOXAPIBooleanUnknown, user.isExternalCollabRestricted);
    XCTAssertEqual(BOXAPIBooleanUnknown, user.isExemptFromDeviceLimits);
    XCTAssertEqual(BOXAPIBooleanUnknown, user.isExemptFromLoginVerification);
    XCTAssertNil(user.enterprise);
}

- (void)test_that_user_with_all_fields_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"user_all_fields"];
    BOXUser *user = [[BOXUser alloc] initWithJSON:dictionary];
    
    XCTAssertEqualObjects(@"13338532", user.modelID);
    XCTAssertEqualObjects(@"Michelle Brown", user.name);
    XCTAssertEqualObjects(@"booxqa@gmail.com", user.login);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2011-09-02T09:38:01-07:00"], user.createdDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-11-26T12:04:22-08:00"], user.modifiedDate);
    XCTAssertEqualObjects(@"en", user.language);
    XCTAssertEqualObjects(@"America/Los_Angeles", user.timeZone);
    XCTAssertEqual(53687091200l, [user.spaceAmount longLongValue]);
    XCTAssertEqual(6099293l, [user.spaceUsed longLongValue]);
    XCTAssertEqual(262144000l, [user.maxUploadSize longLongValue]);
    XCTAssertEqualObjects(@"active", user.status);
    XCTAssertEqualObjects(@"Professional Ultimate Frisbee Player", user.jobTitle);
    XCTAssertEqualObjects(@"604-423-4362", user.phone);
    XCTAssertEqualObjects(@"100 Main Street, Vancouver BC, Canada", user.address);
    XCTAssertEqualObjects([NSURL URLWithString:@"https://app.box.com/api/avatar/large/13338532"], user.avatarURL);
    XCTAssertEqual(BOXAPIBooleanYES, user.hasCustomAvatar);
    
    XCTAssertEqualObjects(@"user", user.role);
    NSArray *expectedTrackingCodes = @[
                                       @{@"type" : @"tracking_code",
                                         @"name" : @"tracking code 1",
                                         @"value" : @"tracking code value 1"},
                                       @{@"type" : @"tracking_code",
                                         @"name" : @"tracking code 2",
                                         @"value" : @"tracking code value 2"}
                                       ];
    XCTAssertEqualObjects(expectedTrackingCodes, user.trackingCodes);
    XCTAssertEqual(BOXAPIBooleanYES, user.canSeeManagedUsers);
    XCTAssertEqual(BOXAPIBooleanYES, user.isSyncEnabled);
    XCTAssertEqual(BOXAPIBooleanYES, user.isExternalCollabRestricted);
    XCTAssertEqual(BOXAPIBooleanNO, user.isExemptFromDeviceLimits);
    XCTAssertEqual(BOXAPIBooleanNO, user.isExemptFromLoginVerification);
    
    XCTAssertEqualObjects(@"17077211", user.enterprise.modelID);
    XCTAssertEqualObjects(@"Furious George", user.enterprise.name);
    XCTAssertEqual(BOXAPIBooleanYES, user.isBoxNotesCreationEnabled);
}

- (void)test_that_user_with_all_fields_and_null_enterprise_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"user_all_fields_null_enterprise"];
    BOXUser *user = [[BOXUser alloc] initWithJSON:dictionary];
    
    XCTAssertEqualObjects(@"13338532", user.modelID);
    XCTAssertEqualObjects(@"Michelle Brown", user.name);
    XCTAssertEqualObjects(@"booxqa@gmail.com", user.login);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2011-09-02T09:38:01-07:00"], user.createdDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-11-26T12:04:22-08:00"], user.modifiedDate);
    XCTAssertEqualObjects(@"en", user.language);
    XCTAssertEqualObjects(@"America/Los_Angeles", user.timeZone);
    XCTAssertEqual(53687091200l, [user.spaceAmount longLongValue]);
    XCTAssertEqual(6099293l, [user.spaceUsed longLongValue]);
    XCTAssertEqual(262144000l, [user.maxUploadSize longLongValue]);
    XCTAssertEqualObjects(@"active", user.status);
    XCTAssertEqualObjects(@"Professional Ultimate Frisbee Player", user.jobTitle);
    XCTAssertEqualObjects(@"604-423-4362", user.phone);
    XCTAssertEqualObjects(@"100 Main Street, Vancouver BC, Canada", user.address);
    XCTAssertEqualObjects([NSURL URLWithString:@"https://app.box.com/api/avatar/large/13338532"], user.avatarURL);
    XCTAssertEqual(BOXAPIBooleanYES, user.hasCustomAvatar);
    
    XCTAssertEqualObjects(@"user", user.role);
    NSArray *expectedTrackingCodes = @[
                                       @{@"type" : @"tracking_code",
                                         @"name" : @"tracking code 1",
                                         @"value" : @"tracking code value 1"},
                                       @{@"type" : @"tracking_code",
                                         @"name" : @"tracking code 2",
                                         @"value" : @"tracking code value 2"}
                                       ];
    XCTAssertEqualObjects(expectedTrackingCodes, user.trackingCodes);
    XCTAssertEqual(BOXAPIBooleanYES, user.canSeeManagedUsers);
    XCTAssertEqual(BOXAPIBooleanYES, user.isSyncEnabled);
    XCTAssertEqual(BOXAPIBooleanYES, user.isExternalCollabRestricted);
    XCTAssertEqual(BOXAPIBooleanNO, user.isExemptFromDeviceLimits);
    XCTAssertEqual(BOXAPIBooleanNO, user.isExemptFromLoginVerification);
    XCTAssertEqual(BOXAPIBooleanNO, user.isBoxNotesCreationEnabled);
    
    XCTAssertNil(user.enterprise);
}


@end
                       
