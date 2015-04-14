//
//  BOXThreadHelper.m
//  app
//
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXDispatchHelper.h"

@implementation BOXDispatchHelper

+ (void)callBlockOnSerialBackgroundQueue:(dispatch_block_t)block
{
    static dispatch_queue_t __serialQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __serialQueue = dispatch_queue_create("net.box.serialqueue", DISPATCH_QUEUE_SERIAL);
    });

    dispatch_async(__serialQueue, ^{
        block();
    });
}

+ (void)callCompletionBlock:(dispatch_block_t)block onMainThread:(BOOL)onMainThread
{
    if (block) {
        if (onMainThread) {
            if ([NSThread isMainThread]) {
                block();
            } else {
                dispatch_async(dispatch_get_main_queue(), block);
            }
        } else {
            block();
        }
    }
}

@end
