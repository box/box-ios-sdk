//
//  BOXAPIStreamingUploadHelper.m
//  BoxCore
//
//  Created by Boris Suvorov on 7/10/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXAssetInputStream.h"
#import "BOXLog.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface NSStream (BoundPairAdditions)
+ (void)createBoundInputStream:(NSInputStream **)inputStreamPtr outputStream:(NSOutputStream **)outputStreamPtr bufferSize:(NSUInteger)bufferSize;
@end

// 32 kilobytes is a common buffer size (also a common default buffer size for network sockets).
#define kPostBufferSize 32768 // 32 kilobytes in bytes.

@interface BOXAssetInputStream ()

@property (nonatomic) ALAssetRepresentation *assetRepresentation;
@property (nonatomic) ALAssetsLibrary *assetsLibrary;

@property (nonatomic) long long assetReadOffset;
@property (nonatomic) long long consumerReadOffset;
@property (nonatomic) long long assetRepresentationSize;

@property (nonatomic) NSInputStream *fileStream;
@property (nonatomic) NSOutputStream *producerStream;
@property (nonatomic) NSInputStream *consumerStream;

@property (nonatomic) const uint8_t *buffer;
@property (nonatomic) uint8_t *bufferOnHeap;
@property (nonatomic) size_t bufferOffset;
@property (nonatomic) size_t bufferLimit;

@end

@implementation BOXAssetInputStream

#pragma overriding NSStream abstract methods
// Reason why we're going with NSStream abstraction is to make seamless
// integration with AFHTTP in the createRequestForUploadWithBuilder for
// Library assets, as well as files imported with "open in" Box.
// this code relies on reading from NSInputStream.
// If we were to subcalss BOXAssetInputStream from NSObject, then it'd
// save 70 lines of code for this self.consumer .. indirection below 
// but would more tricker to persist BOXAssetInputStream durign the lifetime of the upload operation.
- (void)open
{
    [self.consumerStream open];
}

- (void)close
{
    [self.consumerStream close];
}

- (id <NSStreamDelegate>)delegate
{
    return self.consumerStream.delegate;
}

- (void)setDelegate:(id <NSStreamDelegate>)delegate
{
    self.consumerStream.delegate = delegate;
}

- (id)propertyForKey:(NSString *)key
{
    return [self.consumerStream propertyForKey:key];
}

- (BOOL)setProperty:(id)property forKey:(NSString *)key
{
    return [self.consumerStream setProperty:property forKey:key];
}

- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode
{
    [self.consumerStream scheduleInRunLoop:aRunLoop forMode:mode];
}

- (void)removeFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode
{
    [self.consumerStream removeFromRunLoop:aRunLoop forMode:mode];
}

- (NSStreamStatus)streamStatus
{
    return [self.consumerStream streamStatus];
}

- (NSError *)streamError
{
    return [self.consumerStream streamError];
}

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len
{
    NSInteger bytesRead = [self.consumerStream read:buffer maxLength:len];
    if (bytesRead > 0) {
        self.consumerReadOffset += bytesRead;
    }
    return bytesRead;
}

- (BOOL)getBuffer:(uint8_t **)buffer length:(NSUInteger *)len
{
    return [self.consumerStream getBuffer:buffer length:len];
}

- (BOOL)hasBytesAvailable
{
    // calling [self.consumer hasBytesAvailable] is not guaranteed to work when self and the callee are running on different threads
    // Instead we manually keep track of the bytes read from the consumer
    return self.consumerReadOffset < self.assetRepresentationSize;
}

- (instancetype)init
{
    // we should never use init method
    BOXAssertFail(@"Not implemented");
    return nil;
}

- (instancetype)initWithAssetRepresentation:(ALAssetRepresentation *)assetRepresentation assetsLibrary:(ALAssetsLibrary *)assetsLibrary
{
    self = [super init];
    
    if (self == nil) {
        return nil;
    }

    self.assetRepresentation = assetRepresentation;
    self.assetsLibrary = assetsLibrary;
    // We remove assetRepresentation from memory when we are done reading.
    // Keep track of the size in the event we read from the consumer stream after assetRepresentation has completed reading and been removed from memory
    self.assetRepresentationSize = assetRepresentation.size;

    // allocate buffer to read information from output stream/write into input
    self.bufferOnHeap = malloc(kPostBufferSize);
    self.buffer = self.bufferOnHeap;
    
    [self setupStreams];
	return self;
}

- (void)setupStreams
{
	// Open producer/consumer streams.  We open the producerStream straight 
	// away.  We leave the consumerStream alone; NSURLConnection will deal 
	// with it.
    __autoreleasing NSInputStream *consStream;
    __autoreleasing NSOutputStream *prodStream;
	
    [BOXAssetInputStream createBoundInputStream:&consStream outputStream:&prodStream bufferSize:kPostBufferSize];
    
    self.producerStream = prodStream;
    self.consumerStream = consStream;
    
	self.producerStream.delegate = self;

    // FIXME IOS-5321: figure out why it can't be done on the currentRunLoop
	[self.producerStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
	[self.producerStream open];
}

- (void)dealloc
{
    [self resetUploadBuffers];
    self.producerStream.delegate = nil;
}

#pragma mark NSStreamDelegate related methods
- (void)readNextChunk
{     
    NSUInteger bytesRead = 0;

    // if error occurs, bytesRead == 0 and stream will get closed
    NSError *error = nil;
    
    bytesRead = [self.assetRepresentation getBytes:self.bufferOnHeap fromOffset:self.assetReadOffset length:kPostBufferSize error:&error];
    
    if (error == nil && bytesRead != 0) {
        self.assetReadOffset += (long long)bytesRead;
        self.bufferOffset = 0;
        self.bufferLimit  = bytesRead;
    } else {
        if (error) {
            BOXLog(@"Failed to getBytes from asset rep %@ with error %@", self.assetRepresentation, error);
        }
        
        self.assetRepresentation = nil;
        [self resetUploadBuffers];
    }
}

- (void)handleStreamEventHasSpaceAvailable
{
    // once we starting new chunk or completely finished 
    // writing data to producerStream, read next chunk
    if (self.bufferOffset == self.bufferLimit) {
        self.bufferOffset = 0;
        self.bufferLimit  = 0;    

        // we nil out assetRepresentation when we're done reading
        // this however is not going to close input stream. it'll attempt to read again from the outputStream
        // so it is our job to ensure we don't attempt to read again from the asset
        if (self.assetRepresentation) {
            [self readNextChunk];
        }
    }
    
    // Send the next chunk of data in our buffer when there is something to write 
    if (self.bufferOffset != self.bufferLimit && self.buffer != nil) {
        NSInteger bytesWritten;
        bytesWritten = [self.producerStream write:&self.buffer[self.bufferOffset]
                                        maxLength:self.bufferLimit - self.bufferOffset];
        if (bytesWritten <= 0) {
            // Network write error
            BOXLog(@"Uploading FAILED due to producer stream write error");
            [self resetUploadBuffers];
        } else {
            self.bufferOffset += bytesWritten;
        }
    }
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{    
    if (streamEvent == NSStreamEventHasSpaceAvailable) {
        [self handleStreamEventHasSpaceAvailable];
    }
}

- (void)resetUploadBuffers
{
    @synchronized(self) {
        if (self.bufferOnHeap != nil) {
            free(self.bufferOnHeap);
            self.bufferOnHeap = nil;
        }
        
        if (self.producerStream != nil) {
            [self.producerStream close];
            self.producerStream = nil;
        }
    }
}
@end

@implementation NSStream (BoundPairAdditions)

+ (void)createBoundInputStream:(NSInputStream **)inputStreamPtr outputStream:(NSOutputStream **)outputStreamPtr bufferSize:(NSUInteger)bufferSize
{
    CFReadStreamRef     readStream;
    CFWriteStreamRef    writeStream;
    
    assert( (inputStreamPtr != NULL) || (outputStreamPtr != NULL) );
    
    readStream = NULL;
    writeStream = NULL;
    
    CFStreamCreateBoundPair(
                            NULL, 
                            ((inputStreamPtr  != nil) ? &readStream : NULL),
                            ((outputStreamPtr != nil) ? &writeStream : NULL), 
                            (CFIndex) bufferSize
                            );

    
    if (inputStreamPtr != NULL) {
        *inputStreamPtr  = CFBridgingRelease(readStream);
    }
    if (outputStreamPtr != NULL) {
        *outputStreamPtr = CFBridgingRelease(writeStream);
    }
}

@end

