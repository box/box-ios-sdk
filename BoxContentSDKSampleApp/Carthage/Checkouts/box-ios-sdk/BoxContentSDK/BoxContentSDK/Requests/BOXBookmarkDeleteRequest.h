//
//  BOXBookmarkDeleteRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXBookmarkDeleteRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, strong) NSString *bookmarkID;

// Optional, if nil the bookmark will get deleted if it exists and deletion is permissable.
// If an etag value is supplied, the file will only be deleted if the provided etag matches the current value.
@property (nonatomic, readwrite, strong) NSString *matchingEtag;


- (instancetype)initWithBookmarkID:(NSString *)bookmarkID;
- (instancetype)initWithBookmarkID:(NSString *)bookmarkID isTrashed:(BOOL)isTrashed;
- (void)performRequestWithCompletion:(BOXErrorBlock)completionBlock;

@end
