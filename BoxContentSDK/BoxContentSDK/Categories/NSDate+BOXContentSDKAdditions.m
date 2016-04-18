//
//  NSDate+BOXAdditions.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/12/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "NSDate+BOXContentSDKAdditions.h"
#import "BoxISO8601DateFormatter.h"

@implementation NSDate (BOXContentSDKAdditions)

+ (NSDate *)box_dateWithISO8601String:(NSString *)timestamp
{
    static NSString *token = @"boxdateformatter";
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
        // Add @synchronized because this is not thread safe
        @synchronized(token) {
            returnDate = [dateFormatter dateFromString:timestamp];
        }
    }
    
    return returnDate;
}

- (NSString *)box_ISO8601String
{
    static NSString *token = @"box_iso8601stringToken";
    static BOXISO8601DateFormatter *dateFormatter;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        dateFormatter = [[BOXISO8601DateFormatter alloc] init];
        dateFormatter.parsesStrictly = YES;
        dateFormatter.format = BOXISO8601DateFormatCalendar;
        dateFormatter.includeTime = YES;
        dateFormatter.defaultTimeZone = [[NSTimeZone alloc] initWithName:@"UTC"];
    });

    NSString *dateString = nil;
    @synchronized (token) {
        dateString = [dateFormatter stringFromDate:self];
    }
    return dateString;
}

@end
