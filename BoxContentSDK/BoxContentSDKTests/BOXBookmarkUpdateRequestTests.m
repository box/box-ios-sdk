//
//  BOXBookmarkUpdateRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/17/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXBookmarkUpdateRequest.h"
#import "BOXBookmark.h"
#import "BOXContentClient.h"
#import "NSURL+BOXURLHelper.h"
#import "BOXRequest_Private.h"

@interface BOXBookmarkUpdateRequestTests : BOXRequestTestCase
@end

@implementation BOXBookmarkUpdateRequestTests

- (void)test_that_update_request_with_no_params_has_expected_URLRequest
{
    NSString *bookmarkID = @"123";
    BOXBookmarkUpdateRequest *request = [[BOXBookmarkUpdateRequest alloc] initWithBookmarkID:bookmarkID];
    
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/web_links/%@", [BOXContentClient APIBaseURL], bookmarkID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"PUT", URLRequest.HTTPMethod);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
}

- (void)test_shared_link_properties
{
    NSString *bookmarkID = @"123";
    BOXBookmarkUpdateRequest *request = [[BOXBookmarkUpdateRequest alloc] initWithBookmarkID:bookmarkID];
    
    XCTAssertEqualObjects([request itemIDForSharedLink], bookmarkID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeWebLink);    
}

- (void)test_that_update_request_with_all_possible_params_has_expected_URLRequest
{
    NSString *bookmarkID = @"123";
    NSString *newName = @"Hello";
    NSString *newParentFolderID = @"456";
    NSString *newDescription = @"Star trek rules. Star wars sucks.";
    NSURL *newURL = [NSURL URLWithString:@"http://blog.box.com/"];
    NSString *matchingEtag = @"5849054tsefs";
    
    BOXSharedLinkAccessLevel *newAccessLevel = BOXSharedLinkAccessLevelCollaborators;
    NSDate *newSharedLinkExpirationDate = [NSDate distantFuture];
    BOOL newSharedLinkPermissionCanDownload = YES;
    BOOL newSharedLinkPermissionCanPreview = YES;
    
    BOXBookmarkUpdateRequest *request = [[BOXBookmarkUpdateRequest alloc] initWithBookmarkID:bookmarkID];
    request.requestAllBookmarkFields = YES;
    request.bookmarkName = newName;
    request.bookmarkDescription = newDescription;
    request.parentID = newParentFolderID;
    request.sharedLinkAccessLevel = newAccessLevel;
    request.sharedLinkExpirationDate = newSharedLinkExpirationDate;
    request.sharedLinkPermissionCanDownload = newSharedLinkPermissionCanDownload;
    request.sharedLinkPermissionCanPreview = newSharedLinkPermissionCanPreview;
    request.URL = newURL;
    request.matchingEtag = matchingEtag;
    
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    XCTAssertEqualObjects(@"PUT", URLRequest.HTTPMethod);
    
    NSString *expectedURLWithoutQueryString = [NSString stringWithFormat:@"%@/web_links/%@", [BOXContentClient APIBaseURL], bookmarkID];
    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURLWithoutQueryString, actualURLWithoutQueryString);
    
    NSString *expectedFieldsString = [[[BOXRequest alloc] init] fullBookmarkFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, [[[URLRequest.URL box_queryDictionary] objectForKey:@"fields"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{@"name" : newName,
                                             @"parent" : @{@"id" : newParentFolderID},
                                             @"description" : newDescription,
                                             @"url" : [newURL absoluteString],
                                             @"shared_link" : @{@"access" : @"collaborators",
                                                                @"permissions" : @{@"can_download" : @1,
                                                                                   @"can_preview" : @1},
                                                                @"unshared_at" : [newSharedLinkExpirationDate box_ISO8601String]}
                                             };
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
    
    // HTTP header assertions
    NSString *actualIfMatchHeader = [URLRequest.allHTTPHeaderFields objectForKey:@"If-Match"];
    XCTAssertEqualObjects(matchingEtag, actualIfMatchHeader);
}

- (void)test_that_expected_bookmark_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"bookmark_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    
    // Expected response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXBookmark *expectedBookmark = [[BOXBookmark alloc] initWithJSON:jsonDictionary];
    
    // Set up request and attach canned response to it.
    BOXBookmarkUpdateRequest *request = [[BOXBookmarkUpdateRequest alloc] initWithBookmarkID:expectedBookmark.modelID];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    // Peform request and assert that we received the expected object as a response.
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(BOXBookmark *bookmark, NSError *error) {
        [self assertModel:expectedBookmark isEquivalentTo:bookmark];
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
