//
//  BOXBookmarkUpdateRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXBookmarkUpdateRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXBookmark.h"
#import "BOXDispatchHelper.h"

@interface BOXBookmarkUpdateRequest ()
@property (nonatomic, readwrite, strong) NSString *bookmarkID;
@property (nonatomic, readwrite, assign) BOOL shouldUseSharedLinkCanDownload;
@property (nonatomic, readwrite, assign) BOOL shouldUseSharedLinkCanPreview;

@end

@implementation BOXBookmarkUpdateRequest

- (instancetype)initWithBookmarkID:(NSString *)bookmarkID
{
    if (self = [super init]) {
        _bookmarkID = bookmarkID;
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
    NSURL *URL = [self URLWithResource:BOXAPIResourceBookmarks
                                    ID:self.bookmarkID
                           subresource:nil
                                 subID:nil];
    
    // Body
    
    NSMutableDictionary *bodyDictionary = [[NSMutableDictionary alloc] init];
    
    if (self.URL != nil) {
        bodyDictionary[BOXAPIObjectKeyURL] = [self.URL absoluteString];
    }
    
    if (self.bookmarkName.length > 0) {
        bodyDictionary[BOXAPIObjectKeyName] = self.bookmarkName;
    }
    
    if (self.bookmarkDescription.length > 0) {
        bodyDictionary[BOXAPIObjectKeyDescription] = self.bookmarkDescription;
    }
    
    if (self.sharedLinkAccessLevel.length > 0 ||
            self.sharedLinkExpirationDate != nil ||
                self.shouldUseSharedLinkCanDownload ||
                    self.shouldUseSharedLinkCanPreview) {
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
    
    if (self.requestAllBookmarkFields) {
        queryParameters = @{BOXAPIParameterKeyFields : [self fullBookmarkFieldsParameterString]};
    }
    
    BOXAPIOperation *bookmarkOperation = nil;

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
        
        bookmarkOperation = dataOperation;
    } else {
        BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:URL
                                                             HTTPMethod:BOXAPIHTTPMethodPUT
                                                  queryStringParameters:queryParameters
                                                         bodyDictionary:bodyDictionary
                                                       JSONSuccessBlock:nil
                                                           failureBlock:nil];
        
        bookmarkOperation = JSONOperation;
    }
    
    if ([self.matchingEtag length] > 0) {
        [bookmarkOperation.APIRequest setValue:self.matchingEtag forHTTPHeaderField:BOXAPIHTTPHeaderIfMatch];
    }
    
    [self addSharedLinkHeaderToRequest:bookmarkOperation.APIRequest];

    return bookmarkOperation;
}

- (void)performRequestWithCompletion:(BOXBookmarkBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    
    if ([self shouldPerformBackgroundOperation]) {
        BOXAPIDataOperation *bookmarkOperation = (BOXAPIDataOperation *)self.operation;
        __weak BOXAPIDataOperation *weakBookmarkOperation = bookmarkOperation;
        bookmarkOperation.successBlock = ^(NSString *modelID, long long expectedTotalBytes) {
            NSData *data = [NSData dataWithContentsOfFile:weakBookmarkOperation.destinationPath];
            BOXBookmark *bookmark = nil;
            if (data != nil) {
                NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                bookmark = (BOXBookmark *)[[self class] itemWithJSON:jsonDictionary];
                
                if ([self.cacheClient respondsToSelector:@selector(cacheBookmarkUpdateRequest:withBookmark:error:)]) {
                    [self.cacheClient cacheBookmarkUpdateRequest:self
                                                    withBookmark:bookmark
                                                           error:nil];
                }
            }
            
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(bookmark, nil);
                } onMainThread:isMainThread];
            }
        };
        
        bookmarkOperation.failureBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
            if ([self.cacheClient respondsToSelector:@selector(cacheBookmarkUpdateRequest:withBookmark:error:)]) {
                [self.cacheClient cacheBookmarkUpdateRequest:self
                                                withBookmark:nil
                                                       error:error];
            }
            
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(nil, error);
                } onMainThread:isMainThread];
            }
        };
    } else {
        BOXAPIJSONOperation *bookmarkOperation = (BOXAPIJSONOperation *)self.operation;
        
        bookmarkOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            BOXBookmark *bookmark = [[BOXBookmark alloc] initWithJSON:JSONDictionary];
            
            if ([self.cacheClient respondsToSelector:@selector(cacheBookmarkUpdateRequest:withBookmark:error:)]) {
                [self.cacheClient cacheBookmarkUpdateRequest:self
                                                withBookmark:bookmark
                                                       error:nil];
            }
            
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(bookmark, nil);
                } onMainThread:isMainThread];
            }
        };
        bookmarkOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            
            if ([self.cacheClient respondsToSelector:@selector(cacheBookmarkUpdateRequest:withBookmark:error:)]) {
                [self.cacheClient cacheBookmarkUpdateRequest:self
                                                withBookmark:nil
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
    return self.bookmarkID;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeWebLink;
}

- (BOOL)shouldPerformBackgroundOperation
{
    return (self.associateID.length > 0 && self.requestDirectoryPath.length > 0);
}

@end
