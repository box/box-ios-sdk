//
//  BOXSearchRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXSearchRequest.h"
#import "BOXAPIJSONOperation.h"
#import "BOXMetadataKeyValue.h"

@interface BOXSearchRequest ()

@property (nonatomic, readwrite, strong) NSString *query;
@property (nonatomic, readwrite, assign) NSUInteger limit;
@property (nonatomic, readwrite, assign) NSUInteger offset;

// Advanced Metadata Search parameters
@property (nonatomic, readwrite, strong) NSString *templateKey;
@property (nonatomic, readwrite, strong) NSString *scope;
@property (nonatomic, readwrite, strong) NSArray *filters;

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

- (instancetype)initWithTemplateKey:(NSString *)templateKey scope:(NSString *)scope filters:(NSArray *)filters inRange:(NSRange)range
{
    BOXAssert(templateKey, @"TemplateKey must be non-nil for BOXSearchRequest");
    BOXAssert(scope, @"Scope must be non-nil for BOXSearchRequest");
    BOXAssert(&range, @"Range must be non-nil for BOXSearchRequest");
    
    if (self = [self initWithSearchQuery:nil inRange:range]) {
        self.templateKey = templateKey;
        self.scope = scope;
        self.filters = filters ? filters : @[];
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    BOOL isMetadataSearch = self.templateKey && self.scope && self.filters;
    NSURL *URL = [self URLWithResource:BOXAPIResourceSearch
                                    ID:nil
                           subresource:nil
                                 subID:nil];
    
    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionary];
    NSString *queryKey = nil;
    if (isMetadataSearch) {
        self.query = [self generateMetadataQuery];
        queryKey = BOXAPIParameterKeyMDFilter;
    } else {
        queryKey = BOXAPIParameterKeyQuery;
    }
    queryParameters[queryKey] = self.query;

    if (self.requestAllItemFields) {
        queryParameters[BOXAPIParameterKeyFields] = [self fullItemFieldsParameterString];
    }
    
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
    
    BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    
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

- (NSString *)generateMetadataQuery
{
    NSString *queryFormat = @"[{\"%@\":\"%@\", \"%@\":\"%@\", \"%@\":{%@}}]";
    NSString *result = [NSString stringWithFormat:queryFormat, BOXAPIParameterKeyTemplate, self.templateKey, BOXAPIParameterKeyScope, self.scope, BOXAPIParameterKeyFilter, [self generateFilterString]];
    
    return result;
}

- (NSString *)generateFilterString
{
    NSString *filtersString = @"";
    
    for (BOXMetadataKeyValue *keyValue in self.filters) {
        filtersString = [filtersString stringByAppendingFormat:@"\"%@\":\"%@\", ", keyValue.path, keyValue.value];
        
        if (self.filters.lastObject == keyValue) {
            filtersString = [filtersString substringToIndex:filtersString.length - 2];
        }
    }
    
   return filtersString;
}

- (void)setFilters:(NSArray *)filters
{
    for (NSUInteger i = 0; i < filters.count; i++) {
        BOXAssert([filters[i] isKindOfClass:[BOXMetadataKeyValue class]], @"All objects in filters must be of type BOXMetadataKeyValue.");
    }
    
    _filters = filters;
}

@end
