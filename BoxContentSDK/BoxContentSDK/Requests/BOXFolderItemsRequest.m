//
//  BOXFolderItemsRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFolderItemsRequest.h"
#import "BOXFolderPaginatedItemsRequest.h"
#import "BOXBookmark.h"
#import "BOXFile.h"
#import "BOXFolder.h"
#import "BOXItem.h"
#import "BOXSharedLinkHeadersHelper.h"
#import "BOXFolderPaginatedItemsRequest_Private.h"
#import "BOXContentSDKErrors.h"
#import "BOXDispatchHelper.h"
#import "BOXFolderItemsRequest+Metadata.h"

@interface BOXFolderItemsRequest ()

@property (nonatomic) BOOL isCancelled;
@property (nonatomic, readwrite, strong) BOXFolderPaginatedItemsRequest *paginatedRequest;

@end

@implementation BOXFolderItemsRequest

@synthesize rangeStep = _rangeStep;

- (instancetype)initWithFolderID:(NSString *)folderID
{
    if (self = [super init]) {
        _folderID = folderID;
        _rangeStep = 0;
    }

    return self;
}

- (void)cancel
{
    @synchronized(self) {
        [super cancel];
        self.isCancelled = YES;
        [self.paginatedRequest cancel];
        self.paginatedRequest = nil;
    }
}

- (void)setRangeStep:(NSUInteger)rangeStep
{
    _rangeStep = rangeStep;
}

- (NSUInteger)rangeStep
{
    if (_rangeStep == 0) {
        NSUInteger rangeStep = 1000;

        // Root folder has better performance with a smaller page size
        if ([self.folderID isEqualToString:BOXAPIFolderIDRoot]) {
            rangeStep = 100;
        }
        return rangeStep;
    }
    
    return _rangeStep;
}

+ (NSString *)uniqueHashForItem:(BOXItem *)item
{
    NSString *uniqueItemHash = item.modelID;

    if ([item isKindOfClass:[BOXFile class]]) {
        uniqueItemHash = [uniqueItemHash stringByAppendingString:@"_file"];
    } else if ([item isKindOfClass:[BOXFolder class]]) {
        uniqueItemHash = [uniqueItemHash stringByAppendingString:@"_folder"];
    } else if ([item isKindOfClass:[BOXBookmark class]]) {
        uniqueItemHash = [uniqueItemHash stringByAppendingString:@"_bookmark"];
    }

    return uniqueItemHash;
}

+ (NSArray *)dedupeItemsByBoxID:(NSArray *)items
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSMutableSet *uniqueItemSet = [[NSMutableSet alloc] init];
    for (BOXItem *item in items) {
        NSString *uniqueItemHash = [self uniqueHashForItem:item];

        if ([uniqueItemSet containsObject:uniqueItemHash] == NO) {
            [uniqueItemSet addObject:uniqueItemHash];
            [results addObject:item];
        }
    }

    return [results copy];
}


- (void)performRequestWithCompletion:(BOXItemsBlock)completionBlock
{
    [self performRequestWithCached:nil refreshed:completionBlock];
}

- (void)performRequestWithCached:(BOXItemsBlock)cacheBlock refreshed:(BOXItemsBlock)refreshBlock
{
    if (cacheBlock) {
        if ([self.cacheClient respondsToSelector:@selector(retrieveCacheForFolderItemsRequest:completion:)]) {
            [self.cacheClient retrieveCacheForFolderItemsRequest:self completion:cacheBlock];
        } else {
            cacheBlock(nil, nil);
        }
    }

    if (refreshBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        NSMutableArray *results = [[NSMutableArray alloc] init];

        BOXItemsBlock localRefreshBlock = ^(NSArray *items, NSError *error){
            self.paginatedRequest = nil;

            if (error == nil && [self.cacheClient respondsToSelector:@selector(hasFinishedFolderItemsRequest:)]) {
                [self.cacheClient hasFinishedFolderItemsRequest:self];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                refreshBlock(items, error);
            } onMainThread:isMainThread];
        };

        // used to prevent retaining loop on paginatedItemFetch
        __weak __block BOXItemArrayCompletionBlock recursiveFetch = nil;
        BOXItemArrayCompletionBlock paginatedRefreshItemFetch = nil;

        // this block is called recursively to fetch pages of items in folder
        recursiveFetch = paginatedRefreshItemFetch = ^(NSArray *items, NSUInteger totalCount, NSRange range, NSError *error) {
            @synchronized(self) {
                if (error) {
                    if ([self.cacheClient respondsToSelector:@selector(cacheFolderItemsRequest:withItems:error:)]) {
                        [self.cacheClient cacheFolderItemsRequest:self
                                                        withItems:nil
                                                            error:error];
                    }
                    localRefreshBlock(nil, error);
                } else {
                    [results addObjectsFromArray:items];

                    NSUInteger rangeEnd = NSMaxRange(range);
                    if (rangeEnd < totalCount) {
                        // if total count is 1200, kMaxRangeStep is 1000, we've covered first 1000 items.
                        // now, (1200-1000) == 200, so we shuold cover next 200 items instead of 1000.
                        // There is also different situation
                        // total count is 2222, kMaxRangeStep is 1000, we've covered first 1000 items.
                        // now (2222-1000) == 1222, so we shuold cover next 1000 items
                        NSUInteger length = (totalCount - rangeEnd) > self.rangeStep ? self.rangeStep : (totalCount - rangeEnd);
                        NSUInteger offset = rangeEnd;
                        NSUInteger limit = length;
                        NSRange range = NSMakeRange(offset, limit);

                        // if operation got cancelled while preparing for the next request, call cancellation block
                        if (self.isCancelled) {
                            error = [NSError errorWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKAPIUserCancelledError userInfo:nil];
                            localRefreshBlock(nil, error);
                        } else {
                            [self performPaginatedRequestWithCached:nil
                                                          refreshed:recursiveFetch
                                                            inRange:range];
                        }
                    } else {
                        NSArray *dedupedResults = [BOXFolderItemsRequest dedupeItemsByBoxID:results];

                        if ([self.cacheClient respondsToSelector:@selector(cacheFolderItemsRequest:withItems:error:)]) {
                            [self.cacheClient cacheFolderItemsRequest:self
                                                            withItems:dedupedResults
                                                                error:nil];
                        }

                        localRefreshBlock(dedupedResults, nil);
                    }
                }
            }
        };

        [self performPaginatedRequestWithCached:nil
                                      refreshed:paginatedRefreshItemFetch
                                        inRange:NSMakeRange(0, [self rangeStep])];
    }
}

- (void)performPaginatedRequestWithCached:(BOXItemArrayCompletionBlock)cacheBlock
                                refreshed:(BOXItemArrayCompletionBlock)refreshBlock
                                  inRange:(NSRange)range
{
    BOXFolderPaginatedItemsRequest *paginatedRequest = nil;
    
    if (self.metadataTemplateKey != nil && self.metadataScope != nil) {
        paginatedRequest = [[BOXFolderPaginatedItemsRequest alloc] initWithFolderID:self.folderID metadataTemplateKey:self.metadataTemplateKey metadataScope:self.metadataScope inRange:range];
    } else {
        paginatedRequest = [[BOXFolderPaginatedItemsRequest alloc] initWithFolderID:self.folderID inRange:range];
    }
    
    paginatedRequest.cacheClient = self.cacheClient;
    paginatedRequest.queueManager = self.queueManager;
    paginatedRequest.sharedLinkHeadersHelper = self.sharedLinkHeadersHelper;
    paginatedRequest.requestAllItemFields = self.requestAllItemFields;
    paginatedRequest.fieldsToExclude = self.fieldsToExclude;
    paginatedRequest.userAgentPrefix = self.userAgentPrefix;
    paginatedRequest.sharedPaginatedRequestData = self.sharedPaginatedRequestData;
    self.paginatedRequest = paginatedRequest;
    [paginatedRequest performRequestWithCached:cacheBlock refreshed:refreshBlock];
}

#pragma mark - Private Helpers

+ (NSDictionary *)JSONDictionaryFromItems:(NSArray *)items
{
    NSMutableArray *itemsDicts = [NSMutableArray arrayWithCapacity:items.count];

    for (BOXItem *item in items) {
        [itemsDicts addObject:item.JSONData];
    }

    NSDictionary *JSONDictionary = @{@"entries" : [itemsDicts copy]};

    return JSONDictionary;
}


@end
