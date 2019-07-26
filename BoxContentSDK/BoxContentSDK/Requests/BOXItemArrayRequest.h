//
//  BOXItemArrayRequests.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXItemArrayRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, assign) BOOL requestAllItemFields;

/**
 * The list of fields to exclude from the list of fields requested
 * This works in conjuntion with requestAllItemFields to exclude fields from the list of all item fields
 * If requestAllItemFields is NO, fieldsToExclude will not have any effect,
 * and the response will include default fields from API
 */
@property (nonatomic, readwrite, strong) NSArray *fieldsToExclude;

- (void)performRequestWithCompletion:(BOXItemArrayCompletionBlock)completionBlock;
- (void)performRequestWithCached:(BOXItemArrayCompletionBlock)cacheBlock refreshed:(BOXItemArrayCompletionBlock)refreshBlock;

@end
