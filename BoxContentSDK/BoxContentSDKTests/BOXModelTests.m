//
//  BOXModelTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 5/19/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXModelTestCase.h"
#import "BOXModel.h"

@interface BOXModelTests : BOXModelTestCase
@end

@implementation BOXModelTests

- (void)test_that_json_response_is_parsed
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"model"];
    BOXModel *model = [[BOXModel alloc] initWithJSON:dictionary];
    
    XCTAssertEqualObjects(@"123", model.modelID);
    XCTAssertEqualObjects(@"dummy", model.type);
    
    NSDictionary *expectedJSONResponse = @{@"type" : @"dummy", @"id" : @"123"};
    XCTAssertEqualObjects(expectedJSONResponse, model.JSONData);
}

@end
