//
//  BOXCollectionItemOperationRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"

/*
 * This request associates a BOXItem to a list of collections. The return value is the updated BOXItem.
 */

@interface BOXItemSetCollectionsRequest : BOXRequest

@property (nonatomic, readonly, strong) NSString *itemID;
@property (nonatomic, readonly, strong) NSArray *collectionIDs;
@property (nonatomic, readwrite, assign) BOOL requestAllItemFields;

/**
 Caller provided directory path for the result payload of the background operation to be written to.
 */
@property (nonatomic, readwrite, copy) NSString *requestDirectoryPath;

- (instancetype)initFileSetCollectionsRequestForFileWithID:(NSString *)fileID
                                             collectionIDs:(NSArray *)collectionIDs;

- (instancetype)initFileSetCollectionsRequestForFileWithID:(NSString *)fileID
                                             collectionIDs:(NSArray *)collectionIDs
                                               associateId:(NSString *)associateId;

- (instancetype)initFolderSetCollectionsRequestForFolderWithID:(NSString *)folderID
                                                 collectionIDs:(NSArray *)collectionIDs;

- (instancetype)initFolderSetCollectionsRequestForFolderWithID:(NSString *)folderID
                                                 collectionIDs:(NSArray *)collectionIDs
                                                   associateId:(NSString *)associateId;

- (instancetype)initBookmarkSetCollectionsRequestForBookmarkWithID:(NSString *)bookmarkID
                                                     collectionIDs:(NSArray *)collectionIDs;

- (instancetype)initBookmarkSetCollectionsRequestForBookmarkWithID:(NSString *)bookmarkID
                                                     collectionIDs:(NSArray *)collectionIDs
                                                       associateId:(NSString *)associateId;

- (void)performRequestWithCompletion:(BOXItemBlock)completionBlock;

@end
