//
//  BOXSharedItemRequest.h
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXSharedLinkHeadersHelper.h"

@interface BOXSharedItemRequest : BOXRequest

@property (nonatomic, readwrite, strong) BOXSharedLinkHeadersHelper *sharedLinkHeadersHelper;

@property (nonatomic, readonly, strong) NSString *sharedLinkURLString;

- (instancetype)initWithURL:(NSURL *)sharedLinkURL
                   password:(NSString *)password;

- (void)performRequestWithCompletion:(BOXItemBlock)completion;

- (void)performRequestWithCached:(BOXItemBlock)cacheBlock
                       refreshed:(BOXItemBlock)refreshBlock;

@end
