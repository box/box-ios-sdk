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

- (BOOL)canBeReenqueuedDueToTokenExpired
{
    return self.shouldStartImmediately == NO;
}

- (BOOL)canBeReenqueuedDueTo202NotReady
{
    return self.shouldStartImmediately == NO;
}

@end
