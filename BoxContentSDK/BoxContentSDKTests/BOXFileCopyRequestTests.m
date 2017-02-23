//
//  BOXFileCopyRequestTests.m
//  BoxContentSDK
//
//  Created by Scott Liu on 12/10/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXFileCopyRequest.h"
#import "BOXFile.h"

@interface BOXFileCopyRequestTests : BOXRequestTestCase
@end

@implementation BOXFileCopyRequestTests

#pragma mark - URLRequest

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *fileID = @"123";
    NSString *destinationFolderID = @"456";
    
    BOXFileCopyRequest *request = [[BOXFileCopyRequest alloc] initWithFileID:fileID destinationFolderID:destinationFolderID];
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/%@/copy", [BOXContentClient APIBaseURL], fileID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"POST", URLRequest.HTTPMethod);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{@"parent" : @{@"id" : destinationFolderID}};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
}

- (void)test_shared_link_properties
{
    NSString *fileID = @"123";
    NSString *destinationFolderID = @"456";
    BOXFileCopyRequest *request = [[BOXFileCopyRequest alloc] initWithFileID:fileID destinationFolderID:destinationFolderID];
  
    XCTAssertEqualObjects([request itemIDForSharedLink], fileID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeFile);    
}

- (void)test_that_request_with_new_name_has_expected_URLRequest
{
    NSString *fileID = @"123";
    NSString *destinationFolderID = @"456";
    NSString *copiedFileName = @"Battlestar Galactica Rules";
    
    BOXFileCopyRequest *request = [[BOXFileCopyRequest alloc] initWithFileID:fileID destinationFolderID:destinationFolderID];
    request.fileName = copiedFileName;
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/%@/copy", [BOXContentClient APIBaseURL], fileID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"POST", URLRequest.HTTPMethod);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{@"parent" : @{@"id" : destinationFolderID},
                                             @"name" : copiedFileName};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
}

#pragma mark - Perform Request

- (void)test_that_expected_file_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"file_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];

    // Expected BoxFile response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXFile *expectedFile = [[BOXFile alloc] initWithJSON:jsonDictionary];

    // Set up BOXFileRequest and attach canned response to it.
    BOXFileCopyRequest *fileRequest = [[BOXFileCopyRequest alloc] initWithFileID:expectedFile.modelID
                                                             destinationFolderID:@"456"];
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
