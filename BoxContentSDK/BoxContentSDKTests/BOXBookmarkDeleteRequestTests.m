//
//  BOXBookmarkDeleteRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/15/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXBookmarkDeleteRequest.h"
#import "BOXContentClient.h"

@interface BOXBookmarkDeleteRequestTests : BOXRequestTestCase
@end

@implementation BOXBookmarkDeleteRequestTests

- (void)test_that_request_has_expected_URLRequest
{
    NSString *bookmarkID = @"123";
    NSString *matchingEtag = @"fgruiignfrsui3";
    
    BOXBookmarkDeleteRequest *request = [[BOXBookmarkDeleteRequest alloc] initWithBookmarkID:bookmarkID];
    request.matchingEtag = matchingEtag;
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/web_links/%@", [BOXContentClient APIBaseURL], bookmarkID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"DELETE", URLRequest.HTTPMethod);
    
    // HTTP header assertions
    NSString *actualIfMatchHeader = [URLRequest.allHTTPHeaderFields objectForKey:@"If-Match"];
    XCTAssertEqualObjects(matchingEtag, actualIfMatchHeader);
}

- (void)test_shared_link_properties
{
    NSString *bookmarkID = @"123";
    BOXBookmarkDeleteRequest *request = [[BOXBookmarkDeleteRequest alloc] initWithBookmarkID:bookmarkID];
    
    XCTAssertEqualObjects([request itemIDForSharedLink], bookmarkID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeWebLink);    
}

- (void)test_that_trashed_bookmark_permanent_deletion_request_has_expected_URLRequest
{
    NSString *bookmarkID = @"123";

    BOXBookmarkDeleteRequest *request = [[BOXBookmarkDeleteRequest alloc] initWithBookmarkID:bookmarkID isTrashed:YES];
    NSURLRequest *URLRequest = request.urlRequest;

    // URL assertions
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/web_links/%@/trash", [BOXContentClient APIBaseURL], bookmarkID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"DELETE", URLRequest.HTTPMethod);
}

- (void)test_that_delete_request_completes_with_no_error_if_empty_204_is_returned
{
    NSString *bookmarkID = @"123";
    BOXBookmarkDeleteRequest *request = [[BOXBookmarkDeleteRequest alloc] initWithBookmarkID:bookmarkID];
    
    NSData *cannedResponseData = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    NSHTTPURLResponse *cannedHTTPResponse = [self cannedURLResponseWithStatusCode:204 responseData:cannedResponseData];
    [self setCannedURLResponse:cannedHTTPResponse cannedResponseData:cannedResponseData forRequest:request];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(NSError *error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
