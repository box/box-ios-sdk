//
//  BOXFolderShareRequestTests.m
//  BoxContentSDK
//
//  Created on 12/1/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXFolderShareRequest.h"
#import "BOXRequest_Private.h"
#import "NSURL+BOXURLHelper.h"
#import "BOXFolder.h"

@interface BOXFolderShareRequestTests : BOXRequestTestCase
@end

@implementation BOXFolderShareRequestTests

#pragma mark - URLRequest

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *folderID = @"123";
    BOXFolderShareRequest *folderRequest = [[BOXFolderShareRequest alloc] initWithFolderID:folderID];
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
    BOXFolderShareRequest *folderRequest = [[BOXFolderShareRequest alloc] initWithFolderID:folderID];
    
    XCTAssertEqualObjects([folderRequest itemIDForSharedLink], folderID);
    XCTAssertEqualObjects([folderRequest itemTypeForSharedLink], BOXAPIItemTypeFolder);    
}

- (void)test_that_request_with_access_level_has_expected_URLRequest_body
{
    NSString *folderID = @"456";
    BOXFolderShareRequest *folderRequest = [[BOXFolderShareRequest alloc] initWithFolderID:folderID];
    BOXSharedLinkAccessLevel *accessLevel = BOXSharedLinkAccessLevelCollaborators;
    [folderRequest setAccessLevel:accessLevel];
    NSURLRequest *URLRequest = folderRequest.urlRequest;

    NSString *expectedURL = [NSString stringWithFormat:@"%@/folders/%@", [BOXContentClient APIBaseURL], folderID];
    NSString *actualURL = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURL, actualURL);

    NSDictionary *expectedBodyDictionary = @{BOXAPIObjectKeySharedLink: @{BOXAPIObjectKeyAccess: accessLevel}};
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:[URLRequest HTTPBody] options:0 error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, bodyDictionary);
}

- (void)test_that_request_with_unshare_date_has_expected_URLRequest_body
{
    NSString *folderID = @"456";
    BOXFolderShareRequest *folderRequest = [[BOXFolderShareRequest alloc] initWithFolderID:folderID];
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSince1970:473040000];
    [folderRequest setExpirationDate:expirationDate];
    NSURLRequest *URLRequest = folderRequest.urlRequest;

    NSString *expectedURL = [NSString stringWithFormat:@"%@/folders/%@", [BOXContentClient APIBaseURL], folderID];
    NSString *actualURL = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURL, actualURL);

    NSDictionary *expectedBodyDictionary = @{BOXAPIObjectKeySharedLink: @{BOXAPIObjectKeyAccess: [NSNull null], BOXAPIObjectKeyUnsharedAt: [expirationDate box_ISO8601String]}};
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:[URLRequest HTTPBody] options:0 error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, bodyDictionary);
}

- (void)test_that_request_with_download_permission_has_expected_URLRequest_body
{
    NSString *folderID = @"456";
    BOXFolderShareRequest *folderRequest = [[BOXFolderShareRequest alloc] initWithFolderID:folderID];
    [folderRequest setCanDownload:YES];
    NSURLRequest *URLRequest = folderRequest.urlRequest;

    NSString *expectedURL = [NSString stringWithFormat:@"%@/folders/%@", [BOXContentClient APIBaseURL], folderID];
    NSString *actualURL = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURL, actualURL);
    
    NSDictionary *expectedBodyDictionary = @{BOXAPIObjectKeySharedLink: @{BOXAPIObjectKeyAccess: [NSNull null], BOXAPIObjectKeyPermissions: @{BOXAPIObjectKeyCanDownload: [NSNumber numberWithBool:YES]}}};
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:[URLRequest HTTPBody] options:0 error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, bodyDictionary);
}

- (void)test_that_request_with_no_download_permission_has_expected_URLRequest_body
{
    NSString *folderID = @"456";
    BOXFolderShareRequest *folderRequest = [[BOXFolderShareRequest alloc] initWithFolderID:folderID];
    [folderRequest setCanDownload:NO];
    NSURLRequest *URLRequest = folderRequest.urlRequest;
    
    NSString *expectedURL = [NSString stringWithFormat:@"%@/folders/%@", [BOXContentClient APIBaseURL], folderID];
    NSString *actualURL = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURL, actualURL);
    
    NSDictionary *expectedBodyDictionary = @{BOXAPIObjectKeySharedLink: @{BOXAPIObjectKeyAccess: [NSNull null], BOXAPIObjectKeyPermissions: @{BOXAPIObjectKeyCanDownload: [NSNumber numberWithBool:NO]}}};
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:[URLRequest HTTPBody] options:0 error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, bodyDictionary);
}

- (void)test_that_request_with_preview_permission_has_expected_URLRequest_body
{
    NSString *folderID = @"456";
    BOXFolderShareRequest *folderRequest = [[BOXFolderShareRequest alloc] initWithFolderID:folderID];
    [folderRequest setCanPreview:YES];
    NSURLRequest *URLRequest = folderRequest.urlRequest;

    NSString *expectedURL = [NSString stringWithFormat:@"%@/folders/%@", [BOXContentClient APIBaseURL], folderID];
    NSString *actualURL = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURL, actualURL);

    NSDictionary *expectedBodyDictionary = @{BOXAPIObjectKeySharedLink: @{BOXAPIObjectKeyAccess: [NSNull null], BOXAPIObjectKeyPermissions: @{BOXAPIObjectKeyCanPreview: [NSNumber numberWithBool:YES]}}};
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:[URLRequest HTTPBody] options:0 error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, bodyDictionary);
}

- (void)test_that_request_with_no_preview_permission_has_expected_URLRequest_body
{
    NSString *folderID = @"456";
    BOXFolderShareRequest *folderRequest = [[BOXFolderShareRequest alloc] initWithFolderID:folderID];
    [folderRequest setCanPreview:NO];
    NSURLRequest *URLRequest = folderRequest.urlRequest;
    
    NSString *expectedURL = [NSString stringWithFormat:@"%@/folders/%@", [BOXContentClient APIBaseURL], folderID];
    NSString *actualURL = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURL, actualURL);
    
    NSDictionary *expectedBodyDictionary = @{BOXAPIObjectKeySharedLink: @{BOXAPIObjectKeyAccess: [NSNull null], BOXAPIObjectKeyPermissions: @{BOXAPIObjectKeyCanPreview: [NSNumber numberWithBool:NO]}}};
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:[URLRequest HTTPBody] options:0 error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, bodyDictionary);
}

- (void)test_that_request_with_etags_not_to_match_specified_has_expected_URLRequest_headers
{
    NSString *folderID = @"123";
    BOXFolderShareRequest *folderRequest = [[BOXFolderShareRequest alloc] initWithFolderID:folderID];
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
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"folder_default_fields_shared"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];

    // Expected BoxFolder response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXFolder *expectedFolder = [[BOXFolder alloc] initWithJSON:jsonDictionary];

    // Set up BOXFolderRequest and attach canned response to it.
    BOXFolderShareRequest *folderRequest = [[BOXFolderShareRequest alloc] initWithFolderID:expectedFolder.modelID];
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
