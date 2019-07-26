//
//  BOXSearchRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"

@interface BOXSearchRequest : BOXRequest

@property (nonatomic, readonly, copy) NSString *query;
@property (nonatomic, readonly, assign) NSUInteger limit;
@property (nonatomic, readonly, assign) NSUInteger offset;

@property (nonatomic, readwrite, copy) NSArray<NSString *> *fileExtensions;
@property (nonatomic, readwrite, strong) NSDate *createdAtFromDate;
@property (nonatomic, readwrite, strong) NSDate *createdAtToDate;
@property (nonatomic, readwrite, strong) NSDate *updatedAtFromDate;
@property (nonatomic, readwrite, strong) NSDate *updatedAtToDate;
@property (nonatomic, readwrite, assign) NSUInteger sizeLowerBound;
@property (nonatomic, readwrite, assign) NSUInteger sizeUpperBound;
@property (nonatomic, readwrite, copy) NSArray<NSString *> *ownerUserIDs;
@property (nonatomic, readwrite, copy) NSArray<NSString *> *ancestorFolderIDs;
@property (nonatomic, readwrite, copy) NSArray<NSString *> *contentTypes;
@property (nonatomic, readwrite, copy) NSString *type;
@property (nonatomic, readwrite, copy) NSString *metadataTemplateKey;
@property (nonatomic, readwrite, copy) NSString *metadataScope;

/*
 By default BOXSearchRequest will only fetch a predefined set of fields. Use |requestAllItemFields| to
 request all fields.
 */
@property (nonatomic, readwrite, assign) BOOL requestAllItemFields;

/**
 * The list of fields to exclude from the list of fields requested
 * This works in conjuntion with requestAllItemFields to exclude fields from the list of all item fields
 * If requestAllItemFields is NO, fieldsToExclude will not have any effect,
 * and the response will include default fields from API
 */
@property (nonatomic, readwrite, strong) NSArray *fieldsToExclude;

- (instancetype)initWithSearchQuery:(NSString *)query inRange:(NSRange)range;

- (instancetype)initWithTemplateKey:(NSString *)templateKey scope:(NSString *)scope filters:(NSArray *)filters inRange:(NSRange)range;

- (instancetype)initWithTemplateKey:(NSString *)templateKey scope:(NSString *)scope filters:(NSArray *)filters inRange:(NSRange)range unifiedMetadataKeys:(NSArray *)unifiedMetadataKeys;

//Perform API request only if completionBlock is not nil
- (void)performRequestWithCompletion:(BOXItemArrayCompletionBlock)completionBlock;

//Perform API and cache requests, with each request occurring only if it is not nil
- (void)performRequestWithCached:(BOXItemArrayCompletionBlock)cacheBlock
                       refreshed:(BOXItemArrayCompletionBlock)refreshBlock;

@end
