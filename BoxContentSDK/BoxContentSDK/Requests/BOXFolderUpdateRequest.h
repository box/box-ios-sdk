//
//  BOXFolderUpdateRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFolderUpdateRequest : BOXRequestWithSharedLinkHeader <BOXBackgroundRequestProtocol>

@property (nonatomic, readonly, strong) NSString *folderID;
@property (nonatomic, readwrite, strong) NSString *folderName;
@property (nonatomic, readwrite, strong) NSString *folderDescription;
@property (nonatomic, readwrite, strong) NSString *parentID;

/**
 Caller provided directory path for the result payload of the background operation to be written to.
 */
@property (nonatomic, readwrite, copy) NSString *requestDirectoryPath;

@property (nonatomic, readwrite, strong) BOXSharedLinkAccessLevel *sharedLinkAccessLevel;
@property (nonatomic, readwrite, strong) NSDate *sharedLinkExpirationDate;
@property (nonatomic, readwrite, assign) BOOL sharedLinkPermissionCanDownload;
@property (nonatomic, readwrite, assign) BOOL sharedLinkPermissionCanPreview;

@property (nonatomic, readwrite, strong) NSString *folderUploadEmailAddress;
@property (nonatomic, readwrite, strong) BOXFolderUploadEmailAccessLevel *folderUploadEmailAccess;

@property (nonatomic, readwrite, strong) NSString *ownerUserID;
@property (nonatomic, readwrite, strong) NSString *syncState;

@property (nonatomic, readwrite, strong) NSString *matchingEtag;

@property (nonatomic, readwrite, assign) BOOL requestAllFolderFields;

- (instancetype)initWithFolderID:(NSString *)folderID;
- (instancetype)initWithFolderID:(NSString *)folderID associateID:(NSString *)associateID;
- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock;

@end
