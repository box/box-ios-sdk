//
//  BOXAPIOperation_Private.h
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/7/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXAPIOperation.h"

typedef NS_ENUM(NSUInteger, BOXAPIOperationState) {
    BOXAPIOperationStateReady = 1,
    BOXAPIOperationStateExecuting,
    BOXAPIOperationStateFinished
};

@interface BOXAPIOperation ()

#pragma mark - NSOperation state
@property (nonatomic, readwrite, assign) BOXAPIOperationState state;

@property (nonatomic, readwrite, strong) NSURLSessionTask *sessionTask;

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

//to create an NSURLSessionTask appropriate for this type of api operation
- (NSURLSessionTask *)createSessionTask;

@end
