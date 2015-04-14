//
//  NSDate+BOXAdditions.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/12/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "NSDate+BOXAdditions.h"
#import "BoxISO8601DateFormatter.h"

@implementation NSDate (BOXAdditions)

+ (NSDate *)box_dateWithISO8601String:(NSString *)timestamp
{
    static BOXISO8601DateFormatter *dateFormatter;
    static dispatch_once_t pred;
    
    if (dateFormatter == nil)
    {
        // use one date formatter for all models
        dispatch_once(&pred, ^{
            dateFormatter = [[BOXISO8601DateFormatter alloc] init];
            dateFormatter.parsesStrictly = YES;
        });
    }
    
    NSDate *returnDate = nil;
    if (timestamp != nil)
    {
        returnDate = [dateFormatter dateFromString:timestamp];
    }
    
    return returnDate;
}

- (NSString *)box_ISO8601String
{
    static BOXISO8601DateFormatter *dateFormatter;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        dateFormatter = [[BOXISO8601DateFormatter alloc] init];
        dateFormatter.parsesStrictly = YES;
        dateFormatter.format = BOXISO8601DateFormatCalendar;
        dateFormatter.includeTime = YES;
        dateFormatter.defaultTimeZone = [[NSTimeZone alloc] initWithName:@"UTC"];
    });
    
    return [dateFormatter stringFromDate:self];
}

@end
