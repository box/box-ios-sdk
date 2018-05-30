//
//  BOXStreamingHashHelper.m
//  BoxContentSDK
//
//  Created by Prithvi Jutur on 5/21/18.
//  Copyright © 2018 Box. All rights reserved.
//

#import "BOXHashHelper.h"
    
#include <CommonCrypto/CommonDigest.h>
#import "BOXLog.h"
#import "BOXStreamingHashHelper.h"

@interface BOXStreamingHashHelper()
@property (nonatomic, assign) CC_SHA1_CTX context;
@property (nonatomic, assign) BOOL processing;
@end

@implementation BOXStreamingHashHelper

-(instancetype) init {
    self = [super init];
    if (self) {
        _processing = NO;
    }
    return self;
}

- (void) open {
    self.processing = YES;
    CC_SHA1_Init(&_context);
}

- (void) processData:(NSData* ) buffer {
    BOXAssert(self.processing, @"Stream must be re-opened before processing begins");
    CC_SHA1_Update(&_context, [buffer bytes], (CC_LONG)buffer.length);
}

- (NSString *) close {
    BOXAssert(self.processing, @"Stream must be open before it can be closed");
    self.processing = NO;
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(digest, &_context);

    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
           snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    return [NSString stringWithUTF8String:hash];
}

@end
