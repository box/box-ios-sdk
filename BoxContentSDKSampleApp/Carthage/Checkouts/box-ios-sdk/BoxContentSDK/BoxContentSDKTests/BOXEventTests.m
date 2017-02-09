//
//  BOXEventTests.m
//  BoxContentSDK
//
//  Created on 12/16/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXModelTestCase.h"
#import "BOXEvent.h"
#import "BOXUser.h"
#import "BOXFile.h"
#import "BOXFolder.h"
#import "BOXBookmark.h"
#import "BOXComment.h"
#import "BOXCollection.h"

@interface BOXEventTests : BOXModelTestCase

@end

@implementation BOXEventTests

- (void)test_event_is_parsed_corretly
{
    NSDictionary *dict = [self dictionaryFromCannedJSON:@"event_all_fields"];
    BOXUser *expectedCreator = [[BOXUser alloc] initWithJSON:dict[BOXAPIObjectKeyCreatedBy]];
    BOXModel *expectedModel = [self modelFromDict:dict[BOXAPIObjectKeySource]];
    
    BOXEvent *event = [[BOXEvent alloc] initWithJSON:dict];
    
    XCTAssertEqualObjects(event.modelID, @"59258b2c913b322decec09a5b2932ddb57dfa296");
    XCTAssertEqualObjects(event.createdDate, [NSDate box_dateWithISO8601String:@"2014-11-03T06:25:44-08:00"]);
    XCTAssertEqualObjects(event.eventType, @"ITEM_PREVIEW");
    XCTAssertEqualObjects(event.sessionID, @"dlfkgjdflgkjd");

    [self assertModel:event.creator isEquivalentTo:expectedCreator];
    XCTAssertEqualObjects(event.creator.modelID, @"14292077");
    
    [self assertModel:event.source isEquivalentTo:expectedModel];
    XCTAssertEqualObjects(event.source.modelID, @"22371775721");
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
