//
//  BOXAPIAuthenticatedOperation.m
//  BoxContentSDK
//
//  Created on 2/27/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXAPIAuthenticatedOperation.h"

#import "BOXAPIJSONOperation.h"
#import "BOXLog.h"
#import "BOXContentSDKErrors.h"

#define WWW_AUTHENTICATE_HEADER           (@"WWW-Authenticate")

#define OAUTH2_INVALID_REQUEST_ERROR      (@"error=\"invalid_request\"")
#define OAUTH2_INVALID_TOKEN_ERROR        (@"error=\"invalid_token\"")
#define OAUTH2_INSUFFICIENT_SCOPE_ERROR   (@"error=\"insufficient_scope\"")

@implementation BOXAPIAuthenticatedOperation

@synthesize timesReenqueued = _timesReenqueued;

- (id)initWithURL:(NSURL *)URL HTTPMethod:(NSString *)HTTPMethod body:(NSDictionary *)body queryParams:(NSDictionary *)queryParams session:(BOXAbstractSession *)session
{
    self = [super initWithURL:URL HTTPMethod:HTTPMethod body:body queryParams:queryParams session:session];
    if (self != nil)
    {
        _timesReenqueued = 0;
    }
    return self;
}

- (void)prepareAPIRequest
{
    [self.session addAuthorizationParametersToRequest:self.APIRequest];
}

- (BOOL)isAccessTokenExpired
{
    NSString *wwwAuthenticateHeader = [[self.HTTPResponse allHeaderFields] objectForKey:WWW_AUTHENTICATE_HEADER];

    // Requests made with invalid Bearer tokens will come back with a WWW-Authenticate header containing
    // OAUTH2_INVALID_TOKEN_ERROR in the header
    if (wwwAuthenticateHeader != nil && [wwwAuthenticateHeader rangeOfString:OAUTH2_INVALID_TOKEN_ERROR].location != NSNotFound)
    {
        return YES;
    }

    return NO;
}

- (void)handleExpiredAccessToken
{
    // We rely on NSNotifications sent by performRefreshTokenGrant in this case so we're not setting a completion-block.
    [self.session performRefreshTokenGrant:self.accessToken withCompletionBlock:nil];
}

- (BOOL)canBeReenqueued
{
    return NO;
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [super connection:connection didReceiveResponse:response];

    BOOL isOAuth2TokenExpired = [self isAccessTokenExpired];

    if (isOAuth2TokenExpired)
    {
        [self handleExpiredAccessToken];
        
        // re-enqueue operation in the same queue referred to by the OAuth2 session if possible.
        if ([self canBeReenqueued] && self.timesReenqueued == 0)
        {
            self.error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKAuthErrorAccessTokenExpiredOperationWillBeClonedAndReenqueued userInfo:nil];
            
            BOXAPIJSONOperation *operationCopy = [self copy];
            operationCopy.timesReenqueued = operationCopy.timesReenqueued + 1;
            [self.session.queueManager enqueueOperation:operationCopy];
        }
        else
        {
            self.error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKAuthErrorAccessTokenExpiredOperationCannotBeReenqueued userInfo:nil];
        }
    }
}

@end
