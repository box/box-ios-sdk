//
//  BOXCollectionItemOperationRequest.m
//  BoxContentSDK
//

#import "BOXItemSetCollectionsRequest.h"

#import "BOXCollection.h"
#import "BOXFile.h"
#import "BOXFolder.h"
#import "BOXBookmark.h"

@interface BOXItemSetCollectionsRequest()

@property (nonatomic, readwrite, strong) NSString *itemID;
@property (nonatomic, readwrite, strong) NSArray *collectionIDs;
@property (nonatomic, readwrite, strong) NSString *resource;

@end

@implementation BOXItemSetCollectionsRequest

- (instancetype)initWithItemID:(NSString *)itemID
                 collectionIDs:(NSArray *)collectionIDs
                      resource:(NSString *)resource
{
    if (self = [super init]) {
        _itemID = itemID;
        _collectionIDs = collectionIDs;
        _resource = resource;
    }
    return self;
}

- (instancetype)initFileSetCollectionsRequestForFileWithID:(NSString *)fileID
                                             collectionIDs:(NSArray *)collectionIDs
{
    return [self initWithItemID:fileID
                  collectionIDs:collectionIDs
                       resource:BOXAPIResourceFiles];
}

- (instancetype)initFolderSetCollectionsRequestForFolderWithID:(NSString *)folderID
                                                 collectionIDs:(NSArray *)collectionIDs
{
    return [self initWithItemID:folderID
                  collectionIDs:collectionIDs
                       resource:BOXAPIResourceFolders];
}

- (instancetype)initBookmarkSetCollectionsRequestForBookmarkWithID:(NSString *)bookmarkID
                                                     collectionIDs:(NSArray *)collectionIDs
{
        return [self initWithItemID:bookmarkID
                      collectionIDs:collectionIDs
                           resource:BOXAPIResourceBookmarks];
}

-(BOXAPIOperation *)createOperation
{
    BOXAPIJSONOperation *operation = nil;
    
    NSURL *url = [self URLWithResource:self.resource 
                                    ID:self.itemID
                           subresource:nil
                                 subID:nil];
    
    NSMutableArray *bodyContent = [NSMutableArray array];
    
    for (NSString *collectionID in self.collectionIDs) {
        [bodyContent addObject:@{BOXAPIObjectKeyID : collectionID}];
    }
        
    NSDictionary *bodyDictionary = @{BOXAPIObjectKeyCollections : bodyContent};
    
    operation = [self JSONOperationWithURL:url 
                                HTTPMethod:BOXAPIHTTPMethodPUT
                     queryStringParameters:nil
                            bodyDictionary:bodyDictionary
                          JSONSuccessBlock:nil
                              failureBlock:nil];
    
    return operation;
}

- (void)performRequestWithCompletion:(BOXItemBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *collectionAddItemOperation = (BOXAPIJSONOperation *)self.operation;
    
    collectionAddItemOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {

            BOXItem *item = [self itemWithJSON:JSONDictionary];

            if ([self.cacheClient respondsToSelector:@selector(cacheItemSetCollectionsRequest:withUpdatedItem:error:)]) {
                [self.cacheClient cacheItemSetCollectionsRequest:self
                                                 withUpdatedItem:item
                                                           error:nil];
            }
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(item, nil);
                } onMainThread:isMainThread];
            }
    };
    collectionAddItemOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

            if ([self.cacheClient respondsToSelector:@selector(cacheItemSetCollectionsRequest:withUpdatedItem:error:)]) {
                [self.cacheClient cacheItemSetCollectionsRequest:self
                                                 withUpdatedItem:nil
                                                           error:error];
            }
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(nil, error);
                } onMainThread:isMainThread];
            }
    };
    [self performRequest];
}

- (BOXItem *)itemWithJSON:(NSDictionary *)JSONDictionary
{
    BOXItem *item = nil;
    
    NSString *itemType = [JSONDictionary objectForKey:BOXAPIObjectKeyType];

    if ([itemType isEqualToString:BOXAPIItemTypeFile]) {
        item = [[BOXFile alloc] initWithJSON:JSONDictionary];
    } else if ([itemType isEqualToString:BOXAPIItemTypeFolder]) {
        item = [[BOXFolder alloc] initWithJSON:JSONDictionary];
    } else if ([itemType isEqualToString:BOXAPIItemTypeWebLink]) {
        item = [[BOXBookmark alloc] initWithJSON:JSONDictionary];
    } else {
        item = [[BOXItem alloc] initWithJSON:JSONDictionary];
    }
    
    return item;
}

@end
