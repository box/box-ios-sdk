//
//  BOXFolderCopyRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFolderCopyRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXFolder.h"

@implementation BOXFolderCopyRequest

- (instancetype)initWithFolderID:(NSString *)folderID destinationFolderID:(NSString *)destinationFolderID
{
    if (self = [super init]) {
        _folderID = folderID;
        _destinationFolderID = destinationFolderID;
    }
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFolders
                                    ID:self.folderID
                           subresource:BOXAPISubresourceCopy
                                 subID:nil];
    
    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionary];
    
    if (self.requestAllFolderFields) {
        queryParameters[BOXAPIParameterKeyFields] = [self fullFolderFieldsParameterString];
    }
    
    NSMutableDictionary *bodyDictionary = [NSMutableDictionary dictionary];
    
    if (self.destinationFolderID.length > 0) {
        bodyDictionary[BOXAPIObjectKeyParent] = @{BOXAPIObjectKeyID : self.destinationFolderID};
    }
 
    if (self.folderName.length > 0) {
        bodyDictionary[BOXAPIObjectKeyName] = self.folderName;
    }
    
    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodPOST
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:bodyDictionary
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    
    [self addSharedLinkHeaderToRequest:JSONoperation.APIRequest];
    
    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *folderOperation = (BOXAPIJSONOperation *)self.operation;

    folderOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
        BOXFolder *folder = [[BOXFolder alloc] initWithJSON:JSONDictionary];

        if ([self.cacheClient respondsToSelector:@selector(cacheFolderCopyRequest:withFolder:error:)]) {
            [self.cacheClient cacheFolderCopyRequest:self
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

        if ([self.cacheClient respondsToSelector:@selector(cacheFolderCopyRequest:withFolder:error:)]) {
            [self.cacheClient cacheFolderCopyRequest:self
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

#pragma mark - Superclass overidden methods

- (NSString *)itemIDForSharedLink
{
    return self.folderID;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeFolder;
}

@end
