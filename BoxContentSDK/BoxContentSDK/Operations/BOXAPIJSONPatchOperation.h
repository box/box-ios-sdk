//
//  BOXAPIJSONPatchOperation.h
//  BoxContentSDK
//
//  Created by Jeremy Pang on 1/8/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXAPIJSONOperation.h"

@interface BOXAPIJSONPatchOperation : BOXAPIJSONOperation

- (id)initWithURL:(NSURL *)URL HTTPMethod:(NSString *)HTTPMethod patchOperations:(NSArray *)patchOperations queryParams:(NSDictionary *)queryParams OAuth2Session:(BOXOAuth2Session *)OAuth2Session;

@end
