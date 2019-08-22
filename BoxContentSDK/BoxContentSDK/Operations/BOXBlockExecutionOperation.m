//
//  BOXBlockExecutionOperation.m
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 8/21/19.
//  Copyright © 2019 Box. All rights reserved.
//

#import <BOXContentSDK/BOXBlockExecutionOperation.h>
#import "BOXLog.h"
#import "BOXContentSDKErrors.h"
#import "BOXAPIOperation_Private.h"

@implementation BOXBlockExecutionOperation

#pragma mark - NSOperation

- (void)executeOperation
{
    BOXLog(@"BOXBlockExecutionOperation %@ was started", self);
    if (![self isCancelled]) {
        self.execution();
    } else {
        BOXLog(@"BOXBlockExecutionOperation %@ was cancelled -- short circuiting and not call execution block", self);
        self.error = [NSError errorWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKAPIUserCancelledError userInfo:nil];
    }
    [self finish];
}

@end
