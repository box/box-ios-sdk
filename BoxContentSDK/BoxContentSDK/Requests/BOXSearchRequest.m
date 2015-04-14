//
//  BOXSearchRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXSearchRequest.h"
#import "BOXAPIJSONOperation.h"

@interface BOXSearchRequest ()

@property (nonatomic, readwrite, strong) NSString *query;
@property (nonatomic, readwrite, assign) NSUInteger limit;
@property (nonatomic, readwrite, assign) NSUInteger offset;

@end

@implementation BOXSearchRequest

- (instancetype)initWithSearchQuery:(NSString *)query inRange:(NSRange)range
{
    if (self = [super init]) {
        _query = query;
        _limit = range.length;
        _offset = range.location;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceSearch
                                    ID:nil
                           subresource:nil
                                 subID:nil];
    
    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionary];
    queryParameters[BOXAPIParameterKeyQuery] = self.query;

    if (self.fileExtensions) {
        queryParameters[BOXAPIParameterKeyFileExtensions] = [self.fileExtensions componentsJoinedByString:@","];
    }

    // If both to and from values are not set, the API allows trailing commas (e.g. "value," or ",value")
    if (self.createdAtFromDate || self.createdAtToDate) {
        NSString *fromDate = [self.createdAtFromDate box_ISO8601String];
        NSString *toDate = [self.createdAtToDate box_ISO8601String];
        queryParameters[BOXAPIParameterKeyCreatedAtRange] =
            [NSString stringWithFormat:@"%@,%@", fromDate.length > 0 ? fromDate : @"", toDate.length > 0 ? toDate : @""];
    }

    if (self.updatedAtFromDate || self.updatedAtToDate) {
        NSString *fromDate = [self.updatedAtFromDate box_ISO8601String];
        NSString *toDate = [self.updatedAtToDate box_ISO8601String];
        queryParameters[BOXAPIParameterKeyUpdatedAtRange] =
            [NSString stringWithFormat:@"%@,%@", fromDate.length > 0 ? fromDate : @"", toDate.length > 0 ? toDate : @""];
    }

    if (self.sizeLowerBound != 0 || self.sizeUpperBound != 0) {
        NSString *lowerBound =
            self.sizeLowerBound != 0 ? [NSString stringWithFormat:@"%lu", (unsigned long)self.sizeLowerBound] : @"";

        NSString *upperBound =
            self.sizeUpperBound != 0 ? [NSString stringWithFormat:@"%lu", (unsigned long)self.sizeUpperBound] : @"";

        queryParameters[BOXAPIParameterKeySizeRange] = [NSString stringWithFormat:@"%@,%@", lowerBound, upperBound];
    }

    if (self.ownerUserIDs.count > 0) {
        queryParameters[BOXAPIParameterKeyOwnerUserIDs] = [self.ownerUserIDs componentsJoinedByString:@","];
    }

    if (self.ancestorFolderIDs.count > 0) {
        queryParameters[BOXAPIParameterKeyAncestorFolderIDs] = [self.ancestorFolderIDs componentsJoinedByString:@","];
    }

    if (self.contentTypes.count > 0) {
        queryParameters[BOXAPIParameterKeyContentTypes] = [self.contentTypes componentsJoinedByString:@","];
    }

    if (self.type.length > 0) {
        queryParameters[BOXAPIParameterKeyType] = self.type;
    }
    queryParameters[BOXAPIParameterKeyOffset] = [NSString stringWithFormat:@"%lu", (unsigned long)self.offset];
    queryParameters[BOXAPIParameterKeyLimit] = [NSString stringWithFormat:@"%lu", (unsigned long)self.limit];
    
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
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *folderOperation = (BOXAPIJSONOperation *)self.operation;

    if (completionBlock) {
        folderOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            NSUInteger totalCount = [JSONDictionary[BOXAPICollectionKeyTotalCount] unsignedIntegerValue];
            NSUInteger offset = [JSONDictionary[BOXAPIParameterKeyOffset] unsignedIntegerValue];
            NSUInteger limit = [JSONDictionary[BOXAPIParameterKeyLimit] unsignedIntegerValue];
            NSArray *itemDictionaries = JSONDictionary[BOXAPICollectionKeyEntries];
            NSUInteger capacity = [itemDictionaries count];
            NSMutableArray *items = [NSMutableArray arrayWithCapacity:capacity];

            for (NSDictionary *itemDictionary in itemDictionaries) {
                [items addObject:[self itemWithJSON:itemDictionary]];
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
    }
    
    [self performRequest];
}

@end
