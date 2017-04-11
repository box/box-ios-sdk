//
//  BOXCollaborationPendingRequestTests.m
//  BoxContentSDK
//
//  Created by Jeremy Pang on 12/18/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXCollaborationPendingRequest.h"
#import "BOXContentSDKConstants.h"
#import "BOXCollaboration.h"
#import "BOXContentClient.h"

@interface BOXCollaborationPendingRequestTests : BOXRequestTestCase

@end

@implementation BOXCollaborationPendingRequestTests

- (void)test_that_basic_request_has_expected_URLRequest
{
    BOXCollaborationPendingRequest *request = [[BOXCollaborationPendingRequest alloc] init];
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/collaborations?status=pending", [BOXContentClient APIBaseURL]]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodGET, URLRequest.HTTPMethod);
}

- (void)test_that_expected_collaboration_array_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"collaborations_pending"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    
    // Expected BOXCollaboration response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    NSArray *entries = jsonDictionary[BOXAPIObjectKeyEntries];
    BOXCollaboration *expectedCollaboration = [[BOXCollaboration alloc] initWithJSON:[entries objectAtIndex:0]];
    BOXCollaboration *expectedCollaboration2 = [[BOXCollaboration alloc] initWithJSON:[entries objectAtIndex:1]];
    NSArray *collaborationsArray = [NSArray arrayWithObjects:expectedCollaboration, expectedCollaboration2, nil];
    
    // Set up BOXCollaborationRequest and attach canned response to it.
    BOXCollaborationPendingRequest *request = [[BOXCollaborationPendingRequest alloc] init];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    // Peform request and assert that we received the expectedFile as a response.
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(NSArray *collaborations, NSError *error) {
        XCTAssertEqual(2, collaborations.count);
        for (int i = 0; i < collaborations.count; i++) {
            [self assertModel:collaborations[i] isEquivalentTo:collaborationsArray[i]];
        }
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
