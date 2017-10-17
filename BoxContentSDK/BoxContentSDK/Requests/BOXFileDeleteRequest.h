//
//  BOXFileDeleteRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileDeleteRequest : BOXRequestWithSharedLinkHeader

// NOTE: Both the associateID and requestDirectoryPath values are required for performing the request in the background.
/**
 Caller provided unique ID to execute the request as a NSURLSession background task.
 This is a required value for performing the request in the background.
 */
@property (nonatomic, readwrite, strong) NSString *associateId;

/**
 Caller provided directory path for the result payload of the background operation to be written to.
 */
@property (nonatomic, readwrite, copy) NSString *requestDirectoryPath;

@property (nonatomic, readonly, strong) NSString *fileID;

// Optional, if nil the file will get deleted if it exists and deletion is permissable.
// If an etag value is supplied, the file will only be deleted if the provided etag matches the current value.
@property (nonatomic, readwrite, strong) NSString *matchingEtag;

- (instancetype)initWithFileID:(NSString *)fileID;
- (instancetype)initWithFileID:(NSString *)fileID isTrashed:(BOOL)isTrashed;

- (instancetype)initWithFileID:(NSString *)fileID
                     isTrashed:(BOOL)isTrashed
                   associateId:(NSString *)associateId;

- (void)performRequestWithCompletion:(BOXErrorBlock)completionBlock;

@end
