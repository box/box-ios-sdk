//
//  BOXCollectionItemsRequestTests.m
//  BoxContentSDK
//
//  Created on 12/15/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequest_Private.h"
#import "BOXRequestTestCase.h"
#import "BOXCollectionItemsRequest.h"
#import "BOXCollection.h"
#import "BOXContentClient.h"
#import "BOXFile.h"
#import "BOXFolder.h"
#import "BOXBookmark.h"
#import "BOXContentCacheTestClient.h"
#import "BOXContentSDKTestsConstants.h"

@interface BOXCollectionItemsRequestTests : BOXRequestTestCase

@end

@implementation BOXCollectionItemsRequestTests

#pragma mark - URLRequest

- (void)test_that_request_with_metadata_templateKey_and_scope_creates_query_parameters_with_metadata_info
{
    BOXCollectionItemsRequest *request = [[BOXCollectionItemsRequest alloc] initWithCollectionID:@"some_collection_id" inRange:NSMakeRange(0, 0) metadataTemplateKey:@"test" metadataScope:@"scope"];
    request.requestAllItemFields = YES;

    BOXAPIOperation *op = [request createOperation];
    NSDictionary *queryDict = op.queryStringParameters;
    NSString *fieldString = queryDict[BOXAPIParameterKeyFields];

    XCTAssertTrue([fieldString isEqualToString:expectedItemRequestFieldsStringWithMetadata]);
}

- (void)test_request_url_is_correct_without_range
{
    NSData *data = [self cannedResponseDataWithName:@"collection_all_fields"];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    BOXCollection *collection = [[BOXCollection alloc] initWithJSON:dict];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@", [BOXContentClient APIBaseURL], BOXAPIResourceCollections, collection.modelID, BOXAPISubresourceItems]];
    
    BOXCollectionItemsRequest *collectionItemsRequest = [[BOXCollectionItemsRequest alloc] initWithCollectionID:collection.modelID inRange:NSMakeRange(0, 0)];
    XCTAssertEqualObjects(url, collectionItemsRequest.urlRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodGET, collectionItemsRequest.urlRequest.HTTPMethod);
}

#pragma mark - Perform Request

- (void)test_that_expected_items_are_returned_for_folder
{
    BOXCollectionItemsRequest *request = [[BOXCollectionItemsRequest alloc] initWithCollectionID:@"123"
                                                                                         inRange:NSMakeRange(0, 5)];
    BOXContentCacheTestClient *cacheClient = [[BOXContentCacheTestClient alloc] init];
    request.cacheClient = cacheClient;

    id cacheClientMock = [OCMockObject partialMockForObject:cacheClient];

    NSData *cannedData = [self cannedResponseDataWithName:@"get_items"];
    
    NSDictionary *expectedResults = [NSJSONSerialization JSONObjectWithData:cannedData options:kNilOptions error:nil];
    
    NSArray *itemsArray = expectedResults[@"entries"];
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

    [[cacheClientMock expect] cacheCollectionItemsRequest:request
                                                withItems:[OCMArg isNotNil]
                                                    error:[OCMArg isNil]];
    [[cacheClientMock expect] retrieveCacheForCollectionItemsRequest:request completion:[OCMArg isNotNil]];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCached:^(NSArray *items, NSUInteger totalCount, NSRange range, NSError *error) {
        // Nothing should happen here.
    } refreshed:^(NSArray *items, NSUInteger totalCount, NSRange range, NSError *error) {
        XCTAssertNil(error);
        XCTAssertEqual(items.count, expectedItems.count);
        XCTAssertEqual(totalCount, 24);
        XCTAssertEqual(range.location, 0);
        XCTAssertEqual(range.length, 5);
        
        for (NSUInteger i = 0; i < items.count ; i++) {
            [self assertModel:items[i] isEquivalentTo:expectedItems[i]];
        }
        
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    [cacheClientMock verify];
}

- (void)test_request_handles_error
{
    BOXCollectionItemsRequest *request = [[BOXCollectionItemsRequest alloc] initWithCollectionID:@"123"
                                                                                         inRange:NSMakeRange(0, 5)];
    BOXContentCacheTestClient *cacheClient = [[BOXContentCacheTestClient alloc] init];
    request.cacheClient = cacheClient;

    id cacheClientMock = [OCMockObject partialMockForObject:cacheClient];

    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:404 responseData:nil];

    [self setCannedURLResponse:response cannedResponseData:nil forRequest:request];

    [[cacheClientMock expect] cacheCollectionItemsRequest:request
                                                withItems:[OCMArg isNil]
                                                    error:[OCMArg isNotNil]];
    [[cacheClientMock expect] retrieveCacheForCollectionItemsRequest:request completion:[OCMArg isNotNil]];

    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCached:^(NSArray *items, NSUInteger totalCount, NSRange range, NSError *error) {
        // Nothing should happen here.
    } refreshed:^(NSArray *items, NSUInteger totalCount, NSRange range, NSError *error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    [cacheClientMock verify];
}

@end
