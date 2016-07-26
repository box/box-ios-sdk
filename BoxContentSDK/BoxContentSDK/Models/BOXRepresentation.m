//
//  BOXRepresentation.m
//  BoxContentSDK
//
//  Created on 7/15/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import "BOXRepresentation.h"
#import "NSJSONSerialization+BOXAdditions.h"
#import "BOXContentSDKConstants.h"

@implementation BOXRepresentation

- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    if (self = [super init]) {
        
        self.JSONData = JSONResponse;
        
        self.type = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyRepresentation
                                                   inDictionary:JSONResponse
                                                hasExpectedType:[NSString class]
                                                    nullAllowed:NO];
        
        NSDictionary *propertiesJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyProperties
                                                                  inDictionary:JSONResponse
                                                               hasExpectedType:[NSDictionary class]
                                                                   nullAllowed:NO];
        
        self.dimensions = [propertiesJSON objectForKey:BOXAPIObjectKeyDimensions];
        
        self.status = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyStatus
                                                     inDictionary:JSONResponse
                                                  hasExpectedType:[NSString class]
                                                      nullAllowed:NO];
        
        NSDictionary *detailsJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyDetails
                                                                   inDictionary:JSONResponse
                                                                hasExpectedType:[NSDictionary class]
                                                                    nullAllowed:NO];
        self.details = detailsJSON;
        
        NSDictionary *linksJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyLinks
                                                                 inDictionary:JSONResponse
                                                              hasExpectedType:[NSDictionary class]
                                                                  nullAllowed:NO];
        
        NSDictionary *contentJSON = linksJSON[BOXAPIObjectKeyContent];
        
        NSString *contentURLString = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyURL
                                                             inDictionary:contentJSON
                                                          hasExpectedType:[NSString class]
                                                              nullAllowed:NO];
        if (contentURLString.length > 0) {
            self.contentURL = [NSURL URLWithString:contentURLString];
        }
        
        self.contentType = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyType
                                                          inDictionary:contentJSON
                                                       hasExpectedType:[NSString class]
                                                           nullAllowed:NO];
        
        NSDictionary *infoJSON = linksJSON[BOXAPIObjectKeyInfo];
        
        self.infoURL = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyURL
                                                      inDictionary:infoJSON
                                                   hasExpectedType:[NSString class]
                                                       nullAllowed:NO];
    }
    
    return self;
}

@end
