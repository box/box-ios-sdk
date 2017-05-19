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
    
    // We let the parent class handle most error scenarios, but for token requests specifically, a 403 should trigger a logout.
    if (!shouldLogout) {
        if ([error.domain isEqualToString:BOXContentSDKErrorDomain]) {
            if (error.code == BOXContentSDKAPIErrorForbidden) {
                shouldLogout = YES;
            }
        }
    }
    
    return shouldLogout;
}

@end
