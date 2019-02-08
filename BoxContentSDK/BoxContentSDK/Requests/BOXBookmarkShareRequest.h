//
//  BOXBookmarkShareRequest.h
//  BoxContentSDK
//

#import "BOXItemShareRequest.h"

@interface BOXBookmarkShareRequest : BOXItemShareRequest

@property (nonatomic, readonly, strong) NSString *bookmarkID;

- (instancetype)initWithBookmarkID:(NSString *)bookmarkID;
- (void)performRequestWithCompletion:(BOXBookmarkBlock)completionBlock;

@end
