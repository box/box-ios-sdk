//
//  BOXFileLock.m
//  BoxContentSDK
//
//  Created by Scott Liu on 12/2/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXFileLock.h"
#import "BOXUser.h"

@implementation BOXFileLock

- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    if (self = [super init]) {
        NSString *createdDate = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCreatedAt
                                                                inDictionary:JSONResponse
                                                             hasExpectedType:[NSString class]
                                                                 nullAllowed:YES // root folders have no timestamps
                                                           suppressNullAsNil:YES];
        self.createdDate = [NSDate box_dateWithISO8601String:createdDate];

        NSString *expirationDate = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCreatedAt
                                                                inDictionary:JSONResponse
                                                             hasExpectedType:[NSString class]
                                                                 nullAllowed:YES // root folders have no timestamps
                                                           suppressNullAsNil:YES];
        self.expirationDate = [NSDate box_dateWithISO8601String:expirationDate];

        NSDictionary *creatorJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCreatedBy
                                                                   inDictionary:JSONResponse
                                                                hasExpectedType:[NSDictionary class]
                                                                    nullAllowed:NO];
        if (creatorJSON) {
            self.creator = [[BOXUserMini alloc] initWithJSON:creatorJSON];
        }

        NSNumber *isDownloadPrevented = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyIsDeactivated
                                                                       inDictionary:JSONResponse
                                                                    hasExpectedType:[NSNumber class]
                                                                        nullAllowed:NO];
        if (isDownloadPrevented) {
            self.isDownloadPrevented = isDownloadPrevented.boolValue ? BOXAPIBooleanYES : BOXAPIBooleanNO;
        }
    }

    return self;
}

@end
