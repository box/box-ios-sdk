//
//  BOXMetadataKeyValue.h
//  BoxContentSDK
//
//  Created on 6/15/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * BOXMetadataKeyValue instances are used for creating metadata key/value pairs.
 */
@interface BOXMetadataKeyValue : NSObject

/**
 * The path (aka. key) for a metadata attribute.
 */
@property (nonatomic, readwrite, strong) NSString *path;

/**
 * The value for a metadata attribute.
 */
@property (nonatomic, readwrite, strong) NSString *value;

/**
 * Initializes a BOXMetadataKeyValue with a given operation to apply to a key/value pair.
 *
 * @param path The path (aka. key)
 * @param value The value for the path.
 *
 * @return A BOXMetadataKeyValue with a key/value pair.
 */
- (instancetype)initWithPath:(NSString *)path value:(NSString *)value;

@end
