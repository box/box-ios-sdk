//
//  BOXTrashedItemArrayRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXTrashedItemArrayRequest.h"

#import "BOXAPIJSONOperation.h"

@interface BOXTrashedItemArrayRequest ()

@property (nonatomic, readwrite, assign) NSUInteger limit;
@property (nonatomic, readwrite, assign) NSUInteger offset;

@end

@implementation BOXTrashedItemArrayRequest

- (instancetype)initWithRange:(NSRange)range
{
    if (self = [super init]) {
        _limit = range.length;
        _offset = range.location;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFolders
                                    ID:nil
                           subresource:BOXAPISubresourceTrash
                                 subID:BOXAPISubresourceItems];
    
    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionary];
    
    if (self.requestAllItemFields) {
        queryParameters[BOXAPIParameterKeyFields] = [self fullItemFieldsParameterString];
    }
    
    if (self.limit != 0) {
        queryParameters[BOXAPIParameterKeyLimit] = [NSString stringWithFormat:@"%lu", (unsigned long)self.limit];
    }
    
    if (self.offset != 0) {
        queryParameters[BOXAPIParameterKeyOffset] = [NSString stringWithFormat:@"%lu", (unsigned long)self.offset];
    }
    
    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    
    return JSONoperation;
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
            NSUInteger capacity = [itemDictionaries count];
            NSMutableArray *items = [NSMutableArray arrayWithCapacity:capacity];

            for (NSDictionary *itemDictionary in itemDictionaries) {
                [items addObject:[BOXRequest itemWithJSON:itemDictionary]];
            }
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(items, totalCount, NSMakeRange(offset, limit), nil);
            } onMainThread:isMainThread];
        };
        folderOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, 0, NSMakeRange(0, 0), error);
            } onMainThread:isMainThread];
        };
        [self performRequest];
    }
}

@end
