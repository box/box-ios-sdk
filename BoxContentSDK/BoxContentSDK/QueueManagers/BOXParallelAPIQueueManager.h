//
//  BOXParallelAPIQueueManager.h
//  BoxContentSDK
//
//  Created on 5/11/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXAPIQueueManager.h"

/**
 * BOXParallelAPIQueueManager is an implementation of the abstract class BOXAPIQueueManager.
 * This queue manager allows many concurrent operations at a time. This means that at any
 * given time, only many API calls may be in progress.
 *
 * BOXParallelAPIQueueManager is intended to be used in conjunction with a BOXParallelOAuth2Session/BOXAppUserSession.
 * Both classes assume many concurrent [BOXAPIOperations]([BOXAPIOperation])s. To ensure that the
 * tokens will not get thrashed by concurrent refreshes of the same token, BOXParallelOAuth2Session/BOXAppUserSession
 * stores a set of all access tokens that have triggered a token refresh. All BOXAPIOperation instances
 * hold a copy of the token they were signed with and pass that to the OAuth2 session when attempting a
 * refresh. This prevents multiple refresh attempts from the same set of tokens.
 *
 * BOXParallelAPIQueueManager allows 10 concurrent download operations, 10 concurrent upload operations
 * and 1 concurrent operation for all other API calls.
 */
@interface BOXParallelAPIQueueManager : BOXAPIQueueManager

/** @name NSOperationQueues */

/**
 * The NSOperationQueue on which all BOXAPIOperations other than uploads
 * and downloads are enqueued. This queue is configured
 * with `maxConcurrentOperationCount = 8`.
 */
@property (nonatomic, readwrite, strong) NSOperationQueue *globalQueue;

/**
 * The NSOperationQueue on which all BOXAPIDataOperations 
 * are enqueued. This queue is configured
 * with `maxConcurrentOperationCount = 2`.
 */
@property (nonatomic, readwrite, strong) NSOperationQueue *downloadsQueue;

/**
 * The NSOperationQueue on which all BOXAPIMultipartToJSONOperations
 * are enqueued. This queue is configured
 * with `maxConcurrentOperationCount = 2`.
 */
@property (nonatomic, readwrite, strong) NSOperationQueue *uploadsQueue;

/** @name Designated initializer */

/**
 * In addition to calling super, this method sets `globalQueue.maxConcurrentOperationCount` to `1`
 * @param session This object is needed for locking
 */
- (id)initWithSession:(BOXAbstractSession *)session;

/** @name Enqueue Operations */

/**
 * Enqueues operation to be executed. This method calls [BOXAPIQueueManager enqueueOperation:].
 *
 * This method synchronizes on session.
 *
 * @param operation The BOXAPIOperation to be enqueued for execution
 */
- (BOOL)enqueueOperation:(BOXAPIOperation *)operation;


@end
