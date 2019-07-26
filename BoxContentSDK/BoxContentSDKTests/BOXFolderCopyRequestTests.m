//
//  BOXFolderCopyRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/15/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXFolderCopyRequest.h"
#import "BOXFolder.h"

@interface BOXFolderCopyRequestTests : BOXRequestTestCase
@end

@implementation BOXFolderCopyRequestTests

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *folderID = @"123";
    NSString *destinationFolderID = @"456";
    
    BOXFolderCopyRequest *request = [[BOXFolderCopyRequest alloc] initWithFolderID:folderID destinationFolderID:destinationFolderID];
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/folders/%@/copy", [BOXContentClient APIBaseURL], folderID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"POST", URLRequest.HTTPMethod);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{@"parent" : @{@"id" : destinationFolderID}};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
}

- (void)test_shared_link_properties
{
    NSString *folderID = @"123";
    NSString *destinationFolderID = @"456";   
    BOXFolderCopyRequest *request = [[BOXFolderCopyRequest alloc] initWithFolderID:folderID destinationFolderID:destinationFolderID];

    XCTAssertEqualObjects([request itemIDForSharedLink], folderID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeFolder);    
}

- (void)test_that_request_with_new_name_has_expected_URLRequest
{
    NSString *folderID = @"123";
    NSString *destinationFolderID = @"456";
    NSString *copiedFolderName = @"Battlestar Galactica Rules";
    
    BOXFolderCopyRequest *request = [[BOXFolderCopyRequest alloc] initWithFolderID:folderID destinationFolderID:destinationFolderID];
    request.folderName = copiedFolderName;
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/folders/%@/copy", [BOXContentClient APIBaseURL], folderID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"POST", URLRequest.HTTPMethod);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{@"parent" : @{@"id" : destinationFolderID},
                                              @"name" : copiedFolderName};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
}

- (void)test_that_expected_folder_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"folder_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    
    // Expected BoxFolder response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXFolder *expectedFolder = [[BOXFolder alloc] initWithJSON:jsonDictionary];
    
    // Set up BOXFolderRequest and attach canned response to it.
    BOXFolderCopyRequest *request = [[BOXFolderCopyRequest alloc] initWithFolderID:expectedFolder.modelID destinationFolderID:expectedFolder.parentFolder.modelID];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    // Peform request and assert that we received the expectedFolder as a response.
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(BOXFolder *folder, NSError *error) {
        [self assertModel:expectedFolder isEquivalentTo:folder];
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
