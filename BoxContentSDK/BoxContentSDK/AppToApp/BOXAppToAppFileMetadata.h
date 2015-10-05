//
//  BOXAppToAppMetadata.h
//  BoxSDK
//
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOXAppToAppFileMetadata : NSObject <NSCoding>

@property (nonatomic, readonly, strong) NSString *fileName;               // e.g. "Cute kitty.jpg"
@property (nonatomic, readonly, strong) NSString *folderName;             // e.g. "Kitten pictures"
@property (nonatomic, readonly, strong) NSString *folderPathStringByName; // e.g. "All Files/Kitten pictures"
                                                                          // (root folder is typically "All Files")
@property (nonatomic, readonly, strong) NSString *fileExtension;          // e.g. "jpg" (no leading dot)
@property (nonatomic, readonly, strong) NSString *fileMimeType;           // e.g. "image/jpeg" or "binary/octet-stream"
@property (nonatomic, readonly, strong) NSString *fileID;                 // e.g. "249859085"
@property (nonatomic, readonly, strong) NSString *folderID;               // e.g. "139208302"
@property (nonatomic, readonly, strong) NSString *folderPathStringByID;   // e.g. "0/56785678" ("0" is user's root folder)
@property (nonatomic, readonly, strong) NSString *userName;               // e.g. "user@example.com"
@property (nonatomic, readonly, strong) NSString *userID;                 // e.g. "124944941"
@property (nonatomic, readonly, strong) NSDictionary *allMetadata;        // all the items in this list

+ (BOXAppToAppFileMetadata *)appToAppFileMetadataWithInfo:(NSDictionary *)info;
+ (BOXAppToAppFileMetadata *)appToAppFileMetadataWithMetadata:(BOXAppToAppFileMetadata *)originalMetadata
                                           changingFileNameTo:(NSString *)newFileName;
+ (BOXAppToAppFileMetadata *)appToAppFileMetadataWithMetadata:(BOXAppToAppFileMetadata *)originalMetadata
                                           changingFileNameTo:(NSString *)newFileName
                                                       fileID:(NSString *)fileID;

+ (BOXAppToAppFileMetadata *)appToAppFileMetadataWithFileName:(NSString *)fileName
                                                fileExtension:(NSString *)fileExtension
                                                   folderName:(NSString *)folderName
                                                     mimeType:(NSString *)mimeType
                                                       fileID:(NSString *)fileID
                                                     folderID:(NSString *)folderID
                                                     username:(NSString *)username
                                                       userID:(NSString *)userID;

+ (BOXAppToAppFileMetadata *)appToAppFileMetadataWithFileName:(NSString *)fileName
                                                fileExtension:(NSString *)fileExtension
                                                   folderPath:(NSString *)folderPath
                                                     mimeType:(NSString *)mimeType
                                                       fileID:(NSString *)fileID
                                               folderPathByID:(NSString *)folderPathByID
                                                     username:(NSString *)username
                                                       userID:(NSString *)userID;

@end
