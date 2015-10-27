//
//  BOXFileRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, assign) BOOL requestAllFileFields;
@property (nonatomic, readwrite, strong) NSArray *notMatchingEtags;//If-None-Match: Array of strings representing etag values

@property (nonatomic, readonly, strong) NSString *fileID;

- (instancetype)initWithFileID:(NSString *)fileID;
- (instancetype)initWithFileID:(NSString *)fileID isTrashed:(BOOL)isTrashed;
- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock;
- (void)performRequestWithCached:(BOXFileBlock)cacheBlock
                       refreshed:(BOXFileBlock)refreshBlock;

@end
