//
//  BOXCollectionItemOperationRequest.h
//  BoxContentSDK
//

#import "BOXRequest_Private.h"

@interface BOXItemSetCollectionsRequest : BOXRequest

- (instancetype)initFileSetCollectionsRequestForFileWithID:(NSString *)fileID
                                             collectionIDs:(NSArray *)collectionIDs;

- (instancetype)initFolderSetCollectionsRequestForFolderWithID:(NSString *)folderID
                                                 collectionIDs:(NSArray *)collectionIDs;

- (instancetype)initBookmarkSetCollectionsRequestForBookmarkWithID:(NSString *)bookmarkID
                                                     collectionIDs:(NSArray *)collectionIDs;

- (void)performRequestWithCompletion:(BOXItemBlock)completionBlock;

@end
