//
//  BOXFileVersionsRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/31/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXFileVersionsRequest.h"
#import "BOXFileVersion.h"

@interface BOXFileVersionsRequestTests : BOXRequestTestCase
@end

@implementation BOXFileVersionsRequestTests

#pragma mark - create URL

- (void)test_request_has_correct_url
{
    NSString *fileID = @"123";
    BOXFileVersionsRequest *request = [[BOXFileVersionsRequest alloc] initWithFileID:fileID];
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/%@/versions", [BOXContentClient APIBaseURL], fileID]];
    
    XCTAssertEqualObjects(expectedURL, request.urlRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodGET, request.urlRequest.HTTPMethod);
}

- (void)test_shared_link_properties
{
    NSString *fileID = @"123";
    BOXFileVersionsRequest *request = [[BOXFileVersionsRequest alloc] initWithFileID:fileID];
    
    XCTAssertEqualObjects([request itemIDForSharedLink], fileID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeFile);    
}

#pragma mark - Perform the request

- (void)test_request_returns_expected_comments
{
    NSString *fileID = @"123";
    
    BOXFileVersionsRequest *request = [[BOXFileVersionsRequest alloc] initWithFileID:fileID];
    
    NSData *cannedData = [self cannedResponseDataWithName:@"file_versions"];
    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:200 responseData:cannedData];

    NSDictionary *expectedResults = [NSJSONSerialization JSONObjectWithData:cannedData options:kNilOptions error:nil];
    NSArray *expectedFileVersions = [self fileVersionsFromJSONDictionary:expectedResults];
    
    [self setCannedURLResponse:response cannedResponseData:cannedData forRequest:request];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(NSArray *objects, NSError *error) {
        
        XCTAssertNil(error);
        XCTAssertEqual(2, objects.count);
        
        for (NSUInteger i = 0; i < objects.count ; i++) {
            [self assertModel:objects[i] isEquivalentTo:expectedFileVersions[i]];
        }
        
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

#pragma mark - Private Helpers

- (NSArray *)fileVersionsFromJSONDictionary:(NSDictionary *)JSONDictionary
{
    NSArray *entries = [JSONDictionary objectForKey:@"entries"];
    NSMutableArray *fileVersions = [NSMutableArray arrayWithCapacity:entries.count];
    
    for (NSDictionary *dict in entries) {
        [fileVersions addObject:[[BOXFileVersion alloc] initWithJSON:dict]];
    }
    
    return fileVersions;
}

@end
