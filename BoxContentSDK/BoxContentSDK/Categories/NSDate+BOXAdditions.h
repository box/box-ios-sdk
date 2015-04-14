//
//  NSDate+BOXAdditions.h
//  BoxContentSDK
//
//  Created by Rico Yao on 12/12/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (BOXAdditions)

+ (NSDate *)box_dateWithISO8601String:(NSString *)timestamp;

- (NSString *)box_ISO8601String;

@end
