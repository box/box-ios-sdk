/*
 *  BOXHashHelper.m
 *
 *  Based on FileHash by Joel Lopes Da Silva:
 *  Copyright © 2010-2014 Joel Lopes Da Silva. All rights reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 * 
 *        http://www.apache.org/licenses/LICENSE-2.0
 * 
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

// Header file
#import "BOXHashHelper.h"

// System framework and libraries
#define COMMON_DIGEST_FOR_OPENSSL
#include <CommonCrypto/CommonDigest.h>
#include <CoreFoundation/CoreFoundation.h>
#include <stdint.h>
#include <stdio.h>
#include <AssetsLibrary/AssetsLibrary.h>

// Constants
static const size_t FileHashDefaultChunkSizeForReadingData = 4096;

// Function pointer types for functions used in the computation 
// of a cryptographic hash.
typedef int (*FileHashInitFunction)   (uint8_t *hashObjectPointer[]);
typedef int (*FileHashUpdateFunction) (uint8_t *hashObjectPointer[], const void *data, CC_LONG len);
typedef int (*FileHashFinalFunction)  (unsigned char *md, uint8_t *hashObjectPointer[]);

// Structure used to describe a hash computation context.
typedef struct _FileHashComputationContext {
    FileHashInitFunction initFunction;
    FileHashUpdateFunction updateFunction;
    FileHashFinalFunction finalFunction;
    size_t digestLength;
    uint8_t **hashObjectPointer;
} FileHashComputationContext;

#define FileHashComputationContextInitialize(context, hashAlgorithmName)                    \
    CC_##hashAlgorithmName##_CTX hashObjectFor##hashAlgorithmName;                          \
    context.initFunction      = (FileHashInitFunction)&CC_##hashAlgorithmName##_Init;       \
    context.updateFunction    = (FileHashUpdateFunction)&CC_##hashAlgorithmName##_Update;   \
    context.finalFunction     = (FileHashFinalFunction)&CC_##hashAlgorithmName##_Final;     \
    context.digestLength      = CC_##hashAlgorithmName##_DIGEST_LENGTH;                     \
    context.hashObjectPointer = (uint8_t **)&hashObjectFor##hashAlgorithmName


@implementation BOXHashHelper

+ (NSString *)hashOfFileAtPath:(NSString *)filePath withComputationContext:(FileHashComputationContext *)context {
    NSString *result = nil;
    CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)filePath, kCFURLPOSIXPathStyle, (Boolean)false);
    CFReadStreamRef readStream = fileURL ? CFReadStreamCreateWithFile(kCFAllocatorDefault, fileURL) : NULL;
    BOOL didSucceed = readStream ? (BOOL)CFReadStreamOpen(readStream) : NO;
    if (didSucceed) {
        
        // Use default value for the chunk size for reading data.
        const size_t chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
        
        // Initialize the hash object
        (*context->initFunction)(context->hashObjectPointer);
        
        // Feed the data to the hash object.
        BOOL hasMoreData = YES;
        while (hasMoreData) {
            uint8_t buffer[chunkSizeForReadingData];
            CFIndex readBytesCount = CFReadStreamRead(readStream, (UInt8 *)buffer, (CFIndex)sizeof(buffer));
            if (readBytesCount == -1) {
                break;
            } else if (readBytesCount == 0) {
                hasMoreData = NO;
            } else {
                (*context->updateFunction)(context->hashObjectPointer, (const void *)buffer, (CC_LONG)readBytesCount);
            }
        }
        
        // Compute the hash digest
        unsigned char digest[context->digestLength];
        (*context->finalFunction)(digest, context->hashObjectPointer);
        
        // Close the read stream.
        CFReadStreamClose(readStream);
        
        // Proceed if the read operation succeeded.
        didSucceed = !hasMoreData;
        if (didSucceed) {
            char hash[2 * sizeof(digest) + 1];
            for (size_t i = 0; i < sizeof(digest); ++i) {
                snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
            }
            result = [NSString stringWithUTF8String:hash];
        }
        
    }
    if (readStream) CFRelease(readStream);
    if (fileURL)    CFRelease(fileURL);
    return result;
}

+ (NSString *)md5HashOfFileAtPath:(NSString *)filePath {
    FileHashComputationContext context;
    FileHashComputationContextInitialize(context, MD5);
    return [self hashOfFileAtPath:filePath withComputationContext:&context];
}

+ (NSString *)sha1HashOfFileAtPath:(NSString *)filePath {
    FileHashComputationContext context;
    FileHashComputationContextInitialize(context, SHA1);
    return [self hashOfFileAtPath:filePath withComputationContext:&context];
}

+ (NSString *)sha512HashOfFileAtPath:(NSString *)filePath {
    FileHashComputationContext context;
    FileHashComputationContextInitialize(context, SHA512);
    return [self hashOfFileAtPath:filePath withComputationContext:&context];
}

+ (NSData *)sha1HashDataOfData:(NSData *)data
{
    unsigned char digest[SHA_DIGEST_LENGTH];

    CC_SHA1([data bytes], (CC_LONG)[data length], digest);

    return [NSData dataWithBytes:&digest length:SHA_DIGEST_LENGTH];
}

+ (NSString *)sha1HashOfData:(NSData *)data
{
    unsigned char digest[SHA_DIGEST_LENGTH];
    char finaldigest[2*SHA_DIGEST_LENGTH];
    int i = 0;

    CC_SHA1([data bytes], (CC_LONG)[data length], digest);
    for (i=0; i<SHA_DIGEST_LENGTH; i++) {
        sprintf(finaldigest+i*2, "%02x", digest[i]);
    }

    return [NSString stringWithCString:finaldigest encoding:NSASCIIStringEncoding];
}

+ (NSString *)sha1HashOfALAsset:(ALAsset *)asset
{
    NSMutableString *hash = nil;
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    long long offset = 0;
    long long length = [representation size];
    
    uint8_t buffer[FileHashDefaultChunkSizeForReadingData];
    NSError *error = nil;
    
    CC_SHA1_CTX sha1Object;
    CC_SHA1_Init(&sha1Object);
    
    do {
        NSUInteger bytesRead = [representation getBytes:buffer fromOffset:offset length:FileHashDefaultChunkSizeForReadingData error:&error];
        if (error || bytesRead == 0) {
            break;
        }
        CC_SHA1_Update(&sha1Object, (const void *)buffer, (CC_LONG)bytesRead);
        offset += bytesRead;
    } while (offset < length);
    
    if (offset == length) {
        unsigned char digest[CC_SHA1_DIGEST_LENGTH];
        CC_SHA1_Final(digest, &sha1Object);
        
        hash = [NSMutableString string];
        
        NSInteger i;
        for (i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
            [hash appendFormat:@"%02x", (uint8_t)digest[i]];
        }
    }
    return hash;
}

@end
