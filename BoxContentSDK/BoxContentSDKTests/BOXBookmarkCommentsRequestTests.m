//
//  BOXBookmarkCommentsRequestTests.m
//  BoxContentSDK
//
//  Created on 12/22/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXBookmarkCommentsRequest.h"
#import "BOXComment.h"

@interface BOXBookmarkCommentsRequestTests : BOXRequestTestCase
@end

@implementation BOXBookmarkCommentsRequestTests

#pragma mark - create URL

- (void)test_request_has_correct_url
{
    NSString *bookmarkID = @"12345";
    BOXBookmarkCommentsRequest *request = [[BOXBookmarkCommentsRequest alloc] initWithBookmarkID:bookmarkID];
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/web_links/%@/comments", BOXAPIBaseURL, BOXAPIVersion, bookmarkID]];
    
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
    
    NSData *cannedData = [self cannedResponseDataWithName:@"get_comments"];
    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:200 responseData:cannedData];
    
    NSDictionary *expectedResults = [NSJSONSerialization JSONObjectWithData:cannedData options:kNilOptions error:nil];
    NSArray *expectedComments = [self commentsFromJSONDictionary:expectedResults];
    
    [self setCannedURLResponse:response cannedResponseData:cannedData forRequest:request];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(NSArray *objects, NSError *error) {
        
        XCTAssertNil(error);
        XCTAssertEqual(objects.count, expectedComments.count);
        
        for (NSUInteger i = 0; i < objects.count ; i++) {
            [self assertModel:objects[i] isEquivalentTo:expectedComments[i]];
        }
        
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    
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
