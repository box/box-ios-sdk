//
//  BOXFileRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, assign) BOOL requestAllFileFields;

@property (nonatomic, readwrite, strong) NSArray *notMatchingEtags; //If-None-Match: Array of strings representing etag values

@property (nonatomic, readonly, strong) NSString *fileID;

// NOTE: Both the associateID and requestDirectoryPath values are required for performing the request in the background.
/**
 Caller provided unique ID to execute the request as a NSURLSession background task.
 This is a required value for performing the request in the background.
 */
@property (nonatomic, readwrite, strong) NSString *associateID;

/**
 Caller provided directory path for the result payload of the background operation to be written to.
 This is a required value for performing the request in the background.
 */
@property (nonatomic, readwrite, strong) NSString *requestDirectoryPath;

/**
 The X-Rep-Hints header, defining what representations will get returned
 when requesting the representations field. Setting this field also adds
 the representations field to the request.
 */
@property (nonatomic, readwrite, copy) BOXRepresentationHints representationHints;

- (instancetype)initWithFileID:(NSString *)fileID;

- (instancetype)initWithFileID:(NSString *)fileID
                     isTrashed:(BOOL)isTrashed;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCached:(BOXFileBlock)cacheBlock
                       refreshed:(BOXFileBlock)refreshBlock;

@end
