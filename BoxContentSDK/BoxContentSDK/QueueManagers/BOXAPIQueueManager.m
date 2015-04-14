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
#import "BOXLog.h"

/**
 * This internal extension provides a notification callback for completed
 * [BOXAPIOAuth2ToJSONOperations](BOXAPIOAuth2ToJSONOperation).
 */
@interface BOXAPIQueueManager ()

/** @name BOXAPIQueueManager() methods */

/**
 * This method listens for notifications of type `BOXOAuth2OperationDidComplete` received from
 * [BOXAPIOAuth2ToJSONOperations](BOXAPIOAuth2ToJSONOperation) that indicate these
 * operations have completed.
 *
 * Upon receiving this notification, the queue manager removes the BOXAPIOAuth2ToJSONOperation from
 * the set enqueuedOAuth2Operations, which means that future BOXAPIOperation instances will not
 * be dependent upon this BOXAPIOAuth2ToJSONOperation.
 *
 * @warning This method is defined in a private category in BOXAPIQueueManager.m
 *
 * @param notification the notification broadcast by a BOXAPIOAuth2ToJSONOperation when it completes
 */
- (void)OAuth2OperationDidComplete:(NSNotification *)notification;

@end

@implementation BOXAPIQueueManager

@synthesize OAuth2Session = _OAuth2Session;
@synthesize enqueuedOAuth2Operations = _enqueuedOAuth2Operations;

- (id)initWithOAuth2Session:(BOXOAuth2Session *)OAuth2Session
{
    self = [super init];
    if (self != nil)
    {
        _OAuth2Session = OAuth2Session;
        _enqueuedOAuth2Operations = [NSMutableSet set];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)enqueueOperation:(BOXAPIOperation *)operation
{
    if ([operation isKindOfClass:[BOXAPIOAuth2ToJSONOperation class]])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OAuth2OperationDidComplete:) name:BOXOAuth2OperationDidCompleteNotification object:operation];
    }

    return YES;
}

- (void)OAuth2OperationDidComplete:(NSNotification *)notification
{
    @synchronized(self.OAuth2Session)
    {
        BOXAPIOAuth2ToJSONOperation *operation = (BOXAPIOAuth2ToJSONOperation *)notification.object;
        BOXLog(@"%@ completed. Removing from set of OAuth2 dependencies", operation);
        [self.enqueuedOAuth2Operations removeObject:operation];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:BOXOAuth2OperationDidCompleteNotification object:operation];
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
    for (BOXAPIOperation *operation in self.enqueuedOAuth2Operations) {
        [operation cancel];
    }
}

@end
