//
//  BOXCollectionItemsRequest.h
//  BoxContentSDK
//

#import "BOXItemArrayRequest.h"

@interface BOXCollectionItemsRequest : BOXItemArrayRequest

@property (nonatomic, readonly, copy) NSString *collectionID;
@property (nonatomic, readonly, assign) NSRange range;
@property (nonatomic, readonly, copy) NSString *metadataTemplateKey;
@property (nonatomic, readonly, copy) NSString *metadataScope;

- (instancetype)initWithCollectionID:(NSString *)collectionID inRange:(NSRange)range;
- (instancetype)initWithCollectionID:(NSString *)collectionID inRange:(NSRange)range metadataTemplateKey:(NSString *)metadataTemplateKey metadataScope:(NSString *)metadataScope;

@end
