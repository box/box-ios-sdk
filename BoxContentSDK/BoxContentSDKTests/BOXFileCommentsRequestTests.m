//
//  BOXFileCommentsRequestTests.m
//  BoxContentSDK
//
//  Created by Clement Rousselle on 12/9/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXFileCommentsRequest.h"
#import "BOXRequest_Private.h"
#import "NSURL+BOXURLHelper.h"
#import "BoxComment.h"

@interface BOXFileCommentsRequest ()

- (NSArray *)commentsFromJSONDictionary:(NSDictionary *)JSONDictionary;

@end

@interface BOXFileCommentsRequestTests : BOXRequestTestCase

@end

@implementation BOXFileCommentsRequestTests 

#pragma mark - create URL

- (void)test_request_has_correct_url
{
    NSString *fileID = @"12345";
    BOXFileCommentsRequest *request = [[BOXFileCommentsRequest alloc] initWithFileID:fileID];
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/files/%@/comments", BOXAPIBaseURL, BOXAPIVersion, fileID]];
    
    XCTAssertEqualObjects(expectedURL, request.urlRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodGET, request.urlRequest.HTTPMethod);
}

- (void)test_shared_link_properties
{
    NSString *fileID = @"123";
    BOXFileCommentsRequest *request = [[BOXFileCommentsRequest alloc] initWithFileID:fileID];
    
    XCTAssertEqualObjects([request itemIDForSharedLink], fileID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeFile);    
}

#pragma mark - Perform the request

- (void)test_request_returns_expected_comments
{
    NSString *fileID = @"1234567";
    
    BOXFileCommentsRequest *request = [[BOXFileCommentsRequest alloc] initWithFileID:fileID];
    
    NSData *cannedData = [self cannedResponseDataWithName:@"get_comments"];
    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:200 responseData:cannedData];
        
    NSDictionary *expectedResults = [NSJSONSerialization JSONObjectWithData:cannedData options:kNilOptions error:nil];
    NSArray *expectedComments = [request commentsFromJSONDictionary:expectedResults];
    
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

- (void)test_that_request_with_all_fields_has_expected_URLRequest_query_params
{
    NSString *fileID = @"1234567";
    
    BOXFileCommentsRequest *request = [[BOXFileCommentsRequest alloc] initWithFileID:fileID];
    request.requestAllItemFields = YES;
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSString *expectedURLWithoutQueryString = [NSString stringWithFormat:@"%@/%@/files/%@/comments", BOXAPIBaseURL, BOXAPIVersion, fileID];
    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURLWithoutQueryString, actualURLWithoutQueryString);
    
    NSString *expectedFieldsString = [[[BOXRequest alloc] init] fullCommentFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, [[[URLRequest.URL box_queryDictionary] objectForKey:@"fields"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
}

@end
