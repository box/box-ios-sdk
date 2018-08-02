//
//  BOXSearchRequestTests.m
//  BoxContentSDK
//
//  Created by Jeremy Pang on 12/19/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXRequest_Private.h"
#import "BOXSearchRequest.h"
#import "NSURL+BOXURLHelper.h"
#import "BOXContentSDKConstants.h"
#import "BOXFile.h"
#import "BOXFolder.h"
#import "BOXBookmark.h"
#import "BOXContentClient.h"
#import "BOXContentSDKTestsConstants.h"

@interface BOXRequest ()

- (NSString *)fullItemFieldsParameterString;

@end

@interface BOXSearchRequestTests : BOXRequestTestCase

@end

@implementation BOXSearchRequestTests

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *searchQuery = @"test";
    BOXSearchRequest *request = [[BOXSearchRequest alloc] initWithSearchQuery:searchQuery inRange:NSMakeRange(2, 10)];
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSString *expectedURL = [NSString stringWithFormat:@"%@/search", [BOXContentClient APIBaseURL]];
    NSString *requestURL = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    
    XCTAssertEqualObjects(expectedURL, requestURL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
    
    NSDictionary *requestURLParameters = [URLRequest.URL box_queryDictionary];
    
    XCTAssertEqualObjects(requestURLParameters[BOXAPIParameterKeyQuery], searchQuery);
    XCTAssertEqualObjects(requestURLParameters[BOXAPIParameterKeyLimit], @"10");
    XCTAssertEqualObjects(requestURLParameters[BOXAPIParameterKeyOffset], @"2");
}

- (void)test_that_request_with_requestAllItemFields_has_expected_URLRequest
{
    NSString *searchQuery = @"test";
    BOXSearchRequest *request = [[BOXSearchRequest alloc] initWithSearchQuery:searchQuery inRange:NSMakeRange(2, 10)];
    request.requestAllItemFields = YES;
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSString *expectedURL = [NSString stringWithFormat:@"%@/search", [BOXContentClient APIBaseURL]];
    NSString *requestURL = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    
    XCTAssertEqualObjects(expectedURL, requestURL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
    
    NSDictionary *requestURLParameters = [URLRequest.URL box_queryDictionary];
    XCTAssertEqualObjects(requestURLParameters[BOXAPIParameterKeyQuery], searchQuery);
    XCTAssertEqualObjects(requestURLParameters[BOXAPIParameterKeyFields], [request fullItemFieldsParameterString]);
}

- (void)test_that_request_with_additional_params_has_expected_URLRequest
{
    NSString *searchQuery = @"test";
    BOXSearchRequest *request = [[BOXSearchRequest alloc] initWithSearchQuery:searchQuery inRange:NSMakeRange(2, 10)];
    request.sizeLowerBound = 100000;
    request.type = BOXAPIItemTypeFile;
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSString *expectedURL = [NSString stringWithFormat:@"%@/search", [BOXContentClient APIBaseURL]];
    NSString *requestURL = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    
    XCTAssertEqualObjects(expectedURL, requestURL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
    
    NSDictionary *requestURLParameters = [URLRequest.URL box_queryDictionary];
    
    XCTAssertEqualObjects(requestURLParameters[BOXAPIParameterKeyQuery], searchQuery);
    XCTAssertEqualObjects(requestURLParameters[BOXAPIParameterKeyLimit], @"10");
    XCTAssertEqualObjects(requestURLParameters[BOXAPIParameterKeyOffset], @"2");
    XCTAssertEqualObjects(requestURLParameters[BOXAPIParameterKeySizeRange], @"100000,");
    XCTAssertEqualObjects(requestURLParameters[BOXAPIParameterKeyType], @"file");
}

- (void)test_that_expected_items_are_returned
{
    BOXSearchRequest *request = [[BOXSearchRequest alloc] initWithSearchQuery:@"abc" inRange:NSMakeRange(0, 5)];
    
    NSData *cannedData = [self cannedResponseDataWithName:@"item_search_results"];
    
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
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(NSArray *items, NSUInteger totalCount, NSRange range, NSError *error) {
        XCTAssertNil(error);
        XCTAssertEqual(items.count, 6);
        XCTAssertEqual(totalCount, 6);
        XCTAssertEqual(range.location, 0);
        XCTAssertEqual(range.length, 30);
        
        for (NSUInteger i = 0; i < items.count ; i++) {
            [self assertModel:items[i] isEquivalentTo:expectedItems[i]];
        }
        
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)test_that_request_with_metadata_templateKey_and_scope_creates_query_parameters_with_metadata_info
{
    BOXSearchRequest *request = [[BOXSearchRequest alloc] initWithSearchQuery:@"some_query" inRange:NSMakeRange(0, 0)];
    request.requestAllItemFields = YES;
    request.metadataTemplateKey = @"test";
    request.metadataScope = @"scope";
    
    BOXAPIOperation *op = [request createOperation];
    NSDictionary *queryDict = op.queryStringParameters;
    NSString *fieldString = queryDict[BOXAPIParameterKeyFields];
    
    XCTAssertTrue([fieldString isEqualToString:expectedItemRequestFieldsStringWithMetadata]);
}

@end
