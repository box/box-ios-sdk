//
//  BOXRepresentationDownloadRequest.h
//  BoxContentSDK
//
//  Created by Clement Rousselle on 3/2/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import "BOXRequestWithSharedLinkHeader.h"

@class BOXRepresentation;

@interface BOXFileRepresentationDownloadRequest : BOXRequestWithSharedLinkHeader

// This is not the etag of a particular version of the file, nor the sequential version number,
// it is the ID of the version representation gotten from /files/<fileID>/versions
@property (nonatomic, readwrite, strong) NSString *versionID;

// Enable NSURLSession cachepolicy for this request
@property (nonatomic, readwrite, assign) BOOL ignoreLocalURLRequestCache;

// Set digest to verify data integrity of downloaded content
@property (nonatomic, readwrite, strong) NSString *sha1Hash;

// Set max size of downloaded content until which data integrity is verified
@property (nonatomic, readwrite, assign) NSUInteger requireSha1ChecksUpToMaxFileSize;

/**
 Request will download file into destinationPath, and the file download can continue
 running in the background even if app is not running.
 
 @param destinationPath File path to download file.
 @param fileID BOXFile modelID
 @param representation BOXRepresentation of available content to download. See BOXFileRequestInfo to
                       retrieve available representation.
 @return instance of BOXFileRepresentationDownloadRequest
 */
- (instancetype)initWithLocalDestination:(NSString *)destinationPath
                                  fileID:(NSString *)fileID
                          representation:(BOXRepresentation *)representation;

/**
 Similar to the above init method, request will download file into destinationPath,
 If associateId is provided, the file download can continue running in the background even if the
 app is not running. It will be used to execute/reconnect with the existing download task.

 @param destinationPath     File path to download file.
 @param fileID              BOXFile modelID
 @param representation      BOXRepresentation of available content to download. See BOXFileRequestInfo to
                            retrieve available representation.
 @param associateId         UniqueID (UUID) to provide session task for background management.
 @return instance of BOXFileRepresentationDownloadRequest
 */
- (instancetype)initWithLocalDestination:(NSString *)destinationPath
                                  fileID:(NSString *)fileID
                          representation:(BOXRepresentation *)representation
                             associateId:(NSString *)associateId;

/**
 * request will download file into outputStream, and the file download cannot continue
 * if the app is not running
 */
- (instancetype)initWithOutputStream:(NSOutputStream *)outputStream
                              fileID:(NSString *)fileID
                      representation:(BOXRepresentation *)representation;

- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock completion:(BOXErrorBlock)completionBlock;

/**
 * Call this to cancel background download with intention to resume from where it left off in a later request
 */
- (void)cancelWithIntentionToResume;

@end
