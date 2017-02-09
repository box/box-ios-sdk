//
//  BOXFolderPaginatedItemsRequest_Private.h
//  BoxContentSDK
//

@interface BOXFolderPaginatedItemsRequest ()

@property (nonatomic, readwrite, strong) NSString *folderID;
@property (nonatomic, readwrite, assign) NSUInteger limit;
@property (nonatomic, readwrite, assign) NSUInteger offset;

@end

