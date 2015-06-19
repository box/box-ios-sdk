//
//  BOXAppSession.h
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/3/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXAbstractSession.h"

/**
 * BOXAppUserSession is an implementation of the abstract class BOXAbstractSession.
 * This session allows for many operations to be in-progress at once.
 *
 * BOXAppUserSession is intended to be used in conjunction with a BOXParallelAPIQueueManager.
 * Both classes assume many concurrent [BOXAPIOperations]([BOXAPIOperation])s. All BOXAPIOperation instances
 * hold a copy of the token they were signed with and pass that to the session when attempting a
 * refresh. This prevents multiple refresh attempts from the same set of tokens.
 */
@interface BOXAppUserSession : BOXAbstractSession

/**
 * A convenience method used to authorize an access token.
 *
 * **Note** BOXAppUserSession does not post a BOXSessionDidBecomeAuthenticatedNotification. 
 * Instead it will always post a BOXSessionDidRefreshTokensNotification as a replacement to BOXSessionDidBecomeAuthenticatedNotification
 * since refresh and authorization of access tokens are the same when using App Users.
 *
 * @param block The completion block that runs after authorizing a access token regardless of whether authorization is successful or not.
 */
- (void)performAuthorizationWithCompletionBlock:(void (^)(BOXAppUserSession *session, NSError *error))block;

/**
 * The method used to authorize an accessToken.
 * 
 * @param URL The URL recieved will authorize an access token
 * @param block The completion block that runs after authorizing a access token regardless of whether authorization is successful or not.
 */
- (void)performAuthorizationCodeGrantWithReceivedURL:(NSURL *)URL withCompletionBlock:(void (^)(BOXAppUserSession *, NSError *))block;

/**
 * The method refreshes an expired access token.
 *
 * @param expiredAccessToken The expired access token.
 * @param block The completion block that runs after authorizing a access token regardless of whether authorization is successful or not.
 */
- (void)performRefreshTokenGrant:(NSString *)expiredAccessToken withCompletionBlock:(void (^)(BOXAppUserSession *, NSError *))block;

@end
