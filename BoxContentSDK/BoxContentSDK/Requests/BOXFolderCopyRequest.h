//
//  BOXFolderCopyRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFolderCopyRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readonly, strong) NSString *folderID;
@property (nonatomic, readonly, strong) NSString *destinationFolderID;
@property (nonatomic, readwrite, strong) NSString *folderName;
@property (nonatomic, readwrite, assign) BOOL requestAllFolderFields;

- (instancetype)initWithFolderID:(NSString *)folderID destinationFolderID:(NSString *)destinationFolderID;

- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock;

@end
