//
//  BOXBookmarkShareRequest.h
//  BoxContentSDK
//

#import <BoxContentSDK/BOXItemShareRequest.h>

@interface BOXBookmarkShareRequest : BOXItemShareRequest

- (instancetype)initWithBookmarkID:(NSString *)bookmarkID;
- (void)performRequestWithCompletion:(BOXBookmarkBlock)completionBlock;

@end
