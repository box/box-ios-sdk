//
//  BOXFileVersionRequestTests.m
//  BoxContentSDK
//
//  Created by Daniel Cech on 05/17/19.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXFileVersionRequest.h"
#import "BOXFileVersion.h"

@interface BOXFileVersionRequestTests : BOXRequestTestCase
@end

@implementation BOXFileVersionRequestTests

#pragma mark - create URL

- (void)test_request_has_correct_url
{
    NSString *fileID = @"123";
    NSString *versionID = @"456";
    
    BOXFileVersionRequest *request = [[BOXFileVersionRequest alloc] initWithFileID:fileID versionID:versionID];
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/%@/versions/%@", [BOXContentClient APIBaseURL], fileID, versionID]];
    
    XCTAssertEqualObjects(expectedURL, request.urlRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodGET, request.urlRequest.HTTPMethod);
}

- (void)test_shared_link_properties
{
    NSString *fileID = @"123";
    NSString *versionID = @"456";
    
    BOXFileVersionRequest *request = [[BOXFileVersionRequest alloc] initWithFileID:fileID versionID:versionID];
    
    XCTAssertEqualObjects([request itemIDForSharedLink], fileID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeFileVersion);    
}

#pragma mark - Perform the request

- (void)test_request_returns_expected_file_version
{
    NSString *fileID = @"123";
    NSString *versionID = @"456";
    
    BOXFileVersionRequest *request = [[BOXFileVersionRequest alloc] initWithFileID:fileID versionID:versionID];
    
    NSData *cannedData = [self cannedResponseDataWithName:@"file_version"];
    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:200 responseData:cannedData];

    [self setCannedURLResponse:response cannedResponseData:cannedData forRequest:request];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(BOXFileVersion *fileVersion, NSError *error) {
        
        XCTAssertNil(error);
        
        XCTAssertEqualObjects(@"22648534753", fileVersion.modelID);
        XCTAssertEqualObjects(@"Borg Invasion Plan.pptx", fileVersion.name);
        XCTAssertEqualObjects(@"9bab16941f6b7c25d2e7c85df99550640ae944ff", fileVersion.sha1);
        XCTAssertEqualObjects([NSNumber numberWithLong:2678490], fileVersion.size);
        XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-12-31T11:58:31-08:00"], fileVersion.createdDate);
        XCTAssertEqualObjects([NSDate box_dateWithISO8601String:@"2014-12-31T11:58:32-08:00"], fileVersion.modifiedDate);
        XCTAssertEqualObjects(@"205510680", fileVersion.lastModifier.modelID);
        XCTAssertEqualObjects(@"Captain Janeway", fileVersion.lastModifier.name);
        XCTAssertEqualObjects(@"janeway04@starfleet.com", fileVersion.lastModifier.login);
        
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
