//
//  BOXAPIOperation_Private.h
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/7/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXAPIOperation.h"

typedef enum {
    BOXAPIOperationStateReady = 1,
    BOXAPIOperationStateExecuting,
    BOXAPIOperationStateFinished
} BOXAPIOperationState;

@interface BOXAPIOperation ()

#pragma mark - NSOperation state
@property (nonatomic, readwrite, assign) BOXAPIOperationState state;

#pragma mark initializers
- (instancetype)initWithSession:(BOXAbstractSession *)session;

#pragma mark - Thread keepalive
+ (NSThread *)globalAPIOperationNetworkThread;
+ (void)globalAPIOperationNetworkThreadEntryPoint:(id)sender;

#pragma mark - Thread entry points for operation
- (void)executeOperation;

#pragma mark error methods
- (BOOL)shouldErrorTriggerLogout:(NSError *)error;

#pragma notification methods
- (void)sendLogoutNotification;

@end