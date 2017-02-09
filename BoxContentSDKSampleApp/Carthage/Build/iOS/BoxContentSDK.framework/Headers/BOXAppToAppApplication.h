//
//  BOXAppToAppApplication.h
//  BoxSDK
//
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

// Represents any app that supports Box app-to-app communication. This includes
// the Box app itself, as well as all partner apps.
@interface BOXAppToAppApplication : NSObject <NSCoding>

@property (nonatomic, readonly, strong) NSString *name;
@property (nonatomic, readonly, strong) NSString *bundleID;
@property (nonatomic, readonly, strong) NSString *clientID;
@property (nonatomic, readonly, strong) NSString *urlScheme;
@property (nonatomic, readonly, strong) NSString *authRedirectURIString;

+ (BOXAppToAppApplication *)appToAppApplicationWithInfo:(NSMutableDictionary *)info;

/**
 * You will probably use this function once, in order to create a BOXAppToAppApplication
 * representing your own app, which you will then assign to
 * `BOXAppToAppManager.currentApplication`.
 *
 * @param name The name of your application. For example, @"My App".
 * @param bundleID The bundle ID of your application. For example, @"com.example.my-bundle-id".
 * @param clientID The Box API OAuth2 client ID of your application. For example, @"0xyzabc12345".
 * @param URLScheme The URL scheme of your app, which the Box app can use to send messages
 *   (e.g. edit-file or create-file messages) to your app. For example, @"myscheme".
 * @param authRedirectURIString The redirect URI string that your app uses when it is
 *   receiving an authcode from the Box app. For example, @"myauthscheme://auth".
 *
 */
+ (BOXAppToAppApplication *)appToAppApplicationWithName:(NSString *)name
                                               bundleID:(NSString *)bundleID
                                               clientID:(NSString *)clientID
                                              URLScheme:(NSString *)URLScheme
                                  authRedirectURIString:(NSString *)authRedirectURIString;

+ (BOXAppToAppApplication *)BoxApplication;

- (BOOL)isInstalled;

@end
