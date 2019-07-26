//
//  BOXTrashedFileRestoreRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXTrashedFileRestoreRequest.h"

#import "BOXFile.h"
#import "BOXDispatchHelper.h"

@interface BOXTrashedFileRestoreRequest ()

@property (nonatomic, readwrite, strong) NSString *fileID;

@end

@implementation BOXTrashedFileRestoreRequest

- (instancetype)initWithFileID:(NSString *)fileID
{
    if (self = [super init]) {
        _fileID = fileID;
    }
    
    return self;
}

- (instancetype)initWithFileID:(NSString *)fileID
                   associateId:(NSString *)associateId
{
    if (self = [super init]) {
        _fileID = fileID;
        _associateId = associateId;
    }
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:nil
                                 subID:nil];
    
    NSMutableDictionary *bodyDictionary = [NSMutableDictionary dictionary];
    if (self.fileName.length > 0) {
        bodyDictionary[BOXAPIObjectKeyName] = self.fileName;
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

- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock
{
    if ([self shouldPerformBackgroundOperation] == YES) {
        BOOL isMainThread = [NSThread isMainThread];
        
        BOXAPIDataOperation *fileOperation = (BOXAPIDataOperation *)self.operation;
        __weak BOXAPIDataOperation *weakFileOperation = fileOperation;
        
        fileOperation.successBlock = ^(NSString *modelID, long long expectedTotalBytes) {
            NSData *data = [NSData dataWithContentsOfFile:weakFileOperation.destinationPath];
            BOXFile *file = nil;
            if (data != nil) {
                NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                file = (BOXFile *)[[self class] itemWithJSON:jsonDictionary];
                
                if ([self.cacheClient respondsToSelector:@selector(cacheTrashedFileRestoreRequest:withFile:error:)]) {
                    [self.cacheClient cacheTrashedFileRestoreRequest:self
                                                            withFile:file
                                                               error:nil];
                }
                
                if ([[NSFileManager defaultManager] fileExistsAtPath: weakFileOperation.destinationPath]) {
                    NSError *error = nil;
                    [[NSFileManager defaultManager] removeItemAtPath:weakFileOperation.destinationPath error:&error];
                }
                
                if (completionBlock) {
                    [BOXDispatchHelper callCompletionBlock:^{
                        completionBlock(file, nil);
                    } onMainThread:isMainThread];
                }
            }
        };
        
        fileOperation.failureBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            if ([self.cacheClient respondsToSelector:@selector(cacheTrashedFileRestoreRequest:withFile:error:)]) {
                [self.cacheClient cacheTrashedFileRestoreRequest:self
                                                        withFile:nil
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
        BOXAPIJSONOperation *fileOperation = (BOXAPIJSONOperation *)self.operation;
        
        fileOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            BOXFile *file = [[BOXFile alloc] initWithJSON:JSONDictionary];
            
            if ([self.cacheClient respondsToSelector:@selector(cacheTrashedFileRestoreRequest:withFile:error:)]) {
                [self.cacheClient cacheTrashedFileRestoreRequest:self
                                                        withFile:file
                                                           error:nil];
            }
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(file, nil);
                } onMainThread:isMainThread];
            }
        };
        fileOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            
            if ([self.cacheClient respondsToSelector:@selector(cacheTrashedFileRestoreRequest:withFile:error:)]) {
                [self.cacheClient cacheTrashedFileRestoreRequest:self
                                                        withFile:nil
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
