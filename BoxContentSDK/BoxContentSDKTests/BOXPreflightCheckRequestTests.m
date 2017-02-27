//
//  BOXPreflightCheckRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 1/2/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXPreflightCheckRequest.h"
#import "BOXContentClient.h"
#import "BOXContentSDKErrors.h"

@interface BOXPreflightCheckRequestTests : BOXRequestTestCase
@end

@implementation BOXPreflightCheckRequestTests

#pragma mark - NSURLRequest

- (void)test_that_preflight_check_request_for_new_file_has_expected_URLRequest
{
    NSString *fileName = @"Hello 123";
    NSString *folderID = @"123";
    NSUInteger fileSize = 4096;

    BOXPreflightCheckRequest *request = [[BOXPreflightCheckRequest alloc] initWithFileName:fileName parentFolderID:folderID];
    request.fileSize = fileSize;
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/content", [BOXContentClient APIBaseURL]]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"OPTIONS", URLRequest.HTTPMethod);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{@"name" : fileName,
                                             @"parent" : @{@"id" : folderID},
                                             @"size" : [NSNumber numberWithUnsignedLong:fileSize]};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
}

- (void)test_that_preflight_check_request_for_new_file_version_has_expected_URLRequest
{
    NSString *fileName = @"Hello 123";
    NSString *fileID = @"123";
    NSUInteger fileSize = 4096;
    
    BOXPreflightCheckRequest *request = [[BOXPreflightCheckRequest alloc] initWithFileName:fileName fileID:fileID];
    request.fileSize = fileSize;
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/%@/content", [BOXContentClient APIBaseURL], fileID]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"OPTIONS", URLRequest.HTTPMethod);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{@"name" : fileName,
                                             @"size" : [NSNumber numberWithUnsignedLong:fileSize]};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
}

#pragma mark - Perform request

- (void)test_that_successful_preflight_check_request_fires_completion_block_with_no_error
{
    NSString *fileName = @"Hello 123";
    NSString *folderID = @"123";
    NSUInteger fileSize = 4096;
    
    BOXPreflightCheckRequest *request = [[BOXPreflightCheckRequest alloc] initWithFileName:fileName parentFolderID:folderID];
    request.fileSize = fileSize;
 
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"preflight_check_success"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    BOXCannedResponse *cannedResponse = [[BOXCannedResponse alloc] initWithURLResponse:URLResponse responseData:cannedResponseData];
    
    [self setCannedResponse:cannedResponse forRequest:request];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(NSError *error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)test_that_failed_preflight_check_request_fires_completion_block_with_expected_error
{
    NSString *fileName = @"Hello 123";
    NSString *folderID = @"123";
    NSUInteger fileSize = 4096;
    
    BOXPreflightCheckRequest *request = [[BOXPreflightCheckRequest alloc] initWithFileName:fileName parentFolderID:folderID];
    request.fileSize = fileSize;
    
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"preflight_check_conflict"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:409 responseData:cannedResponseData];
    BOXCannedResponse *cannedResponse = [[BOXCannedResponse alloc] initWithURLResponse:URLResponse responseData:cannedResponseData];
    
    [self setCannedResponse:cannedResponse forRequest:request];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(NSError *error) {
        XCTAssertEqual(409, error.code);
        XCTAssertEqualObjects(BOXContentSDKErrorDomain, error.domain);
        XCTAssertEqualObjects([NSNumber numberWithLong:409], error.userInfo[BOXJSONErrorResponseKey][@"status"]);
        XCTAssertEqualObjects(@"item_name_in_use", error.userInfo[BOXJSONErrorResponseKey][@"code"]);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
