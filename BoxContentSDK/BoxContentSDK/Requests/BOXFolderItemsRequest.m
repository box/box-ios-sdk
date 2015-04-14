//
//  BOXFolderItemsRequest.m
//  BoxContentSDK
//

#import "BOXFolderItemsRequest.h"

#import "BOXRequest_Private.h"
#import "BOXFolderPaginatedItemsRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXBookmark.h"
#import "BOXFile.h"
#import "BOXFolder.h"
#import "BOXItem.h"
#import "BOXSharedLinkHeadersHelper.h"
#import "BOXFolderPaginatedItemsRequest_Private.h"

@interface BOXFolderItemsRequest ()
@property (nonatomic) BOOL isCancelled;
@end

@implementation BOXFolderItemsRequest

- (instancetype)initWithFolderID:(NSString *)folderID
{
    if (self = [super init]) {
        self.folderID = folderID;
        self.limit = self.rangeStep;        
        self.offset = 0;
    }
    
    return self;
}

- (void)cancel
{
    @synchronized(self) {
        [super cancel];
        self.isCancelled = YES;
    }
}

- (NSUInteger)rangeStep
{
    return 1000;
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
    BOOL isMainThread = [NSThread isMainThread];
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    // used to work around warning on retain loop on paginatedItemFetch
    __block BOXItemArrayCompletionBlock recursiveFetch = nil;
    
    BOXItemsBlock localCompletionBlock = ^(NSArray *items, NSError *error){
        [BOXDispatchHelper callCompletionBlock:^{
            completionBlock(items, error);
        } onMainThread:isMainThread];
    };
    
    BOXItemArrayCompletionBlock paginatedItemFetch = ^(NSArray *items, NSUInteger totalCount, NSRange range, NSError *error){
        @synchronized(self) {
            if (error) {
                localCompletionBlock(nil, error);
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
                    self.offset = rangeEnd;
                    self.limit = length;
                                        
                    // reset operation, so that boxrequest recreates new operation for next batch
                    self.operation = nil;
                    
                    // if operation got cancelled while preparing for the next request, call cancellation block
                    if (self.isCancelled) {
                        error = [NSError errorWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKAPIUserCancelledError userInfo:nil];
                        localCompletionBlock(nil, error);
                    } else {
                        [self performPaginatedRequestWithCompletion:recursiveFetch];
                    }
                } else {
                    NSArray *dedupedResults = [BOXFolderItemsRequest dedupeItemsByBoxID:results];
                    localCompletionBlock(dedupedResults, nil);
                }
            }
        }
    };
    
    recursiveFetch = [paginatedItemFetch copy];
    [self performPaginatedRequestWithCompletion:paginatedItemFetch];
}

- (void)performPaginatedRequestWithCompletion:(BOXItemArrayCompletionBlock)completionBlock
{
    // just call paginated request
    [super performRequestWithCompletion:completionBlock];
}


@end