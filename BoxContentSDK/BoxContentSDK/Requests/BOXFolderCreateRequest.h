//
//  BOXFolderCreateRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFolderCreateRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, strong) NSString *folderName;
@property (nonatomic, readwrite, strong) NSString *parentFolderID;
@property (nonatomic, readwrite, assign) BOOL requestAllFolderFields;

/**
 Caller provided directory path for the result payload of the background operation to be written to.
 */
@property (nonatomic, readwrite, copy) NSString *requestDirectoryPath;

- (instancetype)initWithFolderName:(NSString *)folderName
                    parentFolderID:(NSString *)parentFolderID;

- (instancetype)initWithFolderName:(NSString *)folderName
                    parentFolderID:(NSString *)parentFolderID
                       associateId:(nullable NSString *)associateId;

- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock;

@end
