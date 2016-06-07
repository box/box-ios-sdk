//
//  UIApplication+ExtensionSafeAdditions.m
//
//  Copyright © 2016 Box. All rights reserved.
//

#import "UIApplication+ExtensionSafeAdditions.h"

@implementation UIApplication (ExtensionSafeAdditions)

+ (UIApplication *)box_sharedApplication
{
#ifndef BOX_TARGET_IS_EXTENSION
    // If we are compiling from a non-extension target, use the regular sharedApplication.
    return [UIApplication sharedApplication];
#else
    // If we are compiling from an extension, return nil here since UIApplication isn't extension-safe.
    return nil;
#endif
}

- (BOOL)box_canOpenURL:(NSURL *)url
{
#ifndef BOX_TARGET_IS_EXTENSION
    // If we are compiling from a non-extension target, use the regular sharedApplication.
    return [[UIApplication sharedApplication] canOpenURL:url];
#else
    // If we are compiling from an extension, do nothing and return NO here since UIApplication isn't extension-safe.
    return NO;
#endif
}

- (BOOL)box_openURL:(NSURL*)url
{
#ifndef BOX_TARGET_IS_EXTENSION
    // If we are compiling from a non-extension target, use the regular sharedApplication.
    return [[UIApplication sharedApplication] openURL:url];
#else
    // If we are compiling from an extension, do nothing and return NO here since UIApplication isn't extension-safe.
    return NO;
#endif
}

@end
