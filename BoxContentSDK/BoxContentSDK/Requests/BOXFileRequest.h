//
//  BOXFileRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, assign) BOOL requestAllFileFields;

/**
 Ordered list of representation types, returns first representation type supported by the specified file type
 */
@property (nonatomic, readwrite, assign) BOOL matchSupportedRepresentation;

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


- (instancetype)initWithFileID:(NSString *)fileID;

- (instancetype)initWithFileID:(NSString *)fileID
                     isTrashed:(BOOL)isTrashed;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCached:(BOXFileBlock)cacheBlock
                       refreshed:(BOXFileBlock)refreshBlock;

/**
 Setting a representation or Array of options will include availability for that file when request representation information
 */
- (void)setRepresentationRequestOptions:(NSArray *)representationOptions;

- (NSString *)formatRepresentationRequestHeader;

@end
