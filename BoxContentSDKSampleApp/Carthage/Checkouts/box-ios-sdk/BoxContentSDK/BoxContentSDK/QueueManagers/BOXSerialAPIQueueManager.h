//
//  BOXSerialAPIQueueManager.h
//  BoxContentSDK
//
//  Created on 2/28/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXAPIQueueManager.h"

/**
 * BOXSerialAPIQueueManager is an implementation of the abstract class BOXAPIQueueManager.
 * This queue manager allows only one concurrent operation at a time. This means that at any
 * given time, only one API call will be in progress.
 *
 * This class is intended to be used in conjunction with a BOXSerialOAuth2Session. Both classes
 * assume one concurrent BOXAPIOperation. This assumption enables the locking strategy with regard
 * to access token refresh to be simplified. Whenever any BOXAPIOAuth2ToJSONOperation is enqueued,
 * it is added as a dependency to all currently enqueued operations as well as operations enqueued
 * before the OAuth2 operation completes.
 */
@interface BOXSerialAPIQueueManager : BOXAPIQueueManager

/** @name NSOperationQueues */

/**
 * The NSOperationQueue on which all BOXAPIOperations are enqueued. This queue is configured
 * with `maxConcurrentOperationCount = 1`.
 */
@property (nonatomic, readwrite, strong) NSOperationQueue *globalQueue;

/** @name Designated initializer */

/**
 * In addition to calling super, this method sets `globalQueue.maxConcurrentOperationCount` to `1`
 * @param OAuth2Session This object is needed for locking
 */
- (id)initWithSession:(BOXAbstractSession *)session;

/** @name Enqueue Operations */

/**
 * Enqueues operation on globalQueue to be executed. This method calls [BOXAPIQueueManager enqueueOperation:].
 *
 * This method synchronizes on session.
 *
 * @param operation The BOXAPIOperation to be enqueued for execution
 */
- (BOOL)enqueueOperation:(BOXAPIOperation *)operation;

@end
