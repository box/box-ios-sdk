//
//  BOXFileVersionsRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileVersionsRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readonly, strong) NSString *fileID;

- (instancetype)initWithFileID:(NSString *)fileID;
- (void)performRequestWithCompletion:(BOXObjectsArrayCompletionBlock)completionBlock;
- (void)performRequestWithCached:(BOXObjectsArrayCompletionBlock)cacheBlock
                       refreshed:(BOXObjectsArrayCompletionBlock)refreshBlock;

@end
