//
//  BOXFileDeleteRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileDeleteRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readonly, strong) NSString *fileID;

// Optional, if nil the file will get deleted if it exists and deletion is permissable.
// If an etag value is supplied, the file will only be deleted if the provided etag matches the current value.
@property (nonatomic, readwrite, strong) NSString *matchingEtag;

- (instancetype)initWithFileID:(NSString *)fileID;
- (instancetype)initWithFileID:(NSString *)fileID isTrashed:(BOOL)isTrashed;
- (void)performRequestWithCompletion:(BOXErrorBlock)completionBlock;

@end
