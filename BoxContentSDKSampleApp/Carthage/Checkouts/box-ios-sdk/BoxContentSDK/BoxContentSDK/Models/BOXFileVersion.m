//
//  BOXFileVersion.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/31/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXFileVersion.h"

@implementation BOXFileVersion

- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    BOXAssert([JSONResponse[BOXAPIObjectKeyType] isEqualToString:BOXAPIItemTypeFileVersion], @"Invalid type for object.");
    
    if (self = [super initWithJSON:JSONResponse]) {
        
        self.name = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyName
                                                   inDictionary:JSONResponse
                                                hasExpectedType:[NSString class]
                                                    nullAllowed:NO];
        
        self.sha1 = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeySHA1
                                                   inDictionary:JSONResponse
                                                hasExpectedType:[NSString class]
                                                    nullAllowed:NO];
        
        self.size = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeySize
                                                   inDictionary:JSONResponse
                                                hasExpectedType:[NSNumber class]
                                                    nullAllowed:NO];
        
        NSString *createdDate = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCreatedAt
                                                               inDictionary:JSONResponse
                                                            hasExpectedType:[NSString class]
                                                                nullAllowed:YES
                                                          suppressNullAsNil:YES];
        self.createdDate = [NSDate box_dateWithISO8601String:createdDate];
        
        NSString *modifiedDate = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyModifiedAt
                                                                inDictionary:JSONResponse
                                                             hasExpectedType:[NSString class]
                                                                 nullAllowed:YES
                                                           suppressNullAsNil:YES];
        self.modifiedDate = [NSDate box_dateWithISO8601String:modifiedDate];
        
        NSDictionary *modifierJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyModifiedBy
                                                                    inDictionary:JSONResponse
                                                                 hasExpectedType:[NSDictionary class]
                                                                     nullAllowed:YES
                                                               suppressNullAsNil:YES];
        if (modifierJSON) {
            self.lastModifier = [[BOXUserMini alloc] initWithJSON:modifierJSON];
        }
        
    }
    
    return self;
}

@end
