//
//  BOXItemArrayRequests.m
//  BoxContentSDK
//

#import "BOXItemArrayRequest.h"
#import "BOXContentSDKConstants.h"
#import "BOXLog.h"

@implementation BOXItemArrayRequest

- (void)performRequestWithCompletion:(BOXItemArrayCompletionBlock)completionBlock
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
