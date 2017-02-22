//
//  BOXCollectionListRequestTests.m
//  BoxContentSDK
//
//  Created on 12/15/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequest_Private.h"
#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXCollectionListRequest.h"
#import "BOXCollection.h"
#import "BOXContentCacheTestClient.h"

@interface BOXCollectionListRequestTests : BOXRequestTestCase

@end

@implementation BOXCollectionListRequestTests

- (void)test_url_request_is_correct
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [BOXContentClient APIBaseURL], BOXAPIResourceCollections]];
    BOXCollectionListRequest *request = [[BOXCollectionListRequest alloc] init];
    
    XCTAssertEqualObjects(url, request.urlRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodGET, request.urlRequest.HTTPMethod);
}

- (void)test_request_returns_expected_results
{
    NSData *data = [self cannedResponseDataWithName:@"collections"];
    NSDictionary *collectionsJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSMutableArray *expectedCollections = [NSMutableArray arrayWithCapacity:collectionsJSON.count];
    for (NSDictionary *dict in collectionsJSON[BOXAPICollectionKeyEntries]) {
        [expectedCollections addObject:[[BOXCollection alloc] initWithJSON:dict]];
    }
    
    BOXCollectionListRequest *collectionListRequest = [[BOXCollectionListRequest alloc] init];
    BOXContentCacheTestClient *cacheClient = [[BOXContentCacheTestClient alloc] init];
    collectionListRequest.cacheClient = cacheClient;

    id cacheClientMock = [OCMockObject partialMockForObject:cacheClient];

    [self setCannedURLResponse:[self cannedURLResponseWithStatusCode:200 responseData:data] cannedResponseData:data forRequest:collectionListRequest];

    [[cacheClientMock expect] cacheCollectionListRequest:collectionListRequest
                                         withCollections:[OCMArg isNotNil]
                                                   error:[OCMArg isNil]];
    [[cacheClientMock expect] retrieveCacheForCollectionListRequest:collectionListRequest completion:[OCMArg isNotNil]];

    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [collectionListRequest performRequestWithCached:^(NSArray *collections, NSError *error) {
        // Nothing should happen here.
    } refreshed:^(NSArray *collections, NSError *error) {
        XCTAssertEqual(collections.count, expectedCollections.count);

        for (NSUInteger i = 0; i < collections.count; i++) {
            [self assertModel:collections[i] isEquivalentTo:expectedCollections[i]];
        }

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    [cacheClientMock verify];
}

- (void)test_request_handles_error
{
    BOXCollectionListRequest *collectionListRequest = [[BOXCollectionListRequest alloc] init];
    BOXContentCacheTestClient *cacheClient = [[BOXContentCacheTestClient alloc] init];
    collectionListRequest.cacheClient = cacheClient;

    id cacheClientMock = [OCMockObject partialMockForObject:cacheClient];

    [self setCannedURLResponse:[self cannedURLResponseWithStatusCode:404 responseData:nil]
            cannedResponseData:nil
                    forRequest:collectionListRequest];

    [[cacheClientMock expect] cacheCollectionListRequest:collectionListRequest
                                         withCollections:[OCMArg isNil]
                                                   error:[OCMArg isNotNil]];
    [[cacheClientMock expect] retrieveCacheForCollectionListRequest:collectionListRequest completion:[OCMArg isNotNil]];

    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [collectionListRequest performRequestWithCached:^(NSArray *collections, NSError *error) {
        // Nothing should happen here.
    } refreshed:^(NSArray *collections, NSError *error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    
    [cacheClientMock verify];
}

@end
