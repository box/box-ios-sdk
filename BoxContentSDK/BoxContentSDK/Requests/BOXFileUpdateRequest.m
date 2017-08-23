//
//  BOXFileUpdateRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFileUpdateRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXFile.h"
#import "BOXDispatchHelper.h"

@interface BOXFileUpdateRequest ()
@property (nonatomic, readwrite, strong) NSString *fileID;
@property (nonatomic, readwrite, assign) BOOL shouldUseSharedLinkCanDownload;
@property (nonatomic, readwrite, assign) BOOL shouldUseSharedLinkCanPreview;
@end

@implementation BOXFileUpdateRequest

- (instancetype)initWithFileID:(NSString *)fileID
{
    if (self = [super init]) {
        _fileID = fileID;
    }

    return self;
}

- (void)setSharedLinkPermissionCanDownload:(BOOL)sharedLinkPermissionCanDownload
{
    self.shouldUseSharedLinkCanDownload = YES;
    _sharedLinkPermissionCanDownload = sharedLinkPermissionCanDownload;
}

- (void)setSharedLinkPermissionCanPreview:(BOOL)sharedLinkPermissionCanPreview
{
    self.shouldUseSharedLinkCanPreview = YES;
    _sharedLinkPermissionCanPreview = sharedLinkPermissionCanPreview;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:nil
                                 subID:nil];

    // Body
    
    NSMutableDictionary *bodyDictionary = [[NSMutableDictionary alloc] init];

    if (self.fileName.length > 0) {
        bodyDictionary[BOXAPIObjectKeyName] = self.fileName;
    }

    if (self.fileDescription.length > 0) {
        bodyDictionary[BOXAPIObjectKeyDescription] = self.fileDescription;
    }

    if (self.sharedLinkAccessLevel.length > 0 || self.sharedLinkExpirationDate != nil ||
            self.shouldUseSharedLinkCanDownload || self.shouldUseSharedLinkCanPreview) {
        NSMutableDictionary *sharedLinkDictionary = [NSMutableDictionary dictionary];

        if (self.sharedLinkAccessLevel.length > 0) {
            sharedLinkDictionary[BOXAPIObjectKeyAccess] = self.sharedLinkAccessLevel;
        }

        if (self.sharedLinkExpirationDate != nil) {
            sharedLinkDictionary[BOXAPIObjectKeyUnsharedAt] = [self.sharedLinkExpirationDate box_ISO8601String];
        }

        if (self.shouldUseSharedLinkCanDownload || self.shouldUseSharedLinkCanPreview) {
            NSMutableDictionary *sharedLinkPermissionsDictionary = [NSMutableDictionary dictionary];

            if (self.shouldUseSharedLinkCanDownload) {
                sharedLinkPermissionsDictionary[BOXAPIObjectKeyCanDownload] =
                    [NSNumber numberWithBool:self.sharedLinkPermissionCanDownload];
            }
            
            if (self.shouldUseSharedLinkCanPreview) {
                sharedLinkPermissionsDictionary[BOXAPIObjectKeyCanPreview] =
                    [NSNumber numberWithBool:self.sharedLinkPermissionCanPreview];
            }
            sharedLinkDictionary[BOXAPIObjectKeyPermissions] = sharedLinkPermissionsDictionary;
        }
        bodyDictionary[BOXAPIObjectKeySharedLink] = sharedLinkDictionary;
    }

    if (self.parentID.length > 0) {
        NSDictionary *parentID = [NSDictionary dictionaryWithObject:self.parentID forKey:BOXAPIObjectKeyID];
        bodyDictionary[BOXAPIObjectKeyParent] = parentID;
    }

    // Query Params
    
    NSDictionary *queryParameters = nil;
    
    if (self.requestAllFileFields) {
        queryParameters = @{BOXAPIParameterKeyFields: [self fullFileFieldsParameterString]};
    }
    
    BOXAPIOperation *fileUpdateOperation = nil;

    if ([self shouldPerformBackgroundOperation]) {
        BOXAPIDataOperation *dataOperation = [self dataOperationWithURL:URL
                                                             HTTPMethod:BOXAPIHTTPMethodPUT
                                                  queryStringParameters:queryParameters
                                                         bodyDictionary:bodyDictionary
                                                           successBlock:nil
                                                           failureBlock:nil
                                                            associateId:self.associateID];
        NSString *requestDirectory = self.requestDirectoryPath;
        dataOperation.destinationPath = [requestDirectory stringByAppendingPathComponent:self.associateID];
        
        fileUpdateOperation = dataOperation;
    } else {
        BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                             HTTPMethod:BOXAPIHTTPMethodPUT
                                                  queryStringParameters:queryParameters
                                                         bodyDictionary:bodyDictionary
                                                       JSONSuccessBlock:nil
                                                           failureBlock:nil];
        fileUpdateOperation = JSONoperation;
    }
    
    if ([self.matchingEtag length] > 0) {
        [fileUpdateOperation.APIRequest setValue:self.matchingEtag
                              forHTTPHeaderField:BOXAPIHTTPHeaderIfMatch];
    }
    
    [self addSharedLinkHeaderToRequest:fileUpdateOperation.APIRequest];
    
    return fileUpdateOperation;
}

- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    
    if ([self shouldPerformBackgroundOperation]) {
        BOXAPIDataOperation *fileOperation = (BOXAPIDataOperation *)self.operation;
        __weak BOXAPIDataOperation *weakFileOperation = fileOperation;
        fileOperation.successBlock = ^(NSString *modelID, long long expectedTotalBytes) {
            NSData *data = [NSData dataWithContentsOfFile:weakFileOperation.destinationPath];
            BOXFile *file = nil;
            if (data != nil) {
                NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                file = (BOXFile *)[[self class] itemWithJSON:jsonDictionary];
                
                if ([self.cacheClient respondsToSelector:@selector(cacheFileUpdateRequest:withFile:error:)]) {
                    [self.cacheClient cacheFileUpdateRequest:self
                                                    withFile:file
                                                       error:nil];
                }
            }
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:weakFileOperation.destinationPath]) {
                NSError *error = nil;
                [[NSFileManager defaultManager] removeItemAtPath:weakFileOperation.destinationPath error:&error];
            }
            
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(file, nil);
                } onMainThread:isMainThread];
            }
        };
        
        fileOperation.failureBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            if ([self.cacheClient respondsToSelector:@selector(cacheFileUpdateRequest:withFile:error:)]) {
                [self.cacheClient cacheFileUpdateRequest:self
                                                withFile:nil
                                                   error:error];
            }
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(nil, error);
                } onMainThread:isMainThread];
            }
        };
    } else {
        BOXAPIJSONOperation *fileOperation = (BOXAPIJSONOperation *)self.operation;
        
        fileOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            BOXFile *file = [[BOXFile alloc] initWithJSON:JSONDictionary];
            
            if ([self.cacheClient respondsToSelector:@selector(cacheFileUpdateRequest:withFile:error:)]) {
                [self.cacheClient cacheFileUpdateRequest:self
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
            
            if ([self.cacheClient respondsToSelector:@selector(cacheFileUpdateRequest:withFile:error:)]) {
                [self.cacheClient cacheFileUpdateRequest:self
                                                withFile:nil
                                                   error:error];
            }
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(nil, error);
                } onMainThread:isMainThread];
            }
        };
    }

    [self performRequest];
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
    return (self.associateID.length > 0 && self.requestDirectoryPath.length > 0);
}

@end
