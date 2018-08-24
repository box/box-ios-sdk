//
//  BOXFileRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFileRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXFile.h"
#import "BOXSharedLinkHeadersHelper.h"
#import "BOXDispatchHelper.h"
#import "UIDevice+BoxContentSDKAdditions.h"
#import "BOXRepresentationsHelper.h"

@interface BOXFileRequest ()

@property (nonatomic, readwrite, strong) NSString *fileID;
@property (nonatomic, readwrite, assign) BOOL isTrashed;
@property (nonatomic, readonly, strong) BOXRepresentationsHelper* repsHelpers;

- (BOOL)shouldPerformBackgroundOperation;

@end

@implementation BOXFileRequest

- (instancetype)initWithFileID:(NSString *)fileID
{
    return [self initWithFileID:fileID isTrashed:NO];
}

- (instancetype)initWithFileID:(NSString *)fileID isTrashed:(BOOL)isTrashed
{    
    if (self = [super init]) {
        _fileID = fileID;
        _isTrashed = isTrashed;
        _repsHelpers = [BOXRepresentationsHelper new];
    }

    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSString *subresource = nil;

    if (self.isTrashed) {
        subresource = BOXAPISubresourceTrash;
    }
    
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:subresource
                                 subID:nil];

    NSDictionary *queryParameters = nil;
    
    NSString *fieldString = @"";

    if (self.requestAllFileFields) {
        fieldString = [self fullFileFieldsParameterString];
    }
    
    // The original content url is retrieved from the download_url. Include BOXRepresentationRequestOriginal
    // The download url is added to the BoxFile representations array, retrieved by type value BOXRepresentationRequestOriginal.
    // You can download the file has owner, co-owner, editor, viewer uploader, viewer permissions.
    if ([self.repsHelpers.representationsRequested containsObject:@(BOXRepresentationRequestOriginal)]) {
        [self.repsHelpers.representationsRequested removeObject:@(BOXRepresentationRequestOriginal)];
        fieldString = [fieldString stringByAppendingFormat:@",%@", BOXAPIObjectKeyAuthenticatedDownloadURL];
    }
    if ([self.repsHelpers.representationsRequested count] > 0) {
        // Include information for the original content URL in any request for file representations
        fieldString = [fieldString stringByAppendingFormat:@",%@", BOXAPIObjectKeyRepresentations];
    }
    
    if (fieldString.length > 0) {
        queryParameters = @{BOXAPIParameterKeyFields:fieldString};
    }

    BOXAPIOperation *fileOperation = nil;
    if ([self shouldPerformBackgroundOperation]) {
        BOXAPIDataOperation *dataOperation = [self dataOperationWithURL:URL
                                                             HTTPMethod:BOXAPIHTTPMethodGET
                                                  queryStringParameters:queryParameters
                                                         bodyDictionary:nil
                                                           successBlock:nil
                                                           failureBlock:nil
                                                            associateId:self.associateID];
        NSString *requestDirectory = self.requestDirectoryPath;
        dataOperation.destinationPath = [requestDirectory stringByAppendingPathComponent:self.associateID];

        fileOperation = dataOperation;
    } else {
        BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:URL
                                                             HTTPMethod:BOXAPIHTTPMethodGET
                                                  queryStringParameters:queryParameters
                                                         bodyDictionary:nil
                                                       JSONSuccessBlock:nil
                                                           failureBlock:nil];

        fileOperation = JSONOperation;
    }
    
    if ([self.notMatchingEtags count] > 0) {
        // Set up the If-None-Match header
        for (NSString *notMatchingEtag in self.notMatchingEtags) {
            [fileOperation.APIRequest addValue:notMatchingEtag
                            forHTTPHeaderField:BOXAPIHTTPHeaderIfNoneMatch];
        }
    }
    
    NSString *representationFields = [self formatRepresentationRequestHeader];
    
    if (representationFields.length > 0) {
        [fileOperation.APIRequest addValue:representationFields
                        forHTTPHeaderField:BOXAPIHTTPHeaderXRepHints];
    }

    [self addSharedLinkHeaderToRequest:fileOperation.APIRequest];

    return fileOperation;
}

- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock
{
    if (completionBlock) {
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

                    [self.sharedLinkHeadersHelper storeHeadersFromAncestorsIfNecessaryForItemWithID:file.modelID
                                                                                           itemType:file.type
                                                                                          ancestors:file.pathFolders];

                    if ([self.cacheClient respondsToSelector:@selector(cacheFileRequest:withFile:error:)]) {
                        [self.cacheClient cacheFileRequest:self
                                                  withFile:file
                                                     error:nil];
                    }
                }

                if ([[NSFileManager defaultManager] fileExistsAtPath:weakFileOperation.destinationPath]) {
                    NSError *error = nil;
                    [[NSFileManager defaultManager] removeItemAtPath:weakFileOperation.destinationPath error:&error];
                }

                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(file, nil);
                } onMainThread:isMainThread];
            };

            fileOperation.failureBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                if ([self.cacheClient respondsToSelector:@selector(cacheFileRequest:withFile:error:)]) {
                    [self.cacheClient cacheFileRequest:self
                                              withFile:nil
                                                 error:error];
                }

                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(nil, error);
                } onMainThread:isMainThread];
            };
        } else {
            BOXAPIJSONOperation *fileOperation = (BOXAPIJSONOperation *)self.operation;

            fileOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
                BOXFile *file = [[BOXFile alloc] initWithJSON:JSONDictionary];
                [self.sharedLinkHeadersHelper storeHeadersFromAncestorsIfNecessaryForItemWithID:file.modelID
                                                                                       itemType:file.type
                                                                                      ancestors:file.pathFolders];

                if ([self.cacheClient respondsToSelector:@selector(cacheFileRequest:withFile:error:)]) {
                    [self.cacheClient cacheFileRequest:self
                                              withFile:file
                                                 error:nil];
                }

                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(file, nil);
                } onMainThread:isMainThread];
            };
            fileOperation.failure =
                ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

                    if ([self.cacheClient respondsToSelector:@selector(cacheFileRequest:withFile:error:)]) {
                        [self.cacheClient cacheFileRequest:self
                                                  withFile:nil
                                                     error:error];
                    }

                    [BOXDispatchHelper callCompletionBlock:^{
                        completionBlock(nil, error);
                    } onMainThread:isMainThread];
                };
        }

        [self performRequest];
    }
}

- (void)performRequestWithCached:(BOXFileBlock)cacheBlock
                       refreshed:(BOXFileBlock)refreshBlock
{
    if (cacheBlock) {
        if ([self.cacheClient respondsToSelector:@selector(retrieveCacheForFileRequest:completion:)]) {
            [self.cacheClient retrieveCacheForFileRequest:self completion:cacheBlock];
        } else {
            cacheBlock(nil, nil);
        }
    }

    [self performRequestWithCompletion:refreshBlock];
}

- (void)setRepresentationRequestOptions:(NSArray *)representationOptions {
    [self.repsHelpers setRepresentationRequestOptions:representationOptions];
}

- (NSString *)formatRepresentationRequestHeader {
    return [self.repsHelpers formatRepresentationRequestHeader];
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
