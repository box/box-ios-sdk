//
//  BOXFileVersionPromoteRequest.h
//  BoxContentSDK
//

#import "BOXRequest_Private.h"

@interface BOXFileVersionPromoteRequest : BOXRequest

- (instancetype)initWithFileID:(NSString *)fileID targetVersionID:(NSString *)versionID;
- (void)performRequestWithCompletion:(BOXFileVersionBlock)completionBlock;

@end
