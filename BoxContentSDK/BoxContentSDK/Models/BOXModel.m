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

- (instancetype)initWithJSON:(NSDictionary *)JSONData
{
    if (self = [super init]) {
        self.JSONData = JSONData;
        
        self.modelID = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyID
                                                      inDictionary:JSONData
                                                   hasExpectedType:[NSString class]
                                                       nullAllowed:NO
                                                 suppressNullAsNil:NO];

        self.type = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyType
                                                      inDictionary:JSONData
                                                   hasExpectedType:[NSString class]
                                                       nullAllowed:NO
                                                 suppressNullAsNil:NO];
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[BOXModel class]]) {
        return NO;
    }

    BOXModel *model = (BOXModel *)object;

    return [self.modelID isEqualToString:model.modelID] && [self.type isEqualToString:model.type];
}

- (NSUInteger)hash
{
    return [self.modelID hash] ^ [self.type hash];
}

@end
