//
//  BOXBookmarkCopyRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/15/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXBookmarkCopyRequest.h"
#import "BOXBookmark.h"

@interface BOXBookmarkCopyRequestTests : BOXRequestTestCase
@end

@implementation BOXBookmarkCopyRequestTests

#pragma mark - URLRequest

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *bookmarkID = @"123";
    NSString *destinationFolderID = @"456";
    
    BOXBookmarkCopyRequest *request = [[BOXBookmarkCopyRequest alloc] initWithBookmarkID:bookmarkID destinationFolderID:destinationFolderID];
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/web_links/%@/copy", [BOXContentClient APIBaseURL], bookmarkID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"POST", URLRequest.HTTPMethod);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{@"parent" : @{@"id" : destinationFolderID}};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
}

- (void)test_shared_link_properties
{
    NSString *bookmarkID = @"123";
    NSString *destinationFolderID = @"456";
    BOXBookmarkCopyRequest *request = [[BOXBookmarkCopyRequest alloc] initWithBookmarkID:bookmarkID destinationFolderID:destinationFolderID];    
    
    XCTAssertEqualObjects([request itemIDForSharedLink], bookmarkID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeWebLink);    
}

- (void)test_that_request_with_new_name_has_expected_URLRequest
{
    NSString *bookmarkID = @"123";
    NSString *destinationFolderID = @"456";
    NSString *copiedBookmarkName = @"Battlestar Galactica Rules";
    
    BOXBookmarkCopyRequest *request = [[BOXBookmarkCopyRequest alloc] initWithBookmarkID:bookmarkID destinationFolderID:destinationFolderID];
    request.bookmarkName = copiedBookmarkName;
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/web_links/%@/copy", [BOXContentClient APIBaseURL], bookmarkID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"POST", URLRequest.HTTPMethod);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{@"parent" : @{@"id" : destinationFolderID},
                                             @"name" : copiedBookmarkName};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
}

#pragma mark - Perform Request

- (void)test_that_expected_file_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"bookmark_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    
    // Expected BoxFile response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXBookmark *expectedBookmark = [[BOXBookmark alloc] initWithJSON:jsonDictionary];
    
    // Set up BOXFileRequest and attach canned response to it.
    BOXBookmarkCopyRequest *request = [[BOXBookmarkCopyRequest alloc] initWithBookmarkID:expectedBookmark.modelID
                                                                     destinationFolderID:@"456"];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    // Peform request and assert that we received the expectedFile as a response.
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(BOXBookmark *bookmark, NSError *error) {
        [self assertModel:expectedBookmark isEquivalentTo:bookmark];
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
