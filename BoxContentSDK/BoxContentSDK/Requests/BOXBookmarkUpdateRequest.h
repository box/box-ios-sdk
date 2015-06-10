//
//  BOXBookmarkUpdateRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXBookmarkUpdateRequest : BOXRequestWithSharedLinkHeader

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

- (instancetype)initWithBookmarkID:(NSString *)bookmarkID;

- (void)performRequestWithCompletion:(BOXBookmarkBlock)completionBlock;

@end
