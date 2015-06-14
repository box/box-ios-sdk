//
//  BOXMetadataUpdate.m
//  BoxContentSDK
//
//  Created on 6/15/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXMetadataUpdateTask.h"
#import "BOXLog.h"

@implementation BOXMetadataUpdateTask

- (instancetype)initWithOperation:(BOXMetadataUpdateOperation)operation path:(NSString *)path value:(NSString *)value
{
    if (self = [self init]) {
        NSString *formatString = nil;
        if (path) {
            formatString = @"/%@";
            if ([path characterAtIndex:0] == '/') {
                formatString = @"%@";
            }
        }
        
        self.value = value;
        self.path = [NSString stringWithFormat:formatString, path];
        self.operation = operation;
        
        [self validate];
    }
    
    return self;
}

// Validate is not meant to be user-facing method and is an internal helper to verify that properties are valid.
- (void)validate
{
    BOXAssert([self BOXMetadataUpdateOperationToString:self.operation], @"The operation parameter for BOXMetadataUpdateTask cannot be nil. Please make sure to use an ENUM within BOXMetadataUpdateOperation.");
    BOXAssert(self.path, @"The path parameter for BOXMetadataUpdateTask cannot be nil");
    BOXAssert(!(self.operation == BOXMetadataUpdateADD || self.operation == BOXMetadataUpdateREPLACE) || self.value, @"The value parameter cannot be nil when using BOXMetadataUpdateADD or BOXMetadataUpdateREPLACE.");
}

// BOXMetadataUpdateOperationToString is not meant to be user-facing method and is an internal helper for making
// POST requests when updating metadata information.
- (NSString *)BOXMetadataUpdateOperationToString:(BOXMetadataUpdateOperation)operation
{
    switch (operation) {
        case BOXMetadataUpdateADD:
            return @"add";
        case BOXMetadataUpdateREMOVE:
            return @"remove";
        case BOXMetadataUpdateREPLACE:
            return @"replace";
        case BOXMetadataUpdateTEST:
            return @"test";
        default:
            BOXAssertFail(@"Unidentified BOXMetadataUpdateOperation received. Please send in a valid BOXMetadataUpdateOperation enum value");
    }
}

@end
