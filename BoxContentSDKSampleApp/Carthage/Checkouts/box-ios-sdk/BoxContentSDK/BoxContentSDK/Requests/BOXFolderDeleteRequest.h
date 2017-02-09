//
//  BOXFolderDeleteRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFolderDeleteRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readonly, strong) NSString *folderID;
@property (nonatomic, readwrite, assign) BOOL recursive; // Defaults to YES

// Optional, if nil the folder will get deleted if it exists and deletion is permissable.
// If an etag value is supplied, the folder will only be deleted if the provided etag matches the current value.
@property (nonatomic, readwrite, strong) NSString *matchingEtag;

- (instancetype)initWithFolderID:(NSString *)folderID;
- (instancetype)initWithFolderID:(NSString *)folderID isTrashed:(BOOL)isTrashed;
- (void)performRequestWithCompletion:(BOXErrorBlock)completionBlock;

@end
