//
//  BOXCollectionItemOperationRequest.h
//  BoxContentSDK
//

/*
 * This request associates a BOXItem to a list of collections. The return value is the updated BOXItem.
 */

#import <BOXContentSDK/BOXRequest.h>

@interface BOXItemSetCollectionsRequest : BOXRequest

@property (nonatomic, readonly, strong) NSString *itemID;
@property (nonatomic, readonly, strong) NSArray *collectionIDs;

- (instancetype)initFileSetCollectionsRequestForFileWithID:(NSString *)fileID
                                             collectionIDs:(NSArray *)collectionIDs;

- (instancetype)initFolderSetCollectionsRequestForFolderWithID:(NSString *)folderID
                                                 collectionIDs:(NSArray *)collectionIDs;

- (instancetype)initBookmarkSetCollectionsRequestForBookmarkWithID:(NSString *)bookmarkID
                                                     collectionIDs:(NSArray *)collectionIDs;

- (void)performRequestWithCompletion:(BOXItemBlock)completionBlock;

@end
