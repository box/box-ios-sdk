//
//  BOXParallelAPIQueueManager.m
//  BoxContentSDK
//
//  Created on 5/11/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXParallelAPIQueueManager.h"

#import "BOXAPIDataOperation.h"
#import "BOXAPIOAuth2ToJSONOperation.h"
#import "BOXAPIMultipartToJSONOperation.h"
#import "BOXLog.h"
#import "BOXAPIAppUsersAuthOperation.h"

@interface BOXParallelAPIQueueManager ()

@property (atomic, readwrite, assign) BOOL currentAccessTokenHasExpired;

@end

@implementation BOXParallelAPIQueueManager

@synthesize globalQueue = _globalQueue;
@synthesize downloadsQueue = _downloadsQueue;
@synthesize uploadsQueue = _uploadsQueue;

@synthesize currentAccessTokenHasExpired = _currentAccessTokenHasExpired;

- (id)init
{
    self = [self initWithSession:nil];
    return self;
}

- (id)initWithSession:(BOXAbstractSession *)session
{
    self = [super initWithSession:session];
    if (self != nil)
    {
        _globalQueue = [[NSOperationQueue alloc] init];
        _globalQueue.name = @"BOXParallelAPIQueueManager global queue";
        _globalQueue.maxConcurrentOperationCount = 8;

        _downloadsQueue = [[NSOperationQueue alloc] init];
        _downloadsQueue.name = @"BOXParallelAPIQueueManager download queue";
        _downloadsQueue.maxConcurrentOperationCount = 2;

        _uploadsQueue = [[NSOperationQueue alloc] init];
        _uploadsQueue.name = @"BOXParallelAPIQueueManager upload queue";
        _uploadsQueue.maxConcurrentOperationCount = 2;

        _currentAccessTokenHasExpired = NO;
    }

    return self;
}

- (BOOL)enqueueOperation:(BOXAPIOperation *)operation
{
    // lock on the session, which is the shared resource
    @synchronized(self.session)
    {
        [super enqueueOperation:operation];

        // ensure that authentication operations occur before all other operations
        if ([operation isKindOfClass:[BOXAPIOAuth2ToJSONOperation class]] || [operation isKindOfClass:[BOXAPIAppUsersAuthOperation class]])
        {
            // hold a refernce to the pending authentication operation so it can be added
            // as a dependency to all APIOperations enqueued before it finishes
            [self.enqueuedAuthOperations addObject:operation];

            for (NSOperation *enqueuedOperation in self.globalQueue.operations)
            {
                // All API Operations should be dependent on authentication operations EXCEPT other
                // authentication operations. For example, if a client requests 5 subsequent token refreshes,
                // All authenticated operations should depend on these requests resolving, but these
                // requests do not depend on each other
                if (![enqueuedOperation isKindOfClass:[BOXAPIOAuth2ToJSONOperation class]] && ![enqueuedOperation isKindOfClass:[BOXAPIAppUsersAuthOperation class]])
                {
                    [self addDependency:operation toOperation:enqueuedOperation];
                }
            }
            for (NSOperation *enqueuedOperation in self.downloadsQueue.operations)
            {
                [self addDependency:operation toOperation:enqueuedOperation];

            }
            for (NSOperation *enqueuedOperation in self.uploadsQueue.operations)
            {
                [self addDependency:operation toOperation:enqueuedOperation];

            }
        }
        else
        {
            // If there are any incomplete authentication operations, add them as dependencies for
            // this newly enqueued operation. Authentication operations have the potential to change
            // the access token, which Authenticated operations need in order to complete
            // successfully.
            for (NSOperation *pendingAuthOperation in self.enqueuedAuthOperations)
            {
                [self addDependency:pendingAuthOperation toOperation:operation];
            }
        }

        if ([operation isKindOfClass:[BOXAPIDataOperation class]])
        {
            [self.downloadsQueue addOperation:operation];
            BOXLog(@"enqueued %@ on download queue", operation);
        }
        else if ([operation isKindOfClass:[BOXAPIMultipartToJSONOperation class]])
        {
            [self.uploadsQueue addOperation:operation];
            BOXLog(@"enqueued %@ on upload queue", operation);
        }
        else
        {
            [self.globalQueue addOperation:operation];
            BOXLog(@"enqueued %@ on global queue", operation);
        }

        return YES;
    }
}


@end
