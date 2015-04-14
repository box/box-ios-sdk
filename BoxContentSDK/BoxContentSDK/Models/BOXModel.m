//
//  BOXModel.m
//  BoxContentSDK
//
//  Created by Scott Liu on 11/29/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXModel.h"

#import "BoxISO8601DateFormatter.h"

@implementation BOXModel

- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    if (self = [super init]) {
        self.modelID = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyID
                                                      inDictionary:JSONResponse
                                                   hasExpectedType:[NSString class]
                                                       nullAllowed:NO
                                                 suppressNullAsNil:NO];

        self.type = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyType
                                                      inDictionary:JSONResponse
                                                   hasExpectedType:[NSString class]
                                                       nullAllowed:NO
                                                 suppressNullAsNil:NO];
    }
    return self;
}

@end
