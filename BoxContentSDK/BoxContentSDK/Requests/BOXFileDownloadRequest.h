//
//  BOXFileDownloadRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileDownloadRequest : BOXRequestWithSharedLinkHeader

// This is not the etag of a particular version of the file, nor the sequential version number,
// it is the ID of the version representation gotten from /files/<fileID>/versions
@property (nonatomic, readwrite, strong) NSString *versionID;

- (instancetype)initWithLocalDestination:(NSString *)destinationPath
                                  fileID:(NSString *)fileID;

- (instancetype)initWithOutputStream:(NSOutputStream *)outputStream
                              fileID:(NSString *)fileID;

- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock completion:(BOXErrorBlock)completionBlock;

@end
