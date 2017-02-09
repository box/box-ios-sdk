//
//  BOXAppToAppMessage.h
//  BoxSDK
//
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOXAppToAppFileMetadata.h"

@class BOXAppToAppApplication;

typedef NS_ENUM(NSInteger, BOXAppToAppMessageType)
{
    BOXAppToAppMessageTypeIncoming,
    BOXAppToAppMessageTypeOutgoing,
};

typedef NS_ENUM(NSUInteger, BOXAppToAppStatus)
{
    BOXAppToAppStatusUnknown,
    BOXAppToAppStatusSuccess,
    BOXAppToAppStatusFailed,
};

/**
 * This class describes a Box message sent from one app to another -- typically either
 * from the Box app to a partner app, or vice versa.
 *
 * For example, a command might be "edit the file with ID 1234", or "create a new file
 * of type .docx in folder 5678".
 */
 @interface BOXAppToAppMessage : NSObject <NSCoding>

/**
 * Indicates whether was an incoming message from another app, or an outgoing message
 * to another app.
 */
@property (nonatomic, readonly) BOXAppToAppMessageType messageType;

/**
 * This describes the current application.
 * For incoming messages, it is the application that is receiving the message.
 * For outgoing messages, it is the application that is sending the message.
 */
@property (nonatomic, readonly, strong) BOXAppToAppApplication *currentApplication;

/**
 * This describes the application that sent the message to the current application.
 * Only valid for incoming messages.
 */
@property (nonatomic, readonly, strong) BOXAppToAppApplication *senderApplication;

/**
 * This describes the application that will receive, or did receive, the message.
 * Only valid for outgoing messages.
 */
@property (nonatomic, readonly, strong) BOXAppToAppApplication *receiverApplication;

/** Generic information about the action */
@property (nonatomic, readonly, strong) NSString *action; // e.g. create, edit, etc.

/** The URL which was used to construct this BOXAppToAppMessage, or nil if there is no such URL */
@property (nonatomic, readonly, strong) NSURL *url;

/**
 * For file-related messages (e.g. edit file, create file, etc.), this contains the
 * file id, parent folder id, etc.
 */
@property (nonatomic, readwrite, strong) BOXAppToAppFileMetadata *fileMetadata;

/**
 * Creates an app-to-app message from the NSDictionary that was passed to
 * -[UIApplicationDelegate application:openURL:sourceApplication:annotation:].
 */
+ (BOXAppToAppMessage *)appToAppMessageWithOpenURL:(NSURL *)openURL
                                 sourceApplication:(NSString *)sourceApplication
                                currentApplication:(BOXAppToAppApplication *)currentApplication
                                        annotation:(id)annotation;

/** Use this method to generate a new API Info object for the purposes of sending a request to a specific application */
+ (BOXAppToAppMessage *)appToAppMessageWithTargetApplication:(BOXAppToAppApplication *)targetApplication
                                          currentApplication:(BOXAppToAppApplication *)currentApplication
                                                    metadata:(BOXAppToAppFileMetadata *)metadata; // assume edit action

+ (BOXAppToAppMessage *)appToAppMessageWithTargetApplication:(BOXAppToAppApplication *)targetApplication
                                          currentApplication:(BOXAppToAppApplication *)currentApplication
                                                      action:(NSString *)action
                                                    metadata:(BOXAppToAppFileMetadata *)metadata;

+ (BOXAppToAppMessage *)appToAppMessageWithTargetApplication:(BOXAppToAppApplication *)targetApplication
                                          currentApplication:(BOXAppToAppApplication *)currentApplication
                                                    fileName:(NSString *)fileName; // assume edit action

+ (BOXAppToAppMessage *)appToAppMessageWithTargetApplication:(BOXAppToAppApplication *)targetApplication
                                          currentApplication:(BOXAppToAppApplication *)currentApplication
                                                      action:(NSString *)action
                                                    fileName:(NSString *)fileName;

+ (BOXAppToAppMessage *)boxAppAuthorizationMessageWithState:(NSString *)state
                                         currentApplication:(BOXAppToAppApplication *)app;

/**
 * Perform a transaction
 */
- (BOXAppToAppStatus)execute;

/** An app asking another app to do something (any of the following) */
- (BOOL)isValidBOXAppToAppRequest;

/** An app (e.g. the Box app) asking another app (e.g. from a partner) to edit a Box file */
- (BOOL)isEditFileRequest;

- (BOOL)isCreateFileRequest;    // An app (e.g. the Box app) asking another app (e.g. from a partner) to create a new Box file
- (BOOL)isDownloadFileRequest;  // An app (e.g. from a partner) asking another app (typically the Box app) to download a file
- (BOOL)isLaunchRequest;        // An app launching another app
- (BOOL)isLoginRequest;         // An app asking another app to log the first app into Box
- (BOOL)isAuthorizationForRedirectURLScheme:(NSString *)scheme;        // A login authcode, in reply to an earlier loginRequest

@end
