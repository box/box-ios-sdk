//
//  BOXFileRepresentationDownloadRequestTests.m
//  BoxContentSDK
//
//  Created by Clement Rousselle on 3/2/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXFileRepresentationDownloadRequest.h"
#import "BOXRepresentation.h"
#import "BOXRequest_Private.h"
#import "BOXHashHelper.h"

@interface BOXFileRepresentationDownloadRequestTests : BOXRequestTestCase

@end

@implementation BOXFileRepresentationDownloadRequestTests

- (BOXRepresentation *)testRepresentation
{
    BOXRepresentation *representation = [BOXRepresentation new];
    representation.contentURL = [NSURL URLWithString:@"https://dl.boxcloud.com/api/2.0/internal_files/16258422097/versions/13500827125/representations/jpg_2048x2048/content/"];
    return representation;
}

- (void)test_shared_link_properties
{
    NSString *fileID = @"123";
    BOXRepresentation *rep = [self testRepresentation];
    BOXFileRepresentationDownloadRequest *request = [[BOXFileRepresentationDownloadRequest alloc] initWithLocalDestination:@"/dummy/path" fileID:fileID representation:rep];
    
    XCTAssertEqualObjects([request itemIDForSharedLink], fileID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeFile);
}

- (void)test_that_download_to_path_request_returns_expected_download_data
{
    NSString *fileID = @"123";
    NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *localFileURL = [temporaryDirectoryURL URLByAppendingPathComponent:@"dummyDownloadFile"];
    NSString *localFilePath = [localFileURL path];
    [[NSFileManager defaultManager] removeItemAtPath:localFilePath error:nil];
    
    BOXRepresentation *rep = [self testRepresentation];
    BOXFileRepresentationDownloadRequest *request = [[BOXFileRepresentationDownloadRequest alloc] initWithLocalDestination:localFilePath fileID:fileID representation:rep];
    
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

- (void)test_that_download_to_path_request_returns_expected_download_data_and_verifies_hash
{
    NSString *fileID = @"123";
    NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *localFileURL = [temporaryDirectoryURL URLByAppendingPathComponent:@"dummyDownloadFile"];
    NSString *localFilePath = [localFileURL path];
    [[NSFileManager defaultManager] removeItemAtPath:localFilePath error:nil];
    
    BOXRepresentation *rep = [self testRepresentation];
    BOXFileRepresentationDownloadRequest *request = [[BOXFileRepresentationDownloadRequest alloc] initWithLocalDestination:localFilePath fileID:fileID representation:rep];
    
    NSData *cannedResponseData = [self randomDataWithLength:4096];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    request.sha1Hash = [BOXHashHelper sha1HashOfData:cannedResponseData];
    [request performRequestWithProgress:nil completion:^(NSError *error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    
    NSData *data = [NSData dataWithContentsOfFile:localFilePath];
    XCTAssertEqualObjects(cannedResponseData, data);
    
    [[NSFileManager defaultManager] removeItemAtURL:localFileURL error:nil];
}

- (void)test_that_operation_is_not_marked_as_small_download
{
    NSString *fileID = @"123";
    BOXRepresentation *rep = [self testRepresentation];
    BOXFileRepresentationDownloadRequest *request = [[BOXFileRepresentationDownloadRequest alloc] initWithLocalDestination:@"/dummy/path" fileID:fileID representation:rep];
    
    BOXAPIOperation *operation = [request operation];
    XCTAssert([operation isKindOfClass:[BOXAPIDataOperation class]]);
    BOXAPIDataOperation *dataOperation = (BOXAPIDataOperation *)operation;
    XCTAssert(dataOperation.isSmallDownloadOperation == NO);
}

#pragma mark - Error Handling

- (void)test_that_download_data_integrity_check_triggers_error
{
    NSString *fileID = @"123";
    NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *localFileURL = [temporaryDirectoryURL URLByAppendingPathComponent:@"dummyDownloadFile"];
    NSString *localFilePath = [localFileURL path];
    [[NSFileManager defaultManager] removeItemAtPath:localFilePath error:nil];
    
    BOXRepresentation *rep = [self testRepresentation];
    BOXFileRepresentationDownloadRequest *request = [[BOXFileRepresentationDownloadRequest alloc] initWithLocalDestination:localFilePath fileID:fileID representation:rep];
    
    NSData *cannedResponseData = [self randomDataWithLength:4096];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    request.sha1Hash = @"Some Incorrect Sha1";
    [request performRequestWithProgress:nil completion:^(NSError *error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    
    [[NSFileManager defaultManager] removeItemAtURL:localFileURL error:nil];
}

- (void)test_that_invalid_grant_400_error_triggers_logout_notification
{
    NSString *fileID = @"123";
    BOXRepresentation *rep = [self testRepresentation];
    BOXFileRepresentationDownloadRequest *request = [[BOXFileRepresentationDownloadRequest alloc] initWithLocalDestination:@"/dummy/path" fileID:fileID representation:rep];
    
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
    NSString *fileID = @"123";
    BOXRepresentation *rep = [self testRepresentation];
    BOXFileRepresentationDownloadRequest *request = [[BOXFileRepresentationDownloadRequest alloc] initWithLocalDestination:@"/dummy/path" fileID:fileID representation:rep];
    
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
