//
//  BOXRequestWithSharedLinkHeader.h
//  BoxContentSDK
//

#import <BoxContentSDK/BOXContentSDKConstants.h>
#import <BoxContentSDK/BOXRequest.h>
#import <BoxContentSDK/BOXSharedLinkItemSource.h>

@class BOXSharedLinkHeadersHelper;

@interface BOXRequestWithSharedLinkHeader : BOXRequest <BOXSharedLinkItemSource>

@property (nonatomic, readwrite, strong) BOXSharedLinkHeadersHelper *sharedLinkHeadersHelper;

- (void)addSharedLinkHeaderToRequest:(NSMutableURLRequest *)request;

@end
