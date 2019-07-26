//
//  BOXBookmarkUnshareRequestTests.m
//  BoxContentSDK
//
//  Created on 12/1/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXBookmarkUnshareRequest.h"
#import "BOXContentClient.h"
#import "BOXRequest_Private.h"
#import "NSURL+BOXURLHelper.h"
#import "BOXBookmark.h"

@interface BOXBookmarkUnshareRequestTests : BOXRequestTestCase
@end

@implementation BOXBookmarkUnshareRequestTests

# pragma mark - URLRequest

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *bookmarkID = @"123";
    BOXBookmarkUnshareRequest *bookmarkRequest = [[BOXBookmarkUnshareRequest alloc] initWithBookmarkID:bookmarkID];
    NSURLRequest *URLRequest = bookmarkRequest.urlRequest;

    NSString *expectedURLWithoutQueryString = [NSString stringWithFormat:@"%@/web_links/%@", [BOXContentClient APIBaseURL], bookmarkID];
    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURLWithoutQueryString, actualURLWithoutQueryString);
    
    NSString *expectedFieldsString = [[[BOXRequest alloc] init] fullBookmarkFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, [[[URLRequest.URL box_queryDictionary] objectForKey:@"fields"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);    XCTAssertEqualObjects(@"PUT", URLRequest.HTTPMethod);

}

- (void)test_shared_link_properties
{
    NSString *bookmarkID = @"123";
    BOXBookmarkUnshareRequest *bookmarkRequest = [[BOXBookmarkUnshareRequest alloc] initWithBookmarkID:bookmarkID];
    
    XCTAssertEqualObjects([bookmarkRequest itemIDForSharedLink], bookmarkID);
    XCTAssertEqualObjects([bookmarkRequest itemTypeForSharedLink], BOXAPIItemTypeWebLink);    
}

- (void)test_that_request_with_etags_to_match_specified_has_expected_URLRequest_headers
{
    NSString *bookmarkID = @"123";
    BOXBookmarkUnshareRequest *bookmarkRequest = [[BOXBookmarkUnshareRequest alloc] initWithBookmarkID:bookmarkID];
    NSString *matchingEtagToUse = @"234"; // numeric values as well as special characters
    [bookmarkRequest setMatchingEtag:matchingEtagToUse];
    NSURLRequest *URLRequest = bookmarkRequest.urlRequest;

    NSString *expectedURLWithoutQueryString = [NSString stringWithFormat:@"%@/web_links/%@", [BOXContentClient APIBaseURL], bookmarkID];
    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURLWithoutQueryString, actualURLWithoutQueryString);
    
    NSString *expectedFieldsString = [[[BOXRequest alloc] init] fullBookmarkFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, [[[URLRequest.URL box_queryDictionary] objectForKey:@"fields"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    NSString *expectedHeaderValue = matchingEtagToUse;
    NSString *actualHeaderValue = [URLRequest valueForHTTPHeaderField:BOXAPIHTTPHeaderIfMatch];
    XCTAssertEqualObjects(expectedHeaderValue, actualHeaderValue);
}

#pragma mark - Perform Request

- (void)test_that_expected_bookmark_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"bookmark_default_fields_not_shared"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];

    // Expected Boxbookmark response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXBookmark *expectedbookmark = [[BOXBookmark alloc] initWithJSON:jsonDictionary];

    // Set up BOXbookmarkUnshareRequest and attach canned response to it.
    BOXBookmarkUnshareRequest *bookmarkRequest = [[BOXBookmarkUnshareRequest alloc] initWithBookmarkID:expectedbookmark.modelID];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:bookmarkRequest];

    // Peform request and assert that we received the expectedbookmark as a response.
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [bookmarkRequest performRequestWithCompletion:^(BOXBookmark *bookmark, NSError *error) {
        [self assertModel:expectedbookmark isEquivalentTo:bookmark];
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
