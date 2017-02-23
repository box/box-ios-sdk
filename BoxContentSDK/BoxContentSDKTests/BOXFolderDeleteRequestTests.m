//
//  BOXFolderDeleteRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/15/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXFolderDeleteRequest.h"

@interface BOXFolderDeleteRequestTests : BOXRequestTestCase
@end

@implementation BOXFolderDeleteRequestTests

- (void)test_that_recursive_delete_request_has_expected_URLRequest
{
    NSString *folderID = @"123";
    
    BOXFolderDeleteRequest *request = [[BOXFolderDeleteRequest alloc] initWithFolderID:folderID];
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/folders/%@?recursive=true", [BOXContentClient APIBaseURL], folderID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"DELETE", URLRequest.HTTPMethod);
}

- (void)test_shared_link_properties
{
    NSString *folderID = @"123";
    BOXFolderDeleteRequest *request = [[BOXFolderDeleteRequest alloc] initWithFolderID:folderID];
    
    XCTAssertEqualObjects([request itemIDForSharedLink], folderID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeFolder);    
}

- (void)test_that_trashed_folder_permanent_deletion_request_has_expected_URLRequest
{
    NSString *folderID = @"123";
    
    BOXFolderDeleteRequest *request = [[BOXFolderDeleteRequest alloc] initWithFolderID:folderID isTrashed:YES];
    request.recursive = NO;
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/folders/%@/trash", [BOXContentClient APIBaseURL], folderID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"DELETE", URLRequest.HTTPMethod);
}

- (void)test_that_non_recursive_delete_request_with_matching_etag_has_expected_URLRequest
{
    NSString *folderID = @"123";
    NSString *matchingEtag = @"5849054tsefs";
    
    BOXFolderDeleteRequest *request = [[BOXFolderDeleteRequest alloc] initWithFolderID:folderID];
    request.recursive = NO;
    request.matchingEtag = matchingEtag;
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/folders/%@", [BOXContentClient APIBaseURL], folderID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"DELETE", URLRequest.HTTPMethod);
    
    // HTTP header assertions
    NSString *actualIfMatchHeader = [URLRequest.allHTTPHeaderFields objectForKey:@"If-Match"];
    XCTAssertEqualObjects(matchingEtag, actualIfMatchHeader);
}

- (void)test_that_delete_request_completes_with_no_error_if_empty_204_is_returned
{
    NSString *folderID = @"123";
    BOXFolderDeleteRequest *request = [[BOXFolderDeleteRequest alloc] initWithFolderID:folderID];

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
