//
//  BOXMetadataKeyValue.m
//  BoxContentSDK
//
//  Created on 6/15/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXMetadataKeyValue.h"
#import "BOXLog.h"

@implementation BOXMetadataKeyValue

- (instancetype)initWithPath:(NSString *)path value:(NSString *)value
{
    if (self = [self init]) {
        self.path = path;
        self.value = value;
        
        [self validate];
    }
    
    return self;
}

// Validate is not meant to be user-facing method and is an internal helper to verify that properties are valid.
- (void)validate
{
    BOXAssert(self.path, @"Key cannot be nil when initializing an instance of BOXMetadataKeyValue");
    BOXAssert(self.value, @"Value cannot be nil when initializing an instance of BOXMetadataKeyValue");
}

@end