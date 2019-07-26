//
//  BOXTrashedFolderRestoreRequestTests.m
//  BoxContentSDK
//
//  Created by Jeremy Pang on 12/23/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXTrashedFolderRestoreRequest.h"
#import "BOXFolder.h"

@interface BOXTrashedFolderRestoreRequestTests : BOXRequestTestCase

@end

@implementation BOXTrashedFolderRestoreRequestTests

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *folderID = @"123";
    BOXTrashedFolderRestoreRequest *request = [[BOXTrashedFolderRestoreRequest alloc] initWithFolderID:folderID];
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/folders/%@", [BOXContentClient APIBaseURL], folderID]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodPOST, URLRequest.HTTPMethod);
}

- (void)test_that_request_with_additional_fields_has_expected_URLRequest
{
    NSString *folderID = @"123";
    BOXTrashedFolderRestoreRequest *request = [[BOXTrashedFolderRestoreRequest alloc] initWithFolderID:folderID];
    NSString *folderName = @"new";
    request.folderName = folderName;
    NSString *parentFolderID = @"456";
    request.parentFolderID = parentFolderID;
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/folders/%@", [BOXContentClient APIBaseURL], folderID]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodPOST, URLRequest.HTTPMethod);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{@"name" : folderName, @"parent" : @{@"id" : parentFolderID}};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
}

#pragma mark - Perform Request

- (void)test_that_expected_file_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"folder_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:201 responseData:cannedResponseData];
    
    // Expected BoxFile response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXFolder *expectedFolder = [[BOXFolder alloc] initWithJSON:jsonDictionary];
    
    // Set up BOXFileRequest and attach canned response to it.
    BOXTrashedFolderRestoreRequest *request = [[BOXTrashedFolderRestoreRequest alloc] initWithFolderID:expectedFolder.modelID];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    // Peform request and assert that we received the expectedFile as a response.
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(BOXFolder *folder, NSError *error) {
        [self assertModel:expectedFolder isEquivalentTo:folder];
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}


@end
