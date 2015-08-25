//
//  NSString+BOXAdditions.h
//  BoxContentSDK
//
//  Created on 6/3/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * The BoxAdditions category on NSString provides a method for
 * generating strings representing file size.
 */
@interface NSString (BOXAdditions)

/**
 * Returns a readable string of the size of the item.
 *
 * @param size File size in bytes.
 */
+ (NSString *)box_humanReadableStringForByteSize:(NSNumber *)size;

/**
 * Returns whether a string is empty or constructed completely
 * of space and/or newline characters.
 *
 */
- (BOOL)box_isEmptyOrWhitespacesOnly;

@end
