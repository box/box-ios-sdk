//
//  BOXFolderCreateRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFolderCreateRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXFolder.h"
#import "BOXDispatchHelper.h"

@interface BOXFolderCreateRequest()

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

@implementation BOXFolderCreateRequest

- (instancetype)initWithFolderName:(NSString *)folderName parentFolderID:(NSString *)parentFolderID
{
    return [self initWithFolderName:folderName
                       parentFolderID:parentFolderID
                    associateId:nil];
}

- (instancetype)initWithFolderName:(NSString *)folderName
                    parentFolderID:(NSString *)parentFolderID
                       associateId:(nullable NSString *)associateId

{
    if (self = [super init]) {
        _folderName = folderName;
        _parentFolderID = parentFolderID;
        _associateId = associateId;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFolders
                                    ID:nil
                           subresource:nil
                                 subID:nil];
    
    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionary];
    
    if (self.requestAllFolderFields) {
        queryParameters[BOXAPIParameterKeyFields] = [self fullFolderFieldsParameterString];
    }
    
    NSDictionary *bodyDictionary = @{BOXAPIObjectKeyParent : @{BOXAPIObjectKeyID : self.parentFolderID},
                                     BOXAPIObjectKeyName : self.folderName};

    if ([self shouldPerformBackgroundOperation] == YES) {
        BOXAPIDataOperation *dataOperation = [self dataOperationWithURL:URL
                                                             HTTPMethod:BOXAPIHTTPMethodPOST
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
        BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:URL
                                                             HTTPMethod:BOXAPIHTTPMethodPOST
                                                  queryStringParameters:queryParameters
                                                         bodyDictionary:bodyDictionary
                                                       JSONSuccessBlock:nil
                                                           failureBlock:nil];
        [self addSharedLinkHeaderToRequest:JSONOperation.APIRequest];
        
        return JSONOperation;
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
                
                if ([self.cacheClient respondsToSelector:@selector(cacheFolderCreateRequest:withFolder:error:)]) {
                    [self.cacheClient cacheFolderCreateRequest:self
                                                    withFolder:folder
                                                         error:nil];
                }
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
        };
        
        folderOperation.failureBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
            if ([self.cacheClient respondsToSelector:@selector(cacheFolderCreateRequest:withFolder:error:)]) {
                [self.cacheClient cacheFolderCreateRequest:self
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
            
            if ([self.cacheClient respondsToSelector:@selector(cacheFolderCreateRequest:withFolder:error:)]) {
                [self.cacheClient cacheFolderCreateRequest:self
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
            
            if ([self.cacheClient respondsToSelector:@selector(cacheFolderCreateRequest:withFolder:error:)]) {
                [self.cacheClient cacheFolderCreateRequest:self
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

#pragma mark - Superclass overidden methods

- (NSString *)itemIDForSharedLink
{
    return self.parentFolderID;
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
