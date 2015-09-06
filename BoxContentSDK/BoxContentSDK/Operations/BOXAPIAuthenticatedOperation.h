//
//  BOXAPIAuthenticatedOperation.h
//  BoxContentSDK
//
//  Created on 2/27/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXAPIOperation.h"

// @TODO: Fill in Error Conditions header

/**
 * BOXAPIAuthenticatedOperation is an abstract base class for all API operations that
 * require authentication with Box. Because this class is abstract, you should not instantiate
 * it directly. Instead, use one of its subclasses:
 *
 * - BOXAPIJSONOperation
 * - BOXAPIMultipartToJSONOperation
 * - BOXAPIDataOperation
 *
 * This class encapsulates logic for handling expired access tokens. If an access token is found
 * to be expired, instances will request an attempt to refresh access tokens and will attempt
 * to reenqueue the failed operation.
 *
 * Error Conditions
 * ================
 * ...
 *
 * @warning Only members of the class BOXAPIJSONOperation may be reenqueued. Neither
 * BOXAPIMultipartToJSONOperation nor BOXAPIDataOperation instances may be reenqueued because they
 * contain properties that cannot be copied (subclasses of NSStream).
 */
@interface BOXAPIAuthenticatedOperation : BOXAPIOperation

/** @name Access token expiration and refresh */

/**
 * The number of times an operation has been reenqueued. This class
 * will only attempt to reenqueue failed operations once before failing
 * permanenetly.
 *
 * @see handleAccessTokenExpired:
 * @see connection:didReceiveResponse:
 */
@property (nonatomic, readwrite, assign) NSUInteger timesReenqueued;

/**
 * Checks for the presense of a WWW-Authenticate header with the error reason
 * `error="invalid_token"` which indicates that the token is invalid and potentially expired.
 *
 * @return A BOOL indicating if the token is expired.
 */
- (BOOL)isAccessTokenExpired;

/**
 * Have [self.session]([BOXAPIOperation BOXAbstractSession]) issue a BOXAPIOAuth2ToJSONOperation or BOXAPIAppAuthOperation
 * to refresh the access token.
 */
- (void)handleExpiredAccessToken;

/** @name Request signing */

/**
 * Modify [self.APIRequest]([BOXAPIOperation APIRequest]) to contain authentication information
 * in the form of an Authorization header with a Bearer token.
 *
 * This is delayed as long as possible to ensure that the
 * session is not stale by the time this operation makes it through
 * whatever queue it is in.
 *
 * @see [BOXAbstractSession addAuthorizationParametersToRequest:]
 */
- (void)prepareAPIRequest;

/**
  * Whether or not the operation request can be re-enqueued automatically.
  * In certain cases, the Operations layer can try to re-execute (once) upon failure (e.g. token needed refreshing).
  * Sub-classes should override to indicate whether they are re-enqueueable or not.
  */
- (BOOL)canBeReenqueued;

@end
