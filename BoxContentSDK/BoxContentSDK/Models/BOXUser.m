//
//  BOXUser.m
//  BoxContentSDK
//
//  Created by Scott Liu on 11/12/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXUser_Private.h"

@implementation BOXUserMini

- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    BOXAssert([JSONResponse[BOXAPIObjectKeyType] isEqualToString:BOXAPIItemTypeUser], @"Invalid type for object.");
    
    if (self = [super initWithJSON:JSONResponse])
    {
        self.name = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyName
                                                   inDictionary:JSONResponse
                                                hasExpectedType:[NSString class]
                                                    nullAllowed:NO];
        
        self.login = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyLogin
                                                    inDictionary:JSONResponse
                                                 hasExpectedType:[NSString class]
                                                     nullAllowed:NO
                                               suppressNullAsNil:NO];
    }
    
    return self;
}

- (instancetype)initWithUserID:(NSString *)userID name:(NSString *)name login:(NSString *)login;
{
    if (self = [super init])
    {
        self.modelID = userID;
        self.login = login;
        self.name = name;
    }
    
    return self;
}

@end

@implementation BOXUser

- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    if (self = [super initWithJSON:JSONResponse])
    {
        self.createdDate = [NSDate box_dateWithISO8601String:[NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCreatedAt
                                                                                       inDictionary:JSONResponse
                                                                                    hasExpectedType:[NSString class]
                                                                                        nullAllowed:NO]];
        
        self.modifiedDate = [NSDate box_dateWithISO8601String:[NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyModifiedAt
                                                                                       inDictionary:JSONResponse
                                                                                    hasExpectedType:[NSString class]
                                                                                        nullAllowed:NO]];
        
        self.language = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyLanguage
                                                       inDictionary:JSONResponse
                                                    hasExpectedType:[NSString class]
                                                        nullAllowed:NO];
        
        self.timeZone = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyTimezone
                                                       inDictionary:JSONResponse
                                                    hasExpectedType:[NSString class]
                                                        nullAllowed:NO];
        
        self.spaceAmount = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeySpaceAmount
                                                          inDictionary:JSONResponse
                                                       hasExpectedType:[NSNumber class]
                                                           nullAllowed:NO];
        
        self.spaceUsed = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeySpaceUsed
                                                        inDictionary:JSONResponse
                                                     hasExpectedType:[NSNumber class]
                                                         nullAllowed:NO];
        
        self.maxUploadSize = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyMaxUploadSize
                                                            inDictionary:JSONResponse
                                                         hasExpectedType:[NSNumber class]
                                                             nullAllowed:NO];
        
        self.status = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyStatus
                                                     inDictionary:JSONResponse
                                                  hasExpectedType:[NSString class]
                                                      nullAllowed:NO];
        
        self.jobTitle = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyJobTitle
                                                       inDictionary:JSONResponse
                                                    hasExpectedType:[NSString class]
                                                        nullAllowed:NO];
        
        self.phone = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyPhone
                                                    inDictionary:JSONResponse
                                                 hasExpectedType:[NSString class]
                                                     nullAllowed:NO];
        
        self.address = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyAddress
                                                      inDictionary:JSONResponse
                                                   hasExpectedType:[NSString class]
                                                       nullAllowed:NO];
        
        NSString *avatarURLString = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyAvatarURL
                                                                   inDictionary:JSONResponse
                                                                hasExpectedType:[NSString class]
                                                                    nullAllowed:NO];
        if (avatarURLString) {
            self.avatarURL = [NSURL URLWithString:avatarURLString];
        }
        
        self.role = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyRole
                                                   inDictionary:JSONResponse
                                                hasExpectedType:[NSString class]
                                                    nullAllowed:NO];
        
        self.trackingCodes = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyTrackingCodes
                                                            inDictionary:JSONResponse
                                                         hasExpectedType:[NSArray class]
                                                             nullAllowed:NO];
        
        self.canSeeManagedUsers = BOXAPIBooleanUnknown;
        NSNumber *canSeeManagedUsersNumber = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCanSeeManagedUsers
                                                                            inDictionary:JSONResponse
                                                                         hasExpectedType:[NSNumber class]
                                                                             nullAllowed:NO];
        if (canSeeManagedUsersNumber != nil)
        {
            self.canSeeManagedUsers = canSeeManagedUsersNumber.boolValue ? BOXAPIBooleanYES : BOXAPIBooleanNO;
        }
        
        self.isSyncEnabled = BOXAPIBooleanUnknown;
        NSNumber *isSyncEnabledNumber = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyIsSyncEnabled
                                                                       inDictionary:JSONResponse
                                                                    hasExpectedType:[NSNumber class]
                                                                        nullAllowed:NO];
        if (isSyncEnabledNumber != nil)
        {
            self.isSyncEnabled = isSyncEnabledNumber.boolValue ? BOXAPIBooleanYES : BOXAPIBooleanNO;
        }
        
        self.isExternalCollabRestricted = BOXAPIBooleanUnknown;
        NSNumber *isExternalCollabRestrictedNumber = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyIsExternalCollabRestricted
                                                                                    inDictionary:JSONResponse
                                                                                 hasExpectedType:[NSNumber class]
                                                                                     nullAllowed:NO];
        if (isExternalCollabRestrictedNumber != nil)
        {
            self.isExternalCollabRestricted = isExternalCollabRestrictedNumber.boolValue ? BOXAPIBooleanYES : BOXAPIBooleanNO;
        }
        
        self.isExemptFromDeviceLimits = BOXAPIBooleanUnknown;
        NSNumber *isExcemptFromDeviceLimitsNumber = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyIsExemptFromDeviceLimits
                                                                                   inDictionary:JSONResponse
                                                                                hasExpectedType:[NSNumber class]
                                                                                    nullAllowed:NO];
        if (isExcemptFromDeviceLimitsNumber != nil)
        {
            self.isExemptFromDeviceLimits = isExcemptFromDeviceLimitsNumber.boolValue ? BOXAPIBooleanYES : BOXAPIBooleanNO;
        }
        
        self.isExemptFromLoginVerification = BOXAPIBooleanUnknown;
        NSNumber *isExcemptFromLoginVerificationNumber = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyIsExemptFromLoginVerification
                                                                                        inDictionary:JSONResponse
                                                                                     hasExpectedType:[NSNumber class]
                                                                                         nullAllowed:NO];
        if (isExcemptFromLoginVerificationNumber != nil)
        {
            self.isExemptFromLoginVerification = isExcemptFromLoginVerificationNumber.boolValue ? BOXAPIBooleanYES : BOXAPIBooleanNO;
        }
        
        NSDictionary *enterpriseDictionary = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyEnterprise
                                                                            inDictionary:JSONResponse
                                                                         hasExpectedType:[NSDictionary class]
                                                                             nullAllowed:YES
                                                                       suppressNullAsNil:YES];
        if (enterpriseDictionary)
        {
            self.enterprise = [[BOXEnterpriseMini alloc] initWithJSON:enterpriseDictionary];
        }
    }
    
    return self;
}

@end
