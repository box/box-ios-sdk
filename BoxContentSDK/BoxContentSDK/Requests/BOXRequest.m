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
#import "NSString+BOXAdditions.h"
#include <sys/types.h>
#include <sys/sysctl.h>

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

- (NSString *)APIVersion
{
    if (_APIVersion == nil) {
        _APIVersion = BOXAPIVersion;
    }
    
    return _APIVersion;
}

- (NSString *)baseURL
{
    if (_baseURL == nil) {
        _baseURL = BOXAPIBaseURL;
    }

    return _baseURL;
}

- (NSString *)uploadAPIVersion
{
    if (_uploadAPIVersion == nil) {
        _uploadAPIVersion = BOXAPIUploadAPIVersion;
    }
    
    return _uploadAPIVersion;
}

- (NSString *)uploadBaseURL
{
    if (_uploadBaseURL == nil) {
        _uploadBaseURL = BOXAPIUploadBaseURL;
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

#pragma mark - Convenience Methods

- (NSURL *)URLWithResource:(NSString *)resource
                        ID:(NSString *)ID
               subresource:(NSString *)subresource
                     subID:(NSString *)subID
                   baseURL:(NSString *)baseURL
                APIVersion:(NSString *)APIVersion
{
    NSString *formatString = @"/%@";
    if ([baseURL hasSuffix:@"/"]) {
        formatString = @"%@"; // do not append a trailing slash if the base url already has one
    }

    NSString *URLString = [baseURL stringByAppendingFormat:formatString, APIVersion];

    if (resource != nil) {
        URLString = [URLString stringByAppendingFormat:@"/%@", resource];
        if (ID != nil) {
            URLString = [URLString stringByAppendingFormat:@"/%@", ID];
        }
        if (subresource != nil) {
            URLString = [URLString stringByAppendingFormat:@"/%@", subresource];
            if (subID != nil) {
                URLString = [URLString stringByAppendingFormat:@"/%@", subID];
            }
        }
    }

    return [[NSURL alloc] initWithString:URLString];
}

- (NSURL *)URLWithResource:(NSString *)resource
                        ID:(NSString *)ID
               subresource:(NSString *)subresource
                     subID:(NSString *)subID
{
    return [self URLWithResource:resource ID:ID
                     subresource:subresource
                           subID:subID
                         baseURL:self.baseURL
                      APIVersion:self.APIVersion];
}

- (NSURL *)uploadURLWithResource:(NSString *)resource
                              ID:(NSString *)ID
                     subresource:(NSString *)subresource
{
    return [self URLWithResource:resource
                              ID:ID
                     subresource:subresource
                           subID:nil
                         baseURL:self.uploadBaseURL
                      APIVersion:self.uploadAPIVersion];
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
    BOXAPIDataOperation *operation = [[BOXAPIDataOperation alloc] initWithURL:URL
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
                       BOXAPIObjectKeyFolderUploadEmail,
                       BOXAPIObjectKeySyncState,
                       BOXAPIObjectKeyHasCollaborations,
                       BOXAPIObjectKeyIsExternallyOwned,
                       BOXAPIObjectKeyCanNonOwnersInvite,
                       BOXAPIObjectKeyAllowedInviteeRoles];
    return array;
}

- (NSString *)fullFolderFieldsParameterString
{
    return [[self fullFolderFieldsArray] componentsJoinedByString:@","];
}

- (NSArray *)fullFileFieldsArray
{
    NSArray *array = @[BOXAPIObjectKeyType,
                       BOXAPIObjectKeyID,
                       BOXAPIObjectKeySequenceID,
                       BOXAPIObjectKeyETag,
                       BOXAPIObjectKeySHA1,
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
                       BOXAPIObjectKeyAllowedSharedLinkAccessLevels,
                       BOXAPIObjectKeyCollections];
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
                       BOXAPIObjectKeyAllowedSharedLinkAccessLevels];
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
                       BOXAPIObjectKeyIsExemptFromDeviceLimits,
                       BOXAPIObjectKeyIsExemptFromLoginVerification,
                       BOXAPIObjectKeyEnterprise];
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

- (NSString *)modelID
{
    NSString *model = nil;
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);

    if (machine != NULL) {
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    }
    
    return model;
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
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@;iOS/%@;Apple/%@;%@",
                           self.SDKIdentifier,
                           self.SDKVersion,
                           [[UIDevice currentDevice] systemVersion],
                           [self modelID],
                           [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    
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
        [items addObject:[BOXRequest itemWithJSON:dict]];
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
