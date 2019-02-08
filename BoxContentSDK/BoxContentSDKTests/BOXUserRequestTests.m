//
//  BOXUserRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 11/26/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXRequest_Private.h"
#import "BOXUserRequest.h"
#import "NSURL+BOXURLHelper.h"
#import "BOXUser.h"

@interface BOXUserRequestTests : BOXRequestTestCase
@end

@implementation BOXUserRequestTests

# pragma mark - URLRequest

- (void)test_that_basic_request_has_expected_URLRequest
{
    BOXUserRequest *userRequest = [[BOXUserRequest alloc] init];
    NSURLRequest *URLRequest = userRequest.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/me", [BOXContentClient APIBaseURL]]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
}

- (void)test_that_basic_request_for_user_by_id_has_expected_URLRequest
{
    BOXUserRequest *userRequest = [[BOXUserRequest alloc] initWithUserID:@"12345678"];
    NSURLRequest *URLRequest = userRequest.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/12345678", [BOXContentClient APIBaseURL]]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
}

- (void)test_that_request_with_all_fields_has_expected_URLRequest_query_params
{
    BOXUserRequest *userRequest = [[BOXUserRequest alloc] init];
    [userRequest setRequestAllUserFields:YES];
    NSURLRequest *URLRequest = userRequest.urlRequest;
    
    NSString *expectedURLWithoutQueryString = [NSString stringWithFormat:@"%@/users/me", [BOXContentClient APIBaseURL]];
    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURLWithoutQueryString, actualURLWithoutQueryString);
    
    NSString *expectedFieldsString = [[[BOXRequest alloc] init] fullUserFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, [[[URLRequest.URL box_queryDictionary] objectForKey:@"fields"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
}

#pragma mark - Perform Request

- (void)test_that_expected_user_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"user_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    
    // Expected BoxFile response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXUser *expectedUser = [[BOXUser alloc] initWithJSON:jsonDictionary];
    
    // Set up BOXFileRequest and attach canned response to it.
    BOXUserRequest *userRequest = [[BOXUserRequest alloc] init];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:userRequest];
    
    // Peform request and assert that we received the expectedFile as a response.
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [userRequest performRequestWithCompletion:^(BOXUser *user, NSError *error) {
        [self assertModel:expectedUser isEquivalentTo:user];
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
