//
//  BOXEnterprise.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/3/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXEnterprise.h"

@implementation BOXEnterpriseMini

- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    if (self = [super initWithJSON:JSONResponse])
    {
        self.name = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyName
                                                   inDictionary:JSONResponse
                                                hasExpectedType:[NSString class]
                                                    nullAllowed:NO];
    }
    
    return self;
}

@end

@implementation BOXEnterprise
// TODO We don't have anything in the SDK yet that deals with a full enterprise object so not needed yet.
@end
