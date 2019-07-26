//
//  BOXRepresentationInfoRequestTests.m
//  BoxContentSDKTests
//
//  Created by Prithvi Jutur on 4/15/18.
//  Copyright © 2018 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXRepresentationInfoRequest.h"

@interface BOXRepresentationInfoRequestTests : BOXRequestTestCase
@end

@implementation BOXRepresentationInfoRequestTests
NSString *const testInfoUrl = @"https://dl.boxcloud.com/api/2.0/internal_files/12345/versions/12345/representations/jpg_2048x2048/content/";
NSString *const testFileID = @"12345";

- (BOXRepresentation *)testRepresentation
{
    BOXRepresentation *representation = [BOXRepresentation new];
    representation.infoURL = [NSURL URLWithString:testInfoUrl];
    return representation;
}

#pragma mark - URLRequest
- (void)test_that_basic_request_has_expected_URLRequest {
    BOXRepresentationInfoRequest *request = [[BOXRepresentationInfoRequest alloc] initWithFileID:testFileID representation:[self testRepresentation]];
    NSURLRequest *URLRequest = request.urlRequest;
    
    XCTAssertEqualObjects(testInfoUrl, URLRequest.URL.absoluteString);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
}

#pragma mark - Perform Request

- (void)test_that_expected_items_are_returned_for_representationInfo_request
{
    BOXRepresentationInfoRequest *request = [[BOXRepresentationInfoRequest alloc] initWithFileID:testFileID representation:[self testRepresentation]];
    NSData *cannedData = [self cannedResponseDataWithName:@"representations_info"];
    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:200 responseData:cannedData];
    [self setCannedURLResponse:response cannedResponseData:cannedData forRequest:request];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(BOXRepresentation *representation, NSError *error) {
        XCTAssertNil(error);
        XCTAssertEqualObjects(representation.type, BOXRepresentationTypeJPG);
        XCTAssertEqualObjects(representation.status, BOXRepresentationStatusSuccess);
        XCTAssertEqualObjects(representation.contentURL, [NSURL URLWithString:@"https://www.box.com/s/bbb"]);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];

}

@end
