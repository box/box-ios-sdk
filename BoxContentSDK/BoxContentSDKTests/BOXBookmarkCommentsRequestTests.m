//
//  BOXBookmarkCommentsRequestTests.m
//  BoxContentSDK
//
//  Created on 12/22/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequest_Private.h"
#import "BOXRequestTestCase.h"
#import "BOXBookmarkCommentsRequest.h"
#import "BOXComment.h"
#import "BOXContentCacheTestClient.h"
#import "BOXContentClient.h"

@interface BOXBookmarkCommentsRequestTests : BOXRequestTestCase
@end

@implementation BOXBookmarkCommentsRequestTests

#pragma mark - create URL

- (void)test_request_has_correct_url
{
    NSString *bookmarkID = @"12345";
    BOXBookmarkCommentsRequest *request = [[BOXBookmarkCommentsRequest alloc] initWithBookmarkID:bookmarkID];
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/web_links/%@/comments", [BOXContentClient APIBaseURL], bookmarkID]];
    
    XCTAssertEqualObjects(expectedURL, request.urlRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodGET, request.urlRequest.HTTPMethod);
}

- (void)test_shared_link_properties
{
    NSString *bookmarkID = @"123";
    BOXBookmarkCommentsRequest *request = [[BOXBookmarkCommentsRequest alloc] initWithBookmarkID:bookmarkID];
    
    XCTAssertEqualObjects([request itemIDForSharedLink], bookmarkID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeWebLink);    
}

#pragma mark - Perform the request

- (void)test_request_returns_expected_comments
{
    NSString *bookmarkID = @"12345";
    BOXBookmarkCommentsRequest *request = [[BOXBookmarkCommentsRequest alloc] initWithBookmarkID:bookmarkID];
    BOXContentCacheTestClient *cacheClient = [[BOXContentCacheTestClient alloc] init];
    request.cacheClient = cacheClient;

    id cacheClientMock = [OCMockObject partialMockForObject:cacheClient];
    
    NSData *cannedData = [self cannedResponseDataWithName:@"get_comments"];
    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:200 responseData:cannedData];
    
    NSDictionary *expectedResults = [NSJSONSerialization JSONObjectWithData:cannedData options:kNilOptions error:nil];
    NSArray *expectedComments = [self commentsFromJSONDictionary:expectedResults];
    
    [self setCannedURLResponse:response cannedResponseData:cannedData forRequest:request];

    [[cacheClientMock expect] cacheBookmarkCommentsRequest:request
                                              withComments:[OCMArg isNotNil]
                                                     error:[OCMArg isNil]];
    [[cacheClientMock expect] retrieveCacheForBookmarkCommentsRequest:request completion:[OCMArg isNotNil]];

    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];

    [request performRequestWithCached:^(NSArray *objects, NSError *error) {
        // Nothing should happen here.
    } refreshed:^(NSArray *objects, NSError *error) {
        XCTAssertNil(error);
        XCTAssertEqual(objects.count, expectedComments.count);

        for (NSUInteger i = 0; i < objects.count ; i++) {
            [self assertModel:objects[i] isEquivalentTo:expectedComments[i]];
        }

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    [cacheClientMock verify];
}

- (void)test_request_handles_error
{
    NSString *bookmarkID = @"12345";
    BOXBookmarkCommentsRequest *request = [[BOXBookmarkCommentsRequest alloc] initWithBookmarkID:bookmarkID];
    BOXContentCacheTestClient *cacheClient = [[BOXContentCacheTestClient alloc] init];
    request.cacheClient = cacheClient;

    id cacheClientMock = [OCMockObject partialMockForObject:cacheClient];

    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:404 responseData:nil];

    [self setCannedURLResponse:response cannedResponseData:nil forRequest:request];

    [[cacheClientMock expect] cacheBookmarkCommentsRequest:request
                                              withComments:[OCMArg isNil]
                                                     error:[OCMArg isNotNil]];
    [[cacheClientMock expect] retrieveCacheForBookmarkCommentsRequest:request completion:[OCMArg isNotNil]];

    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];

    [request performRequestWithCached:^(NSArray *objects, NSError *error) {
        // Nothing should happen here.
    } refreshed:^(NSArray *objects, NSError *error) {
        XCTAssertNotNil(error);
        XCTAssertNil(objects);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    
    [cacheClientMock verify];
}

#pragma mark - Private Helpers

- (NSArray *)commentsFromJSONDictionary:(NSDictionary *)JSONDictionary
{
    NSArray *commentsDicts = [JSONDictionary objectForKey:@"entries"];
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:commentsDicts.count];
    
    for (NSDictionary *dict in commentsDicts) {
        [comments addObject:[[BOXComment alloc] initWithJSON:dict]];
    }
    
    return comments;
}

@end
