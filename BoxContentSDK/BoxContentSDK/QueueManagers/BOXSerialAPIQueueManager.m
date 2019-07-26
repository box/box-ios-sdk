//
//  BOXSerialAPIQueueManager.m
//  BoxContentSDK
//
//  Created on 2/28/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXSerialAPIQueueManager.h"

#import "BOXAPIOperation.h"
#import "BOXAPIOAuth2ToJSONOperation.h"
#import "BOXAPIAppUsersAuthOperation.h"
#import "BOXLog.h"
#import "BOXOAuth2Session.h"

@implementation BOXSerialAPIQueueManager

@synthesize globalQueue = _globalQueue;

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
        _globalQueue.name = @"BOXSerialAPIQueueManager global queue";
        _globalQueue.maxConcurrentOperationCount = 1;
    }

    return self;
}

- (BOOL)enqueueOperation:(BOXAPIOperation *)operation
{
    // lock on the OAuth2Session, which is the shared resource
    @synchronized(self.session)
    {
        [super enqueueOperation:operation];

        // ensure that authenation operations occur before all other operations
        if ([operation isKindOfClass:[BOXAPIOAuth2ToJSONOperation class]] || [operation isKindOfClass:[BOXAPIAppUsersAuthOperation class]])
        {
            // hold a refernce to the pending authenation operation so it can be added
            // as a dependency to all APIOperations enqueued before it finishes
            [self.enqueuedAuthOperations addObject:operation];

            for (NSOperation *enqueuedOperation in self.globalQueue.operations)
            {
                // All API Operations should be dependent on authenation operations EXCEPT other
                // authenation operations. For example, if a client requests 5 subsequent token refreshes,
                // All authenticated operations should depend on these requests resolving, but these
                // requests do not depend on each other
                if (![enqueuedOperation isKindOfClass:[BOXAPIOAuth2ToJSONOperation class]] && ![enqueuedOperation isKindOfClass:[BOXAPIAppUsersAuthOperation class]])
                {
                    [self addDependency:operation toOperation:enqueuedOperation];
                }
            }
        }
        else
        {
            // If there are any incomplete authenation operations, add them as dependencies for
            // this newly enqueued operation. authenation operations have the potential to change
            // the access token, which Authenticated operations need in order to complete
            // successfully.
            for (NSOperation *pendingAuthOperation in self.enqueuedAuthOperations)
            {
                [self addDependency:pendingAuthOperation toOperation:operation];

            }
        }

        [self.globalQueue addOperation:operation];
        BOXLog(@"enqueued %@", operation);
        
        return YES;
    }
}

@end
