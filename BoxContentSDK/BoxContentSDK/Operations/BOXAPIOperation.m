//
//  BOXAPIOperation.m
//  BoxContentSDK
//
//  Created on 2/27/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXAPIOperation_Private.h"

#import "BOXOAuth2Session.h"
#import "BOXContentSDKErrors.h"
#import "BOXLog.h"
#import "BOXURLRequestSerialization.h"
#import "BOXAPIOAuth2ToJSONOperation.h"

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

- (void)cancelSessionTask;

@end

@implementation BOXAPIOperation

@synthesize session = _session;
@synthesize accessToken = _accessToken;

// request properties
@synthesize baseRequestURL = _baseRequestURL;
@synthesize body = _body;
@synthesize queryStringParameters = _queryStringParameters;
@synthesize APIRequest = _APIRequest;

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
        
        // If we are not a POST method, postParams will be nil and we will not add a body.
        // If we are a POST method, all api calls will append our custom entries to the body prior to encoding.
        NSMutableDictionary *POSTParams = [body mutableCopy];
        if ([session isKindOfClass:[BOXOAuth2Session class]]) {
            BOXOAuth2Session *currentSession = (BOXOAuth2Session *)session;
            if (currentSession.additionalMessageParameters.count > 0) {
                [POSTParams addEntriesFromDictionary:currentSession.additionalMessageParameters];
            }
        }
        
        _baseRequestURL = URL;
        _body = [POSTParams copy];
        _queryStringParameters = queryParams;
        _session = session;
        // delay setting up the session task as long as possible so the authentication credentials remain fresh

        _APIRequest = nil;
        
        NSMutableURLRequest *APIRequest = [NSMutableURLRequest requestWithURL:[self requestURLWithURL:_baseRequestURL queryStringParameters:_queryStringParameters]];
        APIRequest.HTTPMethod = HTTPMethod;

        if (_body != nil) {
            NSData *encodedBody = [self encodeBody:_body];
            APIRequest.HTTPBody = encodedBody;
        } else {
            APIRequest.HTTPBody = nil;
        }

        _APIRequest = APIRequest;

        //NOTE: This data object needs to be initialized for the subclasses that are going to use it
        // (see BOXAPIDataOperation as an example). Some subclasses will not use this object and for
        // correct processing it needs to remain nil rather than an empty mutable data object.
        _responseData = nil;

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
    if ([queryDictionary count] == 0) {
        return baseURL;
    }

    NSMutableArray *queryParts = [NSMutableArray array];
    for (id key in queryDictionary)
    {
        id value = [queryDictionary objectForKey:key];
        NSString *keyString = BOXPercentEscapedStringFromString([key description]);
        NSString *valueString = BOXPercentEscapedStringFromString([value description]);

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

- (void)prepareOperation
{
    if (![self isCancelled]) {
        if (self.sessionTask == nil) {
            @synchronized(self.session)
            {
                //Note: if sessionTask exists, we cannot change its API request
                //make sure you recreate sessionTask with the new API request if needed
                [self prepareAPIRequest];
                if (![self isKindOfClass:[BOXAPIOAuth2ToJSONOperation class]]) {
                    self.accessToken = self.session.accessToken;
                }
            }
            NSError *error = nil;
            self.sessionTask = [self createSessionTaskWithError:&error];
            if (error != nil) {
                BOXLog(@"BOXAPIOperation %@ failed to create session task to prepare to execute API request", self);
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setObject:error forKey:NSUnderlyingErrorKey];
                self.error = [NSError errorWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKURLSessionFailToCreateSessionTask userInfo:userInfo];
            }
        }
    }
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

- (NSURLSessionTask *)createSessionTaskWithError:(NSError **)outError
{
    __weak BOXAPIOperation *weakSelf = self;
    NSURLSessionTask *sessionTask = [self.session.urlSessionManager dataTaskWithRequest:self.APIRequest
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    [weakSelf finishURLSessionTaskWithData:data response:response error:error];
                                                }];
    NSError *error = nil;
    if (sessionTask == nil) {
        error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKURLSessionInvalidSessionTask userInfo:nil];
    }
    if (outError != nil) {
        *outError = error;
    }
    return sessionTask;
}

- (void)executeSessionTask
{
    if (self.sessionTask == nil) {
        //no session task to execute with, this happens for a background download/upload operation
        //retrieve cached info to finish

        NSString *userId = self.session.user.uniqueId;
        NSError *error = nil;
        BOXURLSessionTaskCachedInfo *cachedInfo = [self.session.urlSessionManager sessionTaskCompletedCachedInfoGivenUserId:userId associateId:self.associateId error:&error];

        if (cachedInfo.response != nil && error == nil) {
            //get valid cached info for session task, finish this operation

            [self sessionTask:self.sessionTask didFinishWithResponse:cachedInfo.response responseData:cachedInfo.responseData error:cachedInfo.error];
        } else {
            //fail to retrieve cached info for session task, finish this operation with error

            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            if (error != nil) {
                [userInfo setObject:error forKey:NSUnderlyingErrorKey];
            }
            self.error = [NSError errorWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKURLSessionCacheErrorFailToRetrieveCachedInfo userInfo:userInfo];
            [self finish];
        }
    } else {
        [self.sessionTask resume];
    }
}

- (void)executeOperation
{
    BOXLog(@"BOXAPIOperation %@ was started", self);
    if (![self isCancelled]) {
        if (self.sessionTask == nil) {
            @synchronized(self.session)
            {
                //Note: if sessionTask exists, we cannot change its API request
                //make sure you recreate sessionTask with the new API request if needed
                [self prepareAPIRequest];
                if (![self isKindOfClass:[BOXAPIOAuth2ToJSONOperation class]]) {
                    self.accessToken = self.session.accessToken;
                }
            }
        }

        if (self.error == nil && ![self isCancelled]) {
            NSError *error = nil;
            if (self.sessionTask == nil) {
                self.sessionTask = [self createSessionTaskWithError:&error];
            }
            if (error == nil) {
                [self executeSessionTask];
            } else {
                BOXLog(@"BOXAPIOperation %@ failed to create session task to execute API request", self);
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setObject:error forKey:NSUnderlyingErrorKey];
                self.error = [NSError errorWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKURLSessionFailToCreateSessionTask userInfo:userInfo];
                [self finish];
            }
        } else {
            // if an error has already occured, do not attempt to start the API call.
            // short circuit instead.
            if ([self isCancelled] && self.error == nil) {
                self.error = [NSError errorWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKAPIUserCancelledError userInfo:nil];
            }
            [self finish];
        }
    } else {
        BOXLog(@"BOXAPIOperation %@ was cancelled -- short circuiting and not making API call", self);
        self.error = [NSError errorWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKAPIUserCancelledError userInfo:nil];
        [self finish];
    }
}

- (void)cancel
{
    [self performSelector:@selector(cancelSessionTask) onThread:[[self class] globalAPIOperationNetworkThread] withObject:nil waitUntilDone:NO];
    [super cancel];
    BOXLog(@"BOXAPIOperation %@ was cancelled", self);
}

- (void)cancelSessionTask
{
    self.error = [NSError errorWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKAPIUserCancelledError userInfo:nil];
    if (self.sessionTask != nil) {
        if ([self shouldAllowResume] == YES && [self.sessionTask isKindOfClass:[NSURLSessionDownloadTask class]] == YES) {
            //if session task is a background download and it was cancelled with intention to resume,
            //acquire resumeData to later resume the download from where it was left off
            NSURLSessionDownloadTask *downloadTask = (NSURLSessionDownloadTask *)self.sessionTask;
            NSString *userId = self.session.user.uniqueId;
            __weak BOXAPIOperation *weakSelf = self;
            [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                /**
                 * Note: as of Mar 15, 2017, Box's download API does not satisfy the requirement to allow
                 * us taking use of resumable download from NSURLSession. resumeData will be nil
                 * A download can be resumed only if the following conditions are met:
                 *   The resource has not changed since you first requested it
                 *   The task is an HTTP or HTTPS GET request
                 *   The server provides either the ETag or Last-Modified header (or both) in its response
                 *   The server supports byte-range requests
                 *   The temporary file hasn’t been deleted by the system in response to disk space pressure
                 */
                if (resumeData != nil) {
                    [weakSelf.session.urlSessionManager cacheResumeData:resumeData forUserId:userId associateId:self.associateId];
                }
            }];
        } else {
            [self.sessionTask cancel];
        }
    }
}

- (void)finish
{
    if ([self shouldErrorTriggerLogout:self.error]) {
        [self sendLogoutNotification];
    }
    [self performCompletionCallback];

    NSString *userId = self.session.user.uniqueId;
    NSError *error = nil;

    if ([self shouldAllowResume] == NO) {
        //clean up cached info for session task if any
        BOOL success = [self.session.urlSessionManager cleanUpBackgroundSessionTaskIfExistForUserId:userId associateId:self.associateId error:&error];
        BOXAssert(success, @"Failed to clean up cached info for background session task", error);
    }
    self.sessionTask = nil;
    self.state = BOXAPIOperationStateFinished;
    BOXLog(@"BOXAPIOperation %@ finished with state %d", self, self.state);
}


- (BOOL)shouldAllowResume
{
    return NO;
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
        } else if (error.code == BOXContentSDKAPIErrorBadRequest) {
            // Device Pinning
            if ([errorType isEqualToString:BOXAuthErrorUnauthorizedDevice]
                || [errorType isEqualToString:BOXAuthErrorExceededDeviceLimit]
                || [errorType isEqualToString:BOXAuthErrorMissingDeviceId]
                || [errorType isEqualToString:BOXAuthErrorUnsupportedDevicePinningRuntime]
                || [errorType isEqualToString:BOXAuthErrorAccountDeactivated])  {
                shouldLogout = YES;
            }
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
    if (self.session.user.uniqueId) {
        objectInfo = [NSDictionary dictionaryWithObject:self.session.user.uniqueId forKey:BOXUserIDKey];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:BOXUserWasLoggedOutDueToErrorNotification
                                                        object:objectInfo
                                                      userInfo:errorInfo];
}

- (void)processResponse:(NSURLResponse *)response
{
    //NOTE: A nil response object will result in an error. This method expects to process a valid
    // server response and should not be called with a nil or unknown response (unless an error is
    // desirable for those scenarios).
    //FIXME: Should evaluate a more specific error code for a nil response to seperate from an unknown response.
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

#pragma mark - url session task handler

- (void)finishURLSessionTaskWithData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error
{
    if (self.HTTPResponse == nil && response != nil) {
        // If the response has not already been handled (some, but not all, operations get
        // 'processResponse:' earlier in the process), handle it here.
        // Also, do not handle a nil response. That could happen if there was a failure on the whole
        // network connection, for example. In that case, there is no response.
        [self processResponse:response];
    }

    if (data != nil) {
        // If the data object is nil, ignore it. Otherwise we need to process the data.
        [self processResponseData:data];
    }

    //FIXME: Need to evaluate moving this to be the first step in this method. If that were
    // the case, more changes may be necessary around setting of self.error in the response
    // and data processing.
    if (self.error == nil) {
        // If we do not already have an error set, use the passed in error.
        self.error = error;
    }

    [self finish];
}

#pragma mark - BOXURLSessionTaskDelegate

- (void)sessionTask:(NSURLSessionTask *)sessionTask didFinishWithResponse:(NSURLResponse *)response responseData:(nullable NSData *)responseData error:(NSError *)error
{
    @synchronized (self) {
        [self finishURLSessionTaskWithData:(responseData != nil ? responseData : self.responseData) response:response error:error];
    }
}

- (void)sessionTask:(NSURLSessionTask *)sessionTask processIntermediateResponse:(NSURLResponse *)response
{
    @synchronized (self) {
        //FIXME: review if we need to check for response != nil before processing
        [self processResponse:response];
    }
}

- (void)sessionTask:(NSURLSessionTask *)sessionTask processIntermediateData:(NSData *)data
{
    @synchronized (self) {
        if (data != nil) {
            [self.responseData appendData:data];
        }
    }
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
