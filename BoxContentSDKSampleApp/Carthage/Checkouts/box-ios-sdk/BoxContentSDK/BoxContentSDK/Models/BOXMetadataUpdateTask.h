//
//  BOXMetadataUpdate.h
//  BoxContentSDK
//
//  Created on 6/15/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOXMetadataKeyValue.h"

/**
 * ENUM that defines all possible operations available to the BOXMetadataUpdateTask class.
 */
typedef enum : NSUInteger {
    
    /**
     * Add Operation
     */
    BOXMetadataUpdateADD,
    
    /**
     * Replace Operation.
     */
    BOXMetadataUpdateREPLACE,
    
    /**
     * Remove Operation.
     */
    BOXMetadataUpdateREMOVE,
    
    /**
     * Test Operation.
     */
    BOXMetadataUpdateTEST
} BOXMetadataUpdateOperation;

/**
 * BOXMetadataUpdateTask instances are used for updating metadata with @see BOXMetadataUpdateRequest.
 */
@interface BOXMetadataUpdateTask : NSObject

/**
 * Operation that will be applied for this BOXMetadataUpdateTask instance.
 */
@property (nonatomic, readwrite, assign) BOXMetadataUpdateOperation operation;

/**
 * The path (aka. key) for a metadata attribute.
 */
@property (nonatomic, readwrite, strong) NSString *path;

/**
 * The value for a metadata attribute.
 */
@property (nonatomic, readwrite, strong) NSString *value;

/**
 * Initializes a BOXMetadataUpdateTask with a given operation to apply to a key/value pair.
 *
 * @param operation The operation to apply.
 * @param path The path (aka. key) 
 * @param value The value for the path.
 *
 * @return A BOXMetadataUpdateTask with a given operation to apply to a key/value pair.
 */
- (instancetype)initWithOperation:(BOXMetadataUpdateOperation)operation path:(NSString *)path value:(NSString *)value;

/**
 * Converts a BOXMetadataUpdateOperation ENUM value to a string.
 */
- (NSString *)BOXMetadataUpdateOperationToString:(BOXMetadataUpdateOperation)operation;

@end