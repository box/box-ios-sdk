//
//  BOXFolderRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFolderRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXFolder.h"
#import "BOXContentSDKConstants.h"
#import "BOXSharedLinkHeadersHelper.h"
#import "BOXDispatchHelper.h"

@interface BOXFolderRequest ()

@property (nonatomic, readwrite, strong) NSString *folderID;
@property (nonatomic, readwrite, assign) BOOL isTrashed;

/// Properties related to Background tasks

/**
 Check if the request can executre on background. Requires valid associateId and requestDirectoryPath
 
 @return BOOL Yes for can preform on background
 */
- (BOOL)shouldPerformBackgroundOperation;

@end

@implementation BOXFolderRequest

- (instancetype)initWithFolderID:(NSString *)folderID
{
    return [self initWithFolderID:folderID associateId:nil];
}

- (instancetype)initWithFolderID:(NSString *)folderID
                     associateId:(NSString *)associateId
{
    return [self initWithFolderID:folderID isTrashed:NO associateId: associateId];
}

- (instancetype)initWithFolderID:(NSString *)folderID isTrashed:(BOOL)isTrashed
{
    return [self initWithFolderID:folderID isTrashed:isTrashed associateId: nil];
}

- (instancetype)initWithFolderID:(NSString *)folderID
                       isTrashed:(BOOL)isTrashed
                     associateId:(NSString *)associateId
{
    if (self = [super init]) {
        _folderID = folderID;
        _isTrashed = isTrashed;
        _associateId = associateId;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSString *subresource = nil;

    if (self.isTrashed) {
        subresource = BOXAPISubresourceTrash;
    }

    NSURL *URL = [self URLWithResource:BOXAPIResourceFolders
                                    ID:self.folderID
                           subresource:subresource
                                 subID:nil];

    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionary];

    if (self.requestAllFolderFields) {
        queryParameters[BOXAPIParameterKeyFields] = [self fullFolderFieldsParameterString];
    }

    // We don't want to request the children through this request. We don't parse it, and it would be a waste
    // of bandwidth/processing time.
    queryParameters[@"limit"] = @"0";
    
    if ([self shouldPerformBackgroundOperation] == YES) {
        BOXAPIDataOperation *dataOperation = [self dataOperationWithURL:URL
                                                             HTTPMethod:BOXAPIHTTPMethodGET
                                                  queryStringParameters:queryParameters
                                                         bodyDictionary:nil
                                                           successBlock:nil
                                                           failureBlock:nil
                                                            associateId:self.associateId];
        
        NSString *requestDirectory = self.requestDirectoryPath;
        NSString *destinationPath = [requestDirectory stringByAppendingPathComponent:self.associateId];
        dataOperation.destinationPath = destinationPath;
        
        if ([self.notMatchingEtags count] > 0) {
            // Set up the If-None-Match header
            for (NSString *notMatchingEtag in self.notMatchingEtags) {
                [dataOperation.APIRequest addValue:notMatchingEtag
                                forHTTPHeaderField:BOXAPIHTTPHeaderIfNoneMatch];
            }
        }
        
        [self addSharedLinkHeaderToRequest:dataOperation.APIRequest];
        
        return dataOperation;
    } else {
        BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                             HTTPMethod:BOXAPIHTTPMethodGET
                                                  queryStringParameters:queryParameters
                                                         bodyDictionary:nil
                                                       JSONSuccessBlock:nil
                                                           failureBlock:nil];
        if ([self.notMatchingEtags count] > 0) {
            // Set up the If-None-Match header
            for (NSString *notMatchingEtag in self.notMatchingEtags) {
                [JSONoperation.APIRequest addValue:notMatchingEtag
                                forHTTPHeaderField:BOXAPIHTTPHeaderIfNoneMatch];
            }
        }
        
        [self addSharedLinkHeaderToRequest:JSONoperation.APIRequest];
        
        return JSONoperation;
    }
}

- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock
{
    if (completionBlock) {
        if ([self shouldPerformBackgroundOperation] == YES) {
            BOOL isMainThread = [NSThread isMainThread];
            
            BOXAPIDataOperation *folderOperation = (BOXAPIDataOperation *)self.operation;
            
            __weak BOXAPIDataOperation *weakFolderOperation = folderOperation;
            
            folderOperation.successBlock = ^(NSString *modelID, long long expectedTotalBytes) {
                NSData *data = [NSData dataWithContentsOfFile:weakFolderOperation.destinationPath];
                BOXFolder *folder = nil;
                if (data != nil) {
                    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    folder = (BOXFolder*)[[self class] itemWithJSON:jsonDictionary];
                    
                    [self.sharedLinkHeadersHelper storeHeadersFromAncestorsIfNecessaryForItemWithID:folder.modelID
                                                                                           itemType:folder.type
                                                                                          ancestors:folder.pathFolders];
                    
                    if ([self.cacheClient respondsToSelector:@selector(cacheFolderRequest:withFolder:error:)]) {
                        [self.cacheClient cacheFolderRequest:self
                                                  withFolder:folder
                                                       error:nil];
                    }
                }
                
                if ([[NSFileManager defaultManager] fileExistsAtPath: weakFolderOperation.destinationPath]) {
                    NSError *error = nil;
                    [[NSFileManager defaultManager] removeItemAtPath:weakFolderOperation.destinationPath error:&error];
                }
                
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(folder, nil);
                } onMainThread:isMainThread];
            };
            
            folderOperation.failureBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
                if ([self.cacheClient respondsToSelector:@selector(cacheFolderRequest:withFolder:error:)]) {
                    [self.cacheClient cacheFolderRequest:self
                                              withFolder:nil
                                                   error:error];
                }
                
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(nil, error);
                } onMainThread:isMainThread];
            };
            
            [self performRequest];
        } else {
            BOOL isMainThread = [NSThread isMainThread];
            BOXAPIJSONOperation *folderOperation = (BOXAPIJSONOperation *)self.operation;
            
            folderOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
                BOXFolder *folder = [[BOXFolder alloc] initWithJSON:JSONDictionary];
                
                [self.sharedLinkHeadersHelper storeHeadersFromAncestorsIfNecessaryForItemWithID:folder.modelID
                                                                                       itemType:folder.type
                                                                                      ancestors:folder.pathFolders];
                
                if ([self.cacheClient respondsToSelector:@selector(cacheFolderRequest:withFolder:error:)]) {
                    [self.cacheClient cacheFolderRequest:self
                                              withFolder:folder
                                                   error:nil];
                }
                
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(folder, nil);
                } onMainThread:isMainThread];
            };
            folderOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
                
                if ([self.cacheClient respondsToSelector:@selector(cacheFolderRequest:withFolder:error:)]) {
                    [self.cacheClient cacheFolderRequest:self
                                              withFolder:nil
                                                   error:error];
                }
                
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(nil, error);
                } onMainThread:isMainThread];
            };
            
            [self performRequest];
        }
    }
}

- (void)performRequestWithCached:(BOXFolderBlock)cacheBlock
                       refreshed:(BOXFolderBlock)refreshBlock
{
    if (cacheBlock) {
        if ([self.cacheClient respondsToSelector:@selector(retrieveCacheForFolderRequest:completion:)]) {
            [self.cacheClient retrieveCacheForFolderRequest:self completion:cacheBlock];
        } else {
            cacheBlock(nil, nil);
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

#pragma mark - Private Helper methods

- (BOOL)shouldPerformBackgroundOperation
{
    return (self.associateId.length > 0 && self.requestDirectoryPath.length > 0);
}

@end
