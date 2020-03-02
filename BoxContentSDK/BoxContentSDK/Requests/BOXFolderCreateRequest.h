//
//  BOXFolderCreateRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface BOXFolderCreateRequest : BOXRequestWithSharedLinkHeader <BOXBackgroundRequestProtocol>

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
                       associateID:(nullable NSString *)associateID;

- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END

