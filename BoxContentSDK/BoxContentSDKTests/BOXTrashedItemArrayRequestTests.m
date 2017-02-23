//
//  BOXTrashedItemArrayRequestTests.m
//  BoxContentSDK
//
//  Created by Jeremy Pang on 12/23/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXTrashedItemArrayRequest.h"
#import "BOXRequest_Private.h"
#import "NSURL+BOXURLHelper.h"
#import "BOXFile.h"
#import "BOXFolder.h"
#import "BOXBookmark.h"

@interface BOXTrashedItemArrayRequestTests : BOXRequestTestCase

@end

@implementation BOXTrashedItemArrayRequestTests

#pragma mark - URLRequest

- (void)test_that_basic_request_has_expected_URLRequest
{
    BOXTrashedItemArrayRequest *request = [[BOXTrashedItemArrayRequest alloc] initWithRange:NSMakeRange(2, 5)];
    request.requestAllItemFields = YES;
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSString *expectedURL = [NSString stringWithFormat:@"%@/folders/trash/items", [BOXContentClient APIBaseURL]];
    NSString *requestURL = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    
    XCTAssertEqualObjects(expectedURL, requestURL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
    
    NSDictionary *requestURLParameters = [URLRequest.URL box_queryDictionary];
    NSString *expectedFieldsString = [[[BOXRequest alloc] init] fullItemFieldsParameterString];
    
    XCTAssertEqualObjects([requestURLParameters[BOXAPIParameterKeyFields] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], expectedFieldsString);
    XCTAssertEqualObjects(requestURLParameters[BOXAPIParameterKeyLimit], @"5");
    XCTAssertEqualObjects(requestURLParameters[BOXAPIParameterKeyOffset], @"2");
}

#pragma mark - Perform Request

- (void)test_that_expected_items_are_returned_for_folder
{
    BOXTrashedItemArrayRequest *request = [[BOXTrashedItemArrayRequest alloc] initWithRange:NSMakeRange(0, 6)];
    
    NSData *cannedData = [self cannedResponseDataWithName:@"trashed_items"];
    
    NSDictionary *expectedResults = [NSJSONSerialization JSONObjectWithData:cannedData options:kNilOptions error:nil];
    
    NSArray *itemsArray = expectedResults[BOXAPIObjectKeyEntries];
    NSMutableArray *expectedItems = [NSMutableArray array];
    
    for (NSDictionary *itemDictionary in itemsArray) {
        NSString *itemType = [itemDictionary objectForKey:BOXAPIObjectKeyType];
        if ([itemType isEqualToString:BOXAPIItemTypeFile]) {
            [expectedItems addObject:[[BOXFile alloc] initWithJSON:itemDictionary]];
        } else if ([itemType isEqualToString:BOXAPIItemTypeFolder]) {
            [expectedItems addObject:[[BOXFolder alloc] initWithJSON:itemDictionary]];
        } else if ([itemType isEqualToString:BOXAPIItemTypeWebLink]) {
            [expectedItems addObject:[[BOXBookmark alloc] initWithJSON:itemDictionary]];
        } else {
            [expectedItems addObject:[[BOXItem alloc] initWithJSON:itemDictionary]];
        }
    }
    
    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:200 responseData:cannedData];
    
    [self setCannedURLResponse:response cannedResponseData:cannedData forRequest:request];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(NSArray *items, NSUInteger totalCount, NSRange range, NSError *error) {
        XCTAssertNil(error);
        XCTAssertEqual(items.count, 6);
        XCTAssertEqual(totalCount, 100);
        XCTAssertEqual(range.length, 6);
        XCTAssertEqual(range.location, 0);
        
        for (NSUInteger i = 0; i < items.count ; i++) {
            [self assertModel:items[i] isEquivalentTo:expectedItems[i]];
        }
        
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
