//
//  BOXAPIQueueManager.m
//  BoxContentSDK
//
//  Created on 2/28/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXAPIQueueManager.h"

#import "BOXAPIOperation.h"
#import "BOXAPIOAuth2ToJSONOperation.h"
#import "BOXAPIAppUsersAuthOperation.h"
#import "BOXLog.h"

/**
 * This internal extension provides a notification callback for completed
 * [BOXAPIOAuth2ToJSONOperations](BOXAPIOAuth2ToJSONOperation) and [BOXAPIAppAuthOperation](BOXAPIAppAuthOperation).
 */
@interface BOXAPIQueueManager ()

/** @name BOXAPIQueueManager() methods */

/**
 * This method listens for notifications of type `BOXAuthOperationDidComplete` received from
 * [BOXAPIOAuth2ToJSONOperations](BOXAPIOAuth2ToJSONOperation) and [BOXAPIAppAuthOpeartion](BOXAPIAppAuthOperation) that indicate these
 * operations have completed.
 *
 * Upon receiving this notification, the queue manager removes the BOXAPIOAuth2ToJSONOperation/BOXAPIAppAuthOperation from
 * the set enqueuedAuthOperations, which means that future BOXAPIOperation instances will not
 * be dependent upon this BOXAPIOAuth2ToJSONOperation/BOXAPIAppAuthOperation.
 *
 * @warning This method is defined in a private category in BOXAPIQueueManager.m
 *
 * @param notification the notification broadcast by a BOXAPIOAuth2ToJSONOperation/BOXAPIAppAuthOperation when it completes
 */
- (void)AuthOperationDidComplete:(NSNotification *)notification;

@end

@implementation BOXAPIQueueManager

@synthesize session = _session;
@synthesize enqueuedAuthOperations = _enqueuedAuthOperations;

- (id)initWithSession:(BOXAbstractSession *)session
{
    self = [super init];
    if (self != nil)
    {
        _session = session;
        _enqueuedAuthOperations = [NSMutableSet set];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)enqueueOperation:(BOXAPIOperation *)operation
{
    BOXAssert(![self.session isKindOfClass:[BOXAppUserSession class]] || self.delegate, @"BOXAPIAccessTokenDelegate must be set when using App Users. Please call setAccessTokenDelegate on BOXContentClient.");
    
    if ([operation isKindOfClass:[BOXAPIOAuth2ToJSONOperation class]] || [operation isKindOfClass:[BOXAPIAppUsersAuthOperation class]])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AuthOperationDidComplete:) name:BOXAuthOperationDidCompleteNotification object:operation];
    }

    return YES;
}

- (void)AuthOperationDidComplete:(NSNotification *)notification
{
    @synchronized(self.session)
    {
        BOXAPIOperation *operation = (BOXAPIOperation *)notification.object;
        BOXLog(@"%@ completed. Removing from set of Auth dependencies", operation);
        [self.enqueuedAuthOperations removeObject:operation];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:BOXAuthOperationDidCompleteNotification object:operation];
    }
}

- (BOOL)addDependency:(NSOperation *)dependency toOperation:(NSOperation *)operation
{
    BOOL dependencyAdded = NO;

    // acquire the global API Operation lock before adding dependencies to
    // ensure operation cannot be started before adding dependency.
    [[BOXAPIOperation APIOperationGlobalLock] lock];

    // operation may have started before acquiring the lock. Now that we have the lock,
    // no other operations can start. Only add the dependency if operation has not
    // started executing.
    if (!operation.isExecuting)
    {
        [operation addDependency:dependency];
        dependencyAdded = YES;
    }

    [[BOXAPIOperation APIOperationGlobalLock] unlock];

    return dependencyAdded;
}

- (void)cancelAllOperations
{
    for (BOXAPIOperation *operation in self.enqueuedAuthOperations) {
        [operation cancel];
    }
}

@end
