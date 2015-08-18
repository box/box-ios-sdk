//
//  ALAssetRepresentationMock.m
//  BoxContentSDK
//
//  Created by Jeremy Pang on 1/6/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "ALAssetRepresentationMock.h"

@implementation ALAssetRepresentationMock

- (long long)size
{
    return [self.data length];
}

- (NSUInteger)getBytes:(uint8_t *)buffer fromOffset:(long long)offset length:(NSUInteger)length error:(NSError *__autoreleasing *)error
{
    if (offset + length > self.size) {
        length = (NSUInteger)(self.size - offset);
    }
    NSRange range = NSMakeRange((NSUInteger)offset, length);
    [self.data getBytes:buffer range:range];
    return length;
}

@end
