//
//  BOXSharedItemRequestTests.m
//  BoxContentSDK
//
//  Created on 12/11/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXSharedItemRequest.h"
#import "BOXFolder.h"
#import "BOXSharedLink.h"

@interface BOXSharedItemRequestTests : BOXRequestTestCase
@end

@implementation BOXSharedItemRequestTests

# pragma mark - URLRequest

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *sharedLinkString = @"https://app.box.com/s/test321";
    BOXSharedItemRequest *folderRequest = [[BOXSharedItemRequest alloc] initWithURL:[NSURL URLWithString:sharedLinkString]
                                                                           password:nil];
    NSURLRequest *URLRequest = folderRequest.urlRequest;

    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/shared_items", [BOXContentClient APIBaseURL]]];

    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);

    NSString *expectedHeaderValue = [@"shared_link=" stringByAppendingString:sharedLinkString];
    NSString *actualHeaderValue = [URLRequest valueForHTTPHeaderField:BOXAPIHTTPHeaderBoxAPI];
    XCTAssertEqualObjects(expectedHeaderValue, actualHeaderValue);
}

- (void)test_that_request_with_password_has_expected_URLRequest
{
    NSString *sharedLinkString = @"https://app.box.com/s/test321";
    NSString *password = @"p@ssw0rd-h3r3";
    BOXSharedItemRequest *folderRequest = [[BOXSharedItemRequest alloc] initWithURL:[NSURL URLWithString:sharedLinkString]
                                                                           password:password];
    NSURLRequest *URLRequest = folderRequest.urlRequest;

    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/shared_items", [BOXContentClient APIBaseURL]]];

    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);

    NSString *expectedHeaderValue = [NSString stringWithFormat:@"shared_link=%@&shared_link_password=%@", sharedLinkString, password];
    NSString *actualHeaderValue = [URLRequest valueForHTTPHeaderField:BOXAPIHTTPHeaderBoxAPI];
    XCTAssertEqualObjects(expectedHeaderValue, actualHeaderValue);
}

#pragma mark - Perform Request

- (void)test_that_expected_folder_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"folder_default_fields_shared"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];

    // Expected BoxFolder response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXFolder *expectedFolder = [[BOXFolder alloc] initWithJSON:jsonDictionary];

    // Set up BOXFolderRequest and attach canned response to it.
    BOXSharedItemRequest *sharedFolderRequest = [[BOXSharedItemRequest alloc] initWithURL:expectedFolder.sharedLink.url password:nil];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:sharedFolderRequest];

    // Peform request and assert that we received the expectedFolder as a response.
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [sharedFolderRequest performRequestWithCompletion:^(BOXItem *item, NSError *error) {
        [self assertModel:expectedFolder isEquivalentTo:item];
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
