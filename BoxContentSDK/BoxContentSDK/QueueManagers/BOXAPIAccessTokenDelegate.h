//
//  BOXAPIAccessTokenDelegate.h
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/6/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

/**
 * BOXAPIAccessTokenDelegate is a protocol that should only be conformed to if AppUsers is being used.
 */
@protocol BOXAPIAccessTokenDelegate <NSObject>

/**
 * The method is meant to be used to make network requests to acquire access tokens and access token expiration dates.
 */
- (void)fetchAccessTokenWithCompletion:(void (^)(NSString *, NSDate *, NSError *))completion;

@end