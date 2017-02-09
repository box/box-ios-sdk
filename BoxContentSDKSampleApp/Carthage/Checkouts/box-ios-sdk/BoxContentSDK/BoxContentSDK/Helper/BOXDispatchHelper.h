//
//  BOXThreadHelper.h
//  app
//
//  Copyright (c) 2014 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOXDispatchHelper : NSObject

+ (void)callBlockOnSerialBackgroundQueue:(dispatch_block_t)block;
+ (void)callCompletionBlock:(dispatch_block_t)block onMainThread:(BOOL)onMainThread;

@end
