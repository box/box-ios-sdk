//
//  BOXFileUploadNewVersionRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/18/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXFileUploadNewVersionRequest.h"
#import "BOXRequest_Private.h"
#import "BOXAPIMultipartToJSONOperation.h"
#import "BOXFile.h"

@interface BOXAPIMultipartToJSONOperation ()
// An array of BOXAPIMultipartPiece. In our tests, we want to inspect these.
@property (nonatomic, readwrite, strong) NSMutableArray *formPieces;
@end

@interface BOXFileUploadNewVersionRequestTests : BOXRequestTestCase
@end

@implementation BOXFileUploadNewVersionRequestTests

#pragma mark - NSURLRequest

- (void)test_shared_link_properties
{
    NSString *fileID = @"123";
    BOXFileUploadNewVersionRequest *request = [[BOXFileUploadNewVersionRequest alloc] initWithFileID:fileID localPath:nil];
    
    XCTAssertEqualObjects([request itemIDForSharedLink], fileID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeFile);    
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
    
    NSString *fileID = @"123";
    NSString *localFilePath = [localFileURL path];
    
    BOXFileUploadNewVersionRequest *request = [[BOXFileUploadNewVersionRequest alloc] initWithFileID:fileID localPath:localFilePath];
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/files/%@/content", BOXAPIUploadBaseURL, BOXAPIUploadAPIVersion, fileID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"POST", URLRequest.HTTPMethod);
    
    // Multi part form body
    XCTAssertTrue([request.operation isKindOfClass:[BOXAPIMultipartToJSONOperation class]]);
    BOXAPIMultipartToJSONOperation *operation = (BOXAPIMultipartToJSONOperation *)request.operation;
    
    XCTAssertEqual(1, operation.formPieces.count);
    
    for (BOXAPIMultipartPiece *formPiece in operation.formPieces)
    {
        NSString *contentDisposition = formPiece.headers[@"Content-Disposition"];
        NSString *bodyDataString = [self stringFromInputStream:formPiece.bodyInputStream];
        
        if ([contentDisposition isEqualToString:[NSString stringWithFormat:@"form-data; name=\"file\"; filename=\"\""]]) {
            XCTAssertEqualObjects(uploadData, bodyDataString);
        }
        else {
            XCTFail(@"Unexpected multipart form piece encountered: %@", formPiece);
        }
    }
    
    // HTTP Headers
    [request.operation prepareAPIRequest]; // BOXAPIMultipartToJSONOperation does not populate headers until prepareAPIRequest
    unsigned long long expectedContentLength = 0;
    for (BOXAPIMultipartPiece *formPiece in operation.formPieces)
    {
        expectedContentLength += formPiece.contentLength;
    }
    NSString *expectedContentLengthString = [NSString stringWithFormat:@"%llu", expectedContentLength];
    XCTAssertEqualObjects(expectedContentLengthString, URLRequest.allHTTPHeaderFields[@"Content-Length"]);
    XCTAssertEqualObjects(@"multipart/form-data; boundary=0xBoXSdKMulTiPaRtFoRmBoUnDaRy", URLRequest.allHTTPHeaderFields[@"Content-Type"]);
}

- (void)test_that_upload_from_local_file_with_matching_etag_has_expected_URLRequest
{
    NSString *localFileName = @"tempFile.txt";
    NSString *uploadData = @"hello";
    NSString *matchingEtag = @"fiesfiusen563";
    
    NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *localFileURL = [temporaryDirectoryURL URLByAppendingPathComponent:localFileName];
    NSError *writeError = nil;
    [uploadData writeToURL:localFileURL atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
    XCTAssertNil(writeError);
    
    NSString *fileID = @"123";
    NSString *localFilePath = [localFileURL path];
    
    BOXFileUploadNewVersionRequest *request = [[BOXFileUploadNewVersionRequest alloc] initWithFileID:fileID localPath:localFilePath];
    request.matchingEtag = matchingEtag;
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/files/%@/content", BOXAPIUploadBaseURL, BOXAPIUploadAPIVersion, fileID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"POST", URLRequest.HTTPMethod);
    
    // Multi part form body
    XCTAssertTrue([request.operation isKindOfClass:[BOXAPIMultipartToJSONOperation class]]);
    BOXAPIMultipartToJSONOperation *operation = (BOXAPIMultipartToJSONOperation *)request.operation;
    
    XCTAssertEqual(1, operation.formPieces.count);
    
    for (BOXAPIMultipartPiece *formPiece in operation.formPieces)
    {
        NSString *contentDisposition = formPiece.headers[@"Content-Disposition"];
        NSString *bodyDataString = [self stringFromInputStream:formPiece.bodyInputStream];
        
        if ([contentDisposition isEqualToString:@"form-data; name=\"file\"; filename=\"\""]) {
            XCTAssertEqualObjects(uploadData, bodyDataString);
        }
        else {
            XCTFail(@"Unexpected multipart form piece encountered: %@", formPiece);
        }
    }
    
    // HTTP Headers
    [request.operation prepareAPIRequest]; // BOXAPIMultipartToJSONOperation does not populate headers until prepareAPIRequest
    unsigned long long expectedContentLength = 0;
    for (BOXAPIMultipartPiece *formPiece in operation.formPieces)
    {
        expectedContentLength += formPiece.contentLength;
    }
    NSString *expectedContentLengthString = [NSString stringWithFormat:@"%llu", expectedContentLength];
    XCTAssertEqualObjects(expectedContentLengthString, URLRequest.allHTTPHeaderFields[@"Content-Length"]);
    XCTAssertEqualObjects(@"multipart/form-data; boundary=0xBoXSdKMulTiPaRtFoRmBoUnDaRy", URLRequest.allHTTPHeaderFields[@"Content-Type"]);
    XCTAssertEqualObjects(matchingEtag, URLRequest.allHTTPHeaderFields[@"If-Match"]);
}

- (void)test_that_upload_from_data_has_expected_URLRequest
{
    NSString *uploadData = @"hello";
    NSString *fileID = @"123";
    
    BOXFileUploadNewVersionRequest *request = [[BOXFileUploadNewVersionRequest alloc] initWithFileID:fileID data:[uploadData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/files/%@/content", BOXAPIUploadBaseURL, BOXAPIUploadAPIVersion, fileID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"POST", URLRequest.HTTPMethod);
    
    // Multi part form body
    XCTAssertTrue([request.operation isKindOfClass:[BOXAPIMultipartToJSONOperation class]]);
    BOXAPIMultipartToJSONOperation *operation = (BOXAPIMultipartToJSONOperation *)request.operation;
    
    XCTAssertEqual(1, operation.formPieces.count);
    
    for (BOXAPIMultipartPiece *formPiece in operation.formPieces)
    {
        NSString *contentDisposition = formPiece.headers[@"Content-Disposition"];
        NSString *bodyDataString = [self stringFromInputStream:formPiece.bodyInputStream];
        
        if ([contentDisposition isEqualToString:[NSString stringWithFormat:@"form-data; name=\"file\"; filename=\"\""]]) {
            XCTAssertEqualObjects(uploadData, bodyDataString);
        }
        else {
            XCTFail(@"Unexpected multipart form piece encountered: %@", formPiece);
        }
    }
    
    // HTTP Headers
    [request.operation prepareAPIRequest]; // BOXAPIMultipartToJSONOperation does not populate headers until prepareAPIRequest
    unsigned long long expectedContentLength = 0;
    for (BOXAPIMultipartPiece *formPiece in operation.formPieces)
    {
        expectedContentLength += formPiece.contentLength;
    }
    NSString *expectedContentLengthString = [NSString stringWithFormat:@"%llu", expectedContentLength];
    XCTAssertEqualObjects(expectedContentLengthString, URLRequest.allHTTPHeaderFields[@"Content-Length"]);
    XCTAssertEqualObjects(@"multipart/form-data; boundary=0xBoXSdKMulTiPaRtFoRmBoUnDaRy", URLRequest.allHTTPHeaderFields[@"Content-Type"]);
}

- (void)test_that_upload_from_data_with_content_dates_and_matching_etag_has_expected_URLRequest
{
    NSString *uploadData = @"hello";
    NSString *fileID = @"123";
    NSString *matchingEtag = @"uicns46563";
    
    BOXFileUploadNewVersionRequest *request = [[BOXFileUploadNewVersionRequest alloc] initWithFileID:fileID data:[uploadData dataUsingEncoding:NSUTF8StringEncoding]];
    request.matchingEtag = matchingEtag;
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/files/%@/content", BOXAPIUploadBaseURL, BOXAPIUploadAPIVersion, fileID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"POST", URLRequest.HTTPMethod);
    
    // Multi part form body
    XCTAssertTrue([request.operation isKindOfClass:[BOXAPIMultipartToJSONOperation class]]);
    BOXAPIMultipartToJSONOperation *operation = (BOXAPIMultipartToJSONOperation *)request.operation;
    
    XCTAssertEqual(1, operation.formPieces.count);
    
    for (BOXAPIMultipartPiece *formPiece in operation.formPieces)
    {
        NSString *contentDisposition = formPiece.headers[@"Content-Disposition"];
        NSString *bodyDataString = [self stringFromInputStream:formPiece.bodyInputStream];
        
        if ([contentDisposition isEqualToString:@"form-data; name=\"file\"; filename=\"\""]) {
            XCTAssertEqualObjects(uploadData, bodyDataString);
        }
        else {
            XCTFail(@"Unexpected multipart form piece encountered: %@", formPiece);
        }
    }
    
    // HTTP Headers
    [request.operation prepareAPIRequest]; // BOXAPIMultipartToJSONOperation does not populate headers until prepareAPIRequest
    unsigned long long expectedContentLength = 0;
    for (BOXAPIMultipartPiece *formPiece in operation.formPieces)
    {
        expectedContentLength += formPiece.contentLength;
    }
    NSString *expectedContentLengthString = [NSString stringWithFormat:@"%llu", expectedContentLength];
    XCTAssertEqualObjects(expectedContentLengthString, URLRequest.allHTTPHeaderFields[@"Content-Length"]);
    XCTAssertEqualObjects(@"multipart/form-data; boundary=0xBoXSdKMulTiPaRtFoRmBoUnDaRy", URLRequest.allHTTPHeaderFields[@"Content-Type"]);
    XCTAssertEqualObjects(matchingEtag, URLRequest.allHTTPHeaderFields[@"If-Match"]);
}

#pragma mark - Completion and Progress Blocks

- (void)test_that_upload_from_local_file_calls_completion_and_progress_blocks
{
    NSString *localFileName = @"tempFile.txt";
    NSString *uploadData = @"hello";
    
    NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *localFileURL = [temporaryDirectoryURL URLByAppendingPathComponent:localFileName];
    NSError *writeError = nil;
    [uploadData writeToURL:localFileURL atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
    XCTAssertNil(writeError);
    
    NSString *fileID = @"123";
    NSString *localFilePath = [localFileURL path];
    
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"file_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    
    // Expected BoxFile response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXFile *expectedFile = [[BOXFile alloc] initWithJSON:jsonDictionary];
    
    BOXFileUploadNewVersionRequest *request = [[BOXFileUploadNewVersionRequest alloc] initWithFileID:fileID localPath:localFilePath];
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
    NSString *uploadData = @"hello";
    NSString *fileID = @"123";
    
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"file_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    
    // Expected BoxFile response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXFile *expectedFile = [[BOXFile alloc] initWithJSON:jsonDictionary];
    
    BOXFileUploadNewVersionRequest *request = [[BOXFileUploadNewVersionRequest alloc] initWithFileID:fileID data:[uploadData dataUsingEncoding:NSUTF8StringEncoding]];
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
    
    NSString *fileID = @"123";
    NSString *localFilePath = [localFileURL path];
    
    BOXFileUploadNewVersionRequest *request = [[BOXFileUploadNewVersionRequest alloc] initWithFileID:fileID localPath:localFilePath];
    
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"file_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    BOXCannedResponse *cannedResponse = [[BOXCannedResponse alloc] initWithURLResponse:URLResponse responseData:cannedResponseData];
    
    // Examine HTTPBodyStream that was posted.
    __weak BOXFileUploadNewVersionRequestTests *me = self;
    XCTestExpectation *bodyExpectation = [self expectationWithDescription:@"expectation"];
    cannedResponse.httpBodyDataBlock = ^void(NSData *bodyData)
    {
        NSArray *multiPartPieces = [me sortedMultiPartPiecesFromBodyData:bodyData];
        NSArray *expectedPieces = @[[NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"file\"; filename=\"\"\r\n\r\n%@\r\n", uploadData]];
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

- (void)test_that_upload_from_data_posts_expected_data
{
    NSString *uploadData = @"hello";
    NSString *fileID = @"123";
    
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"file_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    BOXCannedResponse *cannedResponse = [[BOXCannedResponse alloc] initWithURLResponse:URLResponse responseData:cannedResponseData];
    
    BOXFileUploadNewVersionRequest *request = [[BOXFileUploadNewVersionRequest alloc] initWithFileID:fileID data:[uploadData dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Examine HTTPBodyStream that was posted.
    __weak BOXFileUploadNewVersionRequestTests *me = self;
    XCTestExpectation *bodyExpectation = [self expectationWithDescription:@"expectation"];
    cannedResponse.httpBodyDataBlock = ^void(NSData *bodyData)
    {
        NSArray *multiPartPieces = [me sortedMultiPartPiecesFromBodyData:bodyData];
        NSArray *expectedPieces = @[[NSString stringWithFormat:@"\r\nContent-Disposition: form-data; name=\"file\"; filename=\"\"\r\n\r\n%@\r\n", uploadData]];
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

@end
