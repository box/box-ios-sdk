//
//  BOXFolderUnshareRequestTests.m
//  BoxContentSDK
//
//  Created on 12/1/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXFolderUnshareRequest.h"
#import "BOXRequest_Private.h"
#import "NSURL+BOXURLHelper.h"
#import "BOXFolder.h"

@interface BOXFolderUnshareRequestTests : BOXRequestTestCase
@end

@implementation BOXFolderUnshareRequestTests

# pragma mark - URLRequest

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *folderID = @"123";
    BOXFolderUnshareRequest *folderRequest = [[BOXFolderUnshareRequest alloc] initWithFolderID:folderID];
    NSURLRequest *URLRequest = folderRequest.urlRequest;

    NSString *expectedURLWithoutQueryString = [NSString stringWithFormat:@"%@/folders/%@", [BOXContentClient APIBaseURL], folderID];
    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURLWithoutQueryString, actualURLWithoutQueryString);
    
    NSString *expectedFieldsString = [[[BOXRequest alloc] init] fullFolderFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, [[[URLRequest.URL box_queryDictionary] objectForKey:@"fields"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    XCTAssertEqualObjects(@"PUT", URLRequest.HTTPMethod);
}

- (void)test_shared_link_properties
{
    NSString *folderID = @"123";
    BOXFolderUnshareRequest *folderRequest = [[BOXFolderUnshareRequest alloc] initWithFolderID:folderID];
    
    XCTAssertEqualObjects([folderRequest itemIDForSharedLink], folderID);
    XCTAssertEqualObjects([folderRequest itemTypeForSharedLink], BOXAPIItemTypeFolder);    
}

- (void)test_that_request_with_etags_to_match_specified_has_expected_URLRequest_headers
{
    NSString *folderID = @"123";
    BOXFolderUnshareRequest *folderRequest = [[BOXFolderUnshareRequest alloc] initWithFolderID:folderID];
    NSString *matchingEtagToUse = @"234"; // numeric values as well as special characters
    [folderRequest setMatchingEtag:matchingEtagToUse];
    NSURLRequest *URLRequest = folderRequest.urlRequest;

    NSString *expectedURLWithoutQueryString = [NSString stringWithFormat:@"%@/folders/%@", [BOXContentClient APIBaseURL], folderID];
    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURLWithoutQueryString, actualURLWithoutQueryString);
    
    NSString *expectedFieldsString = [[[BOXRequest alloc] init] fullFolderFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, [[[URLRequest.URL box_queryDictionary] objectForKey:@"fields"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    NSString *expectedHeaderValue = matchingEtagToUse;
    NSString *actualHeaderValue = [URLRequest valueForHTTPHeaderField:BOXAPIHTTPHeaderIfMatch];
    XCTAssertEqualObjects(expectedHeaderValue, actualHeaderValue);
}

#pragma mark - Perform Request

- (void)test_that_expected_folder_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"folder_default_fields_not_shared"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];

    // Expected BoxFolder response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXFolder *expectedFolder = [[BOXFolder alloc] initWithJSON:jsonDictionary];

    // Set up BOXFolderUnshareRequest and attach canned response to it.
    BOXFolderUnshareRequest *folderRequest = [[BOXFolderUnshareRequest alloc] initWithFolderID:expectedFolder.modelID];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:folderRequest];

    // Peform request and assert that we received the expectedFolder as a response.
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [folderRequest performRequestWithCompletion:^(BOXFolder *folder, NSError *error) {
        [self assertModel:expectedFolder isEquivalentTo:folder];
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
