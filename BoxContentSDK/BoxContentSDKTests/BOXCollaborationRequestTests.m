//
//  BOXCollaborationRequestTests.m
//  BoxContentSDK
//
//  Created by Jeremy Pang on 12/17/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXCollaborationRequest.h"
#import "BOXCollaboration.h"
#import "BOXContentClient.h"
#import "NSURL+BOXURLHelper.h"
#import "BOXContentSDKConstants.h"

@interface BOXCollaborationRequestTests : BOXRequestTestCase

@end

@implementation BOXCollaborationRequestTests

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *collabID = @"123";
    BOXCollaborationRequest *request = [[BOXCollaborationRequest alloc] initWithCollaborationID:collabID];
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/collaborations/%@", [BOXContentClient APIBaseURL], collabID]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
}

- (void)test_that_request_with_all_fields_has_expected_URLRequest_query_params
{
    NSString *collabID = @"123";
    BOXCollaborationRequest *request = [[BOXCollaborationRequest alloc] initWithCollaborationID:collabID];
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSString *expectedURLWithoutQueryString = [NSString stringWithFormat:@"%@/collaborations/%@", [BOXContentClient APIBaseURL], collabID];
    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURLWithoutQueryString, actualURLWithoutQueryString);
}

- (void)test_that_expected_collaboration_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"collaboration"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    
    // Expected BOXCollaboration response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXCollaboration *expectedCollaboration = [[BOXCollaboration alloc] initWithJSON:jsonDictionary];
    
    // Set up BOXCollaborationRequest and attach canned response to it.
    BOXCollaborationRequest *request = [[BOXCollaborationRequest alloc] initWithCollaborationID:expectedCollaboration.modelID];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    // Peform request and assert that we received the expectedFile as a response.
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(BOXCollaboration *collaboration, NSError *error) {
        [self assertModel:expectedCollaboration isEquivalentTo:collaboration];
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
