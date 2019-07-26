//
//  UIApplication+ExtensionSafeAdditions.h
//
//  Copyright © 2016 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  This category's purpose is to allow successful compilation when using BOXContentSDK in an extension.
 */
@interface UIApplication (ExtensionSafeAdditions)

+ (UIApplication *)box_sharedApplication;

- (BOOL)box_openURL:(NSURL *)url;

- (BOOL)box_canOpenURL:(NSURL *)url;

- (UIWindow *)box_window;

@end
