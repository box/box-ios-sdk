//
//  BOXCannedURLProtocol.m
//  BoxContentSDK
//
//  Created by Rico Yao on 11/24/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXCannedURLProtocol.h"

@implementation BOXCannedURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    BOOL canInit = NO;
    
    for (NSURLRequest * myRequest in [[self cannedResponseForRequests] allKeys]) {
        if ([[self class] request:request isEquivalentToRequest:myRequest]) {
            canInit = YES;
            break;
        }
    }
    
    return canInit;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (NSCachedURLResponse *)cachedResponse
{
    return nil;
}

- (void)startLoading
{
    NSURLRequest *request = [self request];
    id<NSURLProtocolClient> client = [self client];

    BOXCannedResponse *cannedResponse = nil;
    
    for (NSURLRequest * myRequest in [[[self class] cannedResponseForRequests] allKeys]) {
        if ([[self class] request:request isEquivalentToRequest:myRequest]) {
            cannedResponse = [[[self class] cannedResponseForRequests] objectForKey:myRequest];
            break;
        }
    }
    
    if (cannedResponse != nil) {
        
        // Short-circuit if we're simulating a 202 (Accepted) response.
        // This can be returned by Box's servers when content is not yet ready on the server.
        if (cannedResponse.numberOfIntermediate202Responses > 0) {
            cannedResponse.numberOfIntermediate202Responses--;
            NSHTTPURLResponse *URLResponse202 = [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:202 HTTPVersion:@"HTTP/1.1" headerFields:nil];
            [client URLProtocol:self didReceiveResponse:URLResponse202 cacheStoragePolicy:NSURLCacheStorageNotAllowed];
            [client URLProtocolDidFinishLoading:self];
            return;
        }
        
        // If there's a body, simulate reading it from the body stream, which is what our operations expect.
        if (request.HTTPBodyStream != nil) {
            [request.HTTPBodyStream open];
            NSMutableData *dataFromStream = [NSMutableData data];
            uint8_t byteBuffer[4096];
            NSInteger bytesRead = 0;
            while ([request.HTTPBodyStream hasBytesAvailable] == YES && (bytesRead = [request.HTTPBodyStream read:byteBuffer maxLength:4096]) != 0) {
                if (bytesRead > 0) {
                    [dataFromStream appendBytes:byteBuffer length:bytesRead];
                }
            }
            [request.HTTPBodyStream close];
            
            // Used by some tests to verify contents of the body.
            if (cannedResponse.httpBodyDataBlock != nil) {
                cannedResponse.httpBodyDataBlock(dataFromStream);
            }
        }
        
        [client URLProtocol:self didReceiveResponse:cannedResponse.URLResponse cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        
        // Simulate receiving data in multiple chunks to ensure our networking layer handles that correctly.
        NSArray *chunks = [self chunkData:cannedResponse.responseData intoChunksWithSize:1024];
        for (NSData *chunk in chunks) {
            [client URLProtocol:self didLoadData:chunk];
        }
        
        [client URLProtocolDidFinishLoading:self];
    }
}

- (void)stopLoading
{
}

#pragma mark - public class methods

+ (void)setCannedResponse:(BOXCannedResponse *)cannedResponse
               forRequest:(NSURLRequest *)request
{
    [[self cannedResponseForRequests] setObject:cannedResponse forKey:request];
}

+ (void)reset
{
    [[self cannedResponseForRequests] removeAllObjects];
}

#pragma mark - private helpers

static NSMutableDictionary *_cannedResponseForRequests;

+ (NSMutableDictionary *)cannedResponseForRequests
{
    if (_cannedResponseForRequests == nil) {
        _cannedResponseForRequests = [NSMutableDictionary dictionary];
    }
    return _cannedResponseForRequests;
}

+ (BOOL)request:(NSURLRequest *)requestA isEquivalentToRequest:(NSURLRequest *)requestB
{
    BOOL isEqual = NO;
    
    if ([requestA.URL isEqual:requestB.URL] && [requestA.HTTPMethod isEqual:requestB.HTTPMethod]) {
        isEqual = YES;
    }
    
    return isEqual;
}

- (NSArray *)chunkData:(NSData *)data intoChunksWithSize:(NSUInteger)chunkSize
{
    NSMutableArray *chunks = [NSMutableArray array];
    
    NSUInteger length = [data length];
    NSUInteger offset = 0;
    do {
        NSUInteger thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
        NSData *chunk = [NSData dataWithBytesNoCopy:(char *)[data bytes] + offset
                                             length:thisChunkSize
                                       freeWhenDone:NO];
        offset += thisChunkSize;
        [chunks addObject:chunk];
    } while (offset < length);
    
    return chunks;
}

@end
