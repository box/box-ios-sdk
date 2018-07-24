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
#import "BOXDispatchHelper.h"
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

- (instancetype)initWithFolderID:(NSString *)folderID metadataTemplateKey:(NSString *)metadataTemplateKey metadataScope:(BOXMetadataScope)metadataScope inRange:(NSRange)range
 {
    if (self = [super init]){
        _folderID = folderID;
        _metadataTemplateKey = metadataTemplateKey;
        _metadataScope = metadataScope;
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
    NSString *fieldString = nil;
    
    if (self.requestAllItemFields) {
        fieldString = [self fullItemFieldsParameterStringExcludingFields:self.fieldsToExclude];
    }
    
    if (self.metadataTemplateKey && self.metadataScope) {
        NSString *metadata = [NSString stringWithFormat:@"%@.%@.%@",BOXAPISubresourceMetadata,self.metadataScope,self.metadataTemplateKey];
        fieldString = [fieldString stringByAppendingFormat:@",%@",metadata];
    }
    
    queryParameters[BOXAPIParameterKeyFields] = fieldString;

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
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *folderOperation = (BOXAPIJSONOperation *)self.operation;

        folderOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            NSUInteger totalCount = [JSONDictionary[BOXAPICollectionKeyTotalCount] unsignedIntegerValue];
            NSUInteger offset = [JSONDictionary[BOXAPIParameterKeyOffset] unsignedIntegerValue];
            NSUInteger limit = [JSONDictionary[BOXAPIParameterKeyLimit] unsignedIntegerValue];
            NSArray *itemDictionaries = JSONDictionary[BOXAPICollectionKeyEntries];
            NSUInteger capacity = itemDictionaries.count;
            NSMutableArray *items = [NSMutableArray arrayWithCapacity:capacity];

            for (NSDictionary *itemDictionary in itemDictionaries) @autoreleasepool {
                BOXItem *item = [BOXRequest itemWithJSON:itemDictionary];
                [items addObject:item];
                [self.sharedLinkHeadersHelper storeHeadersFromAncestorsIfNecessaryForItemWithID:item.modelID
                                                                                       itemType:item.type
                                                                                      ancestors:item.pathFolders];
            }

            if ([self.cacheClient respondsToSelector:@selector(cacheFolderPaginatedItemsRequest:withItems:totalCount:limit:offset:error:)]) {
                [self.cacheClient cacheFolderPaginatedItemsRequest:self
                                                         withItems:items
                                                        totalCount:totalCount
                                                             limit:limit
                                                            offset:offset
                                                             error:nil];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(items, totalCount, NSMakeRange(offset, limit), nil);
            } onMainThread:isMainThread];
        };
        folderOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

            if ([self.cacheClient respondsToSelector:@selector(cacheFolderPaginatedItemsRequest:withItems:totalCount:limit:offset:error:)]) {
                [self.cacheClient cacheFolderPaginatedItemsRequest:self
                                                         withItems:nil
                                                        totalCount:0
                                                             limit:0
                                                            offset:0
                                                             error:error];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, 0, NSMakeRange(0, 0), error);

            } onMainThread:isMainThread];
        };
        [self performRequest];
    }
    
}

- (void)performRequestWithCached:(BOXItemArrayCompletionBlock)cacheBlock refreshed:(BOXItemArrayCompletionBlock)refreshBlock
{
    if (cacheBlock) {
        if ([self.cacheClient respondsToSelector:@selector(retrieveCacheForPaginatedItemsRequest:completion:)]) {
            [self.cacheClient retrieveCacheForPaginatedItemsRequest:self completion:cacheBlock];
        } else {
            cacheBlock(nil, 0, NSMakeRange(0, 0), nil);
        }
    }

    [self performRequestWithCompletion:refreshBlock];
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
