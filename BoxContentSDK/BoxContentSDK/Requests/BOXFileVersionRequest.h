//
//  BOXFileVersionsRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileVersionRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readonly, strong) NSString *fileID;

- (instancetype)initWithFileID:(NSString *)fileID versionID:(NSString *)versionID;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCompletion:(BOXFileVersionBlock)completionBlock;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCached:(BOXFileVersionBlock)cacheBlock
                       refreshed:(BOXFileVersionBlock)refreshBlock;

@end
