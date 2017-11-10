//
//  BOXFolderDeleteRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFolderDeleteRequest.h"
#import "BOXAPIJSONOperation.h"
#import "BOXDispatchHelper.h"

@interface BOXFolderDeleteRequest ()
@property (nonatomic, readwrite, assign) BOOL isTrashed;

/// Properties related to Background tasks

/**
 Check if the request can executre on background. Requires valid associateId and requestDirectoryPath
 
 @return BOOL Yes for can preform on background
 */
- (BOOL)shouldPerformBackgroundOperation;

@end

@implementation BOXFolderDeleteRequest

- (instancetype)initWithFolderID:(NSString *)folderID
{
    return [self initWithFolderID:folderID isTrashed:NO];
}

- (instancetype)initWithFolderID:(NSString *)folderID isTrashed:(BOOL)isTrashed
{
    return [self initWithFolderID:folderID isTrashed:isTrashed associateId:nil];
}

- (instancetype)initWithFolderID:(NSString *)folderID
                       isTrashed:(BOOL)isTrashed
                     associateId:(NSString *)associateId
{
    self = [super init];
    if (self != nil) {
        _folderID = folderID;
        _recursive = YES;
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
    
    NSURL *url = [self URLWithResource:BOXAPIResourceFolders
                                    ID:self.folderID
                           subresource:subresource
                                 subID:nil];

    NSDictionary *queryParameters = nil;

    if (self.recursive) {
        queryParameters = @{BOXAPIParameterKeyRecursive : @"true"};
    }

    if ([self shouldPerformBackgroundOperation] == YES) {
        BOXAPIDataOperation *dataOperation = [self dataOperationWithURL:url
                                                             HTTPMethod:BOXAPIHTTPMethodDELETE
                                                  queryStringParameters:queryParameters
                                                         bodyDictionary:nil
                                                           successBlock:nil
                                                           failureBlock:nil
                                                            associateId:self.associateId];
        
        NSString *requestDirectory = self.requestDirectoryPath;
        NSString *destinationPath = [requestDirectory stringByAppendingPathComponent:self.associateId];
        dataOperation.destinationPath = destinationPath;
        
        if ([self.matchingEtag length] > 0) {
            [dataOperation.APIRequest setValue:self.matchingEtag forHTTPHeaderField:BOXAPIHTTPHeaderIfMatch];
        }
        
        return dataOperation;
    } else {
        BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:url
                                                             HTTPMethod:BOXAPIHTTPMethodDELETE
                                                  queryStringParameters:queryParameters
                                                         bodyDictionary:nil
                                                       JSONSuccessBlock:nil
                                                           failureBlock:nil];
        
        if ([self.matchingEtag length] > 0) {
            [JSONoperation.APIRequest setValue:self.matchingEtag forHTTPHeaderField:BOXAPIHTTPHeaderIfMatch];
        }
        
        return JSONoperation;
    }
}

- (void)performRequestWithCompletion:(BOXErrorBlock)completionBlock
{
    if ([self shouldPerformBackgroundOperation] == YES) {
        BOOL isMainThread = [NSThread isMainThread];
        
        BOXAPIDataOperation *folderOperation = (BOXAPIDataOperation *)self.operation;
        __weak BOXAPIDataOperation *weakFolderOperation = folderOperation;
        
        folderOperation.successBlock = ^(NSString *modelID, long long expectedTotalBytes) {
            
            if (self.isTrashed) {
                if ([self.cacheClient respondsToSelector:@selector(cacheTrashedFolderDeleteRequest:error:)]) {
                    [self.cacheClient cacheTrashedFolderDeleteRequest:self error:nil];
                }
            } else {
                if ([self.cacheClient respondsToSelector:@selector(cacheFolderDeleteRequest:error:)]) {
                    [self.cacheClient cacheFolderDeleteRequest:self error:nil];
                }
            }

            if ([[NSFileManager defaultManager] fileExistsAtPath: weakFolderOperation.destinationPath]) {
                NSError *error = nil;
                [[NSFileManager defaultManager] removeItemAtPath:weakFolderOperation.destinationPath error:&error];
            }
            
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(nil);
                } onMainThread:isMainThread];
            }
        };
        
        folderOperation.failureBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            if ([self.cacheClient respondsToSelector:@selector(cacheFolderDeleteRequest:error:)]) {
                [self.cacheClient cacheFolderDeleteRequest:self error:error];
            }
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(error);
                } onMainThread:isMainThread];
            }
        };
        
        [self performRequest];
    } else {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *folderOperation = (BOXAPIJSONOperation *)self.operation;
        
        folderOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            
            if ([self.cacheClient respondsToSelector:@selector(cacheFolderDeleteRequest:error:)]) {
                [self.cacheClient cacheFolderDeleteRequest:self error:nil];
            }
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(nil);
                } onMainThread:isMainThread];
            }
        };
        folderOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            
            if ([self.cacheClient respondsToSelector:@selector(cacheFolderDeleteRequest:error:)]) {
                [self.cacheClient cacheFolderDeleteRequest:self error:error];
            }
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(error);
                } onMainThread:isMainThread];
            }
        };
        [self performRequest];
    }
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
