//
//  BOXCollectionItemsRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXCollectionItemsRequest.h"
#import "BOXAPIJSONOperation.h"

@interface BOXCollectionItemsRequest ()

@property (nonatomic, readwrite, strong) NSString *collectionID;
@property (nonatomic, readwrite, assign) NSRange range;

@end

@implementation BOXCollectionItemsRequest

- (instancetype)initWithCollectionID:(NSString *)collectionID inRange:(NSRange)range
{
    if (self = [super init]) {
        _collectionID = collectionID;
        _range = range;
    }
    return self;
}

- (BOXAPIOperation *)createOperation
{
    BOXAPIJSONOperation *operation = nil;
    
    NSURL *url = [self URLWithResource:BOXAPIResourceCollections 
                                    ID:self.collectionID 
                           subresource:BOXAPISubresourceItems 
                                 subID:nil];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (self.requestAllItemFields) {
        parameters[BOXAPIParameterKeyFields] = [self fullItemFieldsParameterString];
    }
        
    if (self.range.length > 0) {
        parameters[BOXAPIParameterKeyLimit] = @(self.range.length);
    }
    
    if (self.range.location > 0) {
        parameters[BOXAPIParameterKeyOffset] = @(self.range.location);
    }
    
    operation = [self JSONOperationWithURL:url 
                                HTTPMethod:BOXAPIHTTPMethodGET 
                     queryStringParameters:parameters 
                            bodyDictionary:nil 
                          JSONSuccessBlock:nil 
                              failureBlock:nil];
    
    return operation;
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

            for (NSDictionary *itemDictionary in itemDictionaries) {
                [items addObject:[BOXRequest itemWithJSON:itemDictionary]];
            }

            if ([self.cacheClient respondsToSelector:@selector(cacheCollectionItemsRequest:withItems:error:)]) {
                [self.cacheClient cacheCollectionItemsRequest:self
                                                    withItems:items
                                                        error:nil];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(items, totalCount, NSMakeRange(offset, limit), nil);
            } onMainThread:isMainThread];
        };
        folderOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

            if ([self.cacheClient respondsToSelector:@selector(cacheCollectionItemsRequest:withItems:error:)]) {
                [self.cacheClient cacheCollectionItemsRequest:self
                                                    withItems:nil
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
        if ([self.cacheClient respondsToSelector:@selector(retrieveCacheForCollectionItemsRequest:completion:)]) {
            [self.cacheClient retrieveCacheForCollectionItemsRequest:self completion:cacheBlock];
        } else {
            cacheBlock(nil, 0, NSMakeRange(0,0), nil);
        }
    }

    [self performRequestWithCompletion:refreshBlock];
}

@end
