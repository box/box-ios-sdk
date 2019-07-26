//
//  BOXCollaborationRemoveRequestTests.m
//  BoxContentSDK
//
//  Created by Jeremy Pang on 12/18/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXCollaborationRemoveRequest.h"
#import "BOXContentClient.h"
#import "BOXContentSDKConstants.h"

@interface BOXCollaborationRemoveRequestTests : BOXRequestTestCase

@end

@implementation BOXCollaborationRemoveRequestTests

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *collabID = @"123";
    BOXCollaborationRemoveRequest *request = [[BOXCollaborationRemoveRequest alloc] initWithCollaborationID:collabID];
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/collaborations/%@", [BOXContentClient APIBaseURL], collabID]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodDELETE, URLRequest.HTTPMethod);
}

- (void)test_that_delete_request_completes_with_no_error_if_empty_204_is_returned
{
    NSString *collabID = @"123";
    BOXCollaborationRemoveRequest *request = [[BOXCollaborationRemoveRequest alloc] initWithCollaborationID:collabID];
    
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
