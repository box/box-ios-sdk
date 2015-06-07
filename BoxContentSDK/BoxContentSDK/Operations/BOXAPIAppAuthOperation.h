//
//  BOXAPIAppAuthToJSONOperation.h
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/6/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <BoxContentSDK/BoxContentSDK.h>

typedef void (^BOXAPIAppAuthSuccessBlock)(NSString *, NSDate *);
typedef void (^BOXAPIAppAuthFailureBlock)(NSError *);

@interface BOXAPIAppAuthOperation : BOXAPIOperation

@property (nonatomic, readwrite, strong) BOXAPIAppAuthSuccessBlock success;
@property (nonatomic, readwrite, strong) BOXAPIAppAuthFailureBlock failure;
@property (nonatomic, readwrite, strong) NSDate *accessTokenExpiration;

- (void)prepareAPIRequest;
- (void)performCompletionCallback;
- (void)processResponseData:(NSData *)data;
- (NSData *)encodeBody:(NSDictionary *)bodyDictionary;
- (void)finish;

@end
