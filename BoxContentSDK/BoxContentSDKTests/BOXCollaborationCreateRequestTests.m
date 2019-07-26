//
//  BOXCollaborationCreateRequestTests.m
//  BoxContentSDK
//
//  Created by Jeremy Pang on 12/17/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXCollaborationCreateRequest.h"
#import "BOXCollaboration.h"
#import "BOXContentClient.h"
#import "BOXFolder.h"

@interface BOXCollaborationCreateRequestTests : BOXRequestTestCase

@end

@implementation BOXCollaborationCreateRequestTests

- (void)test_that_request_with_user_id_has_expected_URLRequest
{
    NSString *folderID = @"123";
    BOXCollaborationCreateRequest *request = [[BOXCollaborationCreateRequest alloc] initWithItemType:BOXAPIItemTypeFolder
                                                                                              itemID:folderID];
    NSString *userID = @"36534645";
    request.userID = userID;
    NSString *role = BOXCollaborationRoleEditor;
    request.role = role;
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/collaborations", [BOXContentClient APIBaseURL]]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodPOST, URLRequest.HTTPMethod);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{@"item" : @{@"id" : folderID, @"type" : @"folder"}, @"accessible_by" : @{@"id" : userID, @"type" : @"user"}, @"role" : role};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
}

- (void)test_that_request_with_user_login_has_expected_URLRequest
{
    NSString *folderID = @"123";
    BOXCollaborationCreateRequest *request = [[BOXCollaborationCreateRequest alloc] initWithItemType:BOXAPIItemTypeFolder
                                                                                              itemID:folderID];
    NSString *email = @"test@box.com";
    request.login = email;
    NSString *role = BOXCollaborationRoleEditor;
    request.role = role;
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/collaborations", [BOXContentClient APIBaseURL]]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodPOST, URLRequest.HTTPMethod);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{@"item" : @{@"id" : folderID, @"type" : @"folder"}, @"accessible_by" : @{@"login" : email, @"type" : @"user"}, @"role" : role};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
}

- (void)test_that_request_with_group_id_has_expected_URLRequest
{
    NSString *folderID = @"123";
    BOXCollaborationCreateRequest *request = [[BOXCollaborationCreateRequest alloc] initWithItemType:BOXAPIItemTypeFolder
                                                                                              itemID:folderID];
    NSString *groupID = @"545634";
    request.groupID = groupID;
    NSString *role = BOXCollaborationRoleEditor;
    request.role = role;
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/collaborations", [BOXContentClient APIBaseURL]]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodPOST, URLRequest.HTTPMethod);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{@"item" : @{@"id" : folderID, @"type" : @"folder"}, @"accessible_by" : @{@"id" : groupID, @"type" : @"group"}, @"role" : role};
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
    BOXCollaborationCreateRequest *request = [[BOXCollaborationCreateRequest alloc] initWithItemType:BOXAPIItemTypeFolder
                                                                                              itemID:expectedCollaboration.item.modelID];
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
