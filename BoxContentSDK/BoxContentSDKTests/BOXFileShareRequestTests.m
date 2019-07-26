//
//  BOXFileShareRequestTests.m
//  BoxContentSDK
//
//  Created on 12/1/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXFileShareRequest.h"
#import "BOXRequest_Private.h"
#import "NSURL+BOXURLHelper.h"
#import "BOXFile.h"

@interface BOXFileShareRequestTests : BOXRequestTestCase
@end

@implementation BOXFileShareRequestTests

# pragma mark - URLRequest

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *fileID = @"123";
    BOXFileShareRequest *fileRequest = [[BOXFileShareRequest alloc] initWithFileID:fileID];
    NSURLRequest *URLRequest = fileRequest.urlRequest;

    NSString *expectedURLWithoutQueryString = [NSString stringWithFormat:@"%@/files/%@", [BOXContentClient APIBaseURL], fileID];
    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURLWithoutQueryString, actualURLWithoutQueryString);
    
    NSString *expectedFieldsString = [[[BOXRequest alloc] init] fullFileFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, [[[URLRequest.URL box_queryDictionary] objectForKey:@"fields"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    XCTAssertEqualObjects(@"PUT", URLRequest.HTTPMethod);
}

- (void)test_shared_link_properties
{
    NSString *fileID = @"123";
    BOXFileShareRequest *fileRequest = [[BOXFileShareRequest alloc] initWithFileID:fileID];
    
    XCTAssertEqualObjects([fileRequest itemIDForSharedLink], fileID);
    XCTAssertEqualObjects([fileRequest itemTypeForSharedLink], BOXAPIItemTypeFile);    
}

- (void)test_that_request_with_access_level_has_expected_URLRequest_body
{
    NSString *fileID = @"456";
    BOXFileShareRequest *fileRequest = [[BOXFileShareRequest alloc] initWithFileID:fileID];
    BOXSharedLinkAccessLevel *accessLevel = BOXSharedLinkAccessLevelCollaborators;
    [fileRequest setAccessLevel:accessLevel];
    NSURLRequest *URLRequest = fileRequest.urlRequest;

    NSString *expectedURL = [NSString stringWithFormat:@"%@/files/%@", [BOXContentClient APIBaseURL], fileID];
    NSString *actualURL = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURL, actualURL);

    NSDictionary *expectedBodyDictionary = @{BOXAPIObjectKeySharedLink: @{BOXAPIObjectKeyAccess: accessLevel}};
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:[URLRequest HTTPBody] options:0 error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, bodyDictionary);
}

- (void)test_that_request_with_unshare_date_has_expected_URLRequest_body
{
    NSString *fileID = @"456";
    BOXFileShareRequest *fileRequest = [[BOXFileShareRequest alloc] initWithFileID:fileID];
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSince1970:473040000];
    [fileRequest setExpirationDate:expirationDate];
    NSURLRequest *URLRequest = fileRequest.urlRequest;

    NSString *expectedURL = [NSString stringWithFormat:@"%@/files/%@", [BOXContentClient APIBaseURL], fileID];
    NSString *actualURL = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURL, actualURL);

    NSDictionary *expectedBodyDictionary = @{BOXAPIObjectKeySharedLink: @{BOXAPIObjectKeyAccess: [NSNull null], BOXAPIObjectKeyUnsharedAt: [expirationDate box_ISO8601String]}};
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:[URLRequest HTTPBody] options:0 error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, bodyDictionary);
}

- (void)test_that_request_with_download_permission_has_expected_URLRequest_body
{
    NSString *fileID = @"456";
    BOXFileShareRequest *fileRequest = [[BOXFileShareRequest alloc] initWithFileID:fileID];
    [fileRequest setCanDownload:YES];
    NSURLRequest *URLRequest = fileRequest.urlRequest;

    NSString *expectedURL = [NSString stringWithFormat:@"%@/files/%@", [BOXContentClient APIBaseURL], fileID];
    NSString *actualURL = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURL, actualURL);
    
    NSDictionary *expectedBodyDictionary = @{BOXAPIObjectKeySharedLink: @{BOXAPIObjectKeyAccess: [NSNull null], BOXAPIObjectKeyPermissions: @{BOXAPIObjectKeyCanDownload: [NSNumber numberWithBool:YES]}}};
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:[URLRequest HTTPBody] options:0 error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, bodyDictionary);
}

- (void)test_that_request_with_no_download_permission_has_expected_URLRequest_body
{
    NSString *fileID = @"456";
    BOXFileShareRequest *fileRequest = [[BOXFileShareRequest alloc] initWithFileID:fileID];
    [fileRequest setCanDownload:NO];
    NSURLRequest *URLRequest = fileRequest.urlRequest;
    
    NSString *expectedURL = [NSString stringWithFormat:@"%@/files/%@", [BOXContentClient APIBaseURL], fileID];
    NSString *actualURL = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURL, actualURL);
    
    NSDictionary *expectedBodyDictionary = @{BOXAPIObjectKeySharedLink: @{BOXAPIObjectKeyAccess: [NSNull null], BOXAPIObjectKeyPermissions: @{BOXAPIObjectKeyCanDownload: [NSNumber numberWithBool:NO]}}};
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:[URLRequest HTTPBody] options:0 error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, bodyDictionary);
}

- (void)test_that_request_with_preview_permission_has_expected_URLRequest_body
{
    NSString *fileID = @"456";
    BOXFileShareRequest *fileRequest = [[BOXFileShareRequest alloc] initWithFileID:fileID];
    [fileRequest setCanPreview:YES];
    NSURLRequest *URLRequest = fileRequest.urlRequest;

    NSString *expectedURL = [NSString stringWithFormat:@"%@/files/%@", [BOXContentClient APIBaseURL], fileID];
    NSString *actualURL = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURL, actualURL);

    NSDictionary *expectedBodyDictionary = @{BOXAPIObjectKeySharedLink: @{BOXAPIObjectKeyAccess: [NSNull null], BOXAPIObjectKeyPermissions: @{BOXAPIObjectKeyCanPreview: [NSNumber numberWithBool:YES]}}};
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:[URLRequest HTTPBody] options:0 error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, bodyDictionary);
}

- (void)test_that_request_with_no_preview_permission_has_expected_URLRequest_body
{
    NSString *fileID = @"456";
    BOXFileShareRequest *fileRequest = [[BOXFileShareRequest alloc] initWithFileID:fileID];
    [fileRequest setCanPreview:NO];
    NSURLRequest *URLRequest = fileRequest.urlRequest;
    
    NSString *expectedURL = [NSString stringWithFormat:@"%@/files/%@", [BOXContentClient APIBaseURL], fileID];
    NSString *actualURL = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURL, actualURL);
    
    NSDictionary *expectedBodyDictionary = @{BOXAPIObjectKeySharedLink: @{BOXAPIObjectKeyAccess: [NSNull null], BOXAPIObjectKeyPermissions: @{BOXAPIObjectKeyCanPreview: [NSNumber numberWithBool:NO]}}};
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:[URLRequest HTTPBody] options:0 error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, bodyDictionary);
}

- (void)test_that_request_with_etags_not_to_match_specified_has_expected_URLRequest_headers
{
    NSString *fileID = @"123";
    BOXFileShareRequest *fileRequest = [[BOXFileShareRequest alloc] initWithFileID:fileID];
    NSString *matchingEtagToUse = @"234"; // numeric values as well as special characters
    [fileRequest setMatchingEtag:matchingEtagToUse];
    NSURLRequest *URLRequest = fileRequest.urlRequest;

    NSString *expectedURLWithoutQueryString = [NSString stringWithFormat:@"%@/files/%@", [BOXContentClient APIBaseURL], fileID];
    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURLWithoutQueryString, actualURLWithoutQueryString);
    
    NSString *expectedFieldsString = [[[BOXRequest alloc] init] fullFileFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, [[[URLRequest.URL box_queryDictionary] objectForKey:@"fields"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);

    NSString *expectedHeaderValue = matchingEtagToUse;
    NSString *actualHeaderValue = [URLRequest valueForHTTPHeaderField:BOXAPIHTTPHeaderIfMatch];
    XCTAssertEqualObjects(expectedHeaderValue, actualHeaderValue);
}

#pragma mark - Perform Request

- (void)test_that_expected_file_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"file_default_fields_shared"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];

    // Expected BoxFile response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXFile *expectedFile = [[BOXFile alloc] initWithJSON:jsonDictionary];

    // Set up BOXFileRequest and attach canned response to it.
    BOXFileShareRequest *fileRequest = [[BOXFileShareRequest alloc] initWithFileID:expectedFile.modelID];
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
