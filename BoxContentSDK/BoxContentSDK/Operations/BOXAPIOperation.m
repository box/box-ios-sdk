//
//  BOXAPIOperation.m
//  BoxContentSDK
//
//  Created on 2/27/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXAPIOperation_Private.h"

#import "BOXContentSDKErrors.h"
#import "BOXLog.h"
#import "NSString+BOXURLHelper.h"

static NSString * BoxOperationKeyPathForState(BOXAPIOperationState state) {
    switch (state) {
        case BOXAPIOperationStateReady:
            return @"isReady";
        case BOXAPIOperationStateExecuting:
            return @"isExecuting";
        case BOXAPIOperationStateFinished:
            return @"isFinished";
        default:
            return @"state";
    }
}

static BOOL BoxOperationStateTransitionIsValid(BOXAPIOperationState fromState, BOXAPIOperationState toState, BOOL isCancelled) {
    switch (fromState) {
        case BOXAPIOperationStateReady:
            switch (toState) {
                case BOXAPIOperationStateExecuting:
                    return YES;
                case BOXAPIOperationStateFinished:
                    return isCancelled;
                default:
                    return NO;
            }
        case BOXAPIOperationStateExecuting:
            switch (toState) {
                case BOXAPIOperationStateFinished:
                    return YES;
                default:
                    return NO;
            }
        case BOXAPIOperationStateFinished:
            return NO;
        default:
            return YES;
    }
}

@interface BOXAPIOperation()

- (void)cancelConnection;

@end

@implementation BOXAPIOperation

@synthesize session = _session;
@synthesize accessToken = _accessToken;

// request properties
@synthesize baseRequestURL = _baseRequestURL;
@synthesize body = _body;
@synthesize queryStringParameters = _queryStringParameters;
@synthesize APIRequest = _APIRequest;
@synthesize connection = _connection;

// request response properties
@synthesize responseData = _responseData;
@synthesize HTTPResponse = _HTTPResponse;

// error handling
@synthesize error = _error;

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@" %@ %@", self.HTTPMethod, self.baseRequestURL];
}

- (instancetype)init
{
    self = [self initWithURL:nil HTTPMethod:nil body:nil queryParams:nil session:nil];
    BOXLog(@"Initialize operations with initWithURL:HTTPMethod:body:queryParams:session:. %@ cannot make an API call", self);
    return self;
}

- (instancetype)initWithSession:(BOXAbstractSession *)session
{
    return [self initWithURL:nil HTTPMethod:BOXAPIHTTPMethodGET body:nil queryParams:nil session:session];
}

- (instancetype)initWithURL:(NSURL *)URL HTTPMethod:(BOXAPIHTTPMethod *)HTTPMethod body:(NSDictionary *)body queryParams:(NSDictionary *)queryParams session:(BOXAbstractSession *)session
{
    self = [super init];
    if (self != nil)
    {
        _baseRequestURL = URL;
        _body = body;
        _queryStringParameters = queryParams;
        _session = session;

        _APIRequest = nil;
        _connection = nil; // delay setting up the connection as long as possible so the authentication credentials remain fresh

        NSMutableURLRequest *APIRequest = [NSMutableURLRequest requestWithURL:[self requestURLWithURL:_baseRequestURL queryStringParameters:_queryStringParameters]];
        APIRequest.HTTPMethod = HTTPMethod;

        NSData *encodedBody = [self encodeBody:_body];
        APIRequest.HTTPBody = encodedBody;

        _APIRequest = APIRequest;

        _responseData = [NSMutableData data];

        self.state = BOXAPIOperationStateReady;
    }
    
    return self;
}

- (void)setState:(BOXAPIOperationState)state
{
    if (!BoxOperationStateTransitionIsValid(self.state, state, [self isCancelled]))
    {
        return;
    }
    NSString *oldStateKey = BoxOperationKeyPathForState(self.state);
    NSString *newStateKey = BoxOperationKeyPathForState(state);

    [self willChangeValueForKey:newStateKey];
    [self willChangeValueForKey:oldStateKey];
    _state = state;
    [self didChangeValueForKey:oldStateKey];
    [self didChangeValueForKey:newStateKey];
}

#pragma mark - Accessors
- (BOXAPIHTTPMethod *)HTTPMethod
{
    return self.APIRequest.HTTPMethod;
}

#pragma mark - Build NSURLRequest
- (NSData *)encodeBody:(NSDictionary *)bodyDictionary
{
    BOXAbstract();
    return nil;
}

- (NSURL *)requestURLWithURL:(NSURL *)baseURL queryStringParameters:(NSDictionary *)queryDictionary
{
    if ([queryDictionary count] == 0)
    {
        return baseURL;
    }

    NSMutableArray *queryParts = [NSMutableArray array];
    for (id key in queryDictionary)
    {
        id value = [queryDictionary objectForKey:key];
        NSString *keyString = [NSString box_stringWithString:[key description] URLEncoded:YES];
        NSString *valueString = [NSString box_stringWithString:[value description] URLEncoded:YES];

        [queryParts addObject:[NSString stringWithFormat:@"%@=%@", keyString, valueString]];
    }
    NSString *queryString = [queryParts componentsJoinedByString:@"&"];
    NSString *existingURLString = [baseURL absoluteString];

    NSRange startOfQueryString = [existingURLString rangeOfString:@"?"];
    NSString *joinString = nil;

    if (startOfQueryString.location == NSNotFound)
    {
        joinString = @"?";
    }
    else
    {
        joinString = @"&";
    }

    NSString *urlString = [[existingURLString stringByAppendingString:joinString] stringByAppendingString:queryString];

    return [NSURL URLWithString:urlString];
}

#pragma mark - Prepare to make API call
- (void)prepareAPIRequest
{
    BOXAbstract();
}

- (void)startURLConnection
{
    [self.connection start];
}

#pragma mark - Process API call results
- (void)processResponseData:(NSData *)data
{
    BOXAbstract();
}

#pragma mark - callbacks
- (void)performCompletionCallback
{
    BOXAbstract();
}

#pragma mark - Thread keepalive

+ (NSThread *)globalAPIOperationNetworkThread
{
    static NSThread *boxAPIOperationNewtorkRequestThread = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        boxAPIOperationNewtorkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(globalAPIOperationNetworkThreadEntryPoint:) object:nil];
        boxAPIOperationNewtorkRequestThread.name = @"Box API Operation Thread";
        [boxAPIOperationNewtorkRequestThread start];
        BOXLog(@"%@ started", boxAPIOperationNewtorkRequestThread);
    });
    return boxAPIOperationNewtorkRequestThread;
}

+ (void)globalAPIOperationNetworkThreadEntryPoint:(id)sender
{
    // Run this thread forever
    while (YES)
    {
        // Create an autorelease pool around each iteration of the runloop
        // API call completion blocks are run on this runloop which may
        // create autoreleased objects.
        //
        // See Apple documentation on using autorelease pool blocks
        // https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/mmAutoreleasePools.html#//apple_ref/doc/uid/20000047-CJBFBEDI
        @autoreleasepool {
            [[NSRunLoop currentRunLoop] run];
        }
    }
}

#pragma mark - NSOperation
- (BOOL)isReady
{
    return self.state == BOXAPIOperationStateReady && [super isReady];
}

- (BOOL)isExecuting
{
    return self.state == BOXAPIOperationStateExecuting;
}

- (BOOL)isFinished
{
    return self.state == BOXAPIOperationStateFinished;
}

- (void)start
{
    [[BOXAPIOperation APIOperationGlobalLock] lock];

    if ([self isReady])
    {
        // Set state = executing once we have the lock
        // BOXAPIQueueManagers check to ensure that operations are not executing when
        // they grab the lock and are adding dependencies.
        self.state = BOXAPIOperationStateExecuting;

        [self performSelector:@selector(executeOperation) onThread:[[self class] globalAPIOperationNetworkThread] withObject:nil waitUntilDone:NO];
    }
    else
    {
        BOXAssertFail(@"Operation was not ready but start was called");
    }

    [[BOXAPIOperation APIOperationGlobalLock] unlock];
}

- (void)executeOperation
{
    BOXLog(@"BOXAPIOperation %@ was started", self);
    if (![self isCancelled])
    {
        @synchronized(self.session)
        {
            [self prepareAPIRequest];
            self.accessToken = self.session.accessToken;
        }

        if (self.error == nil && ![self isCancelled])
        {
            self.connection = [[NSURLConnection alloc] initWithRequest:self.APIRequest delegate:self];
            BOXLog(@"Starting %@", self);
            [self startURLConnection];
        }
        else
        {
            // if an error has already occured, do not attempt to start the API call.
            // short circuit instead.
            if ([self isCancelled] && self.error == nil) {
                self.error = [NSError errorWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKAPIUserCancelledError userInfo:nil];
            }
            [self finish];
        }
    }
    else
    {
        BOXLog(@"BOXAPIOperation %@ was cancelled -- short circuiting and not making API call", self);
        self.error = [NSError errorWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKAPIUserCancelledError userInfo:nil];
        [self finish];
    }
}

- (void)cancel
{
    [self performSelector:@selector(cancelConnection) onThread:[[self class] globalAPIOperationNetworkThread] withObject:nil waitUntilDone:NO];
    [super cancel];
    BOXLog(@"BOXAPIOperation %@ was cancelled", self);
}

- (void)cancelConnection
{
    NSDictionary *errorInfo = nil;
    if (self.baseRequestURL)
    {
        errorInfo = [NSDictionary dictionaryWithObject:self.baseRequestURL forKey:NSURLErrorFailingURLErrorKey];
    }
    self.error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:errorInfo];

    if (self.connection)
    {
        [self.connection cancel];
        [self connection:self.connection didFailWithError:self.error];
    }
}

- (void)finish
{
    if ([self shouldErrorTriggerLogout:self.error]) {
        [self sendLogoutNotification];
    }
    [self performCompletionCallback];
    self.connection = nil;
    self.state = BOXAPIOperationStateFinished;
    BOXLog(@"BOXAPIOperation %@ finished with state %d", self, self.state);
}

#pragma mark - Helper Methods

- (BOOL)shouldErrorTriggerLogout:(NSError *)error
{
    BOOL shouldLogout = NO;
    if ([error.domain isEqualToString:BOXContentSDKErrorDomain]) {
        NSDictionary *errorInfo = [error.userInfo objectForKey:BOXJSONErrorResponseKey];
        NSString *errorType = [errorInfo objectForKey:BOXAuthURLParameterErrorCodeKey];
        if ([errorType isEqualToString:BOXAuthTokenRequestErrorInvalidGrant]) {
            shouldLogout = YES;
        } else if (error.code == BOXContentSDKAPIErrorUnauthorized) {
            // HTTP-401 - unauthorized
            if ([errorType isEqualToString:BOXAuthTokenRequestErrorInvalidToken]) {
                BOXLog(@"Operation failure is due to invalid access token.");
                
                // Invalid access-token.
                // We can't just log the user out because this is a state that is often recoverable through an acceess-token refresh.
            } else if ([errorType isEqualToString:BOXAuthTokenRequestErrorInvalidRequest]) {
                BOXLog(@"Operation failure is due to invalid request, possibly due to a missing access token in the request.");
            } else {
                shouldLogout = YES;
            }
        }
    }
    
    return shouldLogout;
}

- (void)sendLogoutNotification
{
    // For testing purposes, sending the notification was separated into this function
    // because we cannot easily test to make sure a notification is not sent when dealing asynchronously
    // Instead, we check to ensure this function was/wasn't called
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:self.error
                                                          forKey:BOXAuthenticationErrorKey];
    NSDictionary *objectInfo = nil;
    if (self.session.user.modelID) {
        objectInfo = [NSDictionary dictionaryWithObject:self.session.user.modelID forKey:BOXUserIDKey];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:BOXUserWasLoggedOutDueToErrorNotification
                                                        object:objectInfo
                                                      userInfo:errorInfo];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.HTTPResponse = (NSHTTPURLResponse *)response;

    if (self.HTTPResponse.statusCode == 202 || self.HTTPResponse.statusCode < 200 || self.HTTPResponse.statusCode >= 300)
    {
        BOXContentSDKAPIError errorCode = BOXContentSDKAPIErrorUnknownStatusCode;
        switch (self.HTTPResponse.statusCode)
        {
            case BOXContentSDKAPIErrorAccepted:
                errorCode = BOXContentSDKAPIErrorAccepted;
                break;
            case BOXContentSDKAPIErrorBadRequest:
                errorCode = BOXContentSDKAPIErrorBadRequest;
                break;
            case BOXContentSDKAPIErrorUnauthorized:
                errorCode = BOXContentSDKAPIErrorUnauthorized;
                break;
            case BOXContentSDKAPIErrorForbidden:
                errorCode = BOXContentSDKAPIErrorForbidden;
                break;
            case BOXContentSDKAPIErrorNotFound:
                errorCode = BOXContentSDKAPIErrorNotFound;
                break;
            case BOXContentSDKAPIErrorMethodNotAllowed:
                errorCode = BOXContentSDKAPIErrorMethodNotAllowed;
                break;
            case BOXContentSDKAPIErrorConflict:
                errorCode = BOXContentSDKAPIErrorConflict;
                break;
            case BOXContentSDKAPIErrorPreconditionFailed:
                errorCode = BOXContentSDKAPIErrorPreconditionFailed;
                break;
            case BOXContentSDKAPIErrorRequestEntityTooLarge:
                errorCode = BOXContentSDKAPIErrorRequestEntityTooLarge;
                break;
            case BOXContentSDKAPIErrorPreconditionRequired:
                errorCode = BOXContentSDKAPIErrorPreconditionRequired;
                break;
            case BOXContentSDKAPIErrorTooManyRequests:
                errorCode = BOXContentSDKAPIErrorTooManyRequests;
                break;
            case BOXContentSDKAPIErrorInternalServerError:
                errorCode = BOXContentSDKAPIErrorInternalServerError;
                break;
            case BOXContentSDKAPIErrorInsufficientStorage:
                errorCode = BOXContentSDKAPIErrorInsufficientStorage;
                break;
            default:
                errorCode = BOXContentSDKAPIErrorUnknownStatusCode;
        }

        self.error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:errorCode userInfo:nil];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    BOXLog(@"BOXAPIOperation %@ did fail with error %@", self, error);
    if (self.error == nil)
    {
        self.error = error;
    }
    [self finish];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    BOXLog(@"BOXAPIOperation %@ did finish loading", self);
    [self processResponseData:self.responseData];
    [self finish];
}

#pragma mark - Lock
+ (NSRecursiveLock *)APIOperationGlobalLock
{
    static NSRecursiveLock *boxAPIOperationLock = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        boxAPIOperationLock = [[NSRecursiveLock alloc] init];
        boxAPIOperationLock.name = @"Box API Operation Lock";
    });

    return boxAPIOperationLock;
}

@end
