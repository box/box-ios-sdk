//
//  BOXBookmarkCommentsRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXBookmarkCommentsRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readonly, strong) NSString *bookmarkID;

- (instancetype)initWithBookmarkID:(NSString *)bookmarkID;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCompletion:(BOXObjectsArrayCompletionBlock)completionBlock;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCached:(BOXObjectsArrayCompletionBlock)cacheBlock
                       refreshed:(BOXObjectsArrayCompletionBlock)refreshBlock;

@end
