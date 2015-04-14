//
//  NSString+BOXURLHelper.h
//  BoxContentSDK
//
//  Created on 2/25/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Provides URL encoding extensions to `NSString`.
 */
@interface NSString (BOXURLHelper)

/**
 * Initialize an `NSString` that may be optionally URL encoded.
 *
 * @param string String to use to initialie returned value.
 * @param encoded Whether or not to URL encode string.
 *
 * @return A string that may or may not be URL encoded.
 */
+ (NSString *)box_stringWithString:(NSString *)string URLEncoded:(BOOL)encoded;

@end
