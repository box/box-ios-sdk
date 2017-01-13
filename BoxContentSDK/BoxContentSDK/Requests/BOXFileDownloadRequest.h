//
//  BOXFileDownloadRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileDownloadRequest : BOXRequestWithSharedLinkHeader

// This is not the etag of a particular version of the file, nor the sequential version number,
// it is the ID of the version representation gotten from /files/<fileID>/versions
@property (nonatomic, readwrite, strong) NSString *versionID;

/**
 * request will download file into destinationPath, and the file download can continue
 * running in the background even if app is not running
 */
- (instancetype)initWithLocalDestination:(NSString *)destinationPath
                                  fileID:(NSString *)fileID;

/**
 * request will download file into outputStream, and the file download cannot continue
 * if the app is not running
 */
- (instancetype)initWithOutputStream:(NSOutputStream *)outputStream
                              fileID:(NSString *)fileID;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock completion:(BOXErrorBlock)completionBlock;

@end
