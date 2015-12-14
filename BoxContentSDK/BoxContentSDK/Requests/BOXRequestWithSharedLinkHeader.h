//
//  BOXRequestWithSharedLinkHeader.h
//  BoxContentSDK
//

#import "BOXRequest.h"
#import "BOXContentSDKConstants.h"
#import "BOXSharedLinkItemSource.h"

@class BOXSharedLinkHeadersHelper;

@interface BOXRequestWithSharedLinkHeader : BOXRequest <BOXSharedLinkItemSource>

@property (nonatomic, readwrite, strong) BOXSharedLinkHeadersHelper *sharedLinkHeadersHelper;

- (void)addSharedLinkHeaderToRequest:(NSMutableURLRequest *)request;

@end
