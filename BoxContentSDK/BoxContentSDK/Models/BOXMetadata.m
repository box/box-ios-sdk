//
//  BOXMetadata.m
//  BoxContentSDK
//
//  Created on 6/14/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXMetadata.h"

@implementation BOXMetadata

- (instancetype)initWithJSON:(NSDictionary *)JSONData
{
    if (self = [super initWithJSON:JSONData]) {
        self.JSONData = JSONData;

        // NOTE: The set of default metadata keys (those that have '$' at the beginning) can
        // change over time.
        self.modelID = [NSJSONSerialization box_ensureObjectForKey:BOXAPIMetadataObjectKeyID
                                                      inDictionary:JSONData
                                                   hasExpectedType:[NSString class]
                                                       nullAllowed:NO];
        
        self.type = [NSJSONSerialization box_ensureObjectForKey:BOXAPIMetadataObjectKeyType
                                                   inDictionary:JSONData
                                                hasExpectedType:[NSString class]
                                                    nullAllowed:NO];
        
        self.scope = [NSJSONSerialization box_ensureObjectForKey:BOXAPIMetadataObjectKeyScope
                                                    inDictionary:JSONData
                                                 hasExpectedType:[NSString class]
                                                     nullAllowed:NO];
        
        self.templateName = [NSJSONSerialization box_ensureObjectForKey:BOXAPIMetadataObjectKeyTemplate
                                                       inDictionary:JSONData
                                                    hasExpectedType:[NSString class]
                                                        nullAllowed:NO];
        
        self.parent = [NSJSONSerialization box_ensureObjectForKey:BOXAPIMetadataObjectKeyParent
                                                     inDictionary:JSONData
                                                  hasExpectedType:[NSString class]
                                                      nullAllowed:NO];
        
        // Retrieving all custom metadata information (key/value pairs).
        NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
        for (NSString *key in JSONData) {
            // Only default metadata keys have '$' at the beginning, so the ones that don't are custom metadata keys.
            if ([key characterAtIndex:0] != '$') {
                NSString *value = [JSONData objectForKey:key];
                [info setObject:value forKey:key];
            }
        }
        self.info = info;
    }
    
    return self;
}

@end
