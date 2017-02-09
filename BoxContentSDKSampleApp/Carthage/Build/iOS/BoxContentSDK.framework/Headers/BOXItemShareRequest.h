//
//  BOXItemShareRequest.h
//  BoxContentSDK
//
//  Created on 1/29/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXItemShareRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, strong) BOXSharedLinkAccessLevel *accessLevel;

// Can only be set if the user has been granted permission (yes, it’s complicated) and is not a free user.
@property (nonatomic, readwrite, strong) NSDate *expirationDate;

// Set this value to YES to remove a shared link's expiration date
@property (nonatomic, readwrite, assign) BOOL removeExpirationDate;

// Can only be used with open and company access levels.
@property (nonatomic, readwrite, assign) BOOL canDownload;

// Can only be used with open and company access levels.
@property (nonatomic, readwrite, assign) BOOL canPreview;

// Optional, if nil the file will get deleted if it exists and deletion is permissable.
// If an etag value is supplied, the file will only be deleted if the provided etag matches the current value.
@property (nonatomic, readwrite, strong) NSString *matchingEtag;

- (void)performRequestWithCompletion:(BOXItemBlock)completionBlock;

@end
