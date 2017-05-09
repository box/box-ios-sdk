//
//  BOXCollaborationTests.m
//  BoxContentSDK
//
//  Created by Jeremy Pang on 12/16/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXModelTestCase.h"
#import "BOXCollaboration.h"
#import "BOXUser.h"
#import "BOXFolder.h"

@interface BOXCollaborationTests : BOXModelTestCase
@end

@implementation BOXCollaborationTests

- (void)test_that_collaboration_with_all_fields_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"collaboration"];
    BOXCollaboration *collaboration = [[BOXCollaboration alloc] initWithJSON:dictionary];
    
    XCTAssertEqualObjects(@"791293", collaboration.modelID);
    
    BOXUserMini *creator = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyCreatedBy]];
    
    [self assertModel:creator isEquivalentTo:collaboration.creator];
    XCTAssertEqualObjects(@"17738362", collaboration.creator.modelID);

    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2012-12-12T10:54:37-08:00"], collaboration.createdDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2012-12-12T11:30:43-08:00"], collaboration.modificationDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2013-12-12T11:30:43-08:00"], collaboration.expirationDate);
    XCTAssertEqualObjects(@"accepted", collaboration.status);
    XCTAssertEqualObjects(@"editor", collaboration.role);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2012-12-12T11:30:43-08:00"], collaboration.acknowledgedDate);
    BOXUserMini *user = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyAccessibleBy]];
    [self assertModel:user isEquivalentTo:collaboration.accessibleBy];

    BOXItemMini *item = [[BOXItemMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyItem]];
    
    [self assertModel:item isEquivalentTo:collaboration.item];
    XCTAssertEqualObjects(@"11446500", collaboration.item.modelID);
}


@end
