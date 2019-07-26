//
//  BOXFileUnshareRequestTests.m
//  BoxContentSDK
//
//  Created on 12/1/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXFileUnshareRequest.h"
#import "BOXRequest_Private.h"
#import "NSURL+BOXURLHelper.h"
#import "BOXFile.h"

@interface BOXFileUnshareRequestTests : BOXRequestTestCase
@end

@implementation BOXFileUnshareRequestTests

# pragma mark - URLRequest

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *fileID = @"123";
    BOXFileUnshareRequest *fileRequest = [[BOXFileUnshareRequest alloc] initWithFileID:fileID];
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
    BOXFileUnshareRequest *fileRequest = [[BOXFileUnshareRequest alloc] initWithFileID:fileID];
    
    XCTAssertEqualObjects([fileRequest itemIDForSharedLink], fileID);
    XCTAssertEqualObjects([fileRequest itemTypeForSharedLink], BOXAPIItemTypeFile);    
}

- (void)test_that_request_with_etags_to_match_specified_has_expected_URLRequest_headers
{
    NSString *fileID = @"123";
    BOXFileUnshareRequest *fileRequest = [[BOXFileUnshareRequest alloc] initWithFileID:fileID];
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
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"file_default_fields_not_shared"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];

    // Expected BoxFile response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXFile *expectedfile = [[BOXFile alloc] initWithJSON:jsonDictionary];

    // Set up BOXFileUnshareRequest and attach canned response to it.
    BOXFileUnshareRequest *fileRequest = [[BOXFileUnshareRequest alloc] initWithFileID:expectedfile.modelID];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:fileRequest];

    // Peform request and assert that we received the expectedfile as a response.
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [fileRequest performRequestWithCompletion:^(BOXFile *file, NSError *error) {
        [self assertModel:expectedfile isEquivalentTo:file];
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
