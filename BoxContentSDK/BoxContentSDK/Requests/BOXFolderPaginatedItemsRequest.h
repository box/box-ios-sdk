//
//  BOXFolderPaginatedItemsRequest.h
//  BoxContentSDK
//

#import "BOXItemArrayRequest.h"

@interface BOXFolderPaginatedItemsRequest : BOXItemArrayRequest

@property (nonatomic, readonly, strong) NSString *folderID;
@property (nonatomic, readonly, assign) NSUInteger limit;
@property (nonatomic, readonly, assign) NSUInteger offset;

- (instancetype)initWithFolderID:(NSString *)folderID inRange:(NSRange)range;

@end
