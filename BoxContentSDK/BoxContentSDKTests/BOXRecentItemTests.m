//
//  BOXRecentItemTests.m
//  BoxContentSDK
//
//  Created by Andrew Dempsey on 1/26/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import "BOXModelTestCase.h"
#import "BOXRecentItem.h"

@interface BOXRecentItemTests : BOXModelTestCase

@end

@implementation BOXRecentItemTests

- (void)test_that_recent_item_with_default_fields_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"recent_item_default_fields"];
    BOXRecentItem *recentItem = [[BOXRecentItem alloc] initWithJSON:dictionary];

    XCTAssertEqualObjects(@"recent_item", recentItem.type);
    XCTAssertEqualObjects(@"item_modify", recentItem.interactionType);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2016-05-03T08:58:50-07:00"], recentItem.interactionDate);
    XCTAssertEqualObjects(nil, recentItem.sharedLinkURL);

    BOXModel *expectedItemModel = [self modelFromDict:dictionary[BOXAPIObjectKeyItem]];
    [self assertModel:expectedItemModel isEquivalentTo:recentItem.item];
}

- (void)test_that_recent_item_with_default_fields_and_shared_link_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"recent_item_default_fields_shared"];
    BOXRecentItem *recentItem = [[BOXRecentItem alloc] initWithJSON:dictionary];

    XCTAssertEqualObjects(@"recent_item", recentItem.type);
    XCTAssertEqualObjects(@"item_modify", recentItem.interactionType);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2016-05-03T08:58:50-07:00"], recentItem.interactionDate);

    NSURL *sharedLinkURL = [NSURL URLWithString:@"https://app.box.com/s/1pesjzsxhp5xdd65opfu6g3907gj0hz1"];
    XCTAssertEqualObjects(sharedLinkURL, recentItem.sharedLinkURL);

    BOXModel *expectedItemModel = [self modelFromDict:dictionary[BOXAPIObjectKeyItem]];
    [self assertModel:expectedItemModel isEquivalentTo:recentItem.item];
}

- (BOXModel *)modelFromDict:(NSDictionary *)dict
{
    BOXModel *model = nil;

    NSString *type = dict[BOXAPIObjectKeyType];

    if ([type isEqualToString:BOXAPIItemTypeFile]) {
        model = [[BOXFile alloc] initWithJSON:dict];
    } else if ([type isEqualToString:BOXAPIItemTypeFolder]) {
        model = [[BOXFolder alloc] initWithJSON:dict];
    } else if ([type isEqualToString:BOXAPIItemTypeComment]) {
        model = [[BOXComment alloc] initWithJSON:dict];
    } else if ([type isEqualToString:BOXAPIItemTypeUser]) {
        model = [[BOXUser alloc] initWithJSON:dict];
    } else if ([type isEqualToString:BOXAPIItemTypeCollection]) {
        model = [[BOXCollection alloc] initWithJSON:dict];
    } else if ([type isEqualToString:BOXAPIItemTypeWebLink]) {
        model = [[BOXBookmark alloc] initWithJSON:dict];
    }

    return model;
}

@end
