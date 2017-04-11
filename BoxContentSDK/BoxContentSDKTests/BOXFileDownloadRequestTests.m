//
//  BOXFileDownloadRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/19/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXRequest_Private.h"
#import "BOXContentClient.h"
#import "BOXFileDownloadRequest.h"
#import "BOXFile.h"
#import "BOXParallelAPIQueueManager.h"

@interface BOXFileDownloadRequestTests : BOXRequestTestCase
@end

@implementation BOXFileDownloadRequestTests

#pragma mark - NSURLRequest

- (void)test_that_download_request_has_expected_URLRequest
{
    NSString *fileID = @"123";
    BOXFileDownloadRequest *request = [[BOXFileDownloadRequest alloc] initWithLocalDestination:@"/dummy/path" fileID:fileID];
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/%@/content", [BOXContentClient APIBaseURL], fileID]];
    
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
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/%@/content?version=%@", [BOXContentClient APIBaseURL], fileID, versionID]];
    
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

    [[NSFileManager defaultManager] removeItemAtURL:localFileURL error:nil];
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
    BOXAPIQueueManager *queueManager = request.queueManager;
    id queueManagerMock = [OCMockObject partialMockForObject:queueManager];
    id realObj = [[[queueManagerMock stub] andDo:^(NSInvocation *invocation) {
        numberOfOperationsEnqueued++;
    }] andForwardToRealObject];
    [realObj enqueueOperation:OCMOCK_ANY];
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

- (void)test_that_operation_is_not_marked_as_small_download
{
    BOXFileDownloadRequest *request = [[BOXFileDownloadRequest alloc] initWithLocalDestination:@"/dummy/path" fileID:@"123"];
    BOXAPIOperation *operation = [request operation];
    XCTAssert([operation isKindOfClass:[BOXAPIDataOperation class]]);
    BOXAPIDataOperation *dataOperation = (BOXAPIDataOperation *)operation;
    XCTAssert(dataOperation.isSmallDownloadOperation == NO);
}

#pragma mark - Error Handling

- (void)test_that_invalid_grant_400_error_triggers_logout_notification
{
    NSOutputStream *outputStream = [[NSOutputStream alloc] initToMemory];
    
    BOXFileDownloadRequest *request = [[BOXFileDownloadRequest alloc] initWithOutputStream:outputStream fileID:@"123"];
    
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"invalid_grant"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:400 responseData:cannedResponseData];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    [request performRequestWithProgress:nil completion:^(NSError *error) {
    }];
    
    [self expectationForNotification:BOXUserWasLoggedOutDueToErrorNotification object:nil handler:nil];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)test_that_unauthorized_401_error_triggers_logout_notification
{
    NSOutputStream *outputStream = [[NSOutputStream alloc] initToMemory];
    
    BOXFileDownloadRequest *request = [[BOXFileDownloadRequest alloc] initWithOutputStream:outputStream fileID:@"123"];
    
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:401 responseData:nil];
    [self setCannedURLResponse:URLResponse cannedResponseData:nil forRequest:request];
    
    [request performRequestWithProgress:nil completion:^(NSError *error) {
    }];
    
    [self expectationForNotification:BOXUserWasLoggedOutDueToErrorNotification object:nil handler:nil];
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
