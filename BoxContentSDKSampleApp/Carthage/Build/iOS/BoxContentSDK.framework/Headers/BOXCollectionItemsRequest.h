//
//  BOXCollectionItemsRequest.h
//  BoxContentSDK
//

#import "BOXItemArrayRequest.h"

@interface BOXCollectionItemsRequest : BOXItemArrayRequest

@property (nonatomic, readonly, strong) NSString *collectionID;
@property (nonatomic, readonly, assign) NSRange range;

- (instancetype)initWithCollectionID:(NSString *)collectionID inRange:(NSRange)range;

@end
