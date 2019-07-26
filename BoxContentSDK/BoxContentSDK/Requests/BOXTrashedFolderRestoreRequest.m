//
//  BOXTrashedFolderRestoreRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXTrashedFolderRestoreRequest.h"

#import "BOXFolder.h"
#import "BOXDispatchHelper.h"

@implementation BOXTrashedFolderRestoreRequest

- (instancetype)initWithFolderID:(NSString *)folderID
{
    if (self = [super init]) {
        _folderID = folderID;
    }
    
    return self;
}

- (instancetype)initWithFolderID:(NSString *)folderID
                     associateId:(NSString *)associateId
{
    if (self = [super init]) {
        _folderID = folderID;
        _associateId = associateId;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFolders
                                    ID:self.folderID
                           subresource:nil
                                 subID:nil];
    
    NSMutableDictionary *bodyDictionary = [NSMutableDictionary dictionary];
    if (self.folderName.length > 0) {
        bodyDictionary[BOXAPIObjectKeyName] = self.folderName;
    }
    if (self.parentFolderID.length > 0) {
        bodyDictionary[BOXAPIObjectKeyParent] = @{BOXAPIObjectKeyID : self.parentFolderID};
    }
    
    if ([self shouldPerformBackgroundOperation] == YES) {
        BOXAPIDataOperation *dataOperation = [self dataOperationWithURL:URL
                                                             HTTPMethod:BOXAPIHTTPMethodPOST
                                                  queryStringParameters:nil
                                                         bodyDictionary:bodyDictionary
                                                           successBlock:nil
                                                           failureBlock:nil
                                                            associateId:self.associateId];
        
        NSString *requestDirectory = self.requestDirectoryPath;
        NSString *destinationPath = [requestDirectory stringByAppendingPathComponent:self.associateId];
        dataOperation.destinationPath = destinationPath;
        
        return dataOperation;
    } else {
        BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                             HTTPMethod:BOXAPIHTTPMethodPOST
                                                  queryStringParameters:nil
                                                         bodyDictionary:bodyDictionary
                                                       JSONSuccessBlock:nil
                                                           failureBlock:nil];
        
        return JSONoperation;
    }
}

- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock
{
    if ([self shouldPerformBackgroundOperation] == YES) {
        BOOL isMainThread = [NSThread isMainThread];
        
        BOXAPIDataOperation *folderOperation = (BOXAPIDataOperation *)self.operation;
        __weak BOXAPIDataOperation *weakFolderOperation = folderOperation;
        
        folderOperation.successBlock = ^(NSString *modelID, long long expectedTotalBytes) {
            NSData *data = [NSData dataWithContentsOfFile:weakFolderOperation.destinationPath];
            BOXFolder *folder = nil;
            if (data != nil) {
                NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                folder = (BOXFolder *)[[self class] itemWithJSON:jsonDictionary];
                
                if ([self.cacheClient respondsToSelector:@selector(cacheTrashedFolderRestoreRequest:withFolder:error:)]) {
                    [self.cacheClient cacheTrashedFolderRestoreRequest:self
                                                            withFolder:folder
                                                                 error:nil];
                }
                
                if ([[NSFileManager defaultManager] fileExistsAtPath: weakFolderOperation.destinationPath]) {
                    NSError *error = nil;
                    [[NSFileManager defaultManager] removeItemAtPath:weakFolderOperation.destinationPath error:&error];
                }
                
                if (completionBlock) {
                    [BOXDispatchHelper callCompletionBlock:^{
                        completionBlock(folder, nil);
                    } onMainThread:isMainThread];
                }
            }
        };
        
        folderOperation.failureBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            if ([self.cacheClient respondsToSelector:@selector(cacheTrashedFolderRestoreRequest:withFolder:error:)]) {
                [self.cacheClient cacheTrashedFolderRestoreRequest:self
                                                        withFolder:nil
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
        BOXAPIJSONOperation *folderOperation = (BOXAPIJSONOperation *)self.operation;
        
        folderOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            BOXFolder *folder = [[BOXFolder alloc] initWithJSON:JSONDictionary];
            
            if ([self.cacheClient respondsToSelector:@selector(cacheTrashedFolderRestoreRequest:withFolder:error:)]) {
                [self.cacheClient cacheTrashedFolderRestoreRequest:self
                                                        withFolder:folder
                                                             error:nil];
            }
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(folder, nil);
                } onMainThread:isMainThread];
            }
        };
        folderOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            
            if ([self.cacheClient respondsToSelector:@selector(cacheTrashedFolderRestoreRequest:withFolder:error:)]) {
                [self.cacheClient cacheTrashedFolderRestoreRequest:self
                                                        withFolder:nil
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
