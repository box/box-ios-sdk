//
//  BOXCollaborationUpdateRequestTests.m
//  BoxContentSDK
//
//  Created by Jeremy Pang on 12/18/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXCollaborationUpdateRequest.h"
#import "BOXCollaboration.h"
#import "BOXContentClient.h"

@interface BOXCollaborationUpdateRequestTests : BOXRequestTestCase

@end

@implementation BOXCollaborationUpdateRequestTests

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *collabID = @"123";
    BOXCollaborationUpdateRequest *request = [[BOXCollaborationUpdateRequest alloc] initWithCollaborationID:collabID];
    NSString *role = BOXCollaborationRoleEditor;
    request.role = role;
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/collaborations/%@", [BOXContentClient APIBaseURL], collabID]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodPUT, URLRequest.HTTPMethod);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{@"role" : role};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
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
    BOXCollaborationUpdateRequest *request = [[BOXCollaborationUpdateRequest alloc] initWithCollaborationID:expectedCollaboration.modelID];
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
