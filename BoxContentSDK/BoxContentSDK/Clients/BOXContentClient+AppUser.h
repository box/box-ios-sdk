//
//  BOXContentClient+AppUser.h
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/8/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <BoxContentSDK/BoxContentSDK.h>

@interface BOXContentClient (AppUsers)

/**
 * Sets the delegate for the BOXContentClient (Internally BOXAPIQueueManager).
 *
 * @param delegate The object that will act as the delegate.
 */
- (void)setAccessTokenDelegate:(id)delegate;

/**
 * Autheticates a BOXUser instance based on an access token retrieved.
 *
 * @see fetchAccessTokenWithCompletion:
 *
 * @param completion The completion block to be run after authorization regardless of whether or not authorization is successful.
 */
- (void)autheticateAppUserWithCompletionBlock:(void (^)(BOXUser *user, NSError *error))completion;

@end
