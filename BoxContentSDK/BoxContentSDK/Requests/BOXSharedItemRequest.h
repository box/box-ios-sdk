//
//  BOXSharedItemRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"
#import "BOXSharedLinkHeadersHelper.h"

@interface BOXSharedItemRequest : BOXRequest

@property (nonatomic, readwrite, strong) BOXSharedLinkHeadersHelper *sharedLinkHeadersHelper;

@property (nonatomic, readonly, strong) NSString *sharedLinkURLString;

@property (nonatomic, readwrite, assign) BOOL requestAllItemFields;

/**
 * The list of fields to exclude from the list of fields requested
 * This works in conjuntion with requestAllItemFields to exclude fields from the list of all item fields
 * If requestAllItemFields is NO, fieldsToExclude will not have any effect,
 * and the response will include default fields from API
 */
@property (nonatomic, readwrite, strong) NSArray *fieldsToExclude;

/**
 * The list of fields to include in the response, besides default fields from API
 * @note If requestAllItemFields is YES, fieldsToInclude is ignored
 */
@property (nonatomic, readwrite, strong) NSArray *fieldsToInclude;

- (instancetype)initWithURL:(NSURL *)sharedLinkURL
                   password:(NSString *)password;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCompletion:(BOXItemBlock)completion;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCached:(BOXItemBlock)cacheBlock
                       refreshed:(BOXItemBlock)refreshBlock;

@end
