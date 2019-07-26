//
//  BOXRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFile.h"
#import "BOXFolder.h"
#import "BOXBookmark.h"
#import "BOXAPIQueueManager.h"
#import "BOXContentSDKConstants.h"
#import "BOXContentSDKErrors.h"
#import "BOXISO8601DateFormatter.h"
#import "BOXAppUserSession.h"
#import "NSString+BOXContentSDKAdditions.h"
#import "UIDevice+BOXContentSDKAdditions.h"
#import "BOXContentClient.h"

#define BOX_API_MULTIPART_FILENAME_DEFAULT (@"upload")

@implementation BOXRequest

- (BOXAPIQueueManager *)queueManager
{
    if (_queueManager == nil) {
        //TODO: Default queue setup (grab some shared instance?) or perhaps that is done in the SDK Client, and it always sets the queue for the request
//        _queueManager = ;
    }

    return _queueManager;
}

- (BOXAPIOperation *)operation
{
    if (_operation == nil) {
        _operation = [self createOperation];
    }

    return _operation;
}

- (NSString *)baseURL
{
    if (_baseURL == nil) {
        _baseURL = [BOXContentClient APIBaseURL];
    }

    return _baseURL;
}

- (NSString *)uploadBaseURL
{
    if (_uploadBaseURL == nil) {
        _uploadBaseURL = [BOXContentClient APIUploadBaseURL];
    }

    return _uploadBaseURL;
}

- (NSURLRequest *)urlRequest
{
    return self.operation.APIRequest;
}

- (void)performRequest
{
    [self.operation.APIRequest setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];
    [self.queueManager enqueueOperation:self.operation];
}

- (void)cancel
{
    [self.operation cancel];
}

- (BOXAPIOperation *)createOperation
{
    return nil;
}


- (void)prepareOperation
{
    [self.operation.APIRequest setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];
    [self.operation prepareOperation];
}

#pragma mark - Convenience Methods

- (NSURL *)URLWithResource:(NSString *)resource
                        ID:(NSString *)ID
               subresource:(NSString *)subresource
                     subID:(NSString *)subID
                   baseURL:(NSString *)baseURL
{
    NSURL * url = [[NSURL alloc] initWithString:baseURL];
    if (resource != nil) {
        url = [url URLByAppendingPathComponent:resource];
        if (ID != nil) {
            url = [url URLByAppendingPathComponent:ID];
        }
        if (subresource != nil) {
            url = [url URLByAppendingPathComponent:subresource];
            if (subID != nil) {
                url = [url URLByAppendingPathComponent:subID];
            }
        }
    }

    return url;
}

- (NSURL *)URLWithResource:(NSString *)resource
                        ID:(NSString *)ID
               subresource:(NSString *)subresource
                     subID:(NSString *)subID
{
    return [self URLWithResource:resource ID:ID
                     subresource:subresource
                           subID:subID
                         baseURL:self.baseURL];
}


- (NSURL *)uploadURLWithResource:(NSString *)resource
                              ID:(NSString *)ID
                     subresource:(NSString *)subresource
{
    return [self URLWithResource:resource
                              ID:ID
                     subresource:subresource
                           subID:nil
                         baseURL:self.uploadBaseURL];
}

- (BOXAPIJSONOperation *)JSONOperationWithURL:(NSURL *)URL
                                   HTTPMethod:(BOXAPIHTTPMethod *)HTTPMethod
                        queryStringParameters:(NSDictionary *)queryParameters
                               bodyDictionary:(NSDictionary *)bodyDictionary
                             JSONSuccessBlock:(BOXAPIJSONSuccessBlock)successBlock
                                 failureBlock:(BOXAPIJSONFailureBlock)failureBlock
{
    BOXAPIJSONOperation *operation = [[BOXAPIJSONOperation alloc] initWithURL:URL
                                                                   HTTPMethod:HTTPMethod
                                                                         body:bodyDictionary
                                                                  queryParams:queryParameters
                                                                session:self.queueManager.session];

    // calling a nil block results in a crash, so only set the operation's success block if it is non-nil
    // BOXAPIJSONOperation initializes blocks to empty blocks
    if (successBlock != nil) {
        operation.success = successBlock;
    }
    if (failureBlock != nil) {
        operation.failure = failureBlock;
    }

    return operation;
}

- (BOXAPIJSONPatchOperation *)JSONPatchOperationWithURL:(NSURL *)URL
                                   HTTPMethod:(BOXAPIHTTPMethod *)HTTPMethod
                        queryStringParameters:(NSDictionary *)queryParameters
                               bodyArray:(NSArray *)bodyArray
                             JSONSuccessBlock:(BOXAPIJSONSuccessBlock)successBlock
                                 failureBlock:(BOXAPIJSONFailureBlock)failureBlock
{
    BOXAPIJSONPatchOperation *operation = [[BOXAPIJSONPatchOperation alloc] initWithURL:URL
                                                                             HTTPMethod:HTTPMethod
                                                                        patchOperations:bodyArray
                                                                            queryParams:queryParameters
                                                                          session:self.queueManager.session];

    // calling a nil block results in a crash, so only set the operation's success block if it is non-nil
    // BOXAPIJSONOperation initializes blocks to empty blocks
    if (successBlock != nil) {
        operation.success = successBlock;
    }
    if (failureBlock != nil) {
        operation.failure = failureBlock;
    }

    return operation;
}

- (BOXAPIDataOperation *)dataOperationWithURL:(NSURL *)URL
                                   HTTPMethod:(BOXAPIHTTPMethod *)HTTPMethod
                        queryStringParameters:(NSDictionary *)queryParameters
                               bodyDictionary:(NSDictionary *)bodyDictionary
                                 successBlock:(BOXDownloadSuccessBlock)successBlock
                                 failureBlock:(BOXDownloadFailureBlock)failureBlock
{
    return [self dataOperationWithURL:URL HTTPMethod:HTTPMethod queryStringParameters:queryParameters bodyDictionary:bodyDictionary successBlock:successBlock failureBlock:failureBlock associateId:nil];
}

- (BOXAPIDataOperation *)dataOperationWithURL:(NSURL *)URL
                                   HTTPMethod:(BOXAPIHTTPMethod *)HTTPMethod
                        queryStringParameters:(NSDictionary *)queryParameters
                               bodyDictionary:(NSDictionary *)bodyDictionary
                                 successBlock:(BOXDownloadSuccessBlock)successBlock
                                 failureBlock:(BOXDownloadFailureBlock)failureBlock
                                  associateId:(NSString *)associateId
{
    BOXAPIDataOperation *operation = [[BOXAPIDataOperation alloc] initWithURL:URL
                                                                   HTTPMethod:HTTPMethod
                                                                         body:bodyDictionary
                                                                  queryParams:queryParameters
                                                                      session:self.queueManager.session];
    operation.associateId = associateId;

    if (successBlock != nil) {
        operation.successBlock = successBlock;
    }
    if (failureBlock != nil) {
        operation.failureBlock = failureBlock;
    }

    return operation;
}

- (BOXAPIHeadOperation *)headOperationWithURL:(NSURL *)URL
                                   HTTPMethod:(BOXAPIHTTPMethod *)HTTPMethod
                        queryStringParameters:(NSDictionary *)queryParameters
                               bodyDictionary:(NSDictionary *)bodyDictionary
                                 successBlock:(BOXAPIHeaderSuccessBlock)successBlock
                                 failureBlock:(BOXAPIHeaderFailureBlock)failureBlock
{
    BOXAPIHeadOperation *operation = [[BOXAPIHeadOperation alloc] initWithURL:URL
                                                                   HTTPMethod:HTTPMethod
                                                                         body:bodyDictionary
                                                                  queryParams:queryParameters
                                                                      session:self.queueManager.session];
    if (successBlock != nil) {
        operation.successBlock = successBlock;
    }
    if (failureBlock != nil) {
        operation.failureBlock = failureBlock;
    }

    return operation;
}

- (BOXStreamOperation *)dataStreamOperationWithURL:(NSURL *)URL
                                        HTTPMethod:(BOXAPIHTTPMethod *)HTTPMethod
                                      successBlock:(BOXDownloadSuccessBlock)successBlock
                                      failureBlock:(BOXDownloadFailureBlock)failureBlock
{
    BOXStreamOperation *operation = [[BOXStreamOperation alloc] initWithURL:URL
                                                                 HTTPMethod:HTTPMethod
                                                                       body:nil
                                                                queryParams:nil
                                                                    session:self.queueManager.session];
    if (successBlock != nil) {
        operation.successBlock = successBlock;
    }
    if (failureBlock != nil) {
        operation.failureBlock = failureBlock;
    }

    return operation;
}

- (BOXAPIOAuth2ToJSONOperation *)authOperationWithURL:(NSURL *)URL
                                           HTTPMethod:(BOXAPIHTTPMethod *)HTTPMethod
                                       bodyDictionary:(NSDictionary *)bodyDictionary
                                     JSONSuccessBlock:(BOXAPIJSONSuccessBlock)successBlock
                                         failureBlock:(BOXAPIJSONFailureBlock)failureBlock
{
    BOXAPIOAuth2ToJSONOperation *operation = [[BOXAPIOAuth2ToJSONOperation alloc] initWithURL:URL
                                                                                   HTTPMethod:HTTPMethod
                                                                                         body:bodyDictionary
                                                                                  queryParams:nil
                                                                                      session:self.queueManager.session];

    if (successBlock != nil) {
        operation.success = successBlock;
    }
    if (failureBlock != nil) {
        operation.failure = failureBlock;
    }

    return operation;
}

- (NSArray *)fullFolderFieldsArray
{
    NSArray *array = @[BOXAPIObjectKeyType,
                       BOXAPIObjectKeyID,
                       BOXAPIObjectKeySequenceID,
                       BOXAPIObjectKeyETag,
                       BOXAPIObjectKeyName,
                       BOXAPIObjectKeyDescription,
                       BOXAPIObjectKeySize,
                       BOXAPIObjectKeyPathCollection,
                       BOXAPIObjectKeyCreatedAt,
                       BOXAPIObjectKeyModifiedAt,
                       BOXAPIObjectKeyTrashedAt,
                       BOXAPIObjectKeyPurgedAt,
                       BOXAPIObjectKeyContentCreatedAt,
                       BOXAPIObjectKeyContentModifiedAt,
                       BOXAPIObjectKeyCreatedBy,
                       BOXAPIObjectKeyModifiedBy,
                       BOXAPIObjectKeyOwnedBy,
                       BOXAPIObjectKeySharedLink,
                       BOXAPIObjectKeyParent,
                       BOXAPIObjectKeyItemStatus,
                       BOXAPIObjectKeyPermissions,
                       BOXAPIObjectKeyLock,
                       BOXAPIObjectKeyExtension,
                       BOXAPIObjectKeyIsPackage,
                       BOXAPIObjectKeyAllowedSharedLinkAccessLevels,
                       BOXAPIObjectKeyCollections,
                       BOXAPIObjectKeyCollectionMemberships,
                       BOXAPIObjectKeyFolderUploadEmail,
                       BOXAPIObjectKeySyncState,
                       BOXAPIObjectKeyHasCollaborations,
                       BOXAPIObjectKeyIsExternallyOwned,
                       BOXAPIObjectKeyCanNonOwnersInvite,
                       BOXAPIObjectKeyAllowedInviteeRoles,
                       BOXAPIObjectKeyDefaultInviteeRole];
    return array;
}

- (NSString *)fullFolderFieldsParameterString
{
    return [[self fullFolderFieldsArray] componentsJoinedByString:@","];
}

- (NSArray<NSString *> *)fullFileFieldsArray
{
    NSArray *array = @[BOXAPIObjectKeyType,
                       BOXAPIObjectKeyID,
                       BOXAPIObjectKeySequenceID,
                       BOXAPIObjectKeyETag,
                       BOXAPIObjectKeySHA1,
                       BOXAPIObjectKeyWatermarkInfo,
                       BOXAPIObjectKeyName,
                       BOXAPIObjectKeyDescription,
                       BOXAPIObjectKeySize,
                       BOXAPIObjectKeyPathCollection,
                       BOXAPIObjectKeyCreatedAt,
                       BOXAPIObjectKeyModifiedAt,
                       BOXAPIObjectKeyTrashedAt,
                       BOXAPIObjectKeyPurgedAt,
                       BOXAPIObjectKeyContentCreatedAt,
                       BOXAPIObjectKeyContentModifiedAt,
                       BOXAPIObjectKeyCreatedBy,
                       BOXAPIObjectKeyModifiedBy,
                       BOXAPIObjectKeyOwnedBy,
                       BOXAPIObjectKeySharedLink,
                       BOXAPIObjectKeyParent,
                       BOXAPIObjectKeyItemStatus,
                       BOXAPIObjectKeyVersionNumber,
                       BOXAPIObjectKeyCommentCount,
                       BOXAPIObjectKeyPermissions,
                       BOXAPIObjectKeyLock,
                       BOXAPIObjectKeyExtension,
                       BOXAPIObjectKeyIsPackage,
                       BOXAPIObjectKeyHasCollaborations,
                       BOXAPIObjectKeyIsExternallyOwned,
                       BOXAPIObjectKeyAllowedInviteeRoles,
                       BOXAPIObjectKeyDefaultInviteeRole,
                       BOXAPIObjectKeyAllowedSharedLinkAccessLevels,
                       BOXAPIObjectKeyCollections,
                       BOXAPIObjectKeyCollectionMemberships,
                       BOXAPIObjectKeyFileVersion];
    return array;
}

- (NSString *)fullFileFieldsParameterString
{
    return [[self fullFileFieldsArray] componentsJoinedByString:@","];
}

- (NSArray *)fullBookmarkFieldsArray
{
    NSArray *array = @[BOXAPIObjectKeyType,
                       BOXAPIObjectKeyID,
                       BOXAPIObjectKeySequenceID,
                       BOXAPIObjectKeyETag,
                       BOXAPIObjectKeyName,
                       BOXAPIObjectKeyURL,
                       BOXAPIObjectKeyCreatedAt,
                       BOXAPIObjectKeyModifiedAt,
                       BOXAPIObjectKeyDescription,
                       BOXAPIObjectKeyPathCollection,
                       BOXAPIObjectKeyTrashedAt,
                       BOXAPIObjectKeyPurgedAt,
                       BOXAPIObjectKeyCreatedBy,
                       BOXAPIObjectKeyModifiedBy,
                       BOXAPIObjectKeyOwnedBy,
                       BOXAPIObjectKeyParent,
                       BOXAPIObjectKeyItemStatus,
                       BOXAPIObjectKeySharedLink,
                       BOXAPIObjectKeyCommentCount,
                       BOXAPIObjectKeyPermissions,
                       BOXAPIObjectKeyAllowedSharedLinkAccessLevels,
                       BOXAPIObjectKeyCollections];
    return array;
}

- (NSString *)fullBookmarkFieldsParameterString
{
    return [[self fullBookmarkFieldsArray] componentsJoinedByString:@","];
}

- (NSString *)fullItemFieldsParameterString
{
    NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSet];
    [set addObjectsFromArray:[self fullFolderFieldsArray]];
    [set addObjectsFromArray:[self fullFileFieldsArray]];
    [set addObjectsFromArray:[self fullBookmarkFieldsArray]];
    return [[set array] componentsJoinedByString:@","];
}

- (NSString *)fullItemFieldsParameterStringExcludingFields:(NSArray *)excludedFields
{
    NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSet];
    [set addObjectsFromArray:[self fullFolderFieldsArray]];
    [set addObjectsFromArray:[self fullFileFieldsArray]];
    [set addObjectsFromArray:[self fullBookmarkFieldsArray]];

    [set removeObjectsInArray:excludedFields];
    return [[set array] componentsJoinedByString:@","];
}

- (NSString *)fullCommentFieldsParameterString
{
    NSArray *array = @[BOXAPIObjectKeyMessage,
                       BOXAPIObjectKeyTaggedMessage,
                       BOXAPIObjectKeyCreatedAt,
                       BOXAPIObjectKeyCreatedBy,
                       BOXAPIObjectKeyIsReplyComment,
                       BOXAPIObjectKeyModifiedAt,
                       BOXAPIObjectKeyItem];
    return [array componentsJoinedByString:@","];
}

- (NSString *)fullUserFieldsParameterString
{
    NSArray *array = @[BOXAPIObjectKeyType,
                       BOXAPIObjectKeyID,
                       BOXAPIObjectKeyName,
                       BOXAPIObjectKeyLogin,
                       BOXAPIObjectKeyCreatedAt,
                       BOXAPIObjectKeyModifiedAt,
                       BOXAPIObjectKeyRole,
                       BOXAPIObjectKeyLanguage,
                       BOXAPIObjectKeyTimezone,
                       BOXAPIObjectKeySpaceAmount,
                       BOXAPIObjectKeySpaceUsed,
                       BOXAPIObjectKeyMaxUploadSize,
                       BOXAPIObjectKeyTrackingCodes,
                       BOXAPIObjectKeyCanSeeManagedUsers,
                       BOXAPIObjectKeyIsSyncEnabled,
                       BOXAPIObjectKeyIsExternalCollabRestricted,
                       BOXAPIObjectKeyStatus,
                       BOXAPIObjectKeyJobTitle,
                       BOXAPIObjectKeyPhone,
                       BOXAPIObjectKeyAddress,
                       BOXAPIObjectKeyAvatarURL,
                       BOXAPIObjectKeyHasCustomAvatar,
                       BOXAPIObjectKeyIsExemptFromDeviceLimits,
                       BOXAPIObjectKeyIsExemptFromLoginVerification,
                       BOXAPIObjectKeyEnterprise,
                       BOXAPIObjectKeyIsBoxNotesCreationEnabled];
    return [array componentsJoinedByString:@","];
}

- (NSString *)fullCollaborationFieldsParameterString
{
    NSArray *array = @[BOXAPIObjectKeyType,
                       BOXAPIObjectKeyID,
                       BOXAPIObjectKeyCreatedBy,
                       BOXAPIObjectKeyCreatedAt,
                       BOXAPIObjectKeyModifiedAt,
                       BOXAPIObjectKeyExpiresAt,
                       BOXAPIObjectKeyStatus,
                       BOXAPIObjectKeyAccessibleBy,
                       BOXAPIObjectKeyRole,
                       BOXAPIObjectKeyAcknowledgedAt,
                       BOXAPIObjectKeyItem];
    return [array componentsJoinedByString:@","];
}

- (NSString *)deviceModelName
{
    return [[UIDevice currentDevice] detailedModelName];
}

- (NSString *)SDKIdentifier
{
    if (_SDKIdentifier.length > 0) {
        return _SDKIdentifier;
    } else {
        return BOX_CONTENT_SDK_IDENTIFIER;
    }
}

- (NSString *)SDKVersion
{
    if (_SDKVersion.length > 0) {
        return _SDKVersion;
    } else {
        return BOX_CONTENT_SDK_VERSION;
    }
}

- (NSString *)userAgent
{
    NSString *userAgent;
    NSString *defaultUserAgent = [NSString stringWithFormat:@"iOS/%@;Apple/%@;%@/%@;%@",
                                  [[UIDevice currentDevice] systemVersion],
                                  [self deviceModelName],
                                  self.SDKIdentifier,
                                  self.SDKVersion,
                                  [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    if (self.userAgentPrefix.length > 0) {
        userAgent = [NSString stringWithFormat:@"%@;%@", self.userAgentPrefix, defaultUserAgent];
    } else {
        userAgent = defaultUserAgent;
    }

    return userAgent;
}

- (NSString *)nonEmptyFilename:(NSString *)filename
{
    if ([filename length] == 0) {
        NSDate *now = [NSDate date];
        NSString *nowString = [NSDateFormatter localizedStringFromDate:now
                                                             dateStyle:NSDateFormatterShortStyle
                                                             timeStyle:NSDateFormatterShortStyle];
        filename = [BOX_API_MULTIPART_FILENAME_DEFAULT stringByAppendingFormat:@" %@", nowString];
    }

    return filename;
}

+ (BOXItem *)itemWithJSON:(NSDictionary *)JSONDictionary
{
    BOXItem *item = nil;

    NSString *itemType = [JSONDictionary objectForKey:BOXAPIObjectKeyType];

    if ([itemType isEqualToString:BOXAPIItemTypeFile]) {
        item = [[BOXFile alloc] initWithJSON:JSONDictionary];
    } else if ([itemType isEqualToString:BOXAPIItemTypeFolder]) {
        item = [[BOXFolder alloc] initWithJSON:JSONDictionary];
    } else if ([itemType isEqualToString:BOXAPIItemTypeWebLink]) {
        item = [[BOXBookmark alloc] initWithJSON:JSONDictionary];
    } else {
        item = [[BOXItem alloc] initWithJSON:JSONDictionary];
    }

    return item;
}

+ (NSArray *)itemsWithJSON:(NSDictionary *)JSONDictionary
{
    NSArray *itemsDicts = [JSONDictionary objectForKey:@"entries"];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:itemsDicts.count];

    for (NSDictionary *dict in itemsDicts) {
        [items addObject:[self itemWithJSON:dict]];
    }

    return items;
}

+ (BOOL)shouldRemoveCachedResponseForError:(NSError *)error
{
    if (error != nil && [error.domain isEqualToString:BOXContentSDKErrorDomain] &&
        (error.code == BOXContentSDKAPIErrorUnauthorized ||
         error.code == BOXContentSDKAPIErrorForbidden ||
         error.code == BOXContentSDKAPIErrorNotFound)) {
            return YES;
        }

    return NO;
}

@end
