//
//  BOXRecentItemsRequestTests.m
//  BoxContentSDK
//
//  Created by Andrew Dempsey on 1/26/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXRequest_Private.h"
#import "BOXContentClient.h"
#import "BOXContentSDKConstants.h"
#import "BOXRecentItem.h"
#import "BOXRecentItemsRequest.h"
#import "NSURL+BOXURLHelper.h"
#import "BOXContentSDKTestsConstants.h"

@interface BOXRecentItemsRequestTests : BOXRequestTestCase

@end

@implementation BOXRecentItemsRequestTests

- (void)test_url_request_is_correct_with_default_values
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", [BOXContentClient APIBaseURL], BOXAPIResourceRecentItems];
    NSURL *url = [NSURL URLWithString:urlString];
    BOXRecentItemsRequest *request = [[BOXRecentItemsRequest alloc] init];

    XCTAssertEqualObjects(BOXAPIHTTPMethodGET, request.urlRequest.HTTPMethod);
    XCTAssertEqualObjects(url, request.urlRequest.URL);
}

- (void)test_url_request_is_correct_with_all_values
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", [BOXContentClient APIBaseURL], BOXAPIResourceRecentItems];
    NSURL *url = [NSURL URLWithString:urlString];

    BOXRecentItemsRequest *request = [[BOXRecentItemsRequest alloc] init];
    request.limit = 2;
    request.nextMarker = @"b2Zmc2V0PTIK";
    request.listType = BOXAPIRecentItemsListTypeShared;

    NSMutableDictionary *expectedParameters = [NSMutableDictionary dictionary];
    expectedParameters[BOXAPIParameterKeyLimit] = @"2";
    expectedParameters[BOXAPIParameterKeyNextMarker] = @"b2Zmc2V0PTIK";
    expectedParameters[BOXAPIParameterKeyListType] = BOXAPIRecentItemsListTypeShared;

    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@",
                                             request.urlRequest.URL.scheme,
                                             request.urlRequest.URL.host,
                                             request.urlRequest.URL.path];
    XCTAssertEqualObjects(BOXAPIHTTPMethodGET, request.urlRequest.HTTPMethod);
    XCTAssertEqualObjects([url absoluteString], actualURLWithoutQueryString);

    NSDictionary *parameters = [request.urlRequest.URL box_queryDictionary];
    XCTAssertTrue([expectedParameters isEqualToDictionary:parameters]);
}

- (void)test_request_returns_correct_results
{
    NSData *cannedData = [self cannedResponseDataWithName:@"recent_items"];
    NSDictionary *expectedResults = [NSJSONSerialization JSONObjectWithData:cannedData
                                                                    options:kNilOptions
                                                                      error:nil];
    NSArray *recentItemsJSON = expectedResults[BOXAPICollectionKeyEntries];
    NSMutableArray<BOXRecentItem *> *expectedRecentItems = [NSMutableArray array];

    for (NSDictionary *dict in recentItemsJSON) {
        BOXRecentItem *recentItem = [[BOXRecentItem alloc] initWithJSON:dict];
        [expectedRecentItems addObject:recentItem];
    }

    BOXRecentItemsRequest *request = [[BOXRecentItemsRequest alloc] init];
    NSHTTPURLResponse *cannedResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedData];
    [self setCannedURLResponse:cannedResponse
            cannedResponseData:cannedData
                    forRequest:request];

    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(NSArray *recentItems, NSString *nextMarker, NSError *error) {
        XCTAssertEqual(recentItems.count, expectedRecentItems.count);
        XCTAssertTrue([nextMarker isEqualToString:expectedResults[BOXAPIParameterKeyNextMarker]]);

        [recentItems enumerateObjectsUsingBlock:^(BOXRecentItem *recentItem, NSUInteger idx, BOOL *stop) {
            BOXRecentItem *expectedRecentItem = expectedRecentItems[idx];

            XCTAssertEqualObjects(expectedRecentItem.interactionDate, recentItem.interactionDate);
            XCTAssertEqualObjects(expectedRecentItem.interactionType, recentItem.interactionType);
            XCTAssertEqualObjects(expectedRecentItem.sharedLinkURL, recentItem.sharedLinkURL);
            [self assertModel:expectedRecentItem.item isEquivalentTo:recentItem.item];
        }];

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)test_that_request_with_metadata_templateKey_and_scope_creates_query_parameters_with_metadata_info
{
    BOXRecentItemsRequest *request = [[BOXRecentItemsRequest alloc] init];
    request.requestAllItemFields = YES;
    request.metadataTemplateKey = @"test";
    request.metadataScope = @"scope";
    
    BOXAPIOperation *op = [request createOperation];
    NSDictionary *queryDict = op.queryStringParameters;
    NSString *fieldString = queryDict[BOXAPIParameterKeyFields];
    
    XCTAssertTrue([fieldString isEqualToString:expectedItemRequestFieldsStringWithMetadata]);
    
}

@end
