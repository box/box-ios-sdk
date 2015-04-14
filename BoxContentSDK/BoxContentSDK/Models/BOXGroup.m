//
//  BOXGroup.m
//  BoxContentSDK
//
//  Created by on 12/17/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXGroup.h"

@implementation BOXGroup

- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    if (self = [super initWithJSON:JSONResponse]) {
        self.name = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyName
                                                   inDictionary:JSONResponse
                                                hasExpectedType:[NSString class]
                                                    nullAllowed:NO];

        self.createdDate = [NSDate box_dateWithISO8601String:[NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCreatedAt
                                                                                            inDictionary:JSONResponse
                                                                                         hasExpectedType:[NSString class]
                                                                                             nullAllowed:NO]];

        self.modifiedDate = [NSDate box_dateWithISO8601String:[NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyModifiedAt
                                                                                             inDictionary:JSONResponse
                                                                                          hasExpectedType:[NSString class]
                                                                                              nullAllowed:NO]];
    }

    return self;
}

@end
