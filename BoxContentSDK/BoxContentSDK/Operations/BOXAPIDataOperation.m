//
//  BOXAPIDataOperation.m
//  BoxContentSDK
//
//  Created on 2/27/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXAPIDataOperation.h"

#import "BOXContentSDKErrors.h"
#import "BOXLog.h"

#define MAX_REENQUE_DELAY 60
#define REENQUE_BASE_DELAY 0.2

@interface BOXAPIDataOperation ()

// Buffer data received from the connection in an NSData. Write to the
// output stream from this NSData when space becomes availble
@property (nonatomic, readwrite, strong) NSMutableData *receivedDataBuffer;

// The output stream may trigger the has space available callback when no data
// is buffered. Use this BOOL to keep track of this state and manually invoke
// the callback if necessary
@property (nonatomic, readwrite, assign) BOOL outputStreamHasSpaceAvailable;

@property (nonatomic, readwrite, assign) unsigned long long bytesReceived;

- (void)writeDataToOutputStream;

- (long long)contentLength;

- (void)close;
- (void)abortWithError:(NSError *)error;

@end

@implementation BOXAPIDataOperation

@synthesize successBlock = _successBlock;
@synthesize failureBlock = _failureBlock;
@synthesize progressBlock = _progressBlock;
@synthesize fileID = _fileID;

@synthesize outputStream = _outputStream;
@synthesize receivedDataBuffer = _receivedDataBuffer;
@synthesize outputStreamHasSpaceAvailable = _outputStreamHasSpaceAvailable;
@synthesize bytesReceived = _bytesReceived;

- (id)initWithURL:(NSURL *)URL HTTPMethod:(NSString *)HTTPMethod body:(NSDictionary *)body queryParams:(NSDictionary *)queryParams session:(BOXAbstractSession *)session
{
    self = [super initWithURL:URL HTTPMethod:HTTPMethod body:body queryParams:queryParams session:session];

    if (self != nil)
    {
        _outputStream = [NSOutputStream outputStreamToMemory];
        _receivedDataBuffer = [NSMutableData dataWithCapacity:0];
        _outputStreamHasSpaceAvailable = YES; // attempt to write to the output stream as soon as we receive data
        _bytesReceived = 0;
    }

    return self;
}

- (void)prepareAPIRequest
{
    [super prepareAPIRequest];

    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    self.outputStream.delegate = self;
}

// BOXAPIDataOperation should only ever be GET requests so there should not be a body
- (NSData *)encodeBody:(NSDictionary *)bodyDictionary
{
    return nil;
}

- (void)processResponseData:(NSData *)data
{
    // Empty data assumes that all data received from the NSURLConnection is buffered. This operation
    // streams all received data to its output stream, so do nothing.
    if (data.length == 0) {
        return;
    }
    
    NSError *JSONError = nil;
    id decodedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
    
    if (JSONError != nil)
    {
        NSDictionary *userInfo = @{
                                   NSUnderlyingErrorKey : JSONError,
                                   };
        self.error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKJSONErrorDecodeFailed userInfo:userInfo];;
    }
    else if ([decodedJSON isKindOfClass:[NSDictionary class]] == NO)
    {
        NSDictionary *userInfo = @{
                                   BOXJSONErrorResponseKey : decodedJSON,
                                   };
        self.error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKJSONErrorUnexpectedType userInfo:userInfo];
    }
    else if (self.error != nil)
    {
        // if this operation has already encountered an error, include the decoded JSON in the error info
        NSDictionary *userInfo = @{
                                   BOXJSONErrorResponseKey : decodedJSON,
                                   };
        self.error = [[NSError alloc] initWithDomain:self.error.domain code:self.error.code userInfo:userInfo];
    }
}

#pragma mark - Callback methods

- (void)performCompletionCallback
{
    if (self.error == nil)
    {
        if (self.successBlock)
        {
            self.successBlock(self.fileID, [self contentLength]);
        }
    }
    else
    {
        if ([self.error.domain isEqualToString:BOXContentSDKErrorDomain] && (self.error.code == BOXContentSDKAuthErrorAccessTokenExpiredOperationWillBeClonedAndReenqueued ||
                                                                      self.error.code == BOXContentSDKAPIErrorAccepted))
        {
            // Do not fire failre block if request is going to be re-enqueued due to an expired token, or a 202 response.
        }
        else
        {
            if (self.failureBlock)
            {
                self.failureBlock(self.APIRequest, self.HTTPResponse, self.error);
            }
        }
    }
}

- (void)performProgressCallback
{
    if (self.progressBlock)
    {
        self.progressBlock([self contentLength], self.bytesReceived);
    }
}

- (void)cancel
{
    // Close the output stream before cancelling the operation
    [self close];

    [super cancel];
}

#pragma mark - Output Stream methods

- (long long)contentLength
{
    return [self.HTTPResponse expectedContentLength];
}

- (void)close
{
    if (self.error.code == BOXContentSDKAPIErrorAccepted) {
        // for 202, we are going to re-enqueue so we don't want to mess with the stream.
    }
    else {
        self.outputStream.delegate = nil;
        [self.outputStream close];
        _outputStream = nil;
    }
}

- (void)abortWithError:(NSError *)error
{
    [self close];
    [self.connection cancel];
    [self connection:self.connection didFailWithError:error];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [super connection:connection didReceiveResponse:response];
    
    if (self.error.code == BOXContentSDKAPIErrorAccepted) {
        // If we get a 202, it means the content is not yet ready on Box's servers.
        // Re-enqueue after a certain amount of time.
        double delay = [self reenqueDelay];
        [self performSelector:@selector(reenqueOperationDueTo202Response) withObject:self afterDelay:delay];
    } else {
        [self.outputStream open];
    }
}

// Override this delegate method from the default BOXAPIOperation implementation
// By default, BOXAPIOperation buffers all received data from the connection in
// self.responseData. This operation differs in that it should write its received
// data immediately to its output stream. Failure to do so will cause downloads to
// be buffered entirely in memory.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (self.HTTPResponse.statusCode < 200 || self.HTTPResponse.statusCode >= 300) {
        // If we received an error, don't write the response data to the output stream
        [super connection:connection didReceiveData:data];
    } else {
        // Buffer received data in an NSMutableData ivar because the output stream
        // may not have space available for writing
        [self.receivedDataBuffer appendData:data];
        
        // If the output stream does have space available, trigger the writeDataToOutputStream
        // handler so the data is consumed by the output stream. This state would occur if
        // an NSStreamEventHasSpaceAvailable event was received but receivedDataBuffer was
        // empty.
        if (self.outputStreamHasSpaceAvailable)
        {
            self.outputStreamHasSpaceAvailable = NO;
            [self writeDataToOutputStream];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [super connection:connection didFailWithError:error];
    [self close];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [super connectionDidFinishLoading:connection];
    [self close];
}

#pragma mark - NSStream Delegate

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)eventCode
{
    if (eventCode & NSStreamEventHasSpaceAvailable)
    {
        [self writeDataToOutputStream];
    }
}

- (void)writeDataToOutputStream
{
    while ([self.outputStream hasSpaceAvailable])
    {
        if (self.receivedDataBuffer.length == 0)
        {
            self.outputStreamHasSpaceAvailable = YES;
            return; // bail out because we have nothing to write
        }

        NSInteger bytesWrittenToOutputStream = [self.outputStream write:[self.receivedDataBuffer bytes] maxLength:self.receivedDataBuffer.length];

        if (bytesWrittenToOutputStream == -1)
        {
            // Failed to write from to output stream. The download cannot be completed
            BOXLog(@"BOXAPIDataOperation failed to write to the output stream. Aborting download.");
            NSError *streamWriteError = [self.outputStream streamError];
            NSDictionary *userInfo = @{
                NSUnderlyingErrorKey : streamWriteError,
            };
            NSError *downloadError = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKStreamErrorWriteFailed userInfo:userInfo];
            [self abortWithError:downloadError];

            return; // Bail out due to error
        }
        else
        {
            self.bytesReceived += bytesWrittenToOutputStream;
            [self performProgressCallback];

            // truncate buffer by removing the consumed bytes from the front
            [self.receivedDataBuffer replaceBytesInRange:NSMakeRange(0, bytesWrittenToOutputStream) withBytes:NULL length:0];
        }
    }
}

#pragma mark - Reenque helpers

- (void)reenqueOperationDueTo202Response
{
    BOXAPIDataOperation *operationCopy = [self copy];
    operationCopy.timesReenqueued++;
    self.outputStream = nil;
    [self.session.queueManager enqueueOperation:operationCopy];
    [self finish];
}

- (double)reenqueDelay
{
    // Delay grows each time the request is re-enqueued.
    double delay = MIN(pow((1 + REENQUE_BASE_DELAY), self.timesReenqueued) - 1, MAX_REENQUE_DELAY);
    return delay;
}

- (id)copyWithZone:(NSZone *)zone
{
    NSURL *URLCopy = [self.baseRequestURL copy];
    NSDictionary *bodyCopy = [self.body copy];
    NSDictionary *queryStringParametersCopy = [self.queryStringParameters copy];
    
    BOXAPIDataOperation *operationCopy = [[BOXAPIDataOperation allocWithZone:zone] initWithURL:URLCopy
                                                                                    HTTPMethod:self.HTTPMethod
                                                                                          body:bodyCopy
                                                                                   queryParams:queryStringParametersCopy
                                                                                 session:self.session];
    operationCopy.outputStream = self.outputStream;
    operationCopy.outputStream.delegate = nil;
    operationCopy.timesReenqueued = self.timesReenqueued;
    operationCopy.successBlock = [self.successBlock copy];
    operationCopy.failureBlock = [self.failureBlock copy];
    operationCopy.progressBlock = [self.progressBlock copy];
    
    return operationCopy;
}

- (BOOL)canBeReenqueued
{
    return YES;
}

@end
