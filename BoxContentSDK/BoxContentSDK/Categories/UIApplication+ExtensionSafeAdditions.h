//
//  UIApplication+ExtensionSafeAdditions.h
//
//  Copyright © 2016 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  This category's purpose is to allow successful compilation when using BOXContentSDK in an extension.
 *  If the target is an extension, simply add the build flag BOX_TARGET_IS_EXTENSION to it to avoid any
 *  build failures because of unsafe API calls.
 */
@interface UIApplication (ExtensionSafeAdditions)

+ (UIApplication *)box_sharedApplication;

- (BOOL)box_openURL:(NSURL *)url;

- (BOOL)box_canOpenURL:(NSURL *)url;

@end
