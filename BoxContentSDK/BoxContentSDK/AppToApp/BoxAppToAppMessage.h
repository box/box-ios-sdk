//
//  BoxAppToAppMessage.h
//  BoxSDK
//
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoxAppToAppFileMetadata.h"

@class BoxAppToAppApplication;

typedef NS_ENUM(NSInteger, BoxAppToAppMessageType)
{
    BoxAppToAppMessageTypeIncoming,
    BoxAppToAppMessageTypeOutgoing,
};

typedef NS_ENUM(NSUInteger, BoxAppToAppStatus)
{
    BoxAppToAppStatusUnknown,
    BoxAppToAppStatusSuccess,
    BoxAppToAppStatusFailed,
};

/**
 * This class describes a Box message sent from one app to another -- typically either
 * from the Box app to a partner app, or vice versa.
 *
 * For example, a command might be "edit the file with ID 1234", or "create a new file
 * of type .docx in folder 5678".
 */
 @interface BoxAppToAppMessage : NSObject <NSCoding>

/**
 * Indicates whether was an incoming message from another app, or an outgoing message
 * to another app.
 */
@property (nonatomic, readonly) BoxAppToAppMessageType messageType;

/**
 * This describes the current application.
 * For incoming messages, it is the application that is receiving the message.
 * For outgoing messages, it is the application that is sending the message.
 */
@property (nonatomic, readonly, strong) BoxAppToAppApplication *currentApplication;

/**
 * This describes the application that sent the message to the current application.
 * Only valid for incoming messages.
 */
@property (nonatomic, readonly, strong) BoxAppToAppApplication *senderApplication;

/**
 * This describes the application that will receive, or did receive, the message.
 * Only valid for outgoing messages.
 */
@property (nonatomic, readonly, strong) BoxAppToAppApplication *receiverApplication;

/** Generic information about the action */
@property (nonatomic, readonly, strong) NSString *action; // e.g. create, edit, etc.

/** The URL which was used to construct this BoxAppToAppMessage, or nil if there is no such URL */
@property (nonatomic, readonly, strong) NSURL *url;

/**
 * For file-related messages (e.g. edit file, create file, etc.), this contains the
 * file id, parent folder id, etc.
 */
@property (nonatomic, readwrite, strong) BoxAppToAppFileMetadata *fileMetadata;

/**
 * Creates an app-to-app message from the NSDictionary that was passed to
 * -[UIApplicationDelegate application:openURL:sourceApplication:annotation:].
 */
+ (BoxAppToAppMessage *)appToAppMessageWithOpenURL:(NSURL *)openURL
                                 sourceApplication:(NSString *)sourceApplication
                                currentApplication:(BoxAppToAppApplication *)currentApplication
                                        annotation:(id)annotation;

/** Use this method to generate a new API Info object for the purposes of sending a request to a specific application */
+ (BoxAppToAppMessage *)appToAppMessageWithTargetApplication:(BoxAppToAppApplication *)targetApplication
                                          currentApplication:(BoxAppToAppApplication *)currentApplication
                                                    metadata:(BoxAppToAppFileMetadata *)metadata; // assume edit action

+ (BoxAppToAppMessage *)appToAppMessageWithTargetApplication:(BoxAppToAppApplication *)targetApplication
                                          currentApplication:(BoxAppToAppApplication *)currentApplication
                                                      action:(NSString *)action
                                                    metadata:(BoxAppToAppFileMetadata *)metadata;

+ (BoxAppToAppMessage *)appToAppMessageWithTargetApplication:(BoxAppToAppApplication *)targetApplication
                                          currentApplication:(BoxAppToAppApplication *)currentApplication
                                                    fileName:(NSString *)fileName; // assume edit action

+ (BoxAppToAppMessage *)appToAppMessageWithTargetApplication:(BoxAppToAppApplication *)targetApplication
                                          currentApplication:(BoxAppToAppApplication *)currentApplication
                                                      action:(NSString *)action
                                                    fileName:(NSString *)fileName;

+ (BoxAppToAppMessage *)boxAppAuthorizationMessageWithState:(NSString *)state
                                         currentApplication:(BoxAppToAppApplication *)app;

/**
 * Perform a transaction
 */
- (BoxAppToAppStatus)execute;

/** An app asking another app to do something (any of the following) */
- (BOOL)isValidBoxAppToAppRequest;

/** An app (e.g. the Box app) asking another app (e.g. from a partner) to edit a Box file */
- (BOOL)isEditFileRequest;

- (BOOL)isCreateFileRequest;    // An app (e.g. the Box app) asking another app (e.g. from a partner) to create a new Box file
- (BOOL)isDownloadFileRequest;  // An app (e.g. from a partner) asking another app (typically the Box app) to download a file
- (BOOL)isLaunchRequest;        // An app launching another app
- (BOOL)isLoginRequest;         // An app asking another app to log the first app into Box
- (BOOL)isAuthorizationForRedirectURLScheme:(NSString *)scheme;        // A login authcode, in reply to an earlier loginRequest

@end
