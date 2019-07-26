//
//  BOXFolderCreateRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/10/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXFolderCreateRequest.h"
#import "BOXFolder.h"

@interface BOXFolderCreateRequestTests : BOXRequestTestCase
@end

@implementation BOXFolderCreateRequestTests

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *folderName = @"Hello";
    NSString *parentFolderID = @"123";
    BOXFolderCreateRequest *request = [[BOXFolderCreateRequest alloc] initWithFolderName:folderName parentFolderID:parentFolderID];
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/folders", [BOXContentClient APIBaseURL]]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"POST", URLRequest.HTTPMethod);
    
    NSDictionary *expectedBodyDictionary = @{@"name" : folderName, @"parent" : @{@"id" : parentFolderID}};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
}

- (void)test_shared_link_properties
{
    NSString *folderName = @"Hello";
    NSString *parentFolderID = @"123";
    BOXFolderCreateRequest *request = [[BOXFolderCreateRequest alloc] initWithFolderName:folderName parentFolderID:parentFolderID];
    
    XCTAssertEqualObjects([request itemIDForSharedLink], parentFolderID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeFolder);    
}

- (void)test_that_expected_folder_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"folder_all_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    
    // Expected BoxFolder response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXFolder *expectedFolder = [[BOXFolder alloc] initWithJSON:jsonDictionary];
    
    // Set up BOXFolderRequest and attach canned response to it.
    BOXFolderCreateRequest *request = [[BOXFolderCreateRequest alloc] initWithFolderName:expectedFolder.name parentFolderID:expectedFolder.parentFolder.modelID];
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
