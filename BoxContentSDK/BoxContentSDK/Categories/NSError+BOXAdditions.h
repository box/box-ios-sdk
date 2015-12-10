//
//  NSError+BOXAdditions.h
//  BoxSDK
//
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (BOXAdditions)

- (NSString *)box_localizedFailureReasonString;
- (NSString *)box_localizedShortFailureReasonString;

@end
