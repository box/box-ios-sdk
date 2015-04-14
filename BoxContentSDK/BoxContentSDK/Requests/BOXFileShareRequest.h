//
//  BOXFileShareRequest.h
//  BoxContentSDK
//

#import "BOXItemShareRequest.h"

@interface BOXFileShareRequest : BOXItemShareRequest

- (instancetype)initWithFileID:(NSString *)fileID;
- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock;

@end
