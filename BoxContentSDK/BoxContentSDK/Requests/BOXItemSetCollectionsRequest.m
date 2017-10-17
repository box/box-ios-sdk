//
//  BOXCollectionItemOperationRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXItemSetCollectionsRequest.h"

#import "BOXCollection.h"
#import "BOXFile.h"
#import "BOXFolder.h"
#import "BOXBookmark.h"
#import "BOXDispatchHelper.h"

@interface BOXItemSetCollectionsRequest()

@property (nonatomic, readwrite, strong) NSString *itemID;
@property (nonatomic, readwrite, strong) NSArray *collectionIDs;
@property (nonatomic, readwrite, strong) NSString *resource;

/// Properties related to Background tasks

/**
 Check if the request can executre on background. Requires valid associateId and requestDirectoryPath
 
 @return BOOL Yes for can preform on background
 */
- (BOOL)shouldPerformBackgroundOperation;

/**
 Caller provided unique ID to execute the request as a NSURLSession background task
 */
@property (nonatomic, readwrite, copy) NSString *associateId;

@end

@implementation BOXItemSetCollectionsRequest

- (instancetype)initWithItemID:(NSString *)itemID
                 collectionIDs:(NSArray *)collectionIDs
                      resource:(NSString *)resource
{
    return [self initWithItemID:itemID
                       resource:BOXAPIResourceFiles
                  collectionIDs:collectionIDs
                    associateId:nil];
}

- (instancetype)initWithItemID:(NSString *)itemID
                      resource:(NSString *)resource
                 collectionIDs:(NSArray *)collectionIDs
                   associateId:(NSString *)associateId
{
    if (self = [super init]) {
        _itemID = itemID;
        _resource = resource;
        _collectionIDs = collectionIDs;
        _associateId = associateId;
    }
    return self;
}

- (instancetype)initFileSetCollectionsRequestForFileWithID:(NSString *)fileID
                                             collectionIDs:(NSArray *)collectionIDs
{
    return [self initFileSetCollectionsRequestForFileWithID:fileID
                                              collectionIDs:collectionIDs
                                                associateId:nil];
}

- (instancetype)initFileSetCollectionsRequestForFileWithID:(NSString *)fileID
                                             collectionIDs:(NSArray *)collectionIDs
                                               associateId:(NSString *)associateId
{
    return [self initWithItemID:fileID
                       resource:BOXAPIResourceFiles
                  collectionIDs:collectionIDs
                    associateId:associateId];
}

- (instancetype)initFolderSetCollectionsRequestForFolderWithID:(NSString *)folderID
                                                 collectionIDs:(NSArray *)collectionIDs
{
    return [self initFolderSetCollectionsRequestForFolderWithID:folderID
                                              collectionIDs:collectionIDs
                                                associateId:nil];
}

- (instancetype)initFolderSetCollectionsRequestForFolderWithID:(NSString *)folderID
                                                 collectionIDs:(NSArray *)collectionIDs
                                                   associateId:(NSString *)associateId
{
    return [self initWithItemID:folderID
                       resource:BOXAPIResourceFolders
                  collectionIDs:collectionIDs
                    associateId:associateId];
}

- (instancetype)initBookmarkSetCollectionsRequestForBookmarkWithID:(NSString *)bookmarkID
                                                     collectionIDs:(NSArray *)collectionIDs
{
    return [self initBookmarkSetCollectionsRequestForBookmarkWithID:bookmarkID
                                                  collectionIDs:collectionIDs
                                                    associateId:nil];
}

- (instancetype)initBookmarkSetCollectionsRequestForBookmarkWithID:(NSString *)bookmarkID
                                                     collectionIDs:(NSArray *)collectionIDs
                                                       associateId:(NSString *)associateId
{
    return [self initWithItemID:bookmarkID
                       resource:BOXAPIResourceBookmarks
                  collectionIDs:collectionIDs
                    associateId:associateId];
}

- (BOXAPIOperation *)createOperation
{
    NSURL *url = [self URLWithResource:self.resource
                                    ID:self.itemID
                           subresource:nil
                                 subID:nil];
    
    NSDictionary *queryParameters = nil;
    if (self.requestAllItemFields) {
        queryParameters = @{BOXAPIParameterKeyFields :[self fullItemFieldsParameterString]};
    }
    
    NSMutableArray *bodyContent = [NSMutableArray array];
    
    for (id collectionAttributes in self.collectionIDs) {
        if ([collectionAttributes isKindOfClass:[NSString class]]) {
            [bodyContent addObject:@{BOXAPIObjectKeyID : collectionAttributes}];
        } else if ([collectionAttributes isKindOfClass:[NSDictionary class]]) {
            if ((collectionAttributes[BOXAPIObjectKeyID] != nil) && (collectionAttributes[BOXAPIObjectKeyRank] != nil)) {
                [bodyContent addObject:@{BOXAPIObjectKeyID : collectionAttributes[BOXAPIObjectKeyID], BOXAPIObjectKeyRank : collectionAttributes[BOXAPIObjectKeyRank]}];
            } else if (collectionAttributes[BOXAPIObjectKeyID] != nil) {
                [bodyContent addObject:@{BOXAPIObjectKeyID : collectionAttributes[BOXAPIObjectKeyID]}];
            }
        }
    }
    NSDictionary *bodyDictionary = @{BOXAPIObjectKeyCollections : bodyContent};
    
    if ([self shouldPerformBackgroundOperation] == YES) {
        
        BOXAPIDataOperation *dataOperation = [self dataOperationWithURL:url
                                                             HTTPMethod:BOXAPIHTTPMethodPUT
                                                  queryStringParameters:queryParameters
                                                         bodyDictionary:bodyDictionary
                                                           successBlock:nil
                                                           failureBlock:nil
                                                            associateId:self.associateId];
        
        NSString *requestDirectory = self.requestDirectoryPath;
        NSString *destinationPath = [requestDirectory stringByAppendingPathComponent:self.associateId];
        dataOperation.destinationPath = destinationPath;

        return dataOperation;
    } else {
        BOXAPIJSONOperation *operation = [self JSONOperationWithURL:url
                                                         HTTPMethod:BOXAPIHTTPMethodPUT
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:bodyDictionary
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
        
        return operation;
    }
}

- (void)performRequestWithCompletion:(BOXItemBlock)completionBlock
{
    if ([self shouldPerformBackgroundOperation] == YES) {
        BOOL isMainThread = [NSThread isMainThread];
        
        BOXAPIDataOperation *fileOperation = (BOXAPIDataOperation *)self.operation;
        
        __weak BOXAPIDataOperation *weakFileOperation = fileOperation;
        
        fileOperation.successBlock = ^(NSString *modelID, long long expectedTotalBytes) {
            NSData *data = [NSData dataWithContentsOfFile:weakFileOperation.destinationPath];
            BOXItem *item = nil;
            if (data != nil) {
                NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                item = [[self class] itemWithJSON:jsonDictionary];
                
                if ([self.cacheClient respondsToSelector:@selector(cacheItemSetCollectionsRequest:withUpdatedItem:error:)]) {
                    [self.cacheClient cacheItemSetCollectionsRequest:self
                                                     withUpdatedItem:item
                                                               error:nil];
                }
            }
            
            if ([[NSFileManager defaultManager] fileExistsAtPath: weakFileOperation.destinationPath]) {
                NSError *error = nil;
                [[NSFileManager defaultManager] removeItemAtPath:weakFileOperation.destinationPath error:&error];
            }
            
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(item, nil);
                } onMainThread:isMainThread];
            }
        };
        
        fileOperation.failureBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
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
    } else {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *collectionAddItemOperation = (BOXAPIJSONOperation *)self.operation;
        
        collectionAddItemOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            
            BOXItem *item = [[self class] itemWithJSON:JSONDictionary];
            
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
}

#pragma mark - Private Helper methods

- (BOOL)shouldPerformBackgroundOperation
{
    return (self.associateId.length > 0 && self.requestDirectoryPath.length > 0);
}

@end
