//
//  BOXFileRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 11/21/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXFileRequest.h"
#import "BOXRequest_Private.h"
#import "NSURL+BOXURLHelper.h"
#import "BOXFile.h"
#import "UIDevice+BOXContentSDKAdditions.h"

@interface BOXFileRequestTests : BOXRequestTestCase
@end

@implementation BOXFileRequestTests

# pragma mark - URLRequest

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *fileID = @"123";
    BOXFileRequest *fileRequest = [[BOXFileRequest alloc] initWithFileID:fileID];
    NSURLRequest *URLRequest = fileRequest.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/%@", [BOXContentClient APIBaseURL], fileID]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
}

- (void)test_shared_link_properties
{
    NSString *fileID = @"123";
    BOXFileRequest *fileRequest = [[BOXFileRequest alloc] initWithFileID:fileID];
    
    XCTAssertEqualObjects([fileRequest itemIDForSharedLink], fileID);
    XCTAssertEqualObjects([fileRequest itemTypeForSharedLink], BOXAPIItemTypeFile);    
}

- (void)test_that_request_with_all_fields_has_expected_URLRequest_query_params
{
    NSString *fileID = @"123";
    BOXFileRequest *fileRequest = [[BOXFileRequest alloc] initWithFileID:fileID];
    [fileRequest setRequestAllFileFields:YES];
    NSURLRequest *URLRequest = fileRequest.urlRequest;
    
    NSString *expectedURLWithoutQueryString = [NSString stringWithFormat:@"%@/files/%@", [BOXContentClient APIBaseURL], fileID];
    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURLWithoutQueryString, actualURLWithoutQueryString);
    
    NSString *expectedFieldsString = [[[BOXRequest alloc] init] fullFileFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, [[[URLRequest.URL box_queryDictionary] objectForKey:@"fields"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
}

- (void)test_that_trashed_file_request_has_expected_URLRequest
{
    NSString *fileID = @"123";
    BOXFileRequest *fileRequest = [[BOXFileRequest alloc] initWithFileID:fileID isTrashed:YES];
    NSURLRequest *URLRequest = fileRequest.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/%@/trash", [BOXContentClient APIBaseURL], fileID]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
}

- (void)test_that_request_with_etags_not_to_match_specified_has_expected_URLRequest_headers
{
    NSString *fileID = @"123";
    BOXFileRequest *fileRequest = [[BOXFileRequest alloc] initWithFileID:fileID];
    NSArray *notMatchingEtagsToUse = @[@"123", @"0", @"456", @",", @" ", @"\""]; // numeric values as well as special characters
    [fileRequest setNotMatchingEtags:notMatchingEtagsToUse];
    NSURLRequest *URLRequest = fileRequest.urlRequest;

    NSString *expectedURL = [NSString stringWithFormat:@"%@/files/%@", [BOXContentClient APIBaseURL], fileID];
    NSString *actualURL = [URLRequest.URL absoluteString];
    XCTAssertEqualObjects(expectedURL, actualURL);

    NSDictionary *expectedHeaders = @{BOXAPIHTTPHeaderIfNoneMatch: [notMatchingEtagsToUse componentsJoinedByString:@","]};
    XCTAssertEqualObjects(expectedHeaders, [URLRequest allHTTPHeaderFields]);
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
    BOXFileRequest *fileRequest = [[BOXFileRequest alloc] initWithFileID:expectedFile.modelID];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:fileRequest];
    
    // Peform request and assert that we received the expectedFile as a response.
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [fileRequest performRequestWithCompletion:^(BOXFile *file, NSError *error) {
        [self assertModel:expectedFile isEquivalentTo:file];
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)test_that_representation_options_are_set_correctly_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"file_default_fields"];
    
    // Expected BoxFile response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXFile *expectedFile = [[BOXFile alloc] initWithJSON:jsonDictionary];
    
    // Set up BOXFileRequest and attach canned response to it.
    BOXFileRequest *fileRequest = [[BOXFileRequest alloc] initWithFileID:expectedFile.modelID];
    
    // Check x-reps-hint header original file request
    [fileRequest setRepresentationRequestOptions:@[@(BOXRepresentationRequestOriginal)]];
    NSString *actualXRepsHint = [fileRequest formatRepresentationRequestHeader];
    XCTAssertEqualObjects(nil, actualXRepsHint);
    
    // Check x-reps-hint header with multi-options file request
    [fileRequest setRepresentationRequestOptions:@[@(BOXRepresentationRequestJPGRepresentation), @(BOXRepresentationRequestMP3Representation), @(BOXRepresentationRequestMP4Representation)]];
    actualXRepsHint = [fileRequest formatRepresentationRequestHeader];
    NSString *expectedHeaderXRepsHint = [NSString stringWithFormat:@"[jpg?dimensions=1024x1024&paged=false],[mp3],[mp4]"];
    XCTAssertEqualObjects(expectedHeaderXRepsHint, actualXRepsHint);
    
    // Check x-reps-hint header original file request with other option
    [fileRequest setRepresentationRequestOptions:@[@(BOXRepresentationRequestOriginal)]];
    actualXRepsHint = [fileRequest formatRepresentationRequestHeader];
    XCTAssertEqualObjects(nil, actualXRepsHint);
    
    // Check x-reps-hint header default original file request with other option
    [fileRequest setRepresentationRequestOptions:@[@(BOXRepresentationRequestOriginal), @(BOXRepresentationRequestThumbnailRepresentation)]];
    actualXRepsHint = [fileRequest formatRepresentationRequestHeader];
    expectedHeaderXRepsHint = [NSString stringWithFormat:@"[jpg?dimensions=320x320&paged=false]"];
    XCTAssertEqualObjects(expectedHeaderXRepsHint, actualXRepsHint);
    
    // Check x-reps-hint header thumbnail request
    [fileRequest setRepresentationRequestOptions:@[@(BOXRepresentationRequestThumbnailRepresentation)]];
    actualXRepsHint = [fileRequest formatRepresentationRequestHeader];
    expectedHeaderXRepsHint = [NSString stringWithFormat:@"[jpg?dimensions=320x320&paged=false]"];
    XCTAssertEqualObjects(expectedHeaderXRepsHint, actualXRepsHint);
    
    // Check x-reps-hint header group reps request for all options
    [fileRequest setRepresentationRequestOptions:@[@(BOXRepresentationRequestJPGRepresentation), @(BOXRepresentationRequestMP3Representation), @(BOXRepresentationRequestMP4Representation), @(BOXRepresentationRequestMP4Representation)]];
    actualXRepsHint = [fileRequest formatRepresentationRequestHeader];
    expectedHeaderXRepsHint = [NSString stringWithFormat:@"[jpg?dimensions=1024x1024&paged=false],[mp3],[mp4]"];
    XCTAssertEqualObjects(expectedHeaderXRepsHint, actualXRepsHint);
    
    // Check x-reps-hint header mp3 request
    [fileRequest setRepresentationRequestOptions:@[@(BOXRepresentationRequestMP3Representation)]];
    actualXRepsHint = [fileRequest formatRepresentationRequestHeader];
    expectedHeaderXRepsHint = [NSString stringWithFormat:@"[mp3]"];
    XCTAssertEqualObjects(expectedHeaderXRepsHint, actualXRepsHint);
    
    // Check x-reps-hint header is no option due to persmissions set '0', representation is ignored.
    [fileRequest setRepresentationRequestOptions:@[@(0)]];
    actualXRepsHint = [fileRequest formatRepresentationRequestHeader];
    XCTAssertEqualObjects(nil, actualXRepsHint);
    
    // Match representations option request
    fileRequest.matchSupportedRepresentation = YES;
    
    // Check x-reps-hint header first reps matched request for all options
    [fileRequest setRepresentationRequestOptions:@[@(BOXRepresentationRequestJPGRepresentation),@(BOXRepresentationRequestMP3Representation), @(BOXRepresentationRequestMP4Representation), @(BOXRepresentationRequestMP4Representation)]];
    actualXRepsHint = [fileRequest formatRepresentationRequestHeader];
    expectedHeaderXRepsHint = [NSString stringWithFormat:@"[jpg?dimensions=1024x1024&paged=false,mp3,mp4]"];
    XCTAssertEqualObjects(expectedHeaderXRepsHint, actualXRepsHint);
    
    // Check x-reps-hint header verify single rep in match option
    [fileRequest setRepresentationRequestOptions:@[@(BOXRepresentationRequestHighDefinitionVideo)]];
    actualXRepsHint = [fileRequest formatRepresentationRequestHeader];
    expectedHeaderXRepsHint = [NSString stringWithFormat:@"[hls]"];
    XCTAssertEqualObjects(expectedHeaderXRepsHint, actualXRepsHint);
    
    [fileRequest setRepresentationRequestOptions:@[@(BOXRepresentationRequestLargeThumbnailRepresentation)]];
    actualXRepsHint = [fileRequest formatRepresentationRequestHeader];
    expectedHeaderXRepsHint = [NSString stringWithFormat:@"[jpg?dimensions=1024x1024&paged=false]"];
    XCTAssertEqualObjects(expectedHeaderXRepsHint, actualXRepsHint);
}

@end
