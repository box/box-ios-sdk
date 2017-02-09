//
//  BOXBookmarkShareRequest.h
//  BoxContentSDK
//

#import "BOXItemShareRequest.h"

@interface BOXBookmarkShareRequest : BOXItemShareRequest

- (instancetype)initWithBookmarkID:(NSString *)bookmarkID;
- (void)performRequestWithCompletion:(BOXBookmarkBlock)completionBlock;

@end
