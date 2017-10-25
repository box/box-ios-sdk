//
//  BOXFolderRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFolderRequest : BOXRequestWithSharedLinkHeader

/*
 By default BOXFileRequest will only fetch a predefined set of fields. Use |requestAllFolderFields| to
 request all fields.
 For detailed explaination and list of the fields please visit https://developers.box.com/docs/#folders-folder-object
 */
@property (nonatomic, readwrite, assign) BOOL requestAllFolderFields;
@property (nonatomic, readwrite, strong) NSArray *notMatchingEtags;//If-None-Match: Array of strings representing etag values
@property (nonatomic, readonly, strong) NSString *folderID;

// NOTE: Both the associateID and requestDirectoryPath values are required for performing the request in the background.
/**
 Caller provided unique ID to execute the request as a NSURLSession background task.
 This is a required value for performing the request in the background.
 */
@property (nonatomic, readwrite, copy) NSString *associateId;

/**
 Caller provided directory path for the result payload of the background operation to be written to.
 This is a required value for performing the request in the background.
 */
@property (nonatomic, readwrite, copy) NSString *requestDirectoryPath;

- (instancetype)initWithFolderID:(NSString *)folderID;
- (instancetype)initWithFolderID:(NSString *)folderID
                     associateId:(NSString *)associateId;
- (instancetype)initWithFolderID:(NSString *)folderID isTrashed:(BOOL)isTrashed;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCached:(BOXFolderBlock)cacheBlock
                       refreshed:(BOXFolderBlock)refreshBlock;

@end
