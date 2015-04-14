//
//  BOXFolderPaginatedItemsRequest.h
//  BoxContentSDK
//

#import "BOXItemArrayRequest.h"

@interface BOXFolderPaginatedItemsRequest : BOXItemArrayRequest

- (instancetype)initWithFolderID:(NSString *)folderID inRange:(NSRange)range;

@end
