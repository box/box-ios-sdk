//
//  UIDevice+BOXAdditions.m
//  BoxContentSDK
//
//  Created on 3/21/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import "UIDevice+BOXContentSDKAdditions.h"
#include <sys/sysctl.h>

@implementation UIDevice (BOXContentSDKAdditions)

- (NSString *)modelID
{
    NSString *model = nil;
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    
    // check that machine was correctly allocated by malloc.
    // Not checking is considered a security vulnerability by Veracode
    if (machine != NULL) {
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    }
    
    return model;
}

+ (BOOL)isSingleCore
{
    static NSArray *singleCoreMachines = nil;
    static NSString *machine = nil;
    
    if (machine == nil) {
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *name = NULL;
        if ((name = malloc(size)) != NULL) {
            sysctlbyname("hw.machine", name, &size, NULL, 0);
            machine = [NSString stringWithUTF8String:name];
            free(name);
        }
    }
    
    if (singleCoreMachines == nil) {
        singleCoreMachines = @[
                               //@"i386",      //Simulator
                               //@"x86_64",    //Simulator
                               @"iPhone1,1", //iPhone
                               @"iPhone1,2", //iPhone 3G
                               @"iPhone2,1", //iPhone 3GS
                               @"iPhone3,1", //iPhone 4
                               //@"iPhone4,1", //iPhone 4S
                               //@"iPhone5,1", //iPhone 5
                               @"iPod1,1",   //iPod 1
                               @"iPod2,1",   //iPod 2
                               @"iPod3,1",   //iPod 3
                               @"iPod4,1",   //iPod 4
                               //@"iPod5,1",   //iPod 5
                               @"iPad",      //iPad 1
                               //@"iPad2,1",   //iPad 2 Wifi
                               //@"iPad2,2",   //iPad 2 GSM
                               //@"iPad2,3",   //iPad 2 CDMA
                               //@"iPad2,4",   //iPad 2 Wifi + New Chip
                               //@"iPad2,5",   //iPad Mini Wifi
                               //@"iPad2,6",   //iPad Mini GSM
                               //@"iPad3,1",   //iPad 3 Wifi
                               //@"iPad3,2",   //iPad 3 GSM
                               //@"iPad3,3",   //iPad 3 CDMA
                               ];
    }
    
    return [singleCoreMachines containsObject:machine];
}

+ (BOXiOSVersion)iOSVersion
{
    static BOXiOSVersion __iOSVersion = BOXiOSVersionUnknown;
    if (__iOSVersion == BOXiOSVersionUnknown) {
        NSString *iOSVersionString = [[UIDevice currentDevice] systemVersion];
        
        NSArray *versionComponents = [iOSVersionString componentsSeparatedByString:@"."];
        NSUInteger componentCount = [versionComponents count];
        NSUInteger majorVersion = componentCount ? [[versionComponents objectAtIndex:0] intValue] : 0;
        NSUInteger minorVersion = componentCount > 1 ? [[versionComponents objectAtIndex:1] intValue] : 0;
        
        if (majorVersion < 7) {
            __iOSVersion = BOXiOSVersionTooOld;
        } else if (majorVersion == 7) {
            if (minorVersion == 0) {
                __iOSVersion = BOXiOSVersion7;
            } else if (minorVersion == 1) {
                __iOSVersion = BOXiOSVersion7_1;
            }
        } else if (majorVersion == 8) {
            __iOSVersion = BOXiOSVersion8;
        } else if (majorVersion == 9) {
            __iOSVersion = BOXiOSVersion9;
        } else if (majorVersion == 10) {
            __iOSVersion = BOXiOSVersion10;
        } else if (majorVersion > 10) {
            __iOSVersion = BOXiOSVersionLatest;
        }
    }
    return __iOSVersion;
}

+ (BOOL)isRunningiOS10xOrLater
{
    return [UIDevice iOSVersion] >= BOXiOSVersion10;
}

- (BOOL)isIpad
{
    return [self userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

- (BOOL)isIphone
{
    return [self userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
}

- (NSString *)deviceName
{
    return self.name;
}

- (NSString *)deviceTypeString
{
    return ([self isIpad]) ? @"iPad" : @"iPhone";
}

/*
 From iOS 6.1 beta Downloads listing:
 iPad Wi-Fi (3rd generation)
 iPad Wi-Fi + Cellular (model for ATT)
 iPad Wi-Fi + Cellular (model for Verizon)
 iPad 2 Wi-Fi (Rev A)
 iPad 2 Wi-Fi
 iPad 2 Wi-Fi + 3G (GSM)
 iPad 2 Wi-Fi + 3G (CDMA)
 iPhone 5 (Model A1428)
 iPhone 5 (Model A1429)
 iPhone 4S
 iPhone 4 (GSM)
 iPhone 4 (CDMA)
 iPhone 3GS
 iPod touch (5th generation)
 iPod touch (4th generation)
 */
- (NSString *)detailedModelName
{
    NSString *modelID = [self modelID];
    
    if ([modelID isEqualToString:@"iPhone1,1"]) {
        return @"iPhone";
    } else if ([modelID isEqualToString:@"iPhone1,2"]) {
        return @"iPhone 3G";
    } else if ([modelID isEqualToString:@"iPhone2,1"]) {
        return @"iPhone 3GS";
    } else if ([modelID isEqualToString:@"iPhone3,1"]) {
        return @"iPhone 4 (GSM)"; // AT&T
    } else if ([modelID isEqualToString:@"iPhone3,2"]) {
        return @"iPhone 4 (CDMA)"; // Verizon
    } else if ([modelID isEqualToString:@"iPhone3,3"]) {
        return @"iPhone 4 (CDMA 2nd Generation)"; // Verizon / Sprint
    } else if ([modelID isEqualToString:@"iPhone4,1"]) {
        return @"iPhone 4S"; // World Phone (AT&T, Verizon, and Sprint)
    } else if ([modelID isEqualToString:@"iPhone5,1"]) {
        return @"iPhone 5 (GSM)"; // With LTE. US and International.
    } else if ([modelID isEqualToString:@"iPhone5,2"]) {
        return @"iPhone 5 (CDMA)"; // With LTE
    } else if ([modelID isEqualToString:@"iPhone5,3"]) {
        return @"iPhone 5c";
    } else if ([modelID isEqualToString:@"iPhone5,4"]) {
        return @"iPhone 5c (UMTS)";
    } else if ([modelID isEqualToString:@"iPhone6,1"]) {
        return @"iPhone 5s";
    } else if ([modelID isEqualToString:@"iPhone6,2"]) {
        return @"iPhone 5s (UMTS)";
    } else if ([modelID isEqualToString:@"iPhone7,1"]) {
        return @"iPhone 6 Plus";
    } else if ([modelID isEqualToString:@"iPhone7,2"]) {
        return @"iPhone 6";
    } else if ([modelID isEqualToString:@"iPhone8,1"]) {
        return @"iPhone 6S";
    } else if ([modelID isEqualToString:@"iPhone8,2"]) {
        return @"iPhone 6S Plus";
    } else if ([modelID isEqualToString:@"iPhone8,4"]) {
        return @"iPhone SE";
    } else if ([modelID isEqualToString:@"iPhone9,1"]) {
        return @"iPhone 7 (CDMA)";
    } else if ([modelID isEqualToString:@"iPhone9,2"]) {
        return @"iPhone 7 Plus (CDMA)";
    } else if ([modelID isEqualToString:@"iPhone9,3"]) {
        return @"iPhone 7";
    } else if ([modelID isEqualToString:@"iPhone9,4"]) {
        return @"iPhone 7 Plus";
    } else if ([modelID isEqualToString:@"iPod1,1"]) {
        return @"iPod touch 1st Generation";
    } else if ([modelID isEqualToString:@"iPod2,1"]) {
        return @"iPod touch 2nd Generation";
    } else if ([modelID isEqualToString:@"iPod3,1"]) {
        return @"iPod touch 3rd Generation";
    } else if ([modelID isEqualToString:@"iPod4,1"]) {
        return @"iPod touch 4th Generation";
    } else if ([modelID isEqualToString:@"iPod5,1"]) {
        return @"iPod touch 5th Generation";
    } else if ([modelID isEqualToString:@"iPod7,1"]) {
        return @"iPod touch 6th Generation";
    } else if ([modelID isEqualToString:@"iPad1,1"]) {
        return @"iPad";
    } else if ([modelID isEqualToString:@"iPad2,1"]) {
        return @"iPad 2 (WiFi)";
    } else if ([modelID isEqualToString:@"iPad2,2"]) {
        return @"iPad 2 (GSM)"; // AT&T
    } else if ([modelID isEqualToString:@"iPad2,3"]) {
        return @"iPad 2 (CDMA)"; // Verizon
    } else if ([modelID isEqualToString:@"iPad2,4"]) {
        return @"iPad 2 (WiFi) Rev A";
        // Reduced price $399 iPad 2 sold alongside new (3rd and 4th gen) iPad
    } else if ([modelID isEqualToString:@"iPad2,5"]) {
        return @"iPad mini (WiFi)";
    } else if ([modelID isEqualToString:@"iPad2,6"]) {
        return @"iPad mini (GSM)"; // AT&T
    } else if ([modelID isEqualToString:@"iPad2,7"]) {
        return @"iPad mini (CDMA)"; // Verizon
    } else if ([modelID isEqualToString:@"iPad3,1"]) {
        return @"iPad 3rd Generation (WiFi)";
    } else if ([modelID isEqualToString:@"iPad3,2"]) {
        return @"iPad 3rd Generation (4G LTE CDMA)"; // Verizon
    } else if ([modelID isEqualToString:@"iPad3,3"]) {
        return @"iPad 3rd Generation (4G LTE)"; // AT&T
    } else if ([modelID isEqualToString:@"iPad3,4"]) {
        return @"iPad 4rd Generation (WiFi)";
    } else if ([modelID isEqualToString:@"iPad3,5"]) {
        return @"iPad 4rd Generation (4G LTE)"; // AT&T
    } else if ([modelID isEqualToString:@"iPad3,6"]) {
        return @"iPad 4rd Generation (4G LTE CDMA)"; // Verizon
    } else if ([modelID isEqualToString:@"iPad4,1"]) {
        return @"iPad Air (WiFi)";
    } else if ([modelID isEqualToString:@"iPad4,2"]) {
        return @"iPad Air (4G LTE)";
    } else if ([modelID isEqualToString:@"iPad4,3"]) {
        return @"iPad Air (4G LTE - China)";
    } else if ([modelID isEqualToString:@"iPad4,4"]) {
        return @"iPad mini 2nd Generation (WiFi)";
    } else if ([modelID isEqualToString:@"iPad4,5"]) {
        return @"iPad mini 2nd Generation (4G LTE)";
    } else if ([modelID isEqualToString:@"iPad4,6"]) {
        return @"iPad mini 2nd Generation (4G LTE - China)";
    } else if ([modelID isEqualToString:@"iPad4,7"]) {
        return @"iPad mini 3 (WiFi)";
    } else if ([modelID isEqualToString:@"iPad4,8"]) {
        return @"iPad mini 3 (4G LTE)";
    } else if ([modelID isEqualToString:@"iPad4,9"]) {
        return @"iPad mini 3 (4G LTE - China)";
    } else if ([modelID isEqualToString:@"iPad5,1"]) {
        return @"iPad mini 4 (WiFi)";
    } else if ([modelID isEqualToString:@"iPad5,2"]) {
        return @"iPad mini 4 (4G LTE)";
    } else if ([modelID isEqualToString:@"iPad5,3"]) {
        return @"iPad Air 2 (WiFi)";
    } else if ([modelID isEqualToString:@"iPad5,4"]) {
        return @"iPad Air 2 (4G LTE)";
    } else if ([modelID isEqualToString:@"iPad6,3"]) {
        return @"iPad Pro 9.7-inch (WiFi)";
    } else if ([modelID isEqualToString:@"iPad6,4"]) {
        return @"iPad Pro 9.7-inch (4G LTE)";
    } else if ([modelID isEqualToString:@"iPad6,7"]) {
        return @"iPad Pro 12.9-inch (WiFi)";
    } else if ([modelID isEqualToString:@"iPad6,8"]) {
        return @"iPad Pro 12.9-inch (4G LTE)";
    } else if ([modelID isEqualToString:@"i386"] || [modelID isEqualToString:@"x86_64"] || [modelID isEqualToString:@"x86_32"]) {
        return @"Simulator";
    }
    
    return modelID;
}

@end
