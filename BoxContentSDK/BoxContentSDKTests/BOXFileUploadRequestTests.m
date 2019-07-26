//
//  BOXFileUploadRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/17/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXRequest_Private.h"
#import "BOXContentClient.h"
#import "BOXFileUploadRequest.h"
#import "BOXAPIMultipartToJSONOperation.h"
#import "BOXFile.h"
#import "BOXHashHelper.h"

@interface BOXAPIMultipartToJSONOperation ()
// An array of BOXAPIMultipartPiece. In our tests, we want to inspect these.
@property (nonatomic, readwrite, strong) NSMutableArray *formPieces;
@end

@interface BOXFileUploadRequestTests : BOXRequestTestCase
@end

@implementation BOXFileUploadRequestTests

#pragma mark - NSURLRequest

- (void)test_shared_link_properties
{
    NSString *targetFolderID = @"123";
    BOXFileUploadRequest *request = [[BOXFileUploadRequest alloc] initWithPath:nil targetFolderID:targetFolderID];
    
    XCTAssertEqualObjects([request itemIDForSharedLink], targetFolderID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeFolder);    
}

- (void)test_that_upload_from_local_file_has_expected_URLRequest
{
    NSString *localFileName = @"tempFile.txt";
    NSString *uploadData = @"hello";
    
    NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *localFileURL = [temporaryDirectoryURL URLByAppendingPathComponent:localFileName];
    NSError *writeError = nil;
    [uploadData writeToURL:localFileURL atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
    XCTAssertNil(writeError);
    
    NSString *targetFolderID = @"123";
    NSString *localFilePath = [localFileURL path];
    
    BOXFileUploadRequest *request = [[BOXFileUploadRequest alloc] initWithPath:localFilePath targetFolderID:targetFolderID];
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/content", [BOXContentClient APIUploadBaseURL]]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"POST", URLRequest.HTTPMethod);
    
    // Multi part form body
    XCTAssertTrue([request.operation isKindOfClass:[BOXAPIMultipartToJSONOperation class]]);
    BOXAPIMultipartToJSONOperation *operation = (BOXAPIMultipartToJSONOperation *)request.operation;

    // HTTP Headers
    [request.operation prepareAPIRequest]; // BOXAPIMultipartToJSONOperation does not populate headers until prepareAPIRequest

    NSArray *expectedPieces = @[[NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n\r\n%@\r\n", localFileName, uploadData],
                                [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"name\"\r\n\r\n%@\r\n", localFileName],
                                [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"parent_id\"\r\n\r\n%@\r\n", targetFolderID]
                                ];
    NSString *bodyDataString = [self stringFromInputStream:operation.APIRequest.HTTPBodyStream];
    NSArray *actualPieces = [self sortedMultiPartPiecesFromBodyDataString:bodyDataString];

    XCTAssertEqualObjects(expectedPieces, actualPieces);

    unsigned long long expectedContentLength = operation.contentLength;
    NSString *expectedContentLengthString = [NSString stringWithFormat:@"%llu", expectedContentLength];
    XCTAssertEqualObjects(expectedContentLengthString, URLRequest.allHTTPHeaderFields[@"Content-Length"]);

    NSString *expectedContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOXAPIMultipartFormBoundary];
    XCTAssertTrue([expectedContentType isEqualToString:URLRequest.allHTTPHeaderFields[@"Content-Type"]]);

    [[NSFileManager defaultManager] removeItemAtURL:localFileURL error:nil];
}

- (void)test_that_upload_from_local_file_with_content_dates_and_corruption_check_has_expected_URLRequest
{
    NSString *localFileName = @"tempFile.txt";
    NSString *fileNameOnServer = @"tempFile2.txt";
    NSDate *contentCreatedAtDateOnServer = [NSDate dateWithTimeIntervalSinceNow:-100];
    NSDate *contentModifiedAtDateOnServer = [NSDate dateWithTimeIntervalSinceNow:-200];
    NSString *uploadData = @"hello";
    
    NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *localFileURL = [temporaryDirectoryURL URLByAppendingPathComponent:localFileName];
    NSError *writeError = nil;
    [uploadData writeToURL:localFileURL atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
    XCTAssertNil(writeError);
    
    NSString *targetFolderID = @"123";
    NSString *localFilePath = [localFileURL path];
    
    BOXFileUploadRequest *request = [[BOXFileUploadRequest alloc] initWithPath:localFilePath targetFolderID:targetFolderID];
    request.fileName = fileNameOnServer;
    request.contentCreatedAt = contentCreatedAtDateOnServer;
    request.contentModifiedAt = contentModifiedAtDateOnServer;
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/content", [BOXContentClient APIUploadBaseURL]]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"POST", URLRequest.HTTPMethod);
    
    // Multi part form body
    XCTAssertTrue([request.operation isKindOfClass:[BOXAPIMultipartToJSONOperation class]]);
    BOXAPIMultipartToJSONOperation *operation = (BOXAPIMultipartToJSONOperation *)request.operation;

    // HTTP Headers
    [request.operation prepareAPIRequest]; // BOXAPIMultipartToJSONOperation does not populate headers until prepareAPIRequest

    NSArray *expectedPieces = @[[NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"content_created_at\"\r\n\r\n%@\r\n", [contentCreatedAtDateOnServer box_ISO8601String]],
                                [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"content_modified_at\"\r\n\r\n%@\r\n", [contentModifiedAtDateOnServer box_ISO8601String]],
                                [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n\r\n%@\r\n", fileNameOnServer, uploadData],
                                [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"name\"\r\n\r\n%@\r\n", fileNameOnServer],
                                [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"parent_id\"\r\n\r\n%@\r\n", targetFolderID]
                                ];
    NSString *bodyDataString = [self stringFromInputStream:operation.APIRequest.HTTPBodyStream];
    NSArray *actualPieces = [self sortedMultiPartPiecesFromBodyDataString:bodyDataString];

    XCTAssertEqualObjects(expectedPieces, actualPieces);

    unsigned long long expectedContentLength = operation.contentLength;
    NSString *expectedContentLengthString = [NSString stringWithFormat:@"%llu", expectedContentLength];
    XCTAssertEqualObjects(expectedContentLengthString, URLRequest.allHTTPHeaderFields[@"Content-Length"]);

    NSString *expectedContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOXAPIMultipartFormBoundary];
    XCTAssertTrue([expectedContentType isEqualToString:URLRequest.allHTTPHeaderFields[@"Content-Type"]]);

    XCTAssertEqualObjects([BOXHashHelper sha1HashOfFileAtPath:[localFileURL path]], URLRequest.allHTTPHeaderFields[@"Content-MD5"]);

    [[NSFileManager defaultManager] removeItemAtURL:localFileURL error:nil];
}

- (void)test_that_upload_from_data_has_expected_URLRequest
{
    NSString *fileNameOnServer = @"tempFile.txt";
    NSString *uploadData = @"hello";
    NSString *targetFolderID = @"123";
    
    BOXFileUploadRequest *request = [[BOXFileUploadRequest alloc] initWithName:fileNameOnServer targetFolderID:targetFolderID data:[uploadData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/content", [BOXContentClient APIUploadBaseURL]]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"POST", URLRequest.HTTPMethod);
    
    // Multi part form body
    XCTAssertTrue([request.operation isKindOfClass:[BOXAPIMultipartToJSONOperation class]]);
    BOXAPIMultipartToJSONOperation *operation = (BOXAPIMultipartToJSONOperation *)request.operation;
    
    // HTTP Headers
    [request.operation prepareAPIRequest]; // BOXAPIMultipartToJSONOperation does not populate headers until prepareAPIRequest

    NSArray *expectedPieces = @[[NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n\r\n%@\r\n", fileNameOnServer, uploadData],
                                [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"name\"\r\n\r\n%@\r\n", fileNameOnServer],
                                [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"parent_id\"\r\n\r\n%@\r\n", targetFolderID]
                                ];
    NSString *bodyDataString = [self stringFromInputStream:operation.APIRequest.HTTPBodyStream];
    NSArray *actualPieces = [self sortedMultiPartPiecesFromBodyDataString:bodyDataString];

    XCTAssertEqualObjects(expectedPieces, actualPieces);

    unsigned long long expectedContentLength = operation.contentLength;
    NSString *expectedContentLengthString = [NSString stringWithFormat:@"%llu", expectedContentLength];
    XCTAssertEqualObjects(expectedContentLengthString, URLRequest.allHTTPHeaderFields[@"Content-Length"]);

    NSString *expectedContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOXAPIMultipartFormBoundary];
    XCTAssertTrue([expectedContentType isEqualToString:URLRequest.allHTTPHeaderFields[@"Content-Type"]]);
}

- (void)test_that_upload_from_data_with_content_dates_and_corruption_check_has_expected_URLRequest
{
    NSString *fileNameOnServer = @"tempFile.txt";
    NSDate *contentCreatedAtDateOnServer = [NSDate dateWithTimeIntervalSinceNow:-100];
    NSDate *contentModifiedAtDateOnServer = [NSDate dateWithTimeIntervalSinceNow:-200];
    NSString *uploadData = @"hello";
    NSString *targetFolderID = @"123";
    
    BOXFileUploadRequest *request = [[BOXFileUploadRequest alloc] initWithName:fileNameOnServer targetFolderID:targetFolderID data:[uploadData dataUsingEncoding:NSUTF8StringEncoding]];
    request.fileName = fileNameOnServer;
    request.contentCreatedAt = contentCreatedAtDateOnServer;
    request.contentModifiedAt = contentModifiedAtDateOnServer;
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/content", [BOXContentClient APIUploadBaseURL]]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"POST", URLRequest.HTTPMethod);
    
    // Multi part form body
    XCTAssertTrue([request.operation isKindOfClass:[BOXAPIMultipartToJSONOperation class]]);
    BOXAPIMultipartToJSONOperation *operation = (BOXAPIMultipartToJSONOperation *)request.operation;
    
    // HTTP Headers
    [request.operation prepareAPIRequest]; // BOXAPIMultipartToJSONOperation does not populate headers until prepareAPIRequest

    NSArray *expectedPieces = @[[NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"content_created_at\"\r\n\r\n%@\r\n", [contentCreatedAtDateOnServer box_ISO8601String]],
                                [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"content_modified_at\"\r\n\r\n%@\r\n", [contentModifiedAtDateOnServer box_ISO8601String]],
                                [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n\r\n%@\r\n", fileNameOnServer, uploadData],
                                [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"name\"\r\n\r\n%@\r\n", fileNameOnServer],
                                [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"parent_id\"\r\n\r\n%@\r\n", targetFolderID]
                                ];
    NSString *bodyDataString = [self stringFromInputStream:operation.APIRequest.HTTPBodyStream];
    NSArray *actualPieces = [self sortedMultiPartPiecesFromBodyDataString:bodyDataString];

    XCTAssertEqualObjects(expectedPieces, actualPieces);

    unsigned long long expectedContentLength = operation.contentLength;
    NSString *expectedContentLengthString = [NSString stringWithFormat:@"%llu", expectedContentLength];
    XCTAssertEqualObjects(expectedContentLengthString, URLRequest.allHTTPHeaderFields[@"Content-Length"]);

    NSString *expectedContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOXAPIMultipartFormBoundary];
    XCTAssertTrue([expectedContentType isEqualToString:URLRequest.allHTTPHeaderFields[@"Content-Type"]]);

    XCTAssertEqualObjects([BOXHashHelper sha1HashOfData:[uploadData dataUsingEncoding:NSUTF8StringEncoding]], URLRequest.allHTTPHeaderFields[@"Content-MD5"]);
}

#pragma mark - Completion and Progress Blocks
/*
// NOTE: NSURLProtocol has known limitations which won't call NSURLSessionTaskDelegate's method
// URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend
// to allow us to validate progress block being called
// Uncomment the following 2 tests if limitations are lifted

- (void)test_that_upload_from_local_file_calls_completion_and_progress_blocks
{
    NSString *localFileName = @"tempFile.txt";
    NSString *uploadData = @"hello";
    
    NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *localFileURL = [temporaryDirectoryURL URLByAppendingPathComponent:localFileName];
    NSError *writeError = nil;
    [uploadData writeToURL:localFileURL atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
    XCTAssertNil(writeError);
    
    NSString *targetFolderID = @"123";
    NSString *localFilePath = [localFileURL path];
    
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"file_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    
    // Expected BoxFile response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXFile *expectedFile = [[BOXFile alloc] initWithJSON:jsonDictionary];
    
    BOXFileUploadRequest *request = [[BOXFileUploadRequest alloc] initWithPath:localFilePath targetFolderID:targetFolderID];
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
        
    } completion:^(BOXFile *file, NSError *error) {
        [self assertModel:file isEquivalentTo:expectedFile];
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    
    // Intermediate progress should be called at least once, and final should be called exactly once.
    XCTAssertGreaterThan(intermediateProgressBlockCalls,  0);
    XCTAssertEqual(1, finalProgressBlockCalls);
}

- (void)test_that_upload_from_data_calls_completion_and_progress_blocks
{
    NSString *fileNameOnServer = @"tempFile.txt";
    NSDate *contentCreatedAtDateOnServer = [NSDate dateWithTimeIntervalSinceNow:-100];
    NSDate *contentModifiedAtDateOnServer = [NSDate dateWithTimeIntervalSinceNow:-200];
    NSString *uploadData = @"hello";
    NSString *targetFolderID = @"123";
    
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"file_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    
    // Expected BoxFile response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXFile *expectedFile = [[BOXFile alloc] initWithJSON:jsonDictionary];
    
    BOXFileUploadRequest *request = [[BOXFileUploadRequest alloc] initWithName:fileNameOnServer targetFolderID:targetFolderID data:[uploadData dataUsingEncoding:NSUTF8StringEncoding]];
    request.fileName = fileNameOnServer;
    request.contentCreatedAt = contentCreatedAtDateOnServer;
    request.contentModifiedAt = contentModifiedAtDateOnServer;
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
        
    } completion:^(BOXFile *file, NSError *error) {
        [self assertModel:file isEquivalentTo:expectedFile];
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    
    // Intermediate progress should be called at least once, and final should be called exactly once.
    XCTAssertGreaterThan(intermediateProgressBlockCalls,  0);
    XCTAssertEqual(1, finalProgressBlockCalls);
}
*/

#pragma mark - Post Data

- (void)test_that_upload_from_local_file_posts_expected_data
{
    NSString *localFileName = @"tempFile.txt";
    NSString *uploadData = @"hello";
    
    NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *localFileURL = [temporaryDirectoryURL URLByAppendingPathComponent:localFileName];
    NSError *writeError = nil;
    [uploadData writeToURL:localFileURL atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
    XCTAssertNil(writeError);
    
    NSString *targetFolderID = @"123";
    NSString *localFilePath = [localFileURL path];
    
    BOXFileUploadRequest *request = [[BOXFileUploadRequest alloc] initWithPath:localFilePath targetFolderID:targetFolderID];
    
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"file_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    BOXCannedResponse *cannedResponse = [[BOXCannedResponse alloc] initWithURLResponse:URLResponse responseData:cannedResponseData];
    
    // Examine HTTPBodyStream that was posted.
    __weak BOXFileUploadRequestTests *me = self;
    XCTestExpectation *bodyExpectation = [self expectationWithDescription:@"expectation"];
    cannedResponse.httpBodyDataBlock = ^void(NSData *bodyData)
    {
        NSArray *multiPartPieces = [me sortedMultiPartPiecesFromBodyData:bodyData];
        NSArray *expectedPieces = @[[NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n\r\n%@\r\n", localFileName, uploadData],
                                    [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"name\"\r\n\r\n%@\r\n", localFileName],
                                    [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"parent_id\"\r\n\r\n%@\r\n", targetFolderID]
                                    ];
        XCTAssertEqualObjects(expectedPieces, multiPartPieces);
        [bodyExpectation fulfill];
    };
    [self setCannedResponse:cannedResponse forRequest:request];
    
    // We have to delay completion of test until request is finished or it can interfere with other tests.
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithProgress:nil completion:^(BOXFile *file, NSError *error) {
        [requestExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    [[NSFileManager defaultManager] removeItemAtURL:localFileURL error:nil];
}

- (void)test_that_upload_from_data_posts_expected_data
{
    NSString *fileNameOnServer = @"tempFile.txt";
    NSDate *contentCreatedAtDateOnServer = [NSDate dateWithTimeIntervalSinceNow:-100];
    NSDate *contentModifiedAtDateOnServer = [NSDate dateWithTimeIntervalSinceNow:-200];
    NSString *uploadData = @"hello";
    NSString *targetFolderID = @"123";
    
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"file_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    BOXCannedResponse *cannedResponse = [[BOXCannedResponse alloc] initWithURLResponse:URLResponse responseData:cannedResponseData];
    
    BOXFileUploadRequest *request = [[BOXFileUploadRequest alloc] initWithName:fileNameOnServer targetFolderID:targetFolderID data:[uploadData dataUsingEncoding:NSUTF8StringEncoding]];
    request.fileName = fileNameOnServer;
    request.contentCreatedAt = contentCreatedAtDateOnServer;
    request.contentModifiedAt = contentModifiedAtDateOnServer;
    
    // Examine HTTPBodyStream that was posted.
    __weak BOXFileUploadRequestTests *me = self;
    XCTestExpectation *bodyExpectation = [self expectationWithDescription:@"expectation"];
    cannedResponse.httpBodyDataBlock = ^void(NSData *bodyData)
    {
        NSArray *multiPartPieces = [me sortedMultiPartPiecesFromBodyData:bodyData];
        NSArray *expectedPieces = @[[NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"content_created_at\"\r\n\r\n%@\r\n", [contentCreatedAtDateOnServer box_ISO8601String]],
                                    [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"content_modified_at\"\r\n\r\n%@\r\n", [contentModifiedAtDateOnServer box_ISO8601String]],
                                    [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n\r\n%@\r\n", fileNameOnServer, uploadData],
                                    [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"name\"\r\n\r\n%@\r\n", fileNameOnServer],
                                    [NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"parent_id\"\r\n\r\n%@\r\n", targetFolderID]
                                    ];

        XCTAssertEqualObjects(expectedPieces, multiPartPieces);
        [bodyExpectation fulfill];
    };
    [self setCannedResponse:cannedResponse forRequest:request];
    
    // We have to delay completion of test until request is finished or it can interfere with other tests.
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithProgress:nil completion:^(BOXFile *file, NSError *error) {
        [requestExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

#pragma mark - Error Handling

- (void)test_that_invalid_grant_400_error_triggers_logout_notification
{
    NSString *fileNameOnServer = @"tempFile.txt";
    NSDate *contentCreatedAtDateOnServer = [NSDate dateWithTimeIntervalSinceNow:-100];
    NSDate *contentModifiedAtDateOnServer = [NSDate dateWithTimeIntervalSinceNow:-200];
    NSString *uploadData = @"hello";
    NSString *targetFolderID = @"123";
    
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"invalid_grant"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:400 responseData:cannedResponseData];
    
    BOXFileUploadRequest *request = [[BOXFileUploadRequest alloc] initWithName:fileNameOnServer targetFolderID:targetFolderID data:[uploadData dataUsingEncoding:NSUTF8StringEncoding]];
    request.fileName = fileNameOnServer;
    request.contentCreatedAt = contentCreatedAtDateOnServer;
    request.contentModifiedAt = contentModifiedAtDateOnServer;
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    // We have to delay completion of test until request is finished or it can interfere with other tests.
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithProgress:nil completion:^(BOXFile *file, NSError *error) {
        [requestExpectation fulfill];
    }];
    
    [self expectationForNotification:BOXUserWasLoggedOutDueToErrorNotification object:nil handler:nil];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)test_that_unauthorized_401_error_triggers_logout_notification
{
    NSString *fileNameOnServer = @"tempFile.txt";
    NSDate *contentCreatedAtDateOnServer = [NSDate dateWithTimeIntervalSinceNow:-100];
    NSDate *contentModifiedAtDateOnServer = [NSDate dateWithTimeIntervalSinceNow:-200];
    NSString *uploadData = @"hello";
    NSString *targetFolderID = @"123";
    
    // Canned response json.
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:401 responseData:nil];
    
    BOXFileUploadRequest *request = [[BOXFileUploadRequest alloc] initWithName:fileNameOnServer targetFolderID:targetFolderID data:[uploadData dataUsingEncoding:NSUTF8StringEncoding]];
    request.fileName = fileNameOnServer;
    request.contentCreatedAt = contentCreatedAtDateOnServer;
    request.contentModifiedAt = contentModifiedAtDateOnServer;
    [self setCannedURLResponse:URLResponse cannedResponseData:nil forRequest:request];
    
    // We have to delay completion of test until request is finished or it can interfere with other tests.
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithProgress:nil completion:^(BOXFile *file, NSError *error) {
        [requestExpectation fulfill];
    }];
    
    [self expectationForNotification:BOXUserWasLoggedOutDueToErrorNotification object:nil handler:nil];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
