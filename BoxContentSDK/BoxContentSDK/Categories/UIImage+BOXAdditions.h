//
//  UIImage+BOXAdditions.h
//  BoxContentSDK
//
//  Created on 6/3/13.
//  Copyright (c) 2013 Box. All rights reserved.
//
//  NOTE: this file is a mirror of BoxCocoaSDK/Categories/NSImage+BOXAdditions.h. Changes made here should be reflected there.
//

#import <UIKit/UIKit.h>

/**
 * The BoxAdditions category on UIImage provides a method for loading
 * images from the BoxContentSDK resources bundle.
 */
@interface UIImage (BOXAdditions)

/**
 * Returns an image with the appropriate scale factor given the device.
 *
 * @return An image with the appropriate scale.
 */
- (UIImage *)imageWith2XScaleIfRetina;


@end