//
//  BOXCollection.m
//  BoxContentSDK
//
//  Created on 12/12/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXCollection.h"

@implementation BOXCollection

- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    BOXAssert([JSONResponse[BOXAPIObjectKeyType] isEqualToString:BOXAPIItemTypeCollection], @"Invalid type for object.");
    
    if (self = [super initWithJSON:JSONResponse]) {
            
        self.name = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyName 
                                                   inDictionary:JSONResponse
                                                hasExpectedType:[NSString class]
                                                    nullAllowed:NO];
        
        self.collectionType = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCollectionType 
                                                             inDictionary:JSONResponse
                                                          hasExpectedType:[NSString class]
                                                              nullAllowed:NO];
    }
    
    return self;
}

@end
