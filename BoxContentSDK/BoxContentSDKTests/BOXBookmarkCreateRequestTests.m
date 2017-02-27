//
//  BOXBookmarkCreateRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 1/2/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXBookmarkCreateRequest.h"
#import "BOXBookmark.h"
#import "BOXContentClient.h"

@interface BOXBookmarkCreateRequestTests : BOXRequestTestCase
@end

@implementation BOXBookmarkCreateRequestTests

#pragma mark - NSURLRequest

- (void)test_that_request_has_expected_URLRequest
{
    NSURL *URL = [NSURL URLWithString:@"http://blog.box.com"];
    NSString *parentFolderID = @"123";
    NSString *bookmarkName = @"Hello";
    NSString *bookmarkDescription = @"Goodbye";
    
    BOXBookmarkCreateRequest *request = [[BOXBookmarkCreateRequest alloc] initWithURL:URL parentFolderID:parentFolderID];
    request.bookmarkName = bookmarkName;
    request.bookmarkDescription = bookmarkDescription;
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/web_links", [BOXContentClient APIBaseURL]]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"POST", URLRequest.HTTPMethod);
    
    NSDictionary *expectedBodyDictionary = @{@"url" : [URL absoluteString],
                                             @"parent" : @{@"id" : parentFolderID},
                                             @"name" : bookmarkName,
                                             @"description" : bookmarkDescription};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
}

- (void)test_that_expected_bookmark_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"bookmark_all_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    
    // Expected BOXBookmark response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXBookmark *expectedBookmark = [[BOXBookmark alloc] initWithJSON:jsonDictionary];
    
    // Set up BOXBookmarkCreateRequest and attach canned response to it.
    BOXBookmarkCreateRequest *request = [[BOXBookmarkCreateRequest alloc] initWithURL:expectedBookmark.URL parentFolderID:expectedBookmark.itemDescription];
    request.bookmarkName = expectedBookmark.name;
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    // Peform request and assert that we received the expected Bookmark as a response.
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(BOXBookmark *bookmark, NSError *error) {
        [self assertModel:expectedBookmark isEquivalentTo:bookmark];
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
