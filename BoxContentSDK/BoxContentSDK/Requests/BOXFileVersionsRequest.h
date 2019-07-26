//
//  BOXFileVersionsRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileVersionsRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readonly, strong) NSString *fileID;

- (instancetype)initWithFileID:(NSString *)fileID;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCompletion:(BOXObjectsArrayCompletionBlock)completionBlock;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCached:(BOXObjectsArrayCompletionBlock)cacheBlock
                       refreshed:(BOXObjectsArrayCompletionBlock)refreshBlock;

@end
