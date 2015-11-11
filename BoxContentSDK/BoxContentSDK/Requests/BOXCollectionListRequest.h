//
//  BOXCollectionListRequest.h
//  BoxContentSDK
//

#import "BOXRequest_Private.h"

@interface BOXCollectionListRequest : BOXRequest

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCompletion:(BOXCollectionArrayBlock)completionBlock;

- (void)performRequestWithCached:(BOXCollectionArrayBlock)cacheBlock
                       refreshed:(BOXCollectionArrayBlock)refreshBlock;

@end
