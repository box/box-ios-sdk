//
//  BOXFileDeleteRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/15/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXFileDeleteRequest.h"

@interface BOXFileDeleteRequestTests : BOXRequestTestCase
@end

@implementation BOXFileDeleteRequestTests

- (void)test_that_request_has_expected_URLRequest
{
    NSString *fileID = @"123";
    NSString *matchingEtag = @"fgruiignfrsui3";
    
    BOXFileDeleteRequest *request = [[BOXFileDeleteRequest alloc] initWithFileID:fileID];
    request.matchingEtag = matchingEtag;
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/%@", [BOXContentClient APIBaseURL], fileID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"DELETE", URLRequest.HTTPMethod);
    
    // HTTP header assertions
    NSString *actualIfMatchHeader = [URLRequest.allHTTPHeaderFields objectForKey:@"If-Match"];
    XCTAssertEqualObjects(matchingEtag, actualIfMatchHeader);
}

- (void)test_shared_link_properties
{
    NSString *fileID = @"123";
    BOXFileDeleteRequest *request = [[BOXFileDeleteRequest alloc] initWithFileID:fileID];
    
    XCTAssertEqualObjects([request itemIDForSharedLink], fileID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeFile);    
}


- (void)test_that_trashed_file_permanent_deletion_request_has_expected_URLRequest
{
    NSString *fileID = @"123";
    
    BOXFileDeleteRequest *request = [[BOXFileDeleteRequest alloc] initWithFileID:fileID isTrashed:YES];
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/%@/trash", [BOXContentClient APIBaseURL], fileID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"DELETE", URLRequest.HTTPMethod);
}

- (void)test_that_delete_request_completes_with_no_error_if_empty_204_is_returned
{
    NSString *fileID = @"123";
    BOXFileDeleteRequest *request = [[BOXFileDeleteRequest alloc] initWithFileID:fileID];
    
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
