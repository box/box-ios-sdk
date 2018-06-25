//
//  BOXFileDeleteRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFileDeleteRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXDispatchHelper.h"

@interface BOXFileDeleteRequest ()

@property (nonatomic, readwrite, assign) BOOL isTrashed;

@property (nonatomic, readwrite, strong) NSString *fileID;

/// Properties related to Background tasks

/**
 Check if the request can executre on background. Requires valid associateId and requestDirectoryPath
 
 @return BOOL Yes for can preform on background
 */
- (BOOL)shouldPerformBackgroundOperation;

@end

@implementation BOXFileDeleteRequest

- (instancetype)initWithFileID:(NSString *)fileID
{
    return [self initWithFileID:fileID isTrashed:NO];
}

- (instancetype)initWithFileID:(NSString *)fileID isTrashed:(BOOL)isTrashed
{
    if (self = [super init]) {
        _fileID = fileID;
        _isTrashed = isTrashed;
    }

    return self;
}

- (instancetype)initWithFileID:(NSString *)fileID
                     isTrashed:(BOOL)isTrashed
                   associateId:(NSString *)associateId
{
    if (self = [super init]) {
        _fileID = fileID;
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
    
    NSURL *url = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:subresource
                                 subID:nil];
    
    if ([self shouldPerformBackgroundOperation] == YES) {
        BOXAPIDataOperation *dataOperation = [self dataOperationWithURL:url
                                                             HTTPMethod:BOXAPIHTTPMethodDELETE
                                                  queryStringParameters:nil
                                                         bodyDictionary:nil
                                                           successBlock:nil
                                                           failureBlock:nil
                                                            associateId:self.associateId];
        
        NSString *requestDirectory = self.requestDirectoryPath;
        NSString *destinationPath = [requestDirectory stringByAppendingPathComponent:self.associateId];
        dataOperation.destinationPath = destinationPath;
        
        return dataOperation;
    } else {
        BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:url
                                                             HTTPMethod:BOXAPIHTTPMethodDELETE
                                                  queryStringParameters:nil
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
        
        BOXAPIDataOperation *fileOperation = (BOXAPIDataOperation *)self.operation;
        __weak BOXAPIDataOperation *weakFileOperation = fileOperation;
        
        fileOperation.successBlock = ^(NSString *modelID, long long expectedTotalBytes) {
            if (self.isTrashed) {
                if ([self.cacheClient respondsToSelector:@selector(cacheTrashedFileDeleteRequest:error:)]) {
                    [self.cacheClient cacheTrashedFileDeleteRequest:self error:nil];
                }
            } else {
                if ([self.cacheClient respondsToSelector:@selector(cacheFileDeleteRequest:error:)]) {
                    [self.cacheClient cacheFileDeleteRequest:self error:nil];
                }
            }
            
            if ([[NSFileManager defaultManager] fileExistsAtPath: weakFileOperation.destinationPath]) {
                NSError *error = nil;
                [[NSFileManager defaultManager] removeItemAtPath:weakFileOperation.destinationPath error:&error];
            }
            
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(nil);
                } onMainThread:isMainThread];
            }
        };
        
        fileOperation.failureBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            if ([self.cacheClient respondsToSelector:@selector(cacheFileDeleteRequest:error:)]) {
                [self.cacheClient cacheFileDeleteRequest:self error:error];
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
            
            if ([self.cacheClient respondsToSelector:@selector(cacheFileDeleteRequest:error:)]) {
                [self.cacheClient cacheFileDeleteRequest:self error:nil];
            }
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(nil);
                } onMainThread:isMainThread];
            }
        };
        folderOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            
            if ([self.cacheClient respondsToSelector:@selector(cacheFileDeleteRequest:error:)]) {
                [self.cacheClient cacheFileDeleteRequest:self error:error];
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
    return self.fileID;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeFile;
}

#pragma mark - Private Helper methods

- (BOOL)shouldPerformBackgroundOperation
{
    return (self.associateId.length > 0 && self.requestDirectoryPath.length > 0);
}

@end
