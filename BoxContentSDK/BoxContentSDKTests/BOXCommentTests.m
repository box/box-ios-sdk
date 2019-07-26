//
//  BOXCommentTests.m
//  BoxContentSDK
//
//  Created by Clement Rousselle on 12/9/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXModelTestCase.h"
#import "BOXComment.h"
#import "BOXUser.h"
#import "BOXItem.h"
#import "BOXFile.h"

@interface BOXCommentsTests : BOXModelTestCase
@end

@implementation BOXCommentsTests

- (void)test_that_comment_with_all_fields_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"comment_all_fields"];
    BOXComment *comment = [[BOXComment alloc] initWithJSON:dictionary];
    
    XCTAssertEqualObjects(@"191969", comment.modelID);
    XCTAssertEqualObjects(@"comment", comment.type);
    XCTAssertEqualObjects(@"These tigers are cool!", comment.message);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2012-12-12T11:25:01-08:00"], comment.createdDate);
    XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-13-12T11:25:01-09:00"], comment.modifiedDate);
    XCTAssertTrue(comment.isReplyComment);
    
    BOXUserMini *creator = [[BOXUserMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyCreatedBy]];
    BOXFileMini *item = [[BOXFileMini alloc] initWithJSON:dictionary[BOXAPIObjectKeyItem]];
    
    [self assertModel:creator isEquivalentTo:comment.creator];
    XCTAssertEqualObjects(comment.creator.modelID, @"17738362");
    [self assertModel:item isEquivalentTo:comment.item];
    XCTAssertEqualObjects(comment.item.modelID, @"5000948880");
}




@end