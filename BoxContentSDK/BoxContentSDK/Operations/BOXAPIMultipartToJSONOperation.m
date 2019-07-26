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
#import "BOXContentSDKConstants.h"

//FIXME: These are duplicated with BOXContentSDKConstants.h
#define BOX_API_MULTIPART_CONTENT_TYPE        (@"Content-Type")
#define BOX_API_MULTIPART_CONTENT_LENGTH      (@"Content-Length")

#define BOX_API_OUTPUT_STREAM_BUFFER_SIZE     (32u << 10) // 32 KiB

#pragma mark - Form Boundary Helpers

static NSString * BOXAPIMultipartContentTypeHeader(void)
{
    return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOXAPIMultipartFormBoundary];
}


#pragma mark - Upload Operation

@interface BOXAPIMultipartToJSONOperation ()
{
    dispatch_once_t _pred;
}

@property (nonatomic, readwrite, strong) BOXMultipartBodyStream *inputStream;

- (NSDictionary *)HTTPHeaders;

// called on stream read error
- (void)abortWithError:(NSError *)error;

@end

/* *
 * To make a new BOXAPIOperation support background upload similarly to BOXAPIMultipartToJSONOperation, implement
 * protocol BOXURLSessionUploadTaskDelegate and override its createSessionTaskWithError: exposed from BOXAPIOperation_Private.h
 * to return a foreground upload or background upload accordingly
 */
@implementation BOXAPIMultipartToJSONOperation

- (id)initWithURL:(NSURL *)URL HTTPMethod:(NSString *)HTTPMethod body:(NSDictionary *)body queryParams:(NSDictionary *)queryParams session:(BOXAbstractSession *)session
{
    self = [super initWithURL:URL HTTPMethod:HTTPMethod body:body queryParams:queryParams session:session];
    if (self != nil) {
        // Initialize the responseData object to mutable data
        self.responseData = [NSMutableData data];
    }
    
    return self;
}

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

- (BOOL)shouldRunInBackground
{
    return self.uploadMultipartCopyFilePath != nil && self.associateId != nil;
}

- (NSURLSessionTask *)createSessionTaskWithError:(NSError **)outError
{
    NSURLSessionTask *sessionTask;
    NSString *userId = self.session.user.uniqueId;

    NSError *error = nil;
    if (self.shouldRunInBackground == YES) {
        NSURL *url = [[NSURL alloc] initFileURLWithPath:self.uploadMultipartCopyFilePath];
        sessionTask = [self.session.urlSessionManager backgroundUploadTaskWithRequest:self.APIRequest fromFile:url taskDelegate:self userId:userId associateId:self.associateId error:&error];
    } else {
        sessionTask = [self.session.urlSessionManager foregroundUploadTaskWithStreamedRequest:self.APIRequest taskDelegate:self];
        if (sessionTask == nil) {
            error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKURLSessionInvalidSessionTask userInfo:nil];
        }
    }
    if (outError != nil) {
        *outError = error;
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

- (void)sessionTask:(NSURLSessionTask *)sessionTask didFinishWithResponse:(NSURLResponse *)response responseData:(nullable NSData *)responseData error:(NSError *)error
{
    @synchronized (self) {
        if ([self shouldRunInBackground] == YES) {
            [[NSFileManager defaultManager] removeItemAtPath:self.uploadMultipartCopyFilePath error:nil];
        }
        [super sessionTask:sessionTask didFinishWithResponse:response responseData:responseData error:error];
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
                                                                               completionHandler:^(NSString *digest, NSError * error) {
                                                                                   if (error != nil) {
                                                                                       [weakSelf abortWithError:error];
                                                                                   }
                                                                                   else if ([digest length] > 0){
                                                                                       [self.APIRequest setValue:digest
                                                                                              forHTTPHeaderField:BOXAPIHTTPHeaderContentMD5];
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
    if (self.error == nil) {
        self.error = error;
    }
    [self.sessionTask cancel];
}

- (BOOL)canBeReenqueued
{
    return NO;
}

@end
