//
//  BOXFileVersionsRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileVersionsRequest : BOXRequestWithSharedLinkHeader

- (instancetype)initWithFileID:(NSString *)fileID;
- (void)performRequestWithCompletion:(BOXObjectsArrayCompletionBlock)completionBlock;

@end
