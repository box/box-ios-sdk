//
//  BOXCollectionListRequest.h
//  BoxContentSDK
//

#import "BOXRequest_Private.h"

@interface BOXCollectionListRequest : BOXRequest

- (void)performRequestWithCompletion:(BOXCollectionArrayBlock)completionBlock;

@end
