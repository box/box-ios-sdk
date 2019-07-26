//
//  BOXRecentItemsRequest.m
//  Pods
//
//  Created by Andrew Dempsey on 12/19/16.
//
//

#import "BOXRequest_Private.h"
#import "BOXRecentItemsRequest.h"
#import "BOXRecentItem.h"
#import "BOXAPIOperation.h"
#import "BOXDispatchHelper.h"

@implementation BOXRecentItemsRequest

- (instancetype)init
{
    if (self = [super init]) {
        _limit = -1;
    }

    return self;
}

- (BOXAPIOperation *)createOperation
{
    BOXAPIOperation *operation = nil;

    NSURL *url = [self URLWithResource:BOXAPIResourceRecentItems
                                    ID:nil
                           subresource:nil
                                 subID:nil];

    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionary];

    NSString *fieldString = nil;
    
    if (self.requestAllItemFields) {
        fieldString = [self fullItemFieldsParameterStringExcludingFields:self.fieldsToExclude];
    }
    
    if (self.metadataTemplateKey && self.metadataScope) {
        NSString *metadata = [NSString stringWithFormat:@",%@.%@.%@",BOXAPISubresourceMetadata,self.metadataScope,self.metadataTemplateKey];
        fieldString = [fieldString stringByAppendingString:metadata];
    }
    
    queryParameters[BOXAPIParameterKeyFields] = fieldString;
    
    if (self.limit >= 0) {
        queryParameters[BOXAPIParameterKeyLimit] = @(self.limit);
    }

    if (self.nextMarker != nil) {
        queryParameters[BOXAPIParameterKeyNextMarker] = self.nextMarker;
    }

    if (self.listType != nil) {
        queryParameters[BOXAPIParameterKeyListType] = self.listType;
    }

    operation = [self JSONOperationWithURL:url
                                HTTPMethod:BOXAPIHTTPMethodGET
                     queryStringParameters:queryParameters
                            bodyDictionary:nil
                          JSONSuccessBlock:nil
                              failureBlock:nil];

    return operation;
}

- (void)performRequestWithCompletion:(BOXRecentItemsBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *requestOperation = (BOXAPIJSONOperation *)self.operation;

        requestOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            NSArray *recentsJSON = JSONDictionary[BOXAPICollectionKeyEntries];
            NSMutableArray<BOXRecentItem *> *mutableRecentItems = [NSMutableArray arrayWithCapacity:recentsJSON.count];

            BOXSharedLinkHeadersHelper *sharedLinkHelper = [[BOXContentClient defaultClient] sharedLinksHeaderHelper];
            for (id itemJSON in recentsJSON) {
                if ([itemJSON isKindOfClass:[NSDictionary class]]) {
                    BOXRecentItem *recentItem = [[BOXRecentItem alloc] initWithJSON:itemJSON];
                    [mutableRecentItems addObject:recentItem];

                    // Recent items could have been accessed on another end-point with a shared link.
                    // In that case, we need to update the shared link header helper with this information.
                    if (recentItem.sharedLinkURL != nil) {
                        //FIXME: (adempsey, 2/28/17): currently does not support passwords. Items with
                        // password-protected shared links are not currently returned by the recents API.
                        [sharedLinkHelper storeHeadersForItemWithID:recentItem.item.modelID
                                                           itemType:recentItem.item.type
                                                         sharedLink:recentItem.sharedLinkURL.absoluteString
                                                           password:nil];
                    }
                }
            }

            NSArray<BOXRecentItem *> *recentItems = [mutableRecentItems copy];

            if ([self.cacheClient respondsToSelector:@selector(cacheRecentItemsRequest:withRecentItems:error:)]) {
                [self.cacheClient cacheRecentItemsRequest:self
                                          withRecentItems:recentItems
                                                    error:nil];
            }

            NSString *nextMarker = JSONDictionary[BOXAPIParameterKeyNextMarker];

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(recentItems, nextMarker, nil);
            } onMainThread:isMainThread];
        };

        requestOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

            if ([self.cacheClient respondsToSelector:@selector(cacheRecentItemsRequest:withRecentItems:error:)]) {
                [self.cacheClient cacheRecentItemsRequest:self
                                          withRecentItems:nil
                                                    error:error];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, nil, error);
            } onMainThread:isMainThread];
        };
        [self performRequest];
    }
}

- (void)performRequestWithCached:(BOXRecentItemsBlock)cacheBlock refreshed:(BOXRecentItemsBlock)refreshBlock
{
    if (cacheBlock) {
        if ([self.cacheClient respondsToSelector:@selector(retrieveCacheForRecentItemsRequest:completionBlock:)]) {
            [self.cacheClient retrieveCacheForRecentItemsRequest:self completionBlock:cacheBlock];
        } else {
            cacheBlock(nil, nil, nil);
        }
    }

    [self performRequestWithCompletion:refreshBlock];
}

@end
