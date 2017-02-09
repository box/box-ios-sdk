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
        string = (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                        (__bridge CFStringRef) string,
                                                                                        NULL,
                                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                        kCFStringEncodingUTF8);
    }

    return [NSString stringWithString:string];
}

@end
