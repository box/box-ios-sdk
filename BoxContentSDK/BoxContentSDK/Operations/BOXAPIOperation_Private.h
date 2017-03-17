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

/**
 * Create an NSURLSessionTask appropriate for this type of api operation
 *
 * @param outError  error if failed to create a session task
 *
 * @return a session task
 */
- (NSURLSessionTask *)createSessionTaskWithError:(NSError **)outError;

/**
 * Specify if a background download operation should be cancelled by producing resume data to be able
 * to resume from where it was left off in another operation later.
 */
- (BOOL)shouldAllowResume;

@end
