//
//  BOXBookmarkUnshareRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXBookmarkUnshareRequest : BOXRequestWithSharedLinkHeader

// Optional, if nil the bookmark will get unshared if it exists and removing the shared link is permissable.
// If an etag value is supplied, the bookmark will only be unshared if the provided etag matches the current value.
@property (nonatomic, readwrite, strong) NSString *matchingEtag;

- (instancetype)initWithBookmarkID:(NSString *)bookmarkID;
- (void)performRequestWithCompletion:(BOXBookmarkBlock)completionBlock;

@end
