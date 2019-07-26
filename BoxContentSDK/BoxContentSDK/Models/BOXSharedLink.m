//
//  BOXSharedLink.m
//  BoxContentSDK
//
//  Created by Scott Liu on 11/5/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXSharedLink.h"

@implementation BOXSharedLink

- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    if (self = [super init]) {
        
        self.JSONData = JSONResponse;
        
        NSString *urlString = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyURL
                                                             inDictionary:JSONResponse
                                                          hasExpectedType:[NSString class]
                                                              nullAllowed:YES
                                                        suppressNullAsNil:YES];
        if (urlString.length > 0) {
            self.url = [NSURL URLWithString:urlString];
        }
        
        NSString *downloadUrlString = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyDownloadURL
                                                                     inDictionary:JSONResponse
                                                                  hasExpectedType:[NSString class]
                                                                      nullAllowed:YES
                                                                suppressNullAsNil:YES];
        if (downloadUrlString.length > 0) {
            self.downloadURL = [NSURL URLWithString:downloadUrlString];
        }
        
        NSString *vanityUrlString = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyVanityURL
                                                                   inDictionary:JSONResponse
                                                                hasExpectedType:[NSString class]
                                                                    nullAllowed:YES
                                                              suppressNullAsNil:YES];
        if (vanityUrlString.length > 0) {
            self.vanityURL = [NSURL URLWithString:vanityUrlString];
        }
        
        NSNumber *isPasswordEnabledNumber = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyIsPasswordEnabled
                                                                     inDictionary:JSONResponse
                                                                  hasExpectedType:[NSNumber class]
                                                                      nullAllowed:NO];
        if (isPasswordEnabledNumber) {
            self.isPasswordEnabled = isPasswordEnabledNumber.boolValue ? BOXAPIBooleanYES : BOXAPIBooleanNO;
        }
        
        self.accessLevel = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyAccess
                                                          inDictionary:JSONResponse
                                                       hasExpectedType:[NSString class]
                                                           nullAllowed:NO];

        self.effectiveAccessLevel = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyEffectiveAccess
                                                                   inDictionary:JSONResponse
                                                                hasExpectedType:[NSString class]
                                                                    nullAllowed:NO];
        if ([self.effectiveAccessLevel length] == 0) {
            self.effectiveAccessLevel = self.accessLevel;
        }

        self.canDownload = BOXAPIBooleanUnknown;
        self.canPreview = BOXAPIBooleanUnknown;
        
        NSDictionary *permissions = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyPermissions
                                                                   inDictionary:JSONResponse
                                                                hasExpectedType:[NSDictionary class]
                                                                    nullAllowed:NO];
        if (permissions != nil) {
            NSNumber *canDownloadNumber = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCanDownload
                                                                         inDictionary:permissions
                                                                      hasExpectedType:[NSNumber class]
                                                                          nullAllowed:NO];
            if (canDownloadNumber) {
                self.canDownload = canDownloadNumber.boolValue ? BOXAPIBooleanYES : BOXAPIBooleanNO;
            }
            
            NSNumber *canPreviewNumber = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCanPreview
                                                                        inDictionary:permissions
                                                                     hasExpectedType:[NSNumber class]
                                                                         nullAllowed:NO];
            if (canPreviewNumber) {
                self.canPreview = canDownloadNumber.boolValue ? BOXAPIBooleanYES : BOXAPIBooleanNO;
            }
        }
        
        NSString *expirationDateString = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyUnsharedAt
                                                                        inDictionary:JSONResponse
                                                                     hasExpectedType:[NSString class]
                                                                         nullAllowed:YES
                                                                   suppressNullAsNil:YES];
        if (expirationDateString) {
            self.expirationDate = [NSDate box_dateWithISO8601String:expirationDateString];
        }
        
        self.downloadCount = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyDownloadCount
                                                            inDictionary:JSONResponse
                                                         hasExpectedType:[NSNumber class]
                                                             nullAllowed:NO];
        
        self.previewCount = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyPreviewCount
                                                            inDictionary:JSONResponse
                                                         hasExpectedType:[NSNumber class]
                                                             nullAllowed:NO];
    }
    
    return self;
}

@end
