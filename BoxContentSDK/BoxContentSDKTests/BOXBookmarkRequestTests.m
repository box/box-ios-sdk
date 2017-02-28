//
//  BOXBookmarkRequestTests.m
//  BoxContentSDK
//
//  Created on 12/1/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXBookmarkRequest.h"
#import "BOXContentClient.h"
#import "BOXRequest_Private.h"
#import "NSURL+BOXURLHelper.h"
#import "BOXBookmark.h"

@interface BOXBookmarkRequestTests : BOXRequestTestCase
@end

@implementation BOXBookmarkRequestTests

# pragma mark - URLRequest

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *bookmarkID = @"123";
    BOXBookmarkRequest *bookmarkRequest = [[BOXBookmarkRequest alloc] initWithBookmarkID:bookmarkID];
    NSURLRequest *URLRequest = bookmarkRequest.urlRequest;

    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/web_links/%@", [BOXContentClient APIBaseURL], bookmarkID]];

    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
}

- (void)test_shared_link_properties
{
    NSString *bookmarkID = @"123";
    BOXBookmarkRequest *bookmarkRequest = [[BOXBookmarkRequest alloc] initWithBookmarkID:bookmarkID];
    
    XCTAssertEqualObjects([bookmarkRequest itemIDForSharedLink], bookmarkID);
    XCTAssertEqualObjects([bookmarkRequest itemTypeForSharedLink], BOXAPIItemTypeWebLink);    
}

- (void)test_that_request_with_all_fields_has_expected_URLRequest_query_params
{
    NSString *bookmarkID = @"123";
    BOXBookmarkRequest *bookmarkRequest = [[BOXBookmarkRequest alloc] initWithBookmarkID:bookmarkID];
    [bookmarkRequest setRequestAllBookmarkFields:YES];
    NSURLRequest *URLRequest = bookmarkRequest.urlRequest;

    NSString *expectedURLWithoutQueryString = [NSString stringWithFormat:@"%@/web_links/%@", [BOXContentClient APIBaseURL], bookmarkID];
    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURLWithoutQueryString, actualURLWithoutQueryString);

    NSString *expectedFieldsString = [[[BOXRequest alloc] init] fullBookmarkFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, [[[URLRequest.URL box_queryDictionary] objectForKey:@"fields"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
}

- (void)test_that_request_with_etags_not_to_match_specified_has_expected_URLRequest_headers
{
    NSString *bookmarkID = @"123";
    BOXBookmarkRequest *bookmarkRequest = [[BOXBookmarkRequest alloc] initWithBookmarkID:bookmarkID];
    NSArray *notMatchingEtagsToUse = @[@"123", @"0", @"456", @",", @" ", @"\""]; // numeric values as well as special characters
    [bookmarkRequest setNotMatchingEtags:notMatchingEtagsToUse];
    NSURLRequest *URLRequest = bookmarkRequest.urlRequest;

    NSString *expectedURL = [NSString stringWithFormat:@"%@/web_links/%@", [BOXContentClient APIBaseURL], bookmarkID];
    NSString *actualURL = [URLRequest.URL absoluteString];
    XCTAssertEqualObjects(expectedURL, actualURL);

    NSDictionary *expectedHeaders = @{BOXAPIHTTPHeaderIfNoneMatch: [notMatchingEtagsToUse componentsJoinedByString:@","]};
    XCTAssertEqualObjects(expectedHeaders, [URLRequest allHTTPHeaderFields]);
}

#pragma mark - Perform Request

- (void)test_that_expected_bookmark_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"bookmark_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];

    // Expected BOXBookmark response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXBookmark *expectedBookmark = [[BOXBookmark alloc] initWithJSON:jsonDictionary];

    // Set up BOXBookmarkRequest and attach canned response to it.
    BOXBookmarkRequest *bookmarkRequest = [[BOXBookmarkRequest alloc] initWithBookmarkID:expectedBookmark.modelID];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:bookmarkRequest];

    // Peform request and assert that we received the expectedBookmark as a response.
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [bookmarkRequest performRequestWithCompletion:^(BOXBookmark *bookmark, NSError *error) {
        [self assertModel:expectedBookmark isEquivalentTo:bookmark];
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
