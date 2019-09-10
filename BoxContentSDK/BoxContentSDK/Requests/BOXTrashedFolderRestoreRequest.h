//
//  BOXTrashedFolderRestoreRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"

@interface BOXTrashedFolderRestoreRequest : BOXRequest <BOXBackgroundRequestProtocol>

// NOTE: Both the associateID and requestDirectoryPath values are required for performing the request in the background.

/**
 Caller provided directory path for the result payload of the background operation to be written to.
 This is a required value for performing the request in the background.
 */
@property (nonatomic, readwrite, copy) NSString *requestDirectoryPath;

@property (nonatomic, readonly, strong) NSString *folderID;

@property (nonatomic, readwrite, strong) NSString *folderName;

@property (nonatomic, readwrite, strong) NSString *parentFolderID;

- (instancetype)initWithFolderID:(NSString *)folderID;
- (instancetype)initWithFolderID:(NSString *)folderID associateID:(NSString *)associateID;
- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock;

@end
