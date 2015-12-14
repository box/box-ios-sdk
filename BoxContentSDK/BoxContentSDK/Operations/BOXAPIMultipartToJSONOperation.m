//
//  BOXAPIMultipartToJSONOperation.m
//  BoxContentSDK
//
//  Created on 2/27/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXAPIMultipartToJSONOperation.h"

#import "BOXContentSDKErrors.h"
#import "BOXLog.h"

#define BOX_API_MULTIPART_CONTENT_DISPOSITION (@"Content-Disposition")
#define BOX_API_MULTIPART_CONTENT_TYPE        (@"Content-Type")
#define BOX_API_MULTIPART_CONTENT_LENGTH      (@"Content-Length")

#define BOX_API_OUTPUT_STREAM_BUFFER_SIZE     (32u << 10) // 32 KiB

#pragma mark - Form Boundary Helpers

static NSString *const BOXAPIMultipartFormBoundary = @"0xBoXSdKMulTiPaRtFoRmBoUnDaRy";
static NSString *const BOXAPIMultipartFormCRLF     = @"\r\n";

static NSString * BOXAPIMultipartInitialBoundary(void)
{
    return [NSString stringWithFormat:@"--%@%@", BOXAPIMultipartFormBoundary, BOXAPIMultipartFormCRLF];
}

static NSString * BOXAPIMultipartEncapsulationBoundary(void)
{
    return [NSString stringWithFormat:@"%@--%@%@", BOXAPIMultipartFormCRLF, BOXAPIMultipartFormBoundary, BOXAPIMultipartFormCRLF];
}

static NSString * BOXAPIMultipartFinalBoundary(void)
{
    return [NSString stringWithFormat:@"%@--%@--%@", BOXAPIMultipartFormCRLF, BOXAPIMultipartFormBoundary, BOXAPIMultipartFormCRLF];
}

static NSString * BOXAPIMultipartContentTypeHeader(void)
{
    return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOXAPIMultipartFormBoundary];
}

@implementation BOXAPIMultipartPiece

@synthesize headers = _headers;
@synthesize headersInputStream = _headersInputStream;
@synthesize bodyInputStream = _bodyInputStream;
@synthesize bodyContentLength = _bodyContentLength;
@synthesize hasInitialBoundary = _hasInitialBoundary;
@synthesize startBoundaryInputStream = _startBoundaryInputStream;
@synthesize hasFinalBoundary = _hasFinalBoundary;
@synthesize endBoundaryInputStream = _endBoundaryInputStream;
@synthesize state = _state;

- (id)initWithData:(NSData *)data fieldName:(NSString *)fieldName filename:(NSString *)filename
{
    self = [self initWithData:data fieldName:fieldName filename:filename MIMEType:nil];

    return self;
}

- (id)initWithData:(NSData *)data fieldName:(NSString *)fieldName filename:(NSString *)filename MIMEType:(NSString *)MIMEType
{
    self = [self initWithInputStream:[NSInputStream inputStreamWithData:data] fieldName:fieldName filename:filename MIMEType:MIMEType];

    if (self != nil)
    {
        _bodyContentLength = data.length;
    }

    return self;
}

- (id)initWithInputStream:(NSInputStream *)inputStream fieldName:(NSString *)fieldName filename:(NSString *)filename
{
    self = [self initWithInputStream:inputStream fieldName:fieldName filename:filename MIMEType:nil];

    return self;
}

- (id)initWithInputStream:(NSInputStream *)inputStream fieldName:(NSString *)fieldName filename:(NSString *)filename MIMEType:(NSString *)MIMEType
{
    self = [super init];
    if (self != nil)
    {
        _state = BOXAPIMultipartPieceStateNotOpen;

        _bodyContentLength = 0;
        _hasInitialBoundary = NO;
        _hasFinalBoundary = NO;

        _headers = [NSMutableDictionary dictionary];

        // attach the parameter name as the Content-Disposition header
        BOXAssert(fieldName != nil, @"field name must be specified when sending multipart form data");
        NSString *contentDispositionHeader = [NSString stringWithFormat:@"form-data; name=\"%@\"", fieldName];
        if (filename != nil)
        {
            contentDispositionHeader = [contentDispositionHeader stringByAppendingFormat:@"; filename=\"%@\"", filename];
        }
        [_headers setObject:contentDispositionHeader forKey:BOX_API_MULTIPART_CONTENT_DISPOSITION];

        // add the optionally given MIME Type as the Content-Type header
        if (MIMEType != nil)
        {
            [_headers setObject:MIMEType forKey:BOX_API_MULTIPART_CONTENT_TYPE];
        }

        _bodyInputStream = inputStream;
    }

    return self;
}

- (unsigned long long)contentLength
{
    unsigned long long contentLength = 0;

    contentLength += [self startBoundaryData].length;
    contentLength += [self headersData].length;
    contentLength += self.bodyContentLength;
    contentLength += [self endBoundaryData].length;

    return contentLength;
}

- (NSData *)startBoundaryData
{
    NSData *startBoundaryData = nil;
    if (self.hasInitialBoundary)
    {
        startBoundaryData = [BOXAPIMultipartInitialBoundary() dataUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        startBoundaryData = [BOXAPIMultipartEncapsulationBoundary() dataUsingEncoding:NSUTF8StringEncoding];
    }

    return startBoundaryData;
}

- (NSData *)endBoundaryData
{
    NSData *endBoundaryData = nil;
    if (self.hasFinalBoundary)
    {
        endBoundaryData = [BOXAPIMultipartFinalBoundary() dataUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        endBoundaryData = [[NSData alloc] init];
    }

    return endBoundaryData;
}

- (NSData *)headersData
{
    NSMutableData *headersData = [NSMutableData data];

    for (id headerName in self.headers)
    {
        id headerValue = [self.headers valueForKey:headerName];
        NSString *headerString = [NSString stringWithFormat:@"%@: %@%@", headerName, headerValue, BOXAPIMultipartFormCRLF];
        [headersData appendData:[headerString dataUsingEncoding:NSUTF8StringEncoding]];
    }

    [headersData appendData:[BOXAPIMultipartFormCRLF dataUsingEncoding:NSUTF8StringEncoding]];
    return headersData;
}

- (NSInteger)read:(NSMutableData **)outputData maxLength:(NSUInteger)length error:(NSError **)error
{
    NSInteger bytesRead = 0;

    BOXAssert(outputData != nil, @"outputData is a required out param. It must be non nil");
    NSMutableData *data = *outputData;
    BOXAssert(data != nil, @"ouputData is a required out param. It must point to the address of a non-nil NSMutableData");

    data.length = length;
    uint8_t *buffer = [data mutableBytes];

    if (self.state == BOXAPIMultipartPieceStateNotOpen)
    {
        [self initializeInputStreams];
        [self transitionToNextState];
    }
    else if (self.state == BOXAPIMultipartPieceStateInitialBoundary)
    {
        if ([self.startBoundaryInputStream hasBytesAvailable])
        {
            bytesRead += [self.startBoundaryInputStream read:buffer maxLength:length];
        }
        else
        {
            [self transitionToNextState];
        }
    }
    else if (self.state == BOXAPIMultipartPieceStateHeaders)
    {
        if ([self.headersInputStream hasBytesAvailable])
        {
            bytesRead += [self.headersInputStream read:buffer maxLength:length];
        }
        else
        {
            [self transitionToNextState];
        }
    }
    else if (self.state == BOXAPIMultipartPieceStateBodyData)
    {
        if ([self.bodyInputStream hasBytesAvailable])
        {
            bytesRead += [self.bodyInputStream read:buffer maxLength:length];
        }
        else
        {
            [self transitionToNextState];
        }
    }
    else if (self.state == BOXAPIMultipartPieceStateFinalBoundary)
    {
        if ([self.endBoundaryInputStream hasBytesAvailable])
        {
            bytesRead += [self.endBoundaryInputStream read:buffer maxLength:length];
        }
        else
        {
            [self transitionToNextState];
        }
    }

    BOXAssert(bytesRead == -1 || bytesRead <= length, @"should have read no more than %lu bytes", (unsigned long) length);

    if (bytesRead == -1)
    {
        switch (self.state)
        {
            case BOXAPIMultipartPieceStateInitialBoundary:
                BOXLog(@"failed to read from input stream for multipart piece %@ during phase %@", self, @"initial boundary");
                if (error != NULL)
                {
                    *error = [self.startBoundaryInputStream streamError];
                }
                break;
            case BOXAPIMultipartPieceStateHeaders:
                BOXLog(@"failed to read from input stream for multipart piece %@ during phase %@", self, @"headers");
                if (error != NULL)
                {
                    *error = [self.headersInputStream streamError];
                }
                break;
            case BOXAPIMultipartPieceStateBodyData:
                BOXLog(@"failed to read from input stream for multipart piece %@ during phase %@", self, @"body data");
                if (error != NULL)
                {
                    *error = [self.bodyInputStream streamError];
                }
                break;
            case BOXAPIMultipartPieceStateFinalBoundary:
                BOXLog(@"failed to read from input stream for multipart piece %@ during phase %@", self, @"final boundary");
                if (error != NULL)
                {
                    *error = [self.endBoundaryInputStream streamError];
                }
                break;
            case BOXAPIMultipartPieceStateClosed:
                // fall through
            case BOXAPIMultipartPieceStateNotOpen:
                // fall through
            default:
                BOXAssertFail(@"This state should not be reachable. We are not reading from streams during these states");
        }

        [self close];
    }
    else
    {
        // only set length of buffer if read was successful
        data.length = bytesRead;
    }

    return bytesRead;
}

- (void)initializeInputStreams
{
    self.startBoundaryInputStream = [NSInputStream inputStreamWithData:[self startBoundaryData]];
    self.endBoundaryInputStream = [NSInputStream inputStreamWithData:[self endBoundaryData]];
    self.headersInputStream = [NSInputStream inputStreamWithData:[self headersData]];
}

- (void)transitionToNextState
{
    BOXAPIMultipartPieceState nextState = BOXAPIMultipartPieceStateClosed;

    switch (self.state)
    {
        case BOXAPIMultipartPieceStateNotOpen:
            nextState = BOXAPIMultipartPieceStateInitialBoundary;
            [self.startBoundaryInputStream open];
            break;
        case BOXAPIMultipartPieceStateInitialBoundary:
            nextState = BOXAPIMultipartPieceStateHeaders;
            [self.startBoundaryInputStream close];
            [self.headersInputStream open];
            break;
        case BOXAPIMultipartPieceStateHeaders:
            nextState = BOXAPIMultipartPieceStateBodyData;
            [self.headersInputStream close];
            [self.bodyInputStream open];
            break;
        case BOXAPIMultipartPieceStateBodyData:
            nextState = BOXAPIMultipartPieceStateFinalBoundary;
            [self.bodyInputStream close];
            [self.endBoundaryInputStream open];
            break;
        case BOXAPIMultipartPieceStateFinalBoundary:
            nextState = BOXAPIMultipartPieceStateClosed;
            [self.endBoundaryInputStream close];
            break;
        case BOXAPIMultipartPieceStateClosed:
            // fall through
        default:
            nextState = BOXAPIMultipartPieceStateClosed;
    }

    self.state = nextState;
}

- (BOOL)hasBytesAvailable
{
    if (self.state == BOXAPIMultipartPieceStateClosed)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)close
{
    [self.startBoundaryInputStream close];
    [self.headersInputStream close];
    [self.bodyInputStream close];
    [self.endBoundaryInputStream close];

    self.state = BOXAPIMultipartPieceStateClosed;
}

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@" BOXAPIMultipartPiece with body content-disposition: %@, content-length: %llu",
            [self.headers objectForKey:BOX_API_MULTIPART_CONTENT_DISPOSITION],
            [self contentLength]];
}

@end

#pragma mark - Upload Operation

@interface BOXAPIMultipartToJSONOperation ()
{
    dispatch_once_t _pred;
}

@property (nonatomic, readwrite, strong) NSMutableArray *formPieces;
@property (nonatomic, readwrite, assign) unsigned long long bytesWritten;

@property (nonatomic, readonly) NSOutputStream *outputStream;
@property (nonatomic, readonly) NSMutableData *outputBuffer;
@property (nonatomic, readonly) NSInputStream *inputStream;

@property (nonatomic, readwrite, strong) BOXAPIMultipartPiece *currentPiece;
@property (nonatomic, readwrite, strong) NSEnumerator *pieceEnumerator;

- (NSDictionary *)HTTPHeaders;

- (void)initStreams;
- (void)close;

// called on stream read error
- (void)abortWithError:(NSError *)error;

@end

@implementation BOXAPIMultipartToJSONOperation

@synthesize responseJSON = _responseJSON;
@synthesize formPieces = _formPieces;
@synthesize bytesWritten = _bytesWritten;
@synthesize outputStream = _outputStream;
@synthesize outputBuffer = _outputBuffer;
@synthesize inputStream = _inputStream;

@synthesize currentPiece = _currentPiece;
@synthesize pieceEnumerator = _pieceEnumerator;

@synthesize progressBlock = _progressBlock;

#pragma mark - Upload operation initializers

- (id)initWithURL:(NSURL *)URL HTTPMethod:(NSString *)HTTPMethod body:(NSDictionary *)body queryParams:(NSDictionary *)queryParams session:(BOXAbstractSession *)session
{
    // do not pass body to super because we do not wish to JSON-encode it. The body will be converted to
    // NSDatas and appended as multipart form pieces
    self = [super initWithURL:URL HTTPMethod:HTTPMethod body:nil queryParams:queryParams session:session];
    if (self != nil)
    {
        _formPieces = [NSMutableArray array];
        _bytesWritten = 0;
        _outputBuffer = [NSMutableData dataWithCapacity:0];
        for (id bodyKey in body)
        {
            NSData *formDataToAppend = nil;
            id bodyValue = [body valueForKey:bodyKey];
            if ([bodyValue isKindOfClass:[NSData class]])
            {
                formDataToAppend = bodyValue;
            }
            else if ([bodyValue isKindOfClass:[NSNull class]])
            {
                formDataToAppend = [NSData data];
            }
            else // most likely this is a string
            {
                formDataToAppend = [[bodyValue description] dataUsingEncoding:NSUTF8StringEncoding];
            }

            BOXAPIMultipartPiece *piece = [[BOXAPIMultipartPiece alloc] initWithData:formDataToAppend fieldName:[bodyKey description] filename:nil];
            [_formPieces addObject:piece];
        }
    }

    return self;
}

#pragma mark - Append data to upload operation

- (void)appendMultipartPieceWithData:(NSData *)data fieldName:(NSString *)fieldName filename:(NSString *)filename MIMEType:(NSString *)MIMEType
{
    BOXAPIMultipartPiece *piece = [[BOXAPIMultipartPiece alloc] initWithData:data fieldName:fieldName filename:filename MIMEType:MIMEType];
    [self.formPieces addObject:piece];
}

- (void)appendMultipartPieceWithInputStream:(NSInputStream *)inputStream contentLength:(unsigned long long)length fieldName:(NSString *)fieldName filename:(NSString *)filename MIMEType:(NSString *)MIMEType
{
    BOXAPIMultipartPiece *piece = [[BOXAPIMultipartPiece alloc] initWithInputStream:inputStream fieldName:fieldName filename:filename MIMEType:MIMEType];
    piece.bodyContentLength = length;
    [self.formPieces addObject:piece];
}

#pragma mark -

- (void)prepareAPIRequest
{
    [super prepareAPIRequest];

    // HTTPHeaders is dependent on the content-length of the underlying pieces.
    // initialize the pieces first so boundaries can be set
    [self initStreams];

    [self.APIRequest setAllHTTPHeaderFields:[self HTTPHeaders]];

    // attach body stream to request
    [self.APIRequest setHTTPBodyStream:self.inputStream];
}

// Override this method to turn it into a NO-OP. The multipart operation will attach itself
// to the request with a stream
- (NSData *)encodeBody:(NSDictionary *)bodyDictionary
{
    return nil;
}

- (void)performProgressCallback
{
    if (self.progressBlock)
    {
        self.progressBlock([self contentLength], self.bytesWritten);
    }
}

#pragma mark - Multipart Stream methods

- (unsigned long long)contentLength
{
    unsigned long long contentLength = 0;
    for (BOXAPIMultipartPiece *piece in self.formPieces)
    {
        contentLength += piece.contentLength;
    }

    return contentLength;
}

- (NSDictionary *)HTTPHeaders
{
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    [headers setObject:BOXAPIMultipartContentTypeHeader() forKey:BOX_API_MULTIPART_CONTENT_TYPE];
    [headers setObject:[NSString stringWithFormat:@"%llu", [self contentLength]] forKey:BOX_API_MULTIPART_CONTENT_LENGTH];

    return [NSDictionary dictionaryWithDictionary:headers];
}

- (void)initStreams
{
    dispatch_once(&_pred, ^{
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        CFStreamCreateBoundPair(NULL, &readStream, &writeStream, BOX_API_OUTPUT_STREAM_BUFFER_SIZE);
        _inputStream = CFBridgingRelease(readStream);
        _outputStream = CFBridgingRelease(writeStream);

        _outputStream.delegate = self;
        [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

        [_outputStream open];

        BOXAPIMultipartPiece *initialPiece = [self.formPieces objectAtIndex:0];
        initialPiece.hasInitialBoundary = YES;

        BOXAPIMultipartPiece *finalPiece = [self.formPieces lastObject];
        finalPiece.hasFinalBoundary = YES;
    });
}

- (void)close
{
    self.outputStream.delegate = nil;
    [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

    [self.outputStream close];
    _outputStream = nil;
}

- (void)abortWithError:(NSError *)error
{
    [self close];
    [self.connection cancel];
    [self connection:self.connection didFailWithError:error];
}

#pragma mark - NSStream Delegate

/**
 *This retry works around a nasty problem in which mutli-part uploads
 * will fail due to the stream delegate being sent a `NSStreamEventHasSpaceAvailable`
 * event before the input stream has finished opening. This workaround simply replays
 * the event after allowing the run-loop to cycle, providing enough time for the input
 * stream to finish opening. It appears that this bug is in the CFNetwork layer.
 * (See https://github.com/AFNetworking/AFNetworking/issues/948)
 *
 * @param stream The stream to resend a `NSStreamEventHasSpaceAvailable` event to
 */
- (void)retryWrite:(NSStream *)stream
{
    [self stream:stream handleEvent:NSStreamEventHasSpaceAvailable];
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
    if (self.isCancelled) {
        [self close];
        return;
    }
    
    if (streamEvent & NSStreamEventHasSpaceAvailable)
    {
        if (self.inputStream.streamStatus < NSStreamStatusOpen)
        {
            // See comments in `retryWrite:` for details
            [self performSelector:@selector(retryWrite:) withObject:theStream afterDelay:0.1];
        }
        else
        {
            [self writeDataToOutputStream];
        }
    }
}

- (void)writeDataToOutputStream
{
    while ([self.outputStream hasSpaceAvailable])
    {
        if (self.isCancelled) {
            [self close];
            return;
        }
        
        if (self.outputBuffer.length > 0)
        {
            NSInteger bytesWrittenToOutputStream = [self.outputStream write:[self.outputBuffer mutableBytes] maxLength:self.outputBuffer.length];

            if (bytesWrittenToOutputStream == -1)
            {
                // Failed to write from to output stream. The upload cannot be completed
                BOXLog(@"BOXAPIMultipartToJSONOperation failed to write to the output stream. Aborting upload.");
                NSError *streamWriteError = [self.outputStream streamError];
                NSDictionary *userInfo = @{
                    NSUnderlyingErrorKey : streamWriteError,
                };
                NSError *uploadError = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKStreamErrorWriteFailed userInfo:userInfo];
                [self abortWithError:uploadError];

                return; // Bail out due to error
            }
            else
            {
                self.bytesWritten += bytesWrittenToOutputStream;
                [self performProgressCallback];

                // truncate buffer by removing the consumed bytes from the front
                [self.outputBuffer replaceBytesInRange:NSMakeRange(0, bytesWrittenToOutputStream) withBytes:NULL length:0];
            }
        }
        else
        {
            // prime reading from the stream
            if (self.currentPiece == nil)
            {
                if (self.pieceEnumerator == nil)
                {
                    self.pieceEnumerator = [self.formPieces objectEnumerator];
                }
                self.currentPiece = [self.pieceEnumerator nextObject];
            }

            // if there is no currentPiece by now, we have enumerated through all pieces,
            // so close the stream. No more stream events will be received.
            if (self.currentPiece == nil)
            {
                [self close];
                return; // Upload finished, break out of loop
            }

            if ([self.currentPiece hasBytesAvailable])
            {
                self.outputBuffer.length = BOX_API_OUTPUT_STREAM_BUFFER_SIZE;
                NSMutableData *buffer = self.outputBuffer;
                NSError *streamReadError = nil;
                NSInteger bytesReadFromPiece = [self.currentPiece read:&buffer maxLength:BOX_API_OUTPUT_STREAM_BUFFER_SIZE error:&streamReadError];

                if (bytesReadFromPiece == -1)
                {
                    // Failed to read from an input stream. The upload cannot be completed
                    BOXLog(@"BOXAPIMultipartToJSONOperation failed to read from a multipart piece. Aborting upload.");
                    NSDictionary *userInfo = @{
                        NSUnderlyingErrorKey : streamReadError,
                    };
                    NSError *uploadError = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKStreamErrorReadFailed userInfo:userInfo];
                    [self abortWithError:uploadError];

                    return; // Bail out due to error
                }
                else
                {
                    self.outputBuffer.length = bytesReadFromPiece;
                }
            }
            else
            {
                self.currentPiece = [self.pieceEnumerator nextObject];
            }
        }
    }
}

- (BOOL)canBeReenqueued
{
    return NO;
}

- (void)dealloc
{
    _outputStream.delegate = nil;
}

@end
