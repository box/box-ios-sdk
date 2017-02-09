//
//  BOXRequestWithSharedLinkHeader.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXRequestWithSharedLinkHeader.h"

#import "BOXSharedLinkHeadersHelper.h"

@interface BOXRequestWithSharedLinkHeader()

@end

@implementation BOXRequestWithSharedLinkHeader

- (void)addSharedLinkHeaderToRequest:(NSMutableURLRequest *)request
{
    NSString *sharedLinkHeaderStringValue = [self sharedLinkHeaderString];
    
    if ([sharedLinkHeaderStringValue length] > 0) {
        [request addValue:sharedLinkHeaderStringValue forHTTPHeaderField:BOXAPIHTTPHeaderBoxAPI];
    }
}

- (NSString *)sharedLinkHeaderString
{
    NSString *sharedLinkHeaderString = nil;
    
    NSString *sharedLinkURLString = [self.sharedLinkHeadersHelper sharedLinkForItemID:[self itemIDForSharedLink]
                                                                             itemType:[self itemTypeForSharedLink]];

    NSString *sharedLinkPassword = [self.sharedLinkHeadersHelper passwordForItemForItemWithID:[self itemIDForSharedLink]
                                                                                     itemType:[self itemTypeForSharedLink]];
    
    if ([sharedLinkURLString length] > 0) {
        sharedLinkHeaderString = [BOXAPIObjectKeySharedLink stringByAppendingFormat:@"=%@", sharedLinkURLString];
        if ([sharedLinkPassword length] > 0) {
            sharedLinkHeaderString = [sharedLinkHeaderString stringByAppendingFormat:@"&%@=%@",
                                      BOXAPIObjectKeySharedLinkPassword,
                                      sharedLinkPassword];
        }
    }

    return sharedLinkHeaderString;
}

- (NSString *)itemIDForSharedLink
{
    BOXAbstract();
    return nil;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    BOXAbstract();
    return nil;
}

@end
