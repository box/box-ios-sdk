//
//  BOXAppToAppAnnotationKeys.h
//  BoxSDK
//
//  Copyright (c) 2015 Box. All rights reserved.
//

#pragma mark - BOXAppToAppApplication

#define BOX_APP_TO_APP_APPLICATION_NAME_KEY @"BoxApplicationName"
#define BOX_APP_TO_APP_APPLICATION_BUNDLE_ID_KEY @"BoxApplicationBundleID"
#define BOX_APP_TO_APP_APPLICATION_CLIENT_ID_KEY @"BoxApplicationClientID"
#define BOX_APP_TO_APP_APPLICATION_AUTH_REDIRECT_URI_STRING_KEY @"BoxApplicationAuthRedirectURIString"

#pragma mark - BOXAppToAppMessage keys

#define BOX_APP_TO_APP_MESSAGE_URL_SCHEME_KEY @"BoxMessageURLScheme"
#define BOX_APP_TO_APP_MESSAGE_ACTION_KEY @"BoxMessageAction"

#define BOX_APP_TO_APP_MESSAGE_RETURN_URL_SCHEME_KEY @"BoxMessageReturnURLScheme"

#pragma mark - BOXAppToAppMessage actions

#define BOX_APP_TO_APP_MESSAGE_ACTION_EDIT @"edit"         // ask another app to edit a specified file
#define BOX_APP_TO_APP_MESSAGE_ACTION_CREATE @"create"     // ask another app to create a file in a specified folder
#define BOX_APP_TO_APP_MESSAGE_ACTION_DOWNLOAD @"download" // ask another app to download a specified file
#define BOX_APP_TO_APP_MESSAGE_ACTION_LAUNCH @"launch"     // launch another app
#define BOX_APP_TO_APP_MESSAGE_ACTION_LOGIN @"login"       // ask another app to log the user into Box

#pragma mark - OAuth2 Parameters
#define BOX_APP_TO_APP_OAUTH2_CLIENT_ID @"client_id"
#define BOX_APP_TO_APP_OAUTH2_REDIRECT_URI @"redirect_uri"
#define BOX_APP_TO_APP_OAUTH2_STATE @"state"

#pragma mark - BOXAppToAppMetadata

#define BOX_APP_TO_APP_METADATA_FILE_NAME_KEY @"BoxLocationFileName"
#define BOX_APP_TO_APP_METADATA_FOLDER_NAME_KEY @"BoxLocationFolderName"
#define BOX_APP_TO_APP_METADATA_FOLDER_PATH_KEY @"BoxLocationFolderPath"
#define BOX_APP_TO_APP_METADATA_FILE_EXTENSION_KEY @"BoxLocationFileExtension"
#define BOX_APP_TO_APP_METADATA_FILE_MIME_TYPE_KEY @"BoxLocationFileMimeType"
#define BOX_APP_TO_APP_METADATA_FILE_ID_KEY @"BoxLocationFileID"
#define BOX_APP_TO_APP_METADATA_FOLDER_ID_KEY @"BoxLocationFolderID"
#define BOX_APP_TO_APP_METADATA_FOLDER_PATH_BY_ID_KEY @"BoxLocationFolderPathByID"
#define BOX_APP_TO_APP_METADATA_USERNAME_KEY @"BoxIdentityUsername"
#define BOX_APP_TO_APP_METADATA_USER_ID_KEY @"BoxIdentityUserID"
