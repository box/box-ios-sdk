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

NSString *const BOXOAuth2TokenRequestErrorInvalidGrant = @"invalid_grant";
NSString *const BOXOAuth2TokenRequestErrorInvalidToken = @"invalid_token";
NSString *const BOXOAuth2TokenRequestErrorInvalidRequest = @"invalid_request";

// User denied access to their Box account
NSString *const BOXOAuth2ErrorAccessDenied = @"access_denied";