//
//  BOXFileUpdateRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileUpdateRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, strong) NSString *fileName;
@property (nonatomic, readwrite, strong) NSString *fileDescription;
@property (nonatomic, readwrite, strong) NSString *parentID;

@property (nonatomic, readwrite, strong) BOXSharedLinkAccessLevel *sharedLinkAccessLevel;
@property (nonatomic, readwrite, strong) NSDate *sharedLinkExpirationDate;
@property (nonatomic, readwrite, assign) BOOL sharedLinkPermissionCanDownload;
@property (nonatomic, readwrite, assign) BOOL sharedLinkPermissionCanPreview;

@property (nonatomic, readwrite, strong) NSString *matchingEtag;

@property (nonatomic, readwrite, assign) BOOL requestAllFileFields;

- (instancetype)initWithFileID:(NSString *)fileID;

- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock;

@end
