//
//  ThumbnailsHelper.m
//  BoxContentSDKSampleApp
//
//  Created on 1/7/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXSampleThumbnailsHelper.h"

@interface BOXSampleThumbnailsHelper()

/**
 * In memory cache containing the thumbnails that we already downloaded in this session
 * Key : NSString using the format "userID_modelID"
 * Object : UIImage
 **/
@property (nonatomic, readwrite, strong) NSMutableDictionary *thumbnailCache;

@end

@implementation BOXSampleThumbnailsHelper

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _thumbnailCache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)storeThumbnailForItemWithID:(NSString *)itemID userID:(NSString *)userID thumbnail:(UIImage *)thumbnail
{
    NSString *key = [self keyForItemID:itemID userID:userID];
    if (thumbnail == nil) {
        [self.thumbnailCache removeObjectForKey:key];
    } else {
        [self.thumbnailCache setObject:thumbnail forKey:key];
    }
}

- (UIImage *)thumbnailForItemWithID:(NSString *)itemID userID:(NSString *)userID
{
    return [self.thumbnailCache objectForKey:[self keyForItemID:itemID userID:userID]];
}

- (BOOL)shouldDownloadThumbnailForItemWithName:(NSString *)itemName
{
    BOOL supportsThumbnail = NO;
    
    NSString *extension = [[itemName pathExtension] lowercaseString];
    
    if ([extension isEqualToString:@"png"] ||
        [extension isEqualToString:@"jpg"] ||
        [extension isEqualToString:@"jpeg"] ||
        [extension isEqualToString:@"gif"] ||
        [extension isEqualToString:@"tiff"] ||
        [extension isEqualToString:@"tif"] ||
        [extension isEqualToString:@"bmp"] ||
        [extension isEqualToString:@"avi"] ||
        [extension isEqualToString:@"m4v"] ||
        [extension isEqualToString:@"mov"] ||
        [extension isEqualToString:@"mp4"])
    {
        supportsThumbnail = YES;
    }

    
    return supportsThumbnail;
}

#pragma mark - Private Helpers

- (NSString *)keyForItemID:(NSString *)itemID userID:(NSString *)userID
{
    return [NSString stringWithFormat:@"%@_%@",userID, itemID];
}

@end
