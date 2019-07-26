//
//  BOXEventsRequestTests.m
//  BoxContentSDK
//
//  Created on 12/17/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXEvent.h"
#import "BOXEventsRequest.h"
#import "NSURL+BOXURLHelper.h"


@interface BOXEventsRequestTests : BOXRequestTestCase

@end

@implementation BOXEventsRequestTests

- (void)test_url_request_is_correct_with_default_values
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [BOXContentClient APIBaseURL], BOXAPIResourceEvents]];
    BOXEventsRequest *request = [[BOXEventsRequest alloc] init];
    
    XCTAssertEqualObjects(BOXAPIHTTPMethodGET, request.urlRequest.HTTPMethod);
    XCTAssertEqualObjects(url, request.urlRequest.URL);
}

- (void)test_url_request_is_correct_with_all_values
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [BOXContentClient APIBaseURL], BOXAPIResourceEvents]];
    BOXEventsRequest *request = [[BOXEventsRequest alloc] init];
    request.streamType = BOXEventsStreamTypeChanges;
    request.limit = 200;
    NSString *streamPosition = @"DFLSDFKGJFDLGKJFDSGF";
    request.streamPosition = streamPosition;
    
    NSMutableDictionary *expectedParameters = [NSMutableDictionary dictionary];
    [expectedParameters setObject:@"changes" forKey:BOXAPIParameterKeyStreamType];
    [expectedParameters setObject:@"200" forKey:BOXAPIParameterKeyLimit];
    [expectedParameters setObject:streamPosition forKey:BOXAPIParameterKeyStreamPosition];
    
    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@", request.urlRequest.URL.scheme, request.urlRequest.URL.host, request.urlRequest.URL.path];
    
    XCTAssertEqualObjects(BOXAPIHTTPMethodGET, request.urlRequest.HTTPMethod);
    XCTAssertEqualObjects([url absoluteString], actualURLWithoutQueryString);
    
    NSDictionary *parameters = [request.urlRequest.URL box_queryDictionary];
    
    XCTAssertTrue([expectedParameters isEqualToDictionary:parameters]);
}

- (void)test_request_returns_correct_results
{
    NSData *cannedData = [self cannedResponseDataWithName:@"events"];
    NSDictionary *expectedResults = [NSJSONSerialization JSONObjectWithData:cannedData options:kNilOptions error:nil];
    
    NSArray *eventsJson = expectedResults[BOXAPICollectionKeyEntries];
    NSMutableArray *expectedEvents = [NSMutableArray array];
    
    for (NSDictionary *dict in eventsJson) {
        [expectedEvents addObject:[[BOXEvent alloc] initWithJSON:dict]];
    }
    
    BOXEventsRequest *request = [[BOXEventsRequest alloc] init];
    [self setCannedURLResponse:[self cannedURLResponseWithStatusCode:200 responseData:cannedData] cannedResponseData:cannedData forRequest:request];

    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(NSArray *events, NSString *nextStreamPosition, NSError *error) {
        
        XCTAssertEqual(events.count, expectedEvents.count);
        XCTAssertTrue([nextStreamPosition isEqualToString:@"1415027508361"]);
        
        for (NSUInteger i = 0; i < events.count; i++) {
            [self assertModel:events[i] isEquivalentTo:expectedEvents[i]];
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}


@end
