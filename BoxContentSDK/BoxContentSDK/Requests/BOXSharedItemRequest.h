//
//  BOXSharedItemRequest.h
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXSharedLinkHeadersHelper.h"

@interface BOXSharedItemRequest : BOXRequest

@property (nonatomic, readwrite, strong) BOXSharedLinkHeadersHelper *sharedLinkHeadersHelper;

- (instancetype)initWithURL:(NSURL *)sharedLinkURL
                   password:(NSString *)password;

- (void)performRequestWithCompletion:(BOXItemBlock)completion;

@end
