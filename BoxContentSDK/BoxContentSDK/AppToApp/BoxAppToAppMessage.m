//
//  BoxAppToAppMessage.m
//  BoxSDK
//
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BoxAppToAppMessage.h"
#import "BoxAppToAppAnnotationKeys.h"
#import "BoxAppToAppAnnotationBuilder.h"
#import "BoxAppToAppApplication.h"

@implementation BoxAppToAppMessage

- (instancetype)initWithMessageType:(BoxAppToAppMessageType)messageType
                 currentApplication:(BoxAppToAppApplication *)currentApplication
                  senderApplication:(BoxAppToAppApplication *)senderApplication
                receiverApplication:(BoxAppToAppApplication *)receiverApplication
                             action:(NSString *)action
                       fileMetadata:(BoxAppToAppFileMetadata *)fileMetadata
                                url:(NSURL *)url
{
    if (self = [self init])
    {
        _messageType = messageType;
        _currentApplication = currentApplication;
        _senderApplication = senderApplication;
        _receiverApplication = receiverApplication;
        _action = action;
        _fileMetadata = fileMetadata;
        _url = url;
    }

    return self;
}

- (instancetype)initWithURL:(NSURL *)url
             infoDictionary:(NSMutableDictionary *)infoDictionary
         currentApplication:(BoxAppToAppApplication *)currentApplication
{
    BoxAppToAppApplication *senderApplication = [BoxAppToAppApplication appToAppApplicationWithInfo:infoDictionary];
    NSString *action = [BoxAppToAppAnnotationBuilder stringByDestructivelyParsingInfo:infoDictionary forKey:BOX_APP_TO_APP_MESSAGE_ACTION_KEY];
    BoxAppToAppFileMetadata *fileMetadata = [BoxAppToAppFileMetadata appToAppFileMetadataWithInfo:infoDictionary];

    return [self initWithMessageType:BoxAppToAppMessageTypeIncoming
                  currentApplication:currentApplication
                   senderApplication:senderApplication
                 receiverApplication:nil
                              action:action
                        fileMetadata:fileMetadata
                                 url:url];
}

+ (BoxAppToAppMessage *)appToAppMessageWithOpenURL:(NSURL *)openURL
                                 sourceApplication:(NSString *)sourceApplication
                                currentApplication:(BoxAppToAppApplication *)application
                                        annotation:(id)annotation
{
    NSMutableDictionary *info = [self infoDictionaryFromOpenURL:openURL
                                              sourceApplication:sourceApplication
                                                     annotation:annotation];

    return [[self alloc] initWithURL:openURL infoDictionary:info currentApplication:application];
}

+ (BoxAppToAppMessage *)appToAppMessageWithTargetApplication:(BoxAppToAppApplication *)targetApplication
                                          currentApplication:(BoxAppToAppApplication *)currentApplication
                                                    metadata:(BoxAppToAppFileMetadata *)metadata
{
    return [self appToAppMessageWithTargetApplication:targetApplication
                                   currentApplication:currentApplication
                                               action:BOX_APP_TO_APP_MESSAGE_ACTION_EDIT
                                             metadata:metadata];
}

+ (BoxAppToAppMessage *)appToAppMessageWithTargetApplication:(BoxAppToAppApplication *)targetApplication
                                          currentApplication:(BoxAppToAppApplication *)currentApplication
                                                      action:(NSString *)action
                                                    metadata:(BoxAppToAppFileMetadata *)metadata
{
    return [[self alloc] initWithMessageType:BoxAppToAppMessageTypeOutgoing
                          currentApplication:currentApplication
                           senderApplication:nil
                         receiverApplication:targetApplication
                                      action:action
                                fileMetadata:metadata
                                         url:nil];
}

+ (BoxAppToAppMessage *)appToAppMessageWithTargetApplication:(BoxAppToAppApplication *)targetApplication
                                          currentApplication:(BoxAppToAppApplication *)currentApplication
                                                    fileName:(NSString *)fileName
{
    return [self appToAppMessageWithTargetApplication:targetApplication
                                   currentApplication:currentApplication
                                               action:BOX_APP_TO_APP_MESSAGE_ACTION_EDIT
                                             fileName:fileName];
}

+ (BoxAppToAppMessage *)appToAppMessageWithTargetApplication:(BoxAppToAppApplication *)targetApplication
                                          currentApplication:(BoxAppToAppApplication *)currentApplication
                                                      action:(NSString *)action
                                                    fileName:(NSString *)fileName
{
    NSDictionary *metadata = @{BOX_APP_TO_APP_METADATA_FILE_NAME_KEY: fileName,
                               BOX_APP_TO_APP_METADATA_FILE_EXTENSION_KEY: [fileName pathExtension]};

    return [self appToAppMessageWithTargetApplication:targetApplication
                                   currentApplication:currentApplication
                                               action:action
                                             metadata:[BoxAppToAppFileMetadata appToAppFileMetadataWithInfo:metadata]];
}

+ (BoxAppToAppMessage *)boxAppAuthorizationMessageWithState:(NSString *)state
                                         currentApplication:(BoxAppToAppApplication *)app
{
    return [self appToAppAuthorizationMessageWithApplication:[BoxAppToAppApplication BoxApplication]
                                          currentApplication:app
                                                       state:state];
}

+ (BoxAppToAppMessage *)appToAppAuthorizationMessageWithApplication:(BoxAppToAppApplication *)authApp
                                                 currentApplication:(BoxAppToAppApplication *)currentApp
                                                              state:(NSString *)state
{
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:3];
    if (currentApp.clientID) {
        [info setObject:currentApp.clientID forKey:BOX_APP_TO_APP_OAUTH2_CLIENT_ID];
    }
    if (currentApp.authRedirectURIString) {
        [info setObject:currentApp.authRedirectURIString forKey:BOX_APP_TO_APP_OAUTH2_REDIRECT_URI];
    }
    if (state) {
        [info setObject:state forKey:BOX_APP_TO_APP_OAUTH2_STATE];
    }

    BoxAppToAppFileMetadata *metadata = [BoxAppToAppFileMetadata appToAppFileMetadataWithInfo:info];
    BoxAppToAppMessage *message = [BoxAppToAppMessage appToAppMessageWithTargetApplication:authApp
                                                                        currentApplication:currentApp
                                                                                    action:BOX_APP_TO_APP_MESSAGE_ACTION_LOGIN
                                                                                  metadata:metadata];
    return message;
}

+ (NSMutableDictionary *)infoDictionaryFromOpenURL:(NSURL *)openURL
                                 sourceApplication:(NSString *)sourceApplication
                                        annotation:(id)annotation
{
    // The result will contain all the information in the annotation dictionary, the source application, plus whatever information can be pulled
    // from the URL
    NSMutableDictionary *result = nil;

    if ([annotation isKindOfClass:[NSDictionary class]])
    {
        result = [NSMutableDictionary dictionaryWithDictionary:annotation];
    }
    else
    {
        result = [NSMutableDictionary dictionary];
    }

    // note that setValue:forKey: is nil-safe, unlike "result[key] = value"
    [result setValue:sourceApplication forKey:BOX_APP_TO_APP_APPLICATION_BUNDLE_ID_KEY];

    // We can try to parse annotation information about the URL, which is likely a custom URL launch
    // The URL should be of the form <custom URL scheme>://?<Key 1>=<Value 1>&...&<Key N>=<Value N>

    // parse out the scheme
    [result setValue:[openURL scheme] forKey:BOX_APP_TO_APP_MESSAGE_URL_SCHEME_KEY];

    // get the key value pairs
    NSString *keyValueString = [openURL query];

    if (keyValueString != nil)
    {
        // split the string version into components so it can be parsed
        NSArray *keyValuePairs = [keyValueString componentsSeparatedByString:@"&"];

        for (NSString *keyValuePair in keyValuePairs)
        {
            // each key value pair is separated by '='
            // Note that the value is percent encoded but the keys are not (as they cannot contain special characters)
            NSArray *pair = [keyValuePair componentsSeparatedByString:@"="];
            if ([pair count] == 2)
            {
                NSString *key = pair[0];
                NSString *value = pair[1];
                value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                result[key] = value;
            }
        }
    }

    return result;
}

#pragma mark -

- (BoxAppToAppStatus)execute
{
    BoxAppToAppStatus status = BoxAppToAppStatusFailed;

    // check if the target app is known to be installed
    if ([self targetIsAvailable])
    {
        // launch the other application with the appropriate information
        NSURL *actionURL = [BoxAppToAppAnnotationBuilder actionURLWithAction:self.action
                                                                   urlScheme:self.receiverApplication.urlScheme
                                                                    metadata:self.fileMetadata.allMetadata
                                                           sourceApplication:self.currentApplication];

        if (actionURL != nil)
        {
            if ([[UIApplication sharedApplication] openURL:actionURL])
            {
                status = BoxAppToAppStatusSuccess;
            }
        }
    }

    return status;
}

#pragma mark - Action methods

- (BOOL)isValidBoxAppToAppRequest
{
    BOOL result = NO;

    // the minimal requirement for a BoxAppToAppRequest is that it has an action associated with it
    if ([self.action length] > 0)
    {
        result = YES;
    }

    return result;
}

- (BOOL)isCreateFileRequest
{
    BOOL result = NO;

    if ([self.action isEqualToString:BOX_APP_TO_APP_MESSAGE_ACTION_CREATE])
    {
        result = YES;
    }

    return result;
}

- (BOOL)isEditFileRequest
{
    BOOL result = NO;

    if ([self.action isEqualToString:BOX_APP_TO_APP_MESSAGE_ACTION_EDIT])
    {
        result = YES;
    }

    return result;
}

- (BOOL)isDownloadFileRequest
{
    BOOL result = NO;

    if ([self.action isEqualToString:BOX_APP_TO_APP_MESSAGE_ACTION_DOWNLOAD])
    {
        result = YES;
    }

    return result;
}

- (BOOL)isLaunchRequest
{
    BOOL result = NO;

    if ([self.action isEqualToString:BOX_APP_TO_APP_MESSAGE_ACTION_LAUNCH])
    {
        result = YES;
    }

    return result;
}

- (BOOL)isLoginRequest
{
    BOOL result = NO;

    if ([self.action isEqualToString:BOX_APP_TO_APP_MESSAGE_ACTION_LOGIN])
    {
        result = YES;
    }

    return result;
}

- (BOOL)isAuthorizationForRedirectURLScheme:(NSString *)scheme
{
    NSString *messageUrlScheme = _fileMetadata.allMetadata[BOX_APP_TO_APP_MESSAGE_URL_SCHEME_KEY];
    NSString *authRedirectUrlSchemeOfCurrentApp = scheme;
    return ([messageUrlScheme isEqualToString:authRedirectUrlSchemeOfCurrentApp]);
}

- (BOOL)targetIsAvailable
{
    return [_receiverApplication isInstalled];
}

- (NSString *)description
{
    NSString *description = @"BoxAppToAppMessage: {\n";
    description = [description stringByAppendingFormat:@"Message type: %@\n",
                   self.messageType == BoxAppToAppMessageTypeIncoming ? @"Incoming" : @"Outgoing"];
    description = [description stringByAppendingFormat:@"Sender app: %@\n", self.senderApplication];
    description = [description stringByAppendingFormat:@"Receiver app: %@\n", self.receiverApplication];
    description = [description stringByAppendingFormat:@"Action: %@\n", self.action];
    description = [description stringByAppendingFormat:@"File metadata: %@\n", self.fileMetadata];

    description = [description stringByAppendingString:@"}"];

    return description;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt32:self.messageType forKey:@"messageType"];
    [aCoder encodeObject:self.senderApplication forKey:@"senderApplication"];
    [aCoder encodeObject:self.receiverApplication forKey:@"receiverApplication"];
    [aCoder encodeObject:self.action forKey:@"action"];
    [aCoder encodeObject:self.fileMetadata forKey:@"metadata"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        _messageType = [aDecoder decodeInt32ForKey:@"messageType"];
        _senderApplication = [aDecoder decodeObjectForKey:@"senderApplication"];
        _receiverApplication = [aDecoder decodeObjectForKey:@"receiverApplication"];
        _action = [aDecoder decodeObjectForKey:@"action"];
        _fileMetadata = [aDecoder decodeObjectForKey:@"metadata"];
    }

    return self;
}

@end
