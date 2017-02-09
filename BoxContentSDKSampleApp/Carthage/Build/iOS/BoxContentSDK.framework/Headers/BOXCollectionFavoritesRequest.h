//
//  BOXCollectionFavoritesRequest.h
//  BoxContentSDK
//

#import "BOXCollectionListRequest.h"

@interface BOXCollectionFavoritesRequest : BOXCollectionListRequest

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCompletion:(BOXCollectionBlock)completionBlock;

- (void)performRequestWithCached:(BOXCollectionBlock)cacheBlock
                       refreshed:(BOXCollectionBlock)refreshBlock;

@end
