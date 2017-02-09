//
//  BOXFileCopyRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileCopyRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readonly, strong) NSString *fileID;
@property (nonatomic, readonly, strong) NSString *destinationFolderID;
@property (nonatomic, readwrite, strong) NSString *fileName;
@property (nonatomic, readwrite, assign) BOOL requestAllFileFields;

- (instancetype)initWithFileID:(NSString *)fileID
           destinationFolderID:(NSString *)destinationFolderID;

- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock;

@end
