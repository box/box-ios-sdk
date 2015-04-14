//
//  BOXFileDownloadRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/19/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXRequest_Private.h"
#import "BOXFileDownloadRequest.h"
#import "BOXFile.h"

@interface BOXAPIOperation ()
- (void)sendLogoutNotification;
@end

@interface BOXFileDownloadRequestTests : BOXRequestTestCase
@end

@implementation BOXFileDownloadRequestTests

#pragma mark - NSURLRequest

- (void)test_that_download_request_has_expected_URLRequest
{
    NSString *fileID = @"123";
    BOXFileDownloadRequest *request = [[BOXFileDownloadRequest alloc] initWithLocalDestination:@"/dummy/path" fileID:fileID];
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/files/%@/content", BOXAPIBaseURL, BOXAPIVersion, fileID]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
}

- (void)test_shared_link_properties
{
    NSString *fileID = @"123";
    BOXFileDownloadRequest *request = [[BOXFileDownloadRequest alloc] initWithLocalDestination:@"/dummy/path" fileID:fileID];
    
    XCTAssertEqualObjects([request itemIDForSharedLink], fileID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeFile);    
}

- (void)test_that_download_request_with_version_id_has_expected_URLRequest
{
    NSString *fileID = @"123";
    NSString *versionID = @"456";
    BOXFileDownloadRequest *request = [[BOXFileDownloadRequest alloc] initWithLocalDestination:@"/dummy/path" fileID:fileID];
    request.versionID = versionID;
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/files/%@/content?version=%@", BOXAPIBaseURL, BOXAPIVersion, fileID, versionID]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
}

#pragma mark - Download data

- (void)test_that_download_to_path_request_returns_expected_download_data
{
    NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *localFileURL = [temporaryDirectoryURL URLByAppendingPathComponent:@"dummyDownloadFile"];
    NSString *localFilePath = [localFileURL path];
    [[NSFileManager defaultManager] removeItemAtPath:localFilePath error:nil];
    
    BOXFileDownloadRequest *request = [[BOXFileDownloadRequest alloc] initWithLocalDestination:localFilePath fileID:@"123"];
    
    NSData *cannedResponseData = [self randomDataWithLength:4096];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithProgress:nil completion:^(NSError *error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    
    NSData *data = [NSData dataWithContentsOfFile:localFilePath];
    XCTAssertEqualObjects(cannedResponseData, data);
}

- (void)test_that_download_to_output_stream_request_returns_expected_download_data
{
    NSOutputStream *outputStream = [[NSOutputStream alloc] initToMemory];
    
    BOXFileDownloadRequest *request = [[BOXFileDownloadRequest alloc] initWithOutputStream:outputStream fileID:@"123"];
    
    NSData *cannedResponseData = [self randomDataWithLength:4096];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithProgress:nil completion:^(NSError *error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    
    NSData *data = [outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    XCTAssertEqualObjects(cannedResponseData, data);
}

- (void)test_that_download_request_returns_expected_download_data_after_intermediate_202_responses
{
    NSOutputStream *outputStream = [[NSOutputStream alloc] initToMemory];
    
    BOXFileDownloadRequest *request = [[BOXFileDownloadRequest alloc] initWithOutputStream:outputStream fileID:@"123"];
    
    NSData *cannedResponseData = [self randomDataWithLength:4096];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    BOXCannedResponse *cannedResponse = [[BOXCannedResponse alloc] initWithURLResponse:URLResponse responseData:cannedResponseData];
    
    // Simulate 3 intermediate 202 responses before we actually get the expected contents.
    NSInteger numberOfIntermediate202Responses = 3;
    cannedResponse.numberOfIntermediate202Responses = numberOfIntermediate202Responses;
    
    [self setCannedResponse:cannedResponse forRequest:request];
    
    // We expect the queueManager to re-enque after each 202 is received.
    __block NSInteger numberOfOperationsEnqueued = 0;
    id queueManagerMock = [OCMockObject partialMockForObject:request.queueManager];
    [[[[queueManagerMock stub] andDo:^(NSInvocation *invocation) {
        numberOfOperationsEnqueued++;
    }] andForwardToRealObject] enqueueOperation:OCMOCK_ANY];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithProgress:nil completion:^(NSError *error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    
    NSData *data = [outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    XCTAssertEqualObjects(cannedResponseData, data);
    
    // Expect 1 enqueueing for the initial request, and then 1 more for each of the intermediate 202 responses.
    XCTAssertEqual(1 + numberOfIntermediate202Responses, numberOfOperationsEnqueued);
}

#pragma mark - Progress blocks

- (void)test_that_download_request_calls_progress_blocks
{
    NSOutputStream *outputStream = [[NSOutputStream alloc] initToMemory];
    
    BOXFileDownloadRequest *request = [[BOXFileDownloadRequest alloc] initWithOutputStream:outputStream fileID:@"123"];
    
    NSData *cannedResponseData = [self randomDataWithLength:500 * 1024]; // Has to be sufficiently big enough to trigger progress blocks.
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    __block long intermediateProgressBlockCalls = 0;
    __block long finalProgressBlockCalls = 0;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
        if (totalBytesTransferred < totalBytesExpectedToTransfer) {
            intermediateProgressBlockCalls++;
        }
        else if (totalBytesTransferred == totalBytesExpectedToTransfer) {
            finalProgressBlockCalls++;
        } else {
            XCTFail(@"Progress called with totalBytesTransferred greater than totalBytesExpectedToTransfer");
        }
        
    } completion:^(NSError *error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    
    // Intermediate progress should be called at least once, and final should be called exactly once.
    XCTAssertGreaterThan(intermediateProgressBlockCalls,  0);
    XCTAssertEqual(1, finalProgressBlockCalls);
}

#pragma mark - Error Handling

- (void)test_that_invalid_grant_400_error_triggers_logout_notification
{
    NSOutputStream *outputStream = [[NSOutputStream alloc] initToMemory];
    
    BOXFileDownloadRequest *request = [[BOXFileDownloadRequest alloc] initWithOutputStream:outputStream fileID:@"123"];
    
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"invalid_grant"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:400 responseData:cannedResponseData];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    [request performRequestWithProgress:nil completion:nil];
    
    [self expectationForNotification:BOXUserWasLoggedOutDueToErrorNotification object:nil handler:nil];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)test_that_unauthorized_401_error_triggers_logout_notification
{
    NSOutputStream *outputStream = [[NSOutputStream alloc] initToMemory];
    
    BOXFileDownloadRequest *request = [[BOXFileDownloadRequest alloc] initWithOutputStream:outputStream fileID:@"123"];
    
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:401 responseData:nil];
    [self setCannedURLResponse:URLResponse cannedResponseData:nil forRequest:request];
    
    [request performRequestWithProgress:nil completion:nil];
    
    [self expectationForNotification:BOXUserWasLoggedOutDueToErrorNotification object:nil handler:nil];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];}

- (void)test_that_invalid_token_401_error_does_not_trigger_logout_notification
{
    NSOutputStream *outputStream = [[NSOutputStream alloc] initToMemory];
    
    BOXFileDownloadRequest *request = [[BOXFileDownloadRequest alloc] initWithOutputStream:outputStream fileID:@"123"];
    
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"invalid_token"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:400 responseData:cannedResponseData];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    id operationMock = [OCMockObject partialMockForObject:request.operation];
    [[operationMock reject] sendLogoutNotification];
    
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithProgress:nil completion:^(NSError *error) {
        [operationMock verify];
        [requestExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

# pragma mark - private helpers

- (NSData *)randomDataWithLength:(NSUInteger)length
{
    NSMutableData *mutableData = [NSMutableData dataWithCapacity: length];
    for (unsigned int i = 0; i < length; i++) {
        NSInteger randomBits = arc4random();
        [mutableData appendBytes: (void *) &randomBits length: 1];
    }
    return mutableData;
}

@end
