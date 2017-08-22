//
//  BOXFolderPaginatedItemsRequest.h
//  BoxContentSDK
//

#import "BOXItemArrayRequest.h"

@interface BOXFolderPaginatedItemsRequest : BOXItemArrayRequest

@property (nonatomic, readonly, strong) NSString *folderID;
@property (nonatomic, readonly, assign) NSUInteger limit;
@property (nonatomic, readonly, assign) NSUInteger offset;

//all paginated requests of this request will have the same data
//can be used as a way to link related paginated requests together
@property (nonatomic, readwrite, strong) NSData *sharedPaginatedRequestData;

- (instancetype)initWithFolderID:(NSString *)folderID inRange:(NSRange)range;

@end
