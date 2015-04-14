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

- (id)initWithURL:(NSURL *)URL HTTPMethod:(NSString *)HTTPMethod body:(NSDictionary *)body queryParams:(NSDictionary *)queryParams OAuth2Session:(BOXOAuth2Session *)OAuth2Session
{
    self = [super initWithURL:URL HTTPMethod:HTTPMethod body:body queryParams:queryParams OAuth2Session:OAuth2Session];
    if (self != nil)
    {
        _timesReenqueued = 0;
    }
    return self;
}

- (void)prepareAPIRequest
{
    // If token has expired (or is very close to expiring), enqueue a token-refresh operation, which will become a dependency for this operation.
    NSTimeInterval timeUntilTokenExpiry = [self.OAuth2Session.accessTokenExpiration timeIntervalSinceNow];
    if (timeUntilTokenExpiry < 60)
    {
        // Do a token refresh. This will become a depdency for the API operation.
        [self.OAuth2Session performRefreshTokenGrant:self.OAuth2Session.accessToken withCompletionBlock:nil];
        
        NSInteger errorCode;
        if (self.timesReenqueued == 0)
        {
            errorCode = BOXContentSDKOAuth2ErrorAccessTokenExpiredOperationWillBeClonedAndReenqueued;
            
            // Make a copy of this operation and enqueue.
            BOXAPIJSONOperation *operationCopy = [self copy];
            operationCopy.timesReenqueued = operationCopy.timesReenqueued + 1;
            [self.OAuth2Session.queueManager enqueueOperation:operationCopy];
        }
        else
        {
            errorCode = BOXContentSDKOAuth2ErrorAccessTokenExpiredOperationCouldNotBeCompleted;
        }
        
        // Short-circuit this operation.
        self.error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:errorCode userInfo:nil];
    }
    else
    {
        [self.OAuth2Session addAuthorizationParametersToRequest:self.APIRequest];
    }
}

- (BOOL)isOAuth2TokenExpired
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

- (void)handleExpiredOAuth2Token
{
    // We rely on NSNotifications sent by performRefreshTokenGrant in this case so we're not setting a completion-block.
    [self.OAuth2Session performRefreshTokenGrant:self.OAuth2AccessToken withCompletionBlock:nil];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [super connection:connection didReceiveResponse:response];

    BOOL isOAuth2TokenExpired = [self isOAuth2TokenExpired];

    if (isOAuth2TokenExpired && self.timesReenqueued == 0)
    {
        BOXLog(@"OAuth2 access token is expired.");
        self.error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKOAuth2ErrorAccessTokenExpiredOperationWillBeClonedAndReenqueued userInfo:nil];

        // re-enqueue operation in the same queue referred to by the OAuth2 session
        // if possible. This is only possible for BOXAPIJSONOperations.
        // BOXAPIDataOperations and BOXAPIMultipartToJSONOperations contain NSStream
        // properties that cannot be copied. If an operation cannot be copied, an
        // NSError indicating so is returned in this operation's failure callback.
        if ([self isMemberOfClass:[BOXAPIJSONOperation class]])
        {
            BOXLog(@"Re-enqueueing operation that failed to authenticate");
            BOXAPIJSONOperation *operationCopy = [self copy];
            operationCopy.timesReenqueued = operationCopy.timesReenqueued + 1;
            // re-enqueue before adding OAuth2 operation so OAuth2 operation can be
            // added as a dependency
            [self.OAuth2Session.queueManager enqueueOperation:operationCopy];
        }
        else
        {
            self.error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKOAuth2ErrorAccessTokenExpiredOperationCannotBeReenqueued userInfo:nil];
        }

        BOXLog(@"Attempting automatic OAuth2 token refresh");
        [self handleExpiredOAuth2Token];
    }
    else if (isOAuth2TokenExpired)
    {
        self.error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKOAuth2ErrorAccessTokenExpiredOperationCouldNotBeCompleted userInfo:nil];
    }
}

@end
