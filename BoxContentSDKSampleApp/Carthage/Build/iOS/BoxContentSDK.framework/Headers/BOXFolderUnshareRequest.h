//
//  BOXFolderUnshareRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFolderUnshareRequest : BOXRequestWithSharedLinkHeader

// Optional, if nil the folder will get unshared if it exists and removing the shared link is permissable.
// If an etag value is supplied, the folder will only be unshared if the provided etag matches the current value.
@property (nonatomic, readwrite, strong) NSString *matchingEtag;

- (instancetype)initWithFolderID:(NSString *)folderID;
- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock;

@end
