//
//  ThumbnailsHelper.h
//  BoxContentSDKSampleApp
//
//  Created on 1/7/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOXSampleThumbnailsHelper : NSObject

+ (instancetype)sharedInstance;

- (void)storeThumbnailForItemWithID:(NSString *)itemID userID:(NSString *)userID thumbnail:(UIImage *)thumbnail;
- (UIImage *)thumbnailForItemWithID:(NSString *)itemID userID:(NSString *)userID;

- (BOOL)shouldDownloadThumbnailForItemWithName:(NSString *)itemName;

@end
