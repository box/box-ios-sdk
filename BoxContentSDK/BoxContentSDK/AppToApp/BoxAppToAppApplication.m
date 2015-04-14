//
//  BoxAppToAppApplication.m
//  BoxSDK
//
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BoxAppToAppApplication.h"
#import "BoxAppToAppAnnotationKeys.h"
#import "BoxAppToAppAnnotationBuilder.h"
#import <UIKit/UIKit.h>

@interface BoxAppToAppApplication()

@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readwrite, strong) NSString *bundleID;
@property (nonatomic, readwrite, strong) NSString *clientID;
@property (nonatomic, readwrite, strong) NSString *urlScheme;
@property (nonatomic, readwrite, strong) NSString *authRedirectURIString;

@end

@implementation BoxAppToAppApplication

- (id)initWithName:(NSString *)name
          bundleID:(NSString *)bundleID
          clientID:(NSString *)clientID
         urlScheme:(NSString *)urlScheme
authRedirectURIString:(NSString *)authRedirectURIString;
{
    if (self = [self init])
    {
        self.name = name;
        self.bundleID = bundleID;
        self.clientID = clientID;
        self.urlScheme = urlScheme;
        self.authRedirectURIString = authRedirectURIString;
    }
    return self;
}

+ (BoxAppToAppApplication *)appToAppApplicationWithInfo:(NSMutableDictionary *)info
{
    NSString *name = [BoxAppToAppAnnotationBuilder stringByDestructivelyParsingInfo:info forKey:BOX_APP_TO_APP_APPLICATION_NAME_KEY];
    NSString *bundleID = [BoxAppToAppAnnotationBuilder stringByDestructivelyParsingInfo:info forKey:BOX_APP_TO_APP_APPLICATION_BUNDLE_ID_KEY];
    NSString *clientID = [BoxAppToAppAnnotationBuilder stringByDestructivelyParsingInfo:info forKey:BOX_APP_TO_APP_APPLICATION_CLIENT_ID_KEY];
    NSString *urlScheme = [BoxAppToAppAnnotationBuilder stringByDestructivelyParsingInfo:info forKey:BOX_APP_TO_APP_MESSAGE_RETURN_URL_SCHEME_KEY];
    NSString *authRedirectURIString = [BoxAppToAppAnnotationBuilder stringByDestructivelyParsingInfo:info forKey:BOX_APP_TO_APP_APPLICATION_AUTH_REDIRECT_URI_STRING_KEY];

    return [[BoxAppToAppApplication alloc] initWithName:name
                                               bundleID:bundleID
                                               clientID:clientID
                                              urlScheme:urlScheme
                                  authRedirectURIString:authRedirectURIString];
}

+ (BoxAppToAppApplication *)appToAppApplicationWithName:(NSString *)name
                                               bundleID:(NSString *)bundleID
                                               clientID:(NSString *)clientID
                                              URLScheme:(NSString *)URLScheme
                                  authRedirectURIString:(NSString *)authRedirectURIString
{
    return [[BoxAppToAppApplication alloc] initWithName:name
                                               bundleID:bundleID
                                               clientID:clientID
                                              urlScheme:URLScheme
                                  authRedirectURIString:authRedirectURIString];
}

+ (BoxAppToAppApplication *)BoxApplication
{
    return [self appToAppApplicationWithName:@"Box"
                                    bundleID:@"net.box.BoxNet"
                                    clientID:nil
                                   URLScheme:@"box-onecloud"
                       authRedirectURIString:nil];
}

- (BOOL)isInstalled
{
    BOOL result = NO;

    if ([self.urlScheme length] > 0)
    {
        NSString *testURLString = [self.urlScheme stringByAppendingString:@"://"];
        result = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:testURLString]];
    }

    return result;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"BoxAppToAppApplication %@ with bundleID %@", self.name, self.bundleID];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.bundleID forKey:@"bundleID"];
    [aCoder encodeObject:self.clientID forKey:@"clientID"];
    [aCoder encodeObject:self.urlScheme forKey:@"urlScheme"];
    [aCoder encodeObject:self.authRedirectURIString forKey:@"authRedirectURIString"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.bundleID = [aDecoder decodeObjectForKey:@"bundleID"];
        self.clientID = [aDecoder decodeObjectForKey:@"clientID"];
        self.urlScheme = [aDecoder decodeObjectForKey:@"urlScheme"];
        self.authRedirectURIString = [aDecoder decodeObjectForKey:@"authRedirectURIString"];
    }
    return self;
}

@end
