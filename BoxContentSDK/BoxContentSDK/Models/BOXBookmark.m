//
//  BOXBookmark.m
//  BoxContentSDK
//
//  Created on 12/4/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXBookmark.h"

@implementation BOXBookmarkMini

- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    BOXAssert([JSONResponse[BOXAPIObjectKeyType] isEqualToString:BOXAPIItemTypeWebLink], @"Invalid type for object.");
    
    self = [super initWithJSON:JSONResponse];

    if (self != nil) {
        NSString *URLString = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyURL
                                                             inDictionary:JSONResponse
                                                          hasExpectedType:[NSString class]
                                                              nullAllowed:NO];
        self.URL = [NSURL URLWithString:URLString];
    }
    
    return self;
}

- (BOOL)isBookmark
{
    return YES;
}

@end

@implementation BOXBookmark

- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    self = [super initWithJSON:JSONResponse];
    if (self != nil) {
        NSString *URLString = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyURL
                                                             inDictionary:JSONResponse
                                                          hasExpectedType:[NSString class]
                                                              nullAllowed:NO];
        self.URL = [NSURL URLWithString:URLString];
        
        self.commentCount = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCommentCount
                                                           inDictionary:JSONResponse
                                                        hasExpectedType:[NSNumber class]
                                                            nullAllowed:NO];

        
        // Parse Permissions.
        //FIXME: Uncomment when permissions are put back in (expected within a week or two from 12/5/2014).
//        NSDictionary *permissions = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyPermissions
//                                                                   inDictionary:JSONResponse
//                                                                hasExpectedType:[NSDictionary class]
//                                                                    nullAllowed:NO];
//        [self parsePermssionsFromJSON:permissions];
    }

    return self;
}

- (void)parsePermssionsFromJSON:(NSDictionary *)permissions
{
    if ([permissions count] > 0) {
        NSNumber *canComment = permissions[BOXAPIObjectKeyCanComment];
        if (canComment != nil) {
            self.canComment = canComment.boolValue ? BOXAPIBooleanYES : BOXAPIBooleanNO;
        }

        NSNumber *canRename = permissions[BOXAPIObjectKeyCanRename];
        if (canRename != nil) {
            self.canRename = canRename.boolValue ? BOXAPIBooleanYES : BOXAPIBooleanNO;
        }

        NSNumber *canDelete = permissions[BOXAPIObjectKeyCanDelete];
        if (canDelete != nil) {
            self.canDelete = canDelete.boolValue ? BOXAPIBooleanYES : BOXAPIBooleanNO;
        }

        NSNumber *canShare = permissions[BOXAPIObjectKeyCanShare];
        if (canShare != nil) {
            self.canShare = canShare.boolValue ? BOXAPIBooleanYES : BOXAPIBooleanNO;
        }

        NSNumber *canSetShareAccess = permissions[BOXAPIObjectKeyCanSetShareAccess];
        if (canSetShareAccess != nil) {
            self.canSetShareAccess = canSetShareAccess.boolValue ? BOXAPIBooleanYES : BOXAPIBooleanNO;
        }
    }
}

- (BOOL)isBookmark
{
    return YES;
}

@end
