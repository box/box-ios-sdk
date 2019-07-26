//
//  BOXTrashedFileRestoreRequestTests.m
//  BoxContentSDK
//
//  Created by Jeremy Pang on 12/23/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXTrashedFileRestoreRequest.h"
#import "BOXFile.h"

@interface BOXTrashedFileRestoreRequestTests : BOXRequestTestCase

@end

@implementation BOXTrashedFileRestoreRequestTests

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *fileID = @"123";
    BOXTrashedFileRestoreRequest *fileRequest = [[BOXTrashedFileRestoreRequest alloc] initWithFileID:fileID];
    NSURLRequest *URLRequest = fileRequest.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/%@", [BOXContentClient APIBaseURL], fileID]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodPOST, URLRequest.HTTPMethod);
}

- (void)test_that_request_with_additional_fields_has_expected_URLRequest
{
    NSString *fileID = @"123";
    BOXTrashedFileRestoreRequest *fileRequest = [[BOXTrashedFileRestoreRequest alloc] initWithFileID:fileID];
    NSString *fileName = @"new";
    fileRequest.fileName = fileName;
    NSString *parentFolderID = @"456";
    fileRequest.parentFolderID = parentFolderID;
    NSURLRequest *URLRequest = fileRequest.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/%@", [BOXContentClient APIBaseURL], fileID]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodPOST, URLRequest.HTTPMethod);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{@"name" : fileName, @"parent" : @{@"id" : parentFolderID}};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
}

#pragma mark - Perform Request

- (void)test_that_expected_file_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"file_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:201 responseData:cannedResponseData];
    
    // Expected BoxFile response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXFile *expectedFile = [[BOXFile alloc] initWithJSON:jsonDictionary];
    
    // Set up BOXFileRequest and attach canned response to it.
    BOXTrashedFileRestoreRequest *fileRequest = [[BOXTrashedFileRestoreRequest alloc] initWithFileID:expectedFile.modelID];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:fileRequest];
    
    // Peform request and assert that we received the expectedFile as a response.
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [fileRequest performRequestWithCompletion:^(BOXFile *file, NSError *error) {
        [self assertModel:expectedFile isEquivalentTo:file];
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
