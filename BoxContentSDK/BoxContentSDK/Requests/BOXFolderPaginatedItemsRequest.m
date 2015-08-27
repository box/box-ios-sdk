//
//  BOXFolderPaginatedItemsRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFolderPaginatedItemsRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXBookmark.h"
#import "BOXFile.h"
#import "BOXFolder.h"
#import "BOXItem.h"
#import "BOXSharedLinkHeadersHelper.h"
#import "BOXFolderPaginatedItemsRequest_Private.h"

@implementation BOXFolderPaginatedItemsRequest

- (instancetype)initWithFolderID:(NSString *)folderID inRange:(NSRange)range
{
    if (self = [super init]) {
        _folderID = folderID;
        _limit = range.length;
        _offset = range.location;
    }

    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFolders
                                    ID:self.folderID
                           subresource:BOXAPISubresourceItems
                                 subID:nil];

    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionary];

    if (self.requestAllItemFields) {
        queryParameters[BOXAPIParameterKeyFields] = [self fullItemFieldsParameterString];
    }

    if (self.limit != 0) {
        queryParameters[BOXAPIParameterKeyLimit] = [NSString stringWithFormat:@"%lu", (unsigned long)self.limit];
    }

    queryParameters[BOXAPIParameterKeyOffset] = [NSString stringWithFormat:@"%lu", (unsigned long)self.offset];

    BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];

    [self addSharedLinkHeaderToRequest:JSONOperation.APIRequest];

    return JSONOperation;
}

- (void)performRequestWithCompletion:(BOXItemArrayCompletionBlock)completionBlock
{
    [self performRequestWithCached:nil refreshed:completionBlock];
}

- (void)performRequestWithCached:(BOXItemArrayCompletionBlock)cacheBlock refreshed:(BOXItemArrayCompletionBlock)refreshBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *folderOperation = (BOXAPIJSONOperation *)self.operation;
    
    if (cacheBlock) {
        if (self.requestCache) {
            [self.requestCache fetchCacheResponseForRequest:self cacheBlock:^(NSDictionary *JSONDictionary) {
                NSUInteger totalCount = [JSONDictionary[BOXAPICollectionKeyTotalCount] unsignedIntegerValue];
                NSUInteger offset = [JSONDictionary[BOXAPIParameterKeyOffset] unsignedIntegerValue];
                NSUInteger limit = [JSONDictionary[BOXAPIParameterKeyLimit] unsignedIntegerValue];
                NSArray *itemDictionaries = JSONDictionary[BOXAPICollectionKeyEntries];
                NSUInteger capacity = itemDictionaries.count;
                NSMutableArray *items = [NSMutableArray arrayWithCapacity:capacity];
                
                for (NSDictionary *itemDictionary in itemDictionaries) {
                    BOXItem *item = [self itemWithJSON:itemDictionary];
                    [items addObject:item];
                }
                [BOXDispatchHelper callCompletionBlock:^{
                    cacheBlock(items, totalCount, NSMakeRange(offset, limit), nil);
                } onMainThread:isMainThread];
            }];
        }
    }
    
    if (refreshBlock) {
        folderOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            NSUInteger totalCount = [JSONDictionary[BOXAPICollectionKeyTotalCount] unsignedIntegerValue];
            NSUInteger offset = [JSONDictionary[BOXAPIParameterKeyOffset] unsignedIntegerValue];
            NSUInteger limit = [JSONDictionary[BOXAPIParameterKeyLimit] unsignedIntegerValue];
            NSArray *itemDictionaries = JSONDictionary[BOXAPICollectionKeyEntries];
            NSUInteger capacity = itemDictionaries.count;
            NSMutableArray *items = [NSMutableArray arrayWithCapacity:capacity];

            for (NSDictionary *itemDictionary in itemDictionaries) {
                BOXItem *item = [self itemWithJSON:itemDictionary];
                [items addObject:item];
                
                NSArray *pathFolders = nil;

                if ([item isKindOfClass:[BOXFile class]]) {
                    pathFolders = [((BOXFile *)item) pathFolders];
                } else if ([item isKindOfClass:[BOXFile class]]) {
                    pathFolders = [((BOXFolder *) item) pathFolders];
                } else if ([item isKindOfClass:[BOXBookmark class]]) {
                    pathFolders = [((BOXBookmark *) item) pathFolders];
                }                
                [self.sharedLinkHeadersHelper storeHeadersFromAncestorsIfNecessaryForItemWithID:item.modelID
                                                                                       itemType:item.type
                                                                                      ancestors:pathFolders];
            }
            [BOXDispatchHelper callCompletionBlock:^{
                refreshBlock(items, totalCount, NSMakeRange(offset, limit), nil);
                
                // Don't want to update cache for a subclass recursively calling this method.
                if ([self isMemberOfClass:[BOXFolderPaginatedItemsRequest class]]) {
                    [self.requestCache updateCacheForRequest:self withResponse:JSONDictionary];
                }
            } onMainThread:isMainThread];
        };
        folderOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                refreshBlock(nil, 0, NSMakeRange(0, 0), error);
                // TODO: only if not network error
                if ([self isMemberOfClass:[BOXFolderPaginatedItemsRequest class]]) {
                    [self.requestCache removeCacheResponseForRequest:self];
                }
            } onMainThread:isMainThread];
        };
    }

    [self performRequest];
}

#pragma mark - Superclass overidden methods

- (NSString *)itemIDForSharedLink
{
    return self.folderID;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeFolder;
}

@end
