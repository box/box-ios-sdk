//
//  BOXCommentRequestTests.m
//  BoxContentSDK
//
//  Created on 12/10/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXCommentRequest.h"
#import "BOXRequest_Private.h"
#import "NSURL+BOXURLHelper.h"
#import "BOXComment.h"
#import "BOXContentCacheTestClient.h"
#import "BOXContentClient.h"

@interface BOXCommentRequestTests : BOXRequestTestCase

@end


@implementation BOXCommentRequestTests 

- (void)test_request_url_is_correct
{
    NSString *commentID = @"987654";
    
    BOXCommentRequest *commentDeleteRequest = [[BOXCommentRequest  alloc] initWithCommentID:commentID];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", [BOXContentClient APIBaseURL], BOXAPIResourceComments, commentID]];
    
    XCTAssertEqualObjects(url, commentDeleteRequest.urlRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodGET, commentDeleteRequest.urlRequest.HTTPMethod);
}

- (void)test_request_returns_correct_comment
{
    NSData *cannedData = [self cannedResponseDataWithName:@"comment_all_fields"];
    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:200 responseData:cannedData];

    NSDictionary *expectedResults = [NSJSONSerialization JSONObjectWithData:cannedData options:kNilOptions error:nil];
    BOXComment *expectedComment = [[BOXComment alloc] initWithJSON:expectedResults];
    
    BOXCommentRequest *commentRequest = [[BOXCommentRequest alloc] initWithCommentID:expectedComment.modelID];
    BOXContentCacheTestClient *cacheClient = [[BOXContentCacheTestClient alloc] init];
    commentRequest.cacheClient = cacheClient;

    id cacheClientMock = [OCMockObject partialMockForObject:cacheClient];

    [self setCannedURLResponse:response cannedResponseData:cannedData forRequest:commentRequest];

    [[cacheClientMock expect] cacheCommentRequest:commentRequest
                                      withComment:[OCMArg isNotNil]
                                            error:[OCMArg isNil]];
    [[cacheClientMock expect] retrieveCacheForCommentRequest:commentRequest completion:[OCMArg isNotNil]];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];

    [commentRequest performRequestWithCached:^(BOXComment *comment, NSError *error) {
        // Nothing should happen here.
    } refreshed:^(BOXComment *comment, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(comment);
        [self assertModel:comment isEquivalentTo:expectedComment];

        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    [cacheClientMock verify];
}

- (void)test_request_handles_error
{
    NSData *cannedData = [self cannedResponseDataWithName:@"comment_all_fields"];
    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:404 responseData:nil];

    NSDictionary *expectedResults = [NSJSONSerialization JSONObjectWithData:cannedData options:kNilOptions error:nil];
    BOXComment *expectedComment = [[BOXComment alloc] initWithJSON:expectedResults];

    BOXCommentRequest *commentRequest = [[BOXCommentRequest alloc] initWithCommentID:expectedComment.modelID];
    BOXContentCacheTestClient *cacheClient = [[BOXContentCacheTestClient alloc] init];
    commentRequest.cacheClient = cacheClient;

    id cacheClientMock = [OCMockObject partialMockForObject:cacheClient];

    [self setCannedURLResponse:response cannedResponseData:nil forRequest:commentRequest];

    [[cacheClientMock expect] cacheCommentRequest:commentRequest
                                      withComment:[OCMArg isNil]
                                            error:[OCMArg isNotNil]];
    [[cacheClientMock expect] retrieveCacheForCommentRequest:commentRequest completion:[OCMArg isNotNil]];

    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];

    [commentRequest performRequestWithCached:^(BOXComment *comment, NSError *error) {
        // Nothing should happen here.
    } refreshed:^(BOXComment *comment, NSError *error) {
        XCTAssertNotNil(error);
        XCTAssertNil(comment);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    
    [cacheClientMock verify];
}

- (void)test_that_request_with_all_fields_has_expected_URLRequest_query_params
{
    NSString *commentID = @"987654";
    
    BOXCommentRequest *request = [[BOXCommentRequest  alloc] initWithCommentID:commentID];
    request.requestAllItemFields = YES;
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSString *expectedURLWithoutQueryString = [NSString stringWithFormat:@"%@/comments/%@", [BOXContentClient APIBaseURL], commentID];
    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURLWithoutQueryString, actualURLWithoutQueryString);
    
    NSString *expectedFieldsString = [[[BOXRequest alloc] init] fullCommentFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, [[[URLRequest.URL box_queryDictionary] objectForKey:@"fields"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
}

@end
