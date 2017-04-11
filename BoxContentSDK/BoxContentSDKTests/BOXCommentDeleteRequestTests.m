//
//  BOXCommentDeleteRequestTests.m
//  BoxContentSDK
//
//  Created on 12/10/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequest_Private.h"
#import "BOXRequestTestCase.h"
#import "BOXComment.h"
#import "BOXCommentDeleteRequest.h"
#import "BOXContentCacheTestClient.h"
#import "BOXContentClient.h"

@interface BOXCommentDeleteRequestTests : BOXRequestTestCase

@end

@implementation BOXCommentDeleteRequestTests 

- (void)test_request_url_is_correct
{
    NSString *commentID = @"987654";
    
    BOXCommentDeleteRequest *commentDeleteRequest = [[BOXCommentDeleteRequest alloc] initWithCommentID:commentID];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", [BOXContentClient APIBaseURL], BOXAPIResourceComments, commentID]];

    XCTAssertEqualObjects(url, commentDeleteRequest.urlRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodDELETE, commentDeleteRequest.urlRequest.HTTPMethod);
}

- (void)test_perform_request
{
    NSString *commentID = @"987654";
    BOXCommentDeleteRequest *commentDeleteRequest = [[BOXCommentDeleteRequest alloc] initWithCommentID:commentID];
    BOXContentCacheTestClient *cacheClient = [[BOXContentCacheTestClient alloc] init];
    commentDeleteRequest.cacheClient = cacheClient;

    id cacheClientMock = [OCMockObject partialMockForObject:cacheClient];

    NSData *cannedData = [self cannedResponseDataWithName:@"empty"];
    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:204 responseData:cannedData];

    [self setCannedURLResponse:response cannedResponseData:cannedData forRequest:commentDeleteRequest];

    [[cacheClientMock expect] cacheDeleteCommentRequest:commentDeleteRequest
                                                  error:[OCMArg isNil]];

    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];

    [commentDeleteRequest performRequestWithCompletion:^(NSError *error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    [cacheClientMock verify];
}

- (void)test_perform_request_error
{
    NSString *commentID = @"987654";
    BOXCommentDeleteRequest *commentDeleteRequest = [[BOXCommentDeleteRequest alloc] initWithCommentID:commentID];
    BOXContentCacheTestClient *cacheClient = [[BOXContentCacheTestClient alloc] init];
    commentDeleteRequest.cacheClient = cacheClient;

    id cacheClientMock = [OCMockObject partialMockForObject:cacheClient];

    NSData *cannedData = [self cannedResponseDataWithName:@"empty"];
    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:404 responseData:cannedData];

    [self setCannedURLResponse:response cannedResponseData:cannedData forRequest:commentDeleteRequest];

    [[cacheClientMock expect] cacheDeleteCommentRequest:commentDeleteRequest
                                                  error:[OCMArg isNotNil]];

    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];

    [commentDeleteRequest performRequestWithCompletion:^(NSError *error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    [cacheClientMock verify];
}

@end
