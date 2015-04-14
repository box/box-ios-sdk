//
//  BOXItemArrayRequests.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXItemArrayRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, assign) BOOL requestAllItemFields;

- (void)performRequestWithCompletion:(BOXItemArrayCompletionBlock)completionBlock;

@end
