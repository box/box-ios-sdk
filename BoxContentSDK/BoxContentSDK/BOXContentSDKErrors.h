//
//  BoxContentSDKErrors.h
//  BoxContentSDK
//
//  Created on 4/22/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

// The domain for error responses from API calls
extern NSString *const BOXContentSDKErrorDomain;

// A key for the userInfo dictionary to look up the underlying JSON error response from the API
extern NSString *const BOXJSONErrorResponseKey;

// The BoxContentSDK framework may also return other NSError objects from other dmains, such as
// * JSON parsing
// * NSURLError domain
// * NSStream errors that may arise during uploading and downloading


// BoxContentSDKAPIError codes result from an error response being returned by an API call.
typedef enum {
    // 202 Accepted: operation could not be completed at this time and is in progress
    BOXContentSDKAPIErrorAccepted = 202,
    // 4xx errors
    BOXContentSDKAPIErrorBadRequest = 400,
    BOXContentSDKAPIErrorUnauthorized = 401,
    BOXContentSDKAPIErrorForbidden = 403,
    BOXContentSDKAPIErrorNotFound = 404,
    BOXContentSDKAPIErrorMethodNotAllowed = 405,
    BOXContentSDKAPIErrorConflict = 409,
    BOXContentSDKAPIErrorPreconditionFailed = 412,
    BOXContentSDKAPIErrorRequestEntityTooLarge = 413,
    BOXContentSDKAPIErrorPreconditionRequired = 428,
    BOXContentSDKAPIErrorTooManyRequests = 429, // rate limit exceeded
    BOXContentSDKAPIErrorServerCertError = 495, // indicates error when app encounters server with unverified identity.

    // 5xx errors
    BOXContentSDKAPIErrorInternalServerError = 500,
    BOXContentSDKAPIErrorInsufficientStorage = 507,
    // Access Denied by user
    BOXContentSDKAPIErrorUserDeniedAccess = 997,
    // Cancelation
    BOXContentSDKAPIUserCancelledError = 998,
    // catchall error code
    BOXContentSDKAPIErrorUnknownStatusCode = 999
} BOXContentSDKAPIError;

typedef enum {
    BOXContentSDKJSONErrorDecodeFailed = 10000,
    BOXContentSDKJSONErrorEncodeFailed = 10001,
    BOXContentSDKJSONErrorUnexpectedType = 10002
} BOXContentSDKJSONError;

typedef enum {
    BOXContentSDKOAuth2ErrorAccessTokenExpiredOperationWillBeClonedAndReenqueued = 20000, // access token is expired. The failed request was reenqueued
    BOXContentSDKOAuth2ErrorAccessTokenExpiredOperationCannotBeReenqueued = 20001, // access token is expired and the operation cannot be reenqueued because it cannot be copied
    BOXContentSDKOAuth2ErrorAccessTokenExpiredOperationCouldNotBeCompleted = 20002, // Operation failed because access token is expired and could not be refreshed. Usually due to no internet connection
    BOXContentSDKOAuth2ErrorAccessTokenNonceMismatch = 20003, // Operation failed because nonce returned by server didn't match the one used by app to authorize user.
} BOXContentSDKOAuth2Error;

typedef enum {
    BOXContentSDKAppUserErrorAccessTokenInvalid = 40000,
    BOXContentSDKAppUserErrorAccessTokenExpirationInvalid = 40001
} BOXContentSDKAppUserError;

typedef enum {
    BOXContentSDKStreamErrorWriteFailed = 30000,
    BOXContentSDKStreamErrorReadFailed = 30001
} BOXContentSDKStreamError;

extern NSString *const BOXOAuth2TokenRequestErrorInvalidGrant; // Invalid refresh token
extern NSString *const BOXOAuth2TokenRequestErrorInvalidToken; // Invalid access token
extern NSString *const BOXOAuth2TokenRequestErrorInvalidRequest; // Possibly a missing access token

extern NSString *const BOXOAuth2ErrorAccessDenied; // User denied access to their Box account
