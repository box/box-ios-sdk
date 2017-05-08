//
//  NSString+BOXURLHelper.m
//  BoxContentSDK
//
//  Created on 2/25/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "NSString+BOXURLHelper.h"

@implementation NSString (BOXURLHelper)

+ (NSString *)box_stringWithString:(NSString *)string URLEncoded:(BOOL)encoded
{
    if (encoded)
    {
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"] invertedSet];
        string = [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    }

    return [NSString stringWithString:string];
}

@end
