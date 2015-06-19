//
//  BOXAPIAppUsersAuthOperation.h
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/6/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <BoxContentSDK/BoxContentSDK.h>

typedef void (^BOXAPIAppUsersAuthSuccessBlock)(NSString *, NSDate *);
typedef void (^BOXAPIAppUsersAuthFailureBlock)(NSError *);

/**
 * BOXAPIAppAuthOperation is a concrete BOXAPIOperation subclass. This operation
 * retrieves an access token via fetchAccessTokenWithCompletion: delegate method. 
 *
 * Attempting to authorize an access token using app users without setting the delegate 
 * will result in an NSException being thrown.
 *
 * Failure to obtain an access token or access token expiration date will create an error 
 * and cause the failure block to be run upon completion of the operation.
 */
@interface BOXAPIAppUsersAuthOperation : BOXAPIOperation

/**
 * The completion block to be run if authentication is successful.
 *
 * **Note**: All callbacks are executed on the same queue as the BOXAPIOperation they are associated with.
 * If you wish to interact with the UI in a callback block, dispatch to the main queue in the
 * callback block.
 */
@property (nonatomic, readwrite, strong) BOXAPIAppUsersAuthSuccessBlock success;

/**
 * The completion block to be run if authetication fails.
 *
 * **Note**: All callbacks are executed on the same queue as the BOXAPIOperation they are associated with.
 * If you wish to interact with the UI in a callback block, dispatch to the main queue in the
 * callback block.
 */
@property (nonatomic, readwrite, strong) BOXAPIAppUsersAuthFailureBlock failure;

/**
 * The access token's expiration date.
 */
@property (nonatomic, readwrite, strong) NSDate *accessTokenExpiration;

@end
