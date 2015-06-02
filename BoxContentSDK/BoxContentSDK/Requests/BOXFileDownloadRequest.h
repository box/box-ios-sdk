//
//  BOXFileDownloadRequest.h
//  BoxContentSDK
//

#import "BOXFileAccessRequest.h"

@interface BOXFileDownloadRequest : BOXFileAccessRequest

- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock completion:(BOXErrorBlock)completionBlock;

@end
