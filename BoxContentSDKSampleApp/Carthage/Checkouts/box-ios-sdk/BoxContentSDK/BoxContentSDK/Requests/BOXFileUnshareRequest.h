//
//  BOXFileUnshareRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileUnshareRequest : BOXRequestWithSharedLinkHeader

// Optional, if nil the file will get unshared if it exists and removing the shared link is permissable.
// If an etag value is supplied, the file will only be unshared if the provided etag matches the current value.
@property (nonatomic, readwrite, strong) NSString *matchingEtag;

- (instancetype)initWithFileID:(NSString *)fileID;
- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock;

@end
