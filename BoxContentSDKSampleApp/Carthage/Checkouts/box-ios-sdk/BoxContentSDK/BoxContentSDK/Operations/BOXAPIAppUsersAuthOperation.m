//
//  BOXAPIAppAuthToJSONOperation.m
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/6/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXAPIOperation_Private.h"
#import "BOXAPIAppUsersAuthOperation.h"

#define BOXAccessTokenKey @"BOXAccessTokenKey"
#define BOXAccessTokenExpirationKey @"BOXAccessTokenExpirationKey"

@implementation BOXAPIAppUsersAuthOperation

- (void)start
{
    [[BOXAPIOperation APIOperationGlobalLock] lock];
    
    if ([self isReady]) {
        self.state = BOXAPIOperationStateExecuting;
        
        [self performSelector:@selector(executeOperation)
                     onThread:[[self class] globalAPIOperationNetworkThread]
                   withObject:nil
                waitUntilDone:NO];
    } else {
        BOXAssertFail(@"Operation was not ready but start was called");
    }
    
    [[BOXAPIOperation APIOperationGlobalLock] unlock];
}

- (void)cancel
{
    [super cancel];
    BOXLog(@"BOXAPIOperation %@ was cancelled", self);
}

- (void)executeOperation
{
    if (![self isCancelled]) {
        @synchronized(self.session) {
            [self.session.queueManager.delegate fetchAccessTokenWithCompletion:^(NSString *accessToken, NSDate *accessTokenExpiration, NSError *error) {
                if (error == nil && accessToken && accessTokenExpiration) {
                    self.accessToken = accessToken;
                    self.accessTokenExpiration = accessTokenExpiration;
                } else if (!error) {
                    self.error = [[NSError alloc] initWithDomain:@"accessToken and accessTokenExpiration should be non-nil"
                                                            code:BOXContentSDKAppUserErrorAccessTokenInvalid
                                                        userInfo:nil];
                } else {
                    self.error = error;
                }
                
                [self finish];
            }];
        }
    }
}

- (void)prepareAPIRequest
{
    // Not Authenticated yet, so nothing to prepare.
}

- (void)performCompletionCallback
{
    if (self.error == nil) {
        if (self.success) {
            self.success(self.accessToken, self.accessTokenExpiration);
        }
    } else {
        if (self.failure) {
            self.failure(self.error);
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BOXAuthOperationDidCompleteNotification
                                                        object:self];
}

- (void)processResponseData:(NSData *)data
{
    BOXAssert(false, @"processResponseData: should never be called for BOXAPIAppAuthToJSONOperation instances.");
}

- (NSData *)encodeBody:(NSDictionary *)bodyDictionary
{
    return nil;
}

- (void)finish
{
    if (self.error.code == (BOXContentSDKAppUserErrorAccessTokenInvalid | BOXContentSDKAppUserErrorAccessTokenExpirationInvalid)
        || [self shouldErrorTriggerLogout:self.error]) {
        [self sendLogoutNotification];
    }
    
    [self performCompletionCallback];
    self.state = BOXAPIOperationStateFinished;
    BOXLog(@"BOXAPIOperation %@ finished with state %d", self, self.state);
}

@end
