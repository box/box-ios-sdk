//
//  BOXCollectionFavoritesRequest.h
//  BoxContentSDK
//

#import "BOXCollectionListRequest.h"

@interface BOXCollectionFavoritesRequest : BOXCollectionListRequest

- (void)performRequestWithCompletion:(BOXCollectionBlock)completionBlock;

@end
