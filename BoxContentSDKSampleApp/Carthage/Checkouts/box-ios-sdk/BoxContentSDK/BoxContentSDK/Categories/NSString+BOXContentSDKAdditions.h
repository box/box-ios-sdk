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
@interface NSString (BOXContentSDKAdditions)

/**
 * @return a readable string of the size of the item.
 *
 * @param size File size in bytes.
 */
+ (NSString *)box_humanReadableStringForByteSize:(NSNumber *)size;

/**
 * @return whether a string is empty or constructed completely
 * of space and/or newline characters.
 *
 */
- (BOOL)box_isEmptyOrWhitespacesOnly;

/**
 *  @return Returns the extension of a file with multiple extensions (some iWork files have .xxx.zip file extensions).
 */
- (NSString *)box_pathExtensionAccountingForZippedPackages;

/**
 *  @return The string where all trailing spaces will have been removed 
 */
- (NSString *)box_stringByTrimmingTrailingSpaces;

/**
 *  @return The string whose path extension has been removed, even if it had multiple path extensions.
 */
- (NSString *)box_stringByDeletingMultiplePathExtensionsIfNecessary;

/**
 *  @return The path extension accounting for empty name, where Apple's pathExtension method is inaccurate.
 */
- (NSString *)box_fileNameExtensionAccountingForEmptyName;

/**
 *  @return a properly escaped string.
 */
- (NSString *)box_stringByAddingURLPercentEscapes;

@end
