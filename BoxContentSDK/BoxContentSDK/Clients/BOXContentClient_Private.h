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

+ (NSMutableDictionary *)SDKClients;
- (void)prepareRequest:(BOXRequest *)request;

@end
