//
//  BOXAPIMultipartToJSONOperation.m
//  BoxContentSDK
//
//  Created on 2/27/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXAPIMultipartToJSONOperation.h"
#import "BOXAPIOperation_Private.h"
#import "BOXContentSDKErrors.h"
#import "BOXLog.h"
#import "BOXAbstractSession.h"

//FIXME: These are duplicated with BOXContentSDKConstants.h
#define BOX_API_MULTIPART_CONTENT_TYPE        (@"Content-Type")
#define BOX_API_MULTIPART_CONTENT_LENGTH      (@"Content-Length")

#define BOX_API_OUTPUT_STREAM_BUFFER_SIZE     (32u << 10) // 32 KiB

#pragma mark - Form Boundary Helpers

static NSString *const BOXAPIMultipartFormBoundary = @"0xBoXSdKMulTiPaRtFoRmBoUnDaRy";

static NSString * BOXAPIMultipartContentTypeHeader(void)
{
    return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOXAPIMultipartFormBoundary];
}


#pragma mark - Upload Operation

@interface BOXAPIMultipartToJSONOperation () <BOXURLSessionUploadTaskDelegate>
{
    dispatch_once_t _pred;
}

@property (nonatomic, readwrite, strong) BOXMultipartBodyStream *inputStream;

- (NSDictionary *)HTTPHeaders;

// called on stream read error
- (void)abortWithError:(NSError *)error;

@end

@implementation BOXAPIMultipartToJSONOperation

#pragma mark - Append data to upload operation

- (void)appendMultipartPieceWithData:(NSData *)data fieldName:(NSString *)fieldName filename:(NSString *)filename MIMEType:(NSString *)MIMEType
{
    self.inputStream = [[BOXHTTPRequestSerializer serializer] multipartInputStreamWithParameters:self.body
                                                                                        boundary:BOXAPIMultipartFormBoundary
                                                                       constructingBodyWithBlock:^(id<BOXMultipartFormData> formData) {
                                                                           [formData appendPartWithFileData:data
                                                                                                       name:fieldName
                                                                                                   fileName:filename
                                                                                                   mimeType:MIMEType];
                                                                       }];
}

- (void)appendMultipartPieceWithInputStream:(NSInputStream *)inputStream contentLength:(unsigned long long)length fieldName:(NSString *)fieldName filename:(NSString *)filename MIMEType:(NSString *)MIMEType
{
    self.inputStream = [[BOXHTTPRequestSerializer serializer] multipartInputStreamWithParameters:self.body
                                                                                        boundary:BOXAPIMultipartFormBoundary
                                                                       constructingBodyWithBlock:^(id<BOXMultipartFormData> formData) {
                                                                           [formData appendPartWithInputStream:inputStream
                                                                                                          name:fieldName
                                                                                                      fileName:filename
                                                                                                        length:length
                                                                                                      mimeType:MIMEType];
                                                                       }];
}

- (void)appendMultipartPieceWithFilePath:(NSString *)filePath fieldName:(NSString *)fieldName filename:(NSString *)filename MIMEType:(NSString *)MIMEType
{
    self.inputStream = [[BOXHTTPRequestSerializer serializer] multipartInputStreamWithParameters:self.body
                                                                                        boundary:BOXAPIMultipartFormBoundary
                                                                       constructingBodyWithBlock:^(id<BOXMultipartFormData> formData) {
    
                                                                           [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath]
                                                                                                      name:fieldName
                                                                                                  fileName:filename
                                                                                                  mimeType:MIMEType
                                                                                                     error:nil];
                                                                       }];
}
#pragma mark -

- (BOOL)shouldUseSessionTask
{
    return YES;
}

- (BOOL)shouldRunInBackground
{
    return self.uploadMultipartCopyFilePath != nil;
}

- (NSURLSessionTask *)createSessionTask
{
    NSURLSessionTask *sessionTask;
    if (self.shouldRunInBackground == YES) {
        NSURL *url = [[NSURL alloc] initFileURLWithPath:self.uploadMultipartCopyFilePath];
        sessionTask = [self.session.urlSessionManager createBackgroundUploadTaskWithRequest:self.APIRequest fromFile:url taskDelegate:self];
    } else {
        sessionTask = [self.session.urlSessionManager createNonBackgroundUploadTaskWithStreamedRequest:self.APIRequest taskDelegate:self];
    }
    return sessionTask;
}

- (void)sessionTask:(NSURLSessionTask *)sessionTask
  didSendTotalBytes:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    if (self.progressBlock) {
        self.progressBlock(totalBytesExpectedToSend, totalBytesSent);
    }
}

- (void)processIntermediateData:(NSData *)data
{
    @synchronized (self) {
        if (data != nil) {
            [self processResponseData:data];
        }
    }
}

- (void)sessionTask:(NSURLSessionTask *)sessionTask didFinishWithResponse:(NSURLResponse *)response error:(NSError *)error
{
    @synchronized (self) {
        if (error == nil && self.error == nil && self.responseJSON == nil) {
            self.error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKJSONErrorDecodeFailed userInfo:nil];
        }
        [super sessionTask:sessionTask didFinishWithResponse:response error:error];
    }
}

- (void)prepareAPIRequest
{
    [super prepareAPIRequest];

    [self.APIRequest setAllHTTPHeaderFields:[self HTTPHeaders]];
    // Attach the body stream to the request. The input stream is expected to already
    // be configured via a call to one of the multipart stream preparation methods.
    [self.APIRequest setHTTPBodyStream:self.inputStream];

    //if provided uploadMultipartCopyFilePath, write the APIRequest's HTTPBodyStream into a multi-part formatted file
    //which is required for background upload
    if (self.shouldRunInBackground == YES) {
        NSURL *tempUploadFileURL = [[NSURL alloc] initFileURLWithPath:self.uploadMultipartCopyFilePath];
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        __weak BOXAPIMultipartToJSONOperation *weakSelf = self;

        self.APIRequest = [[BOXHTTPRequestSerializer serializer] requestWithMultipartFormRequest:self.APIRequest
                                                                     writingStreamContentsToFile:tempUploadFileURL
                                                                               completionHandler:^(NSError * error) {
                                                                                   if (error != nil) {
                                                                                       [weakSelf abortWithError:error];
                                                                                   }
                                                                                   dispatch_semaphore_signal(sema);
                                                                               }];

        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
}

// Override this method to turn it into a NO-OP. The multipart operation will attach itself
// to the request with a stream
- (NSData *)encodeBody:(NSDictionary *)bodyDictionary
{
    return nil;
}

#pragma mark - Multipart Stream methods

- (unsigned long long)contentLength
{
    return [self.inputStream contentLength];
}

- (NSDictionary *)HTTPHeaders
{
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    [headers setObject:BOXAPIMultipartContentTypeHeader() forKey:BOX_API_MULTIPART_CONTENT_TYPE];
    [headers setObject:[NSString stringWithFormat:@"%llu", [self contentLength]] forKey:BOX_API_MULTIPART_CONTENT_LENGTH];
    return [NSDictionary dictionaryWithDictionary:headers];
}

- (void)abortWithError:(NSError *)error
{
    self.error = error;
    [self.sessionTask cancel];
}

- (BOOL)canBeReenqueued
{
    return NO;
}

@end
