//
//  BOXFileVersionPromoteRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"

@interface BOXFileVersionPromoteRequest : BOXRequest

@property (nonatomic, readonly, strong) NSString *fileID;
@property (nonatomic, readonly, strong) NSString *versionID;

- (instancetype)initWithFileID:(NSString *)fileID targetVersionID:(NSString *)versionID;
- (void)performRequestWithCompletion:(BOXFileVersionBlock)completionBlock;

@end
