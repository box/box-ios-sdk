//
//  BOXMetadataTemplateField.m
//  BoxContentSDK
//
//  Created on 6/15/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXMetadataTemplateField.h"

@implementation BOXMetadataTemplateField

- (instancetype)initWithJSON:(NSDictionary *)JSONData
{
    if (self = [super initWithJSON:JSONData]) {
        self.modelID = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyKey
                                                      inDictionary:JSONData
                                                   hasExpectedType:[NSString class]
                                                       nullAllowed:NO];
        self.type = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyType
                                                   inDictionary:JSONData
                                                hasExpectedType:[NSString class]
                                                    nullAllowed:NO];
        self.displayName = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyDisplayName
                                                          inDictionary:JSONData
                                                       hasExpectedType:[NSString class]
                                                           nullAllowed:NO];
        self.options = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyOptions
                                                      inDictionary:JSONData
                                                   hasExpectedType:[NSArray class]
                                                       nullAllowed:YES];
        self.JSONData = JSONData;
    }
    
    return self;
}

@end
