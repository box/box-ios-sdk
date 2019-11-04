//
//  BOXAPIAuthenticatedOperation.m
//  BoxContentSDK
//
//  Created on 2/27/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXAPIAuthenticatedOperation.h"

#import "BOXLog.h"
#import "BOXContentSDKErrors.h"
#import "BOXAbstractSession.h"
#import <os/log.h>

#define MAX_REENQUE_DELAY 15
#define REENQUE_BASE_DELAY 0.2

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
    os_log(OS_LOG_DEFAULT, "*****Op: handleExpiredAccessToken %{public}@, baseRequestURL %{public}@", [self class], self.baseRequestURL.lastPathComponent);
    // We rely on NSNotifications sent by performRefreshTokenGrant in this case so we're not setting a completion-block.
    [self.session performRefreshTokenGrant:self.accessToken withCompletionBlock:nil];
}

- (BOOL)canBeReenqueuedDueToTokenExpired
{
    return NO;
}

- (BOOL)canBeReenqueuedDueTo202NotReady
{
    return NO;
}

- (void)processResponse:(NSURLResponse *)response
{
    [super processResponse:response];
    
    [self handlePossible202NotReady];
    [self handlePossibleTokenExpired];
}

- (void)handlePossibleTokenExpired
{
    if ([self isAccessTokenExpired])
    {
        BOXContentSDKAuthError errorCode;
        
        [self handleExpiredAccessToken];
        
        if ([self canBeReenqueuedDueToTokenExpired] && self.timesReenqueued == 0)
        {
            errorCode = BOXContentSDKAuthErrorAccessTokenExpiredOperationWillBeClonedAndReenqueued;
            [self reenqueCopyOfOperation];
        }
        else
        {
            os_log(OS_LOG_DEFAULT, "*****AuthOp: can't reenqueue, request failed op %{public}@ after expired token", self);
            errorCode = BOXContentSDKAuthErrorAccessTokenExpiredOperationCannotBeReenqueued;
        }
        self.error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:errorCode userInfo:nil];
    }
}

- (void)handlePossible202NotReady
{
    if (self.error.code == BOXContentSDKAPIErrorAccepted && [self canBeReenqueuedDueTo202NotReady]) {
        // If we get a 202, it means the content is not yet ready on Box's servers.
        // Re-enqueue after a certain amount of time.
        double delay = [self reenqueDelay];
        dispatch_queue_t currentQueue = [[NSOperationQueue currentQueue] underlyingQueue];
        if (currentQueue == nil) {
            currentQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), currentQueue, ^{
            [self reenqueCopyOfOperation];
            [self finish];
        });
    }
}

- (double)reenqueDelay
{
    // Delay grows each time the request is re-enqueued.
    double delay = MIN(pow((1 + REENQUE_BASE_DELAY), self.timesReenqueued) - 1, MAX_REENQUE_DELAY);
    return delay;
}

- (void)reenqueCopyOfOperation
{
    BOXAPIAuthenticatedOperation *operationCopy = [self copy];
    operationCopy.timesReenqueued++;
    [self.session.queueManager enqueueOperation:operationCopy];
}

@end
