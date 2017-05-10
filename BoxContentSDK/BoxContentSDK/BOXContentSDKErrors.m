//
//  BoxContentSDKErrors.m
//  BoxContentSDK
//
//  Created on 1/26/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXContentSDKErrors.h"

NSString *const BOXContentSDKErrorDomain = @"com.box.contentsdk.errordomain";
NSString *const BOXJSONErrorResponseKey = @"com.box.contentsdk.jsonerrorresponse";

NSString *const BOXAuthTokenRequestErrorInvalidGrant = @"invalid_grant";
NSString *const BOXAuthTokenRequestErrorInvalidToken = @"invalid_token";
NSString *const BOXAuthTokenRequestErrorInvalidRequest = @"invalid_request";

NSString *const BOXAuthErrorUnauthorizedDevice = @"unauthorized_device";
NSString *const BOXAuthErrorExceededDeviceLimit = @"exceeded_device_limits";
NSString *const BOXAuthErrorMissingDeviceId = @"missing_device_id";
NSString *const BOXAuthErrorUnsupportedDevicePinningRuntime = @"unsupported_device_pinning_runtime";
NSString *const BOXAuthErrorAccountDeactivated = @"account_deactivated";

// User denied access to their Box account
NSString *const BOXAuthErrorAccessDenied = @"access_denied";
