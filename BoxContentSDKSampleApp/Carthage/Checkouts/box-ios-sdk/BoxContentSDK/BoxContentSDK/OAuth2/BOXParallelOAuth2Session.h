//
//  BOXParallelOAuth2Session.h
//  BoxContentSDK
//
//  Created on 5/11/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXOAuth2Session.h"

/**
 * BOXParallelOAuth2Session is an implementation of the abstract class BOXOAuth2Session.
 * This OAuth2 session assumes there are many concurrent operations at a time. This means
 * that at any given time, only several API calls may be in progress.
 *
 * BOXParallelOAuth2Session is intended to be used in conjunction with a BOXParallelAPIQueueManager.
 * Both classes assume many concurrent [BOXAPIOperations]([BOXAPIOperation])s. To ensure that the
 * tokens will not get thrashed by concurrent refreshes of the same token, BOXParallelOAuth2Session
 * stores a set of all access tokens that have triggered a token refresh. All BOXAPIOperation instances
 * hold a copy of the token they were signed with and pass that to the OAuth2 session when attempting a
 * refresh. This prevents multiple refresh attempts from the same set of tokens.
 */
@interface BOXParallelOAuth2Session : BOXOAuth2Session

@end
