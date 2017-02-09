//
//  BOXFolderCreateRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFolderCreateRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, strong) NSString *folderName;
@property (nonatomic, readwrite, strong) NSString *parentFolderID;
@property (nonatomic, readwrite, assign) BOOL requestAllFolderFields;

- (instancetype)initWithFolderName:(NSString *)folderName parentFolderID:(NSString *)parentFolderID;

- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock;

@end
