//
//  BOXFileVersionPromoteRequestTests.m
//  BoxContentSDK
//
//  Created by Sowmiya Narayanan on 1/5/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXFileVersionPromoteRequest.h"
#import "BOXFileVersion.h"

@interface BOXFileVersionPromoteRequestTests : BOXRequestTestCase
@end

@implementation BOXFileVersionPromoteRequestTests

#pragma mark - create URL

- (void)test_request_has_correct_url
{
    NSString *fileID = @"123";
    NSString *targetVersionID = @"2";
    BOXFileVersionPromoteRequest *request = [[BOXFileVersionPromoteRequest alloc] initWithFileID:fileID targetVersionID:targetVersionID];
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/%@/versions/current", [BOXContentClient APIBaseURL], fileID]];
    
    XCTAssertEqualObjects(expectedURL, request.urlRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodPOST, request.urlRequest.HTTPMethod);
}

#pragma mark - Perform the request

- (void)test_request_returns_expected_file_version
{
    NSString *fileID = @"123";
    NSString *targetVersionID = @"22648534753";
    BOXFileVersionPromoteRequest *request = [[BOXFileVersionPromoteRequest alloc] initWithFileID:fileID targetVersionID:targetVersionID];
    
    NSData *cannedData = [self cannedResponseDataWithName:@"file_version"];
    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:200 responseData:cannedData];
    
    NSDictionary *expectedResults = [NSJSONSerialization JSONObjectWithData:cannedData options:kNilOptions error:nil];
    BOXFileVersion *expectedFileVersion = [[BOXFileVersion alloc] initWithJSON:expectedResults];
    
    [self setCannedURLResponse:response cannedResponseData:cannedData forRequest:request];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(BOXFileVersion *fileVersion, NSError *error) {
        
        XCTAssertNil(error);
        [self assertModel:fileVersion isEquivalentTo:expectedFileVersion];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
