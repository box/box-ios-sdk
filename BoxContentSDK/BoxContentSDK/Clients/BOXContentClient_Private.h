//
//  BOXClient_Private.h
//  BoxContentSDK
//
//  Created on 12/12/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXContentClient.h"

@class BOXRequest;

@interface BOXContentClient ()

@property (nonatomic, readwrite, strong) BOXOAuth2Session *OAuth2Session;
@property (nonatomic, readwrite, strong) BOXAppUserSession *appSession;
@property (nonatomic, readwrite, strong) BOXAbstractSession *session;

+ (NSMutableDictionary *)SDKClients;
- (void)prepareRequest:(BOXRequest *)request;
- (instancetype)initWithAppUsers:(BOOL)appUsers;

@end
