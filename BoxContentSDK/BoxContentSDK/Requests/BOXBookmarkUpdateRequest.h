//
//  BOXBookmarkUpdateRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXBookmarkUpdateRequest : BOXRequestWithSharedLinkHeader <BOXBackgroundRequestProtocol>

@property (nonatomic, readonly, strong) NSString *bookmarkID;
@property (nonatomic, readwrite, strong) NSURL *URL;
@property (nonatomic, readwrite, strong) NSString *bookmarkName;
@property (nonatomic, readwrite, strong) NSString *bookmarkDescription;
@property (nonatomic, readwrite, strong) NSString *parentID;

@property (nonatomic, readwrite, strong) BOXSharedLinkAccessLevel *sharedLinkAccessLevel;
@property (nonatomic, readwrite, strong) NSDate *sharedLinkExpirationDate;
@property (nonatomic, readwrite, assign) BOOL sharedLinkPermissionCanDownload;
@property (nonatomic, readwrite, assign) BOOL sharedLinkPermissionCanPreview;

@property (nonatomic, readwrite, strong) NSString *matchingEtag;

@property (nonatomic, readwrite, assign) BOOL requestAllBookmarkFields;

// NOTE: Both the associateID and requestDirectoryPath values are required for performing the request in the background.
/**
 Caller provided directory path for the result payload of the background operation to be written to.
 This is a required value for performing the request in the background.
 */
@property (nonatomic, readwrite, strong) NSString *requestDirectoryPath;

- (instancetype)initWithBookmarkID:(NSString *)bookmarkID;

- (instancetype)initWithBookmarkID:(NSString *)bookmarkID associateID:(NSString *)associateID;

- (void)performRequestWithCompletion:(BOXBookmarkBlock)completionBlock;

@end
