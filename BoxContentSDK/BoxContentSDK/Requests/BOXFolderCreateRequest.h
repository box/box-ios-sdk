//
//  BOXFolderCreateRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFolderCreateRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, strong) NSString *folderName;
@property (nonatomic, readwrite, strong) NSString *parentFolderID;

- (instancetype)initWithFolderName:(NSString *)folderName parentFolderID:(NSString *)parentFolderID;

- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock;

@end
