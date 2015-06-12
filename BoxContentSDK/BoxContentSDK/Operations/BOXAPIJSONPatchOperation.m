//
//  BOXAPIJSONPatchOperation.m
//  BoxContentSDK
//
//  Created by Jeremy Pang on 1/8/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXAPIJSONPatchOperation.h"

#define BOX_API_CONTENT_TYPE_JSON_PATCH (@"application/json-patch+json")

@implementation BOXAPIJSONPatchOperation

- (id)initWithURL:(NSURL *)URL HTTPMethod:(NSString *)HTTPMethod patchOperations:(NSArray *)patchOperations queryParams:(NSDictionary *)queryParams session:(BOXAbstractSession *)session
{
    self = [super initWithURL:URL HTTPMethod:HTTPMethod body:@{} queryParams:queryParams session:session];
    if (self != nil)
    {
        self.APIRequest.HTTPBody = [self encodeBody:(id)patchOperations];
    }
    
    return self;
}

- (void)prepareAPIRequest
{
    [super prepareAPIRequest];
    if ([self.HTTPMethod isEqualToString:BOXAPIHTTPMethodPUT])
    {
        [self.APIRequest setValue:BOX_API_CONTENT_TYPE_JSON_PATCH forHTTPHeaderField:BOXAPIHTTPHeaderContentType];
    }
}

@end
