//
//  BOXAPIAppAuthToJSONOperation.h
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/6/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <BoxContentSDK/BoxContentSDK.h>

typedef void (^BOXAPIAppAuthSuccessBlock)(NSString *, NSDate *);
typedef void (^BOXAPIAppAuthFailureBlock)(NSError *);

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
@interface BOXAPIAppAuthOperation : BOXAPIOperation

/**
 * The completion block to be run if authentication is successful.
 *
 * **Note**: All callbacks are executed on the same queue as the BOXAPIOperation they are associated with.
 * If you wish to interact with the UI in a callback block, dispatch to the main queue in the
 * callback block.
 */
@property (nonatomic, readwrite, strong) BOXAPIAppAuthSuccessBlock success;

/**
 * The completion block to be run if authetication fails.
 *
 * **Note**: All callbacks are executed on the same queue as the BOXAPIOperation they are associated with.
 * If you wish to interact with the UI in a callback block, dispatch to the main queue in the
 * callback block.
 */
@property (nonatomic, readwrite, strong) BOXAPIAppAuthFailureBlock failure;

/**
 * The access token's expiration date.
 */
@property (nonatomic, readwrite, strong) NSDate *accessTokenExpiration;

/**
 * Does nothing for BOXAPIAppAuthOperation since authorization hasn't occured yet.
 */
- (void)prepareAPIRequest;

/**
 * Call either a success or failure callback depending on whether or not an error occured during the request.
 */
- (void)performCompletionCallback;

/**
 * Does nothing for BOXAPIAppAuthOperation and should never be called.
 */
- (void)processResponseData:(NSData *)data;

/**
 * Does nothing for BOXAPIAppAuthOperation.
 */
- (NSData *)encodeBody:(NSDictionary *)bodyDictionary;

/**
 * Do not call this. It is used internally.
 */
- (void)finish;

@end
