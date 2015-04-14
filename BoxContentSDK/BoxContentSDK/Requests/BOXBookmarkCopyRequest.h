//
//  BOXBookmarkCopyRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXBookmarkCopyRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readonly, strong) NSString *bookmarkID;
@property (nonatomic, readonly, strong) NSString *destinationFolderID;
@property (nonatomic, readwrite, strong) NSString *bookmarkName;

- (instancetype)initWithBookmarkID:(NSString *)fileID
               destinationFolderID:(NSString *)destinationFolderID;

- (void)performRequestWithCompletion:(BOXBookmarkBlock)completionBlock;

@end
