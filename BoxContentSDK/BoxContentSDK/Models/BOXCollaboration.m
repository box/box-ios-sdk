//
//  BOXCollaboration.m
//  BoxContentSDK
//
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXCollaboration.h"
#import "BOXUser.h"
#import "BOXGroup.h"
#import "BOXFolder.h"

@implementation BOXCollaboration

- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    BOXAssert([JSONResponse[BOXAPIObjectKeyType] isEqualToString:BOXAPIItemTypeCollaboration], @"Invalid type for object.");
    
    if (self = [super initWithJSON:JSONResponse])
    {
        NSDictionary *creatorDictionary = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCreatedBy
                                                                         inDictionary:JSONResponse
                                                                      hasExpectedType:[NSDictionary class]
                                                                          nullAllowed:YES
                                                                    suppressNullAsNil:YES];
        
        if (creatorDictionary) {
            self.creator = [[BOXUserMini alloc] initWithJSON:creatorDictionary];
        }
        
        self.createdDate = [NSDate box_dateWithISO8601String:[NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCreatedAt
                                                                                            inDictionary:JSONResponse
                                                                                         hasExpectedType:[NSString class]
                                                                                             nullAllowed:NO]];
        
        self.modificationDate = [NSDate box_dateWithISO8601String:[NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyModifiedAt
                                                                                                 inDictionary:JSONResponse
                                                                                              hasExpectedType:[NSString class]
                                                                                                  nullAllowed:NO]];
        
        self.expirationDate = [NSDate box_dateWithISO8601String:[NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyExpiresAt
                                                                                               inDictionary:JSONResponse
                                                                                            hasExpectedType:[NSString class]
                                                                                                nullAllowed:YES
                                                                                          suppressNullAsNil:YES]];
        
        self.status = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyStatus
                                                     inDictionary:JSONResponse
                                                  hasExpectedType:[NSString class]
                                                      nullAllowed:NO];
        
        NSDictionary *accessibleByDictionary = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyAccessibleBy
                                                                              inDictionary:JSONResponse
                                                                           hasExpectedType:[NSDictionary class]
                                                                               nullAllowed:YES
                                                                         suppressNullAsNil:YES];
        
        NSString *accessibleByType = [accessibleByDictionary objectForKey:BOXAPIObjectKeyType];
        if ([accessibleByType isEqualToString:BOXAPIItemTypeUser]) {
            self.accessibleBy = [[BOXUserMini alloc] initWithJSON:accessibleByDictionary];
        } else if ([accessibleByType isEqualToString:BOXAPIItemTypeGroup]) {
            self.accessibleBy = [[BOXGroup alloc] initWithJSON:accessibleByDictionary];
        }
        
        self.role = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyRole
                                                   inDictionary:JSONResponse
                                                hasExpectedType:[NSString class]
                                                    nullAllowed:NO];
        
        self.acknowledgedDate = [NSDate box_dateWithISO8601String:[NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyAcknowledgedAt
                                                                                                 inDictionary:JSONResponse
                                                                                              hasExpectedType:[NSString class]
                                                                                                  nullAllowed:YES
                                                                                            suppressNullAsNil:YES]]; // Will be null for pending collaborations
        
        NSDictionary *folderDictionary = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyItem
                                                                        inDictionary:JSONResponse
                                                                     hasExpectedType:[NSDictionary class]
                                                                         nullAllowed:YES
                                                                   suppressNullAsNil:YES];
        if (folderDictionary) {
            self.folder = [[BOXFolderMini alloc] initWithJSON:folderDictionary];
        }
    }
    
    return self;
}

@end
