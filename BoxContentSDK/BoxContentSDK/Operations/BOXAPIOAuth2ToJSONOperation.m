//
//  BOXAPIOAuth2ToJSONOperation.m
//  BoxContentSDK
//
//  Created on 2/27/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXAPIOAuth2ToJSONOperation.h"

#import "BOXLog.h"
#import "BOXContentSDKErrors.h"
#import "BOXURLRequestSerialization.h"
#import "BOXAPIOperation_Private.h"
#import "BOXOAuth2Session.h"
#import "BOXAbstractSession_Private.h"

#define BOX_OAUTH2_AUTHORIZATION_CODE_GRANT_PARAMETER_COUNT  (5)

@implementation BOXAPIOAuth2ToJSONOperation

@synthesize success = _success;
@synthesize failure = _failure;
@synthesize responseJSON = _responseJSON;

- (NSData *)encodeBody:(NSDictionary *)bodyDictionary
{
    NSMutableArray *multipartParamsParts = [NSMutableArray arrayWithCapacity:BOX_OAUTH2_AUTHORIZATION_CODE_GRANT_PARAMETER_COUNT];
    for (id key in bodyDictionary)
    {
        id value = [bodyDictionary objectForKey:key];
        NSString *keyString = BOXPercentEscapedStringFromString([key description]);
        NSString *valueString = BOXPercentEscapedStringFromString([value description]);

        [multipartParamsParts addObject:[NSString stringWithFormat:@"%@=%@", keyString, valueString]];
    }

    NSString *multipartPOSTParams = [multipartParamsParts componentsJoinedByString:@"&"];

    return [multipartPOSTParams dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)prepareAPIRequest
{
    // OAuth2 requests are unauthenticated; they carry the client id and client secret
}

- (void)processResponseData:(NSData *)data
{
    NSError *JSONError = nil;
    id decodedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];

    if (JSONError != nil)
    {
        NSDictionary *userInfo = @{
            NSUnderlyingErrorKey : JSONError,
        };
        self.error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKJSONErrorDecodeFailed userInfo:userInfo];;
    }
    else if ([decodedJSON isKindOfClass:[NSDictionary class]] == NO)
    {
        NSDictionary *userInfo = @{
            BOXJSONErrorResponseKey : decodedJSON,
        };
        self.error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKJSONErrorUnexpectedType userInfo:userInfo];
    }
    else if (self.error != nil)
    {
        // if this operation has already encountered an error, include the decoded JSON in the error info
        NSDictionary *userInfo = @{
            BOXJSONErrorResponseKey : decodedJSON,
        };
        self.error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:self.error.code userInfo:userInfo];
    }
    else
    {
        self.responseJSON = (NSDictionary *)decodedJSON;
    }
}

- (void)performCompletionCallback
{
    if (self.error == nil)
    {
        if (self.success)
        {
            self.success(self.APIRequest, self.HTTPResponse, self.responseJSON);
        }
    }
    else
    {
        if (self.failure)
        {
            self.failure(self.APIRequest, self.HTTPResponse, self.error, self.responseJSON);
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:BOXAuthOperationDidCompleteNotification object:self];
}

- (BOOL)shouldErrorTriggerLogout:(NSError *)error
{
    BOOL shouldLogout = [super shouldErrorTriggerLogout:error];
    

    NSDictionary *errorInfo = [error.userInfo objectForKey:BOXJSONErrorResponseKey];
    NSString *errorType = [errorInfo objectForKey:BOXAuthURLParameterErrorCodeKey];
    
    BOOL isRefreshTokenInvalid = [errorType isEqualToString:BOXAuthTokenRequestErrorInvalidGrant];
    
    BOOL isErrorForbidden = ([error.domain isEqualToString:BOXContentSDKErrorDomain] && error.code == BOXContentSDKAPIErrorForbidden);
    
    // We let the parent class handle most error scenarios, but for token requests specifically, a 403 should trigger a logout.
    if (isRefreshTokenInvalid || isErrorForbidden) {
        
        shouldLogout = YES;
        
        BOXOAuth2Session *session = (BOXOAuth2Session *)self.session;
        
        if ([session isKindOfClass:[BOXOAuth2Session class]]) {
            // We're probably here because we're trying to refresh our access token right around the time it is being
            // refreshed in another process, and we lost the race. Check the keychain, and only report refresh failure
            // if it wasn't updated.
            if ([self updateTokensFromKeychainIntoSession:session]) {
                shouldLogout = NO;
            } else {
                // Pause briefly to allow time for the keychain to be updated (in case we have really unlucky timing).
                // This only happens when racing to refresh our token, which is infrequent enough that this delay should
                // be unnoticable to a user.
                usleep(0.2 * USEC_PER_SEC);
                if ([self updateTokensFromKeychainIntoSession:session]) {
                    shouldLogout = NO;
                }
            }
        }
    }
    return shouldLogout;
}

// Returns whether the session was actually updated by reading the keychain.
- (BOOL)updateTokensFromKeychainIntoSession:(BOXOAuth2Session *)session
{
    NSString *userID = session.user.uniqueId;
    if (!userID) {
        return NO;
    }

    NSString *jsonString = [[BOXOAuth2Session keychainItemWrapperForUserWithID:userID] objectForKey:(__bridge id)kSecValueData];
    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                               options:0
                                                                 error:&error];
    if (dictionary != nil) {
        NSString *keychainAccessToken = dictionary[keychainAccessTokenKey];

        // if keychain's access token is different than the one associated with refreshToken in the token request,
        // we have a newer access token, update session's tokens with the ones from keychain if needed
        if (keychainAccessToken.length > 0 && ![keychainAccessToken isEqualToString:self.accessToken]) {
            if (![keychainAccessToken isEqualToString:session.accessToken]) {
                [session restoreSessionWithKeyChainDictionary:dictionary];

                //log found a newer access token from keychain, refresh current session's accessToken with keychain's
                NSDictionary *userInfo = @{@"completion_status" : @"succeeded",
                                           @"message" : @"failed_and_refresh_from_keychain",
                                           };
                [[NSNotificationCenter defaultCenter] postNotificationName:BOXAccessTokenRefreshDiagnosisNotification object:nil userInfo:userInfo];
            } else {
                //log found a newer access token from keychain, and current session's accessToken is already same as keychain's
                NSDictionary *userInfo = @{@"completion_status" : @"succeeded",
                                           @"message" : @"failed_but_session_has_new_access_token",
                                           };
                [[NSNotificationCenter defaultCenter] postNotificationName:BOXAccessTokenRefreshDiagnosisNotification object:nil userInfo:userInfo];
            }
            return YES;
        }
    }
    //log failing to update session's access token
    NSDictionary *userInfo = @{@"completion_status" : @"failed",
                               @"message" : @"failed_and_no_new_access_token_from_keychain",
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:BOXAccessTokenRefreshDiagnosisNotification object:nil userInfo:userInfo];
    return NO;
}

@end
