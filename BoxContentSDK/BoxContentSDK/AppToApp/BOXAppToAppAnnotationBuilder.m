//
//  BOXAppToAppAnnotationBuilder.m
//  BoxSDK
//
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXAppToAppAnnotationBuilder.h"
#import "BOXAppToAppAnnotationKeys.h"
#import "BOXAppToAppApplication.h"

#import "BOXLog.h"
#import "NSString+BoxURLHelper.h"


@interface BOXAppToAppAnnotationBuilder()

+ (NSString *)stringFromObject:(id)object;
+ (NSString *)URLReadyStringForObject:(id)object;

@end

@implementation BOXAppToAppAnnotationBuilder

+ (NSURL *)actionURLWithAction:(NSString *)action
                     urlScheme:(NSString *)urlScheme
                      metadata:(NSDictionary *)metadata
             sourceApplication:(BOXAppToAppApplication *)app
{
    NSURL *actionURL = nil;

    // Note that a URL scheme and an action are required to generate an action URL
    if ([urlScheme length] != 0 && [action length] != 0)
    {
        // build a dictionary of all key/value pairs that need to get sent
        NSDictionary *params = [self annotationDictionaryWithAction:action metadata:metadata sourceApplication:app];

        // turn the dictionary into an array of "paramName=paramValue" strings
        NSMutableArray *nameEqualsValueStrings = [NSMutableArray arrayWithCapacity:[params count]];
        [params enumerateKeysAndObjectsUsingBlock:^(NSString * key, id value, BOOL *stop) {
            if (value)
            {
                [nameEqualsValueStrings addObject:[NSString stringWithFormat:@"%@=%@", key, [self URLReadyStringForObject:value]]];
            }
        }];

        // "key1=value1&key2=value2&..."
        NSString *allParams = [nameEqualsValueStrings componentsJoinedByString:@"&"];

        NSString *urlString = [NSString stringWithFormat:@"%@://?%@",
                               urlScheme, allParams];
        actionURL = [NSURL URLWithString:urlString];
    }

    return actionURL;
}

+ (NSDictionary *)annotationDictionaryWithAction:(NSString *)action
                                        metadata:(NSDictionary *)metadata
                               sourceApplication:(BOXAppToAppApplication *)app
{
    // start by copying the metadata
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:metadata];
    if (result == nil)
    {
        result = [NSMutableDictionary dictionary];
    }

    // now, insert the action
    result[BOX_APP_TO_APP_MESSAGE_ACTION_KEY] = action;

    // now, insert the return information
    BOXAppToAppApplication *currentApplication = app;

    // If you hit this assertion, it means you need to make the following call before
    // any app-to-app messages are processed:
    //
    //     BOXAppToAppManager.currentApplication =
    //         [BOXAppToAppApplication appToAppApplicationWithName:@"My App"
    //                                                    bundleID:@"com.example.my_bundle_id"
    //                                                   URLScheme:@"myapp"
    //                                       authRedirectURIString:@"myapp-auth://auth"];
    BOXAssert(currentApplication != nil, @"BOXAppToAppManager.currentApplication has not been initialized");

    // note that [setValue:forKey:] is nil-safe, unlike "result[key] = value"
    [result setValue:currentApplication.name forKey:BOX_APP_TO_APP_APPLICATION_NAME_KEY];
    [result setValue:currentApplication.urlScheme forKey:BOX_APP_TO_APP_MESSAGE_RETURN_URL_SCHEME_KEY];

    return result;
}

+ (NSURL *)urlByDestructivelyParsingInfo:(NSMutableDictionary *)info forKey:(NSString *)key
{
    NSURL *result = info[key];
    [info removeObjectForKey:key];

    return result;
}

+ (NSString *)stringByDestructivelyParsingInfo:(NSMutableDictionary *)info forKey:(NSString *)key
{
    NSString *result = info[key];

    if (result != nil)
    {
        result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [info removeObjectForKey:key];
    }

    return result;
}

+ (NSString *)stringFromObject:(id)object
{
    NSString *result = nil;

    // first, convert the type to a string
    if ([object isKindOfClass:[NSString class]])
    {
        result = object;
    }
    else if ([object isKindOfClass:[NSData class]])
    {
        NSData *objectData = (NSData *)object;

        // use the hex representation (rather than the description, which should not be trusted
        // to always return something related to the hex representation and is OS dependent)
        NSMutableString *dataString = [NSMutableString stringWithCapacity:[objectData length] * 2];
        const unsigned char *dataBytes = [objectData bytes];
        for (NSUInteger i = 0; i < [objectData length]; i++)
        {
            [dataString appendFormat:@"%02x", dataBytes[i]];
        }

        result = dataString;
    }
    else
    {
        // by default, fall back to the "description" method
        result = [object description];
    }

    return result;
}

// this method is used to convert datatypes into something that be put into the URL annotation
+ (NSString *)URLReadyStringForObject:(id)object
{
    NSString *result = [self stringFromObject:object];

    // percent encode the string
    return [NSString box_stringWithString:result URLEncoded:YES];
}

+ (NSString *)stringFromAnnotationString:(NSString *)string
{
    NSString *result = string;
    // percent de-encode the string
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    return result;
}

@end
