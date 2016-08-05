//
//  BOXItemArrayRequests.m
//  BoxContentSDK
//

#import <BoxContentSDK/BOXContentSDKConstants.h>
#import <BoxContentSDK/BOXItemArrayRequest.h>
#import <BoxContentSDK/BOXLog.h>

@implementation BOXItemArrayRequest

- (void)performRequestWithCompletion:(BOXItemArrayCompletionBlock)completionBlock
{
    //
}

- (void)performRequestWithCached:(BOXItemArrayCompletionBlock)cacheBlock refreshed:(BOXItemArrayCompletionBlock)refreshBlock
{
    //
}

#pragma mark - Superclass overidden methods

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
