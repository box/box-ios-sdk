//
//  BOXFolderRequestTests.m
//  BoxContentSDK
//
//  Created on 12/1/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXFolderRequest.h"
#import "BOXRequest_Private.h"
#import "NSURL+BOXURLHelper.h"
#import "BOXFolder.h"

@interface BOXFolderRequestTests : BOXRequestTestCase
@end

@implementation BOXFolderRequestTests

#pragma mark - URLRequest

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *folderID = @"123";
    BOXFolderRequest *folderRequest = [[BOXFolderRequest alloc] initWithFolderID:folderID];
    NSURLRequest *URLRequest = folderRequest.urlRequest;

    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/folders/%@?limit=0", [BOXContentClient APIBaseURL], folderID]];

    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
}

- (void)test_that_trashed_folder_request_has_expected_URLRequest
{
    NSString *folderID = @"123";
    BOXFolderRequest *folderRequest = [[BOXFolderRequest alloc] initWithFolderID:folderID isTrashed:YES];
    NSURLRequest *URLRequest = folderRequest.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/folders/%@/trash?limit=0", [BOXContentClient APIBaseURL], folderID]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
}

- (void)test_shared_link_properties
{
    NSString *folderID = @"123";
    BOXFolderRequest *folderRequest = [[BOXFolderRequest alloc] initWithFolderID:folderID];
    
    XCTAssertEqualObjects([folderRequest itemIDForSharedLink], folderID);
    XCTAssertEqualObjects([folderRequest itemTypeForSharedLink], BOXAPIItemTypeFolder);    
}

- (void)test_that_request_with_all_fields_has_expected_URLRequest_query_params
{
    NSString *folderID = @"123";
    BOXFolderRequest *folderRequest = [[BOXFolderRequest alloc] initWithFolderID:folderID];
    [folderRequest setRequestAllFolderFields:YES];
    NSURLRequest *URLRequest = folderRequest.urlRequest;

    NSString *expectedURLWithoutQueryString = [NSString stringWithFormat:@"%@/folders/%@", [BOXContentClient APIBaseURL], folderID];
    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURLWithoutQueryString, actualURLWithoutQueryString);

    NSString *expectedFieldsString = [[[BOXRequest alloc] init] fullFolderFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, [[[URLRequest.URL box_queryDictionary] objectForKey:@"fields"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
}

- (void)test_that_request_with_etags_not_to_match_specified_has_expected_URLRequest_headers
{
    NSString *folderID = @"123";
    BOXFolderRequest *folderRequest = [[BOXFolderRequest alloc] initWithFolderID:folderID];
    NSArray *notMatchingEtagsToUse = @[@"123", @"0", @"456", @",", @" ", @"\""]; // numeric values as well as special characters
    [folderRequest setNotMatchingEtags:notMatchingEtagsToUse];
    NSURLRequest *URLRequest = folderRequest.urlRequest;
    
    NSString *expectedURL = [NSString stringWithFormat:@"%@/folders/%@?limit=0", [BOXContentClient APIBaseURL], folderID];
    NSString *actualURL = [URLRequest.URL absoluteString];
    XCTAssertEqualObjects(expectedURL, actualURL);
    
    NSDictionary *expectedHeaders = @{BOXAPIHTTPHeaderIfNoneMatch: [notMatchingEtagsToUse componentsJoinedByString:@","]};
    XCTAssertEqualObjects(expectedHeaders, [URLRequest allHTTPHeaderFields]);
}

#pragma mark - Perform Request

- (void)test_that_expected_folder_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"folder_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];

    // Expected BoxFolder response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXFolder *expectedFolder = [[BOXFolder alloc] initWithJSON:jsonDictionary];

    // Set up BOXFolderRequest and attach canned response to it.
    BOXFolderRequest *folderRequest = [[BOXFolderRequest alloc] initWithFolderID:expectedFolder.modelID];
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
