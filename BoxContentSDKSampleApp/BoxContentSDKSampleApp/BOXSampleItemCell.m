//
//  ItemCell.m
//  BoxContentSDKSampleApp
//
//  Created on 1/7/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXSampleItemCell.h"
#import "BOXSampleThumbnailsHelper.h"

@interface BOXSampleItemCell()

@property (nonatomic, readwrite, strong) BOXFileThumbnailRequest *request;

@end

@implementation BOXSampleItemCell

- (void)prepareForReuse
{
    [self.request cancel];
    self.request = nil;
}

- (void)setItem:(BOXItem *)item
{
    if (item == nil) {
        return;
    }
    
    _item = item;
    self.textLabel.text = item.name;
    
    [self updateThumbnail];
}

- (void)updateThumbnail
{
    UIImage *icon = nil;
    
    if ([self.item isKindOfClass:[BOXFolder class]]) {
        if (((BOXFolder *) self.item).hasCollaborations == BOXAPIBooleanYES) {
            if (((BOXFolder *) self.item).isExternallyOwned == BOXAPIBooleanYES) {
                icon = [UIImage imageNamed:@"icon-folder-external"];
            } else {
                icon = [UIImage imageNamed:@"icon-folder-shared"];
            }
        } else {
            icon = [UIImage imageNamed:@"icon-folder"];
        }
    } else {
        BOXSampleThumbnailsHelper *thumbnailsHelper = [BOXSampleThumbnailsHelper sharedInstance];
        
        // Try to retrieve the thumbnail from our in memory cache
        UIImage *image = [thumbnailsHelper thumbnailForItemWithID:self.item.modelID userID:self.client.user.modelID];
        
        if (image) {
            icon = image;
        }
        // No cached version was found, we need to query it from our API
        else {
            icon = [UIImage imageNamed:@"icon-file-generic"];
            
            if ([thumbnailsHelper shouldDownloadThumbnailForItemWithName:self.item.name]) {
                self.request = [self.client fileThumbnailRequestWithID:self.item.modelID size:BOXThumbnailSize64];
                __weak BOXSampleItemCell *weakSelf = self;
            
                [self.request performRequestWithProgress:nil completion:^(UIImage *image, NSError *error) {
                    if (error == nil) {   
                        [thumbnailsHelper storeThumbnailForItemWithID:self.item.modelID userID:self.client.user.modelID thumbnail:image];
                        
                        weakSelf.imageView.image = image;
                        CATransition *transition = [CATransition animation];
                        transition.duration = 0.3f;
                        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                        transition.type = kCATransitionFade;
                        [weakSelf.imageView.layer addAnimation:transition forKey:nil];
                    }
                }];
            }    
        }
    }
    self.imageView.image = icon;
}

@end
