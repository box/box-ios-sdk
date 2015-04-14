//
//  BOXCollectionItemsRequest.h
//  BoxContentSDK
//

#import "BOXItemArrayRequest.h"

@interface BOXCollectionItemsRequest : BOXItemArrayRequest

- (instancetype)initWithCollectionID:(NSString *)collectionID inRange:(NSRange)range;

@end
