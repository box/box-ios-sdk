//
//  BOXAPIHeadOperation.m
//  BoxContentSDK
//
//  Created by Helen Kuo on 8/25/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import "BOXAPIHeadOperation.h"
#import "BOXContentSDKErrors.h"
#import "BOXAbstractSession.h"

#define MAX_REENQUE_DELAY 15
#define REENQUE_BASE_DELAY 0.2

@implementation BOXAPIHeadOperation

@synthesize successBlock = _successBlock;
@synthesize failureBlock = _failureBlock;

- (instancetype)copyWithZone:(NSZone *)zone
{
    NSURL *URLCopy = [self.baseRequestURL copy];
    NSDictionary *bodyCopy = [self.body copy];
    NSDictionary *queryStringParametersCopy = [self.queryStringParameters copy];
    
    BOXAPIHeadOperation *operationCopy = [[BOXAPIHeadOperation allocWithZone:zone] initWithURL:URLCopy HTTPMethod:self.HTTPMethod body:bodyCopy queryParams:queryStringParametersCopy session:self.session];
    operationCopy.successBlock = [self.successBlock copy];
    operationCopy.failureBlock = [self.failureBlock copy];
    operationCopy.timesReenqueued = self.timesReenqueued;
    
    // Migrate header fields (this is especially important for requests where some of the key
    // information is in the headers, such as Shared Link requests for the underlying item).
    NSDictionary *headers = [self.APIRequest allHTTPHeaderFields];
    for (id key in headers) {
        [operationCopy.APIRequest setValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
    
    return operationCopy;
}

- (void)processResponseData:(NSData *)data
{
    // do nothing, no body data to process
}

- (NSData *)encodeBody:(NSDictionary *)bodyDictionary
{
    // encode the body dictionary as JSON
    if (bodyDictionary == nil)
    {
        return nil;
    }
    
    NSError *JSONEncodeError = nil;
    NSData *JSONEncodedBody = [NSJSONSerialization dataWithJSONObject:bodyDictionary options:0 error:&JSONEncodeError];
    if (self.error == nil && JSONEncodeError != nil)
    {
        NSDictionary *userInfo = @{
                                   NSUnderlyingErrorKey : JSONEncodeError,
                                   };
        self.error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKJSONErrorEncodeFailed userInfo:userInfo];
        
        // return dummy JSON body
        return [NSData data];
    }
    
    return JSONEncodedBody;
}

- (void)processResponse:(NSURLResponse *)response
{
    [super processResponse:response];

    if (self.error.code == BOXContentSDKAPIErrorAccepted) {
        // If we get a 202, it means the content is not yet ready on Box's servers.
        // Re-enqueue after a certain amount of time.
        double delay = [self reenqueDelay];
        dispatch_queue_t currentQueue = [[NSOperationQueue currentQueue] underlyingQueue];
        if (currentQueue == nil) {
            currentQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), currentQueue, ^{
            [self reenqueOperationDueTo202Response];
        });
    }
}

- (double)reenqueDelay
{
    // Delay grows each time the request is re-enqueued.
    double delay = MIN(pow((1 + REENQUE_BASE_DELAY), self.timesReenqueued) - 1, MAX_REENQUE_DELAY);
    return delay;
}

- (void)reenqueOperationDueTo202Response
{
    BOXAPIHeadOperation *operationCopy = [self copy];
    operationCopy.timesReenqueued++;
    [self.session.queueManager enqueueOperation:operationCopy];
    [self finish];
}

- (void)performCompletionCallback
{
    BOOL shouldClearCompletionBlocks = NO;
    
    if (self.error == nil) {
        if (self.successBlock) {
            self.successBlock(self.APIRequest, self.HTTPResponse);
        }
        shouldClearCompletionBlocks = YES;
    } else {
        if ([self.error.domain isEqualToString:BOXContentSDKErrorDomain] &&
            (self.error.code == BOXContentSDKAuthErrorAccessTokenExpiredOperationWillBeClonedAndReenqueued ||
             self.error.code == BOXContentSDKAPIErrorAccepted)) {
                // Do not fire failure block if request is going to be re-enqueued due to an expired token, or a 202 response.
            } else {
                if (self.failureBlock) {
                    self.failureBlock(self.APIRequest, self.HTTPResponse, self.error);
                }
                shouldClearCompletionBlocks = YES;
            }
    }
    
    if (shouldClearCompletionBlocks) {
        self.successBlock = nil;
        self.failureBlock = nil;
    }
}

- (BOOL)canBeReenqueued
{
    return YES;
}

@end
