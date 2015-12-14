//
//  BOXCollectionListRequest.m
//  BoxContentSDK
//

#import "BOXCollectionListRequest.h"

#import "BOXCollection.h"

@implementation BOXCollectionListRequest

- (BOXAPIOperation *)createOperation
{
    BOXAPIJSONOperation *operation = nil;
    
    NSURL *url = [self URLWithResource:BOXAPIResourceCollections
                                    ID:nil
                           subresource:nil
                                 subID:nil];
    
    operation = [self JSONOperationWithURL:url 
                                HTTPMethod:BOXAPIHTTPMethodGET
                     queryStringParameters:nil 
                            bodyDictionary:nil 
                          JSONSuccessBlock:nil 
                              failureBlock:nil];
    
    return operation;
}

- (void)performRequestWithCompletion:(BOXCollectionArrayBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *collectionListOperation = (BOXAPIJSONOperation *)self.operation;

        collectionListOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            NSArray *collectionsJSON = JSONDictionary[BOXAPICollectionKeyEntries];
            NSMutableArray *collections = [NSMutableArray arrayWithCapacity:collectionsJSON.count];

            for (NSDictionary *dict in collectionsJSON) {
                [collections addObject:[[BOXCollection alloc] initWithJSON:dict]];
            }

            if ([self.cacheClient respondsToSelector:@selector(cacheCollectionListRequest:withCollections:error:)]) {
                [self.cacheClient cacheCollectionListRequest:self
                                             withCollections:collections
                                                       error:nil];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(collections, nil);
            } onMainThread:isMainThread];
        };
        collectionListOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

            if ([self.cacheClient respondsToSelector:@selector(cacheCollectionListRequest:withCollections:error:)]) {
                [self.cacheClient cacheCollectionListRequest:self
                                             withCollections:nil
                                                       error:error];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil,error);
            } onMainThread:isMainThread];
        };
        [self performRequest];
    }
}

- (void)performRequestWithCached:(BOXCollectionArrayBlock)cacheBlock
                       refreshed:(BOXCollectionArrayBlock)refreshBlock
{
    if (cacheBlock) {
        if ([self.cacheClient respondsToSelector:@selector(retrieveCacheForCollectionListRequest:completion:)]) {
            [self.cacheClient retrieveCacheForCollectionListRequest:self completion:cacheBlock];
        } else {
            cacheBlock(nil, nil);
        }
    }

    [self performRequestWithCompletion:refreshBlock];
}

@end
