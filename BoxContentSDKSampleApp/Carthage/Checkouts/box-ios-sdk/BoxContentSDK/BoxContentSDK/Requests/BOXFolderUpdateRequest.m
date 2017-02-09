//
//  BOXFolderUpdateRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFolderUpdateRequest.h"
#import "BOXAPIJSONOperation.h"
#import "BOXFolder.h"
#import "BOXSharedLinkHeadersHelper.h"

@interface BOXFolderUpdateRequest ()

@property (nonatomic, readwrite, assign) BOOL shouldUseSharedLinkCanDownload;
@property (nonatomic, readwrite, assign) BOOL shouldUseSharedLinkCanPreview;

@end

@implementation BOXFolderUpdateRequest

- (instancetype)initWithFolderID:(NSString *)folderID
{
    if (self = [super init]) {
        _folderID = folderID;
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
    NSURL *URL = [self URLWithResource:BOXAPIResourceFolders
                                    ID:self.folderID
                           subresource:nil
                                 subID:nil];
    
    // Body
    
    NSMutableDictionary *bodyDictionary = [NSMutableDictionary dictionary];
    
    if (self.folderName.length > 0) {
        bodyDictionary[BOXAPIObjectKeyName] = self.folderName;
    }
    
    if (self.folderDescription.length > 0) {
        bodyDictionary[BOXAPIObjectKeyDescription] = self.folderDescription;
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
        NSDictionary *parentID = @{BOXAPIObjectKeyID : self.parentID};
        bodyDictionary[BOXAPIObjectKeyParent] = parentID;
    }

    if (self.folderUploadEmailAddress.length > 0 || self.folderUploadEmailAccess.length > 0)
    {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

        if (self.folderUploadEmailAddress.length > 0) {
            dictionary[BOXAPIObjectKeyEmail] = self.folderUploadEmailAddress;
        }

        if (self.folderUploadEmailAccess.length > 0) {
            dictionary[BOXAPIObjectKeyAccess] = self.folderUploadEmailAccess;
        }
        bodyDictionary[BOXAPIObjectKeyFolderUploadEmail] = [NSDictionary dictionaryWithDictionary:dictionary];
    }
    
    if (self.ownerUserID.length > 0) {
        bodyDictionary[BOXAPIObjectKeyOwnedBy] = @{BOXAPIObjectKeyID : self.ownerUserID};
    }
    
    if (self.syncState.length > 0) {
        bodyDictionary[BOXAPIObjectKeySyncState] = self.syncState;
    }
    
    // Query Params
    
    NSDictionary *queryParameters = nil;
    
    if (self.requestAllFolderFields) {
        queryParameters = @{BOXAPIParameterKeyFields: [self fullFolderFieldsParameterString]};
    }
    
    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodPUT
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:bodyDictionary
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    if ([self.matchingEtag length] > 0) {
        [JSONoperation.APIRequest setValue:self.matchingEtag forHTTPHeaderField:BOXAPIHTTPHeaderIfMatch];
    }
    
    [self addSharedLinkHeaderToRequest:JSONoperation.APIRequest];
    
    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXFolderBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *folderOperation = (BOXAPIJSONOperation *)self.operation;
    
    folderOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
        BOXFolder *folder = [[BOXFolder alloc] initWithJSON:JSONDictionary];

        [self.sharedLinkHeadersHelper storeHeadersFromAncestorsIfNecessaryForItemWithID:folder.modelID
                                                                               itemType:folder.type
                                                                              ancestors:folder.pathFolders];

        if ([self.cacheClient respondsToSelector:@selector(cacheFolderUpdateRequest:withFolder:error:)]) {
            [self.cacheClient cacheFolderUpdateRequest:self
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

        if ([self.cacheClient respondsToSelector:@selector(cacheFolderUpdateRequest:withFolder:error:)]) {
            [self.cacheClient cacheFolderUpdateRequest:self
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
