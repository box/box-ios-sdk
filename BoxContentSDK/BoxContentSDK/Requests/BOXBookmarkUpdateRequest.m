//
//  BOXBookmarkUpdateRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXBookmarkUpdateRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXBookmark.h"

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
    
    BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodPUT
                                              queryStringParameters:nil
                                                     bodyDictionary:bodyDictionary
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    
    if ([self.matchingEtag length] > 0) {
        [JSONOperation.APIRequest setValue:self.matchingEtag forHTTPHeaderField:BOXAPIHTTPHeaderIfMatch];
    }
    
    [self addSharedLinkHeaderToRequest:JSONOperation.APIRequest];

    return JSONOperation;
}

- (void)performRequestWithCompletion:(BOXBookmarkBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *fileOperation = (BOXAPIJSONOperation *)self.operation;

    if (completionBlock) {
        fileOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            BOXBookmark *bookmark = [[BOXBookmark alloc] initWithJSON:JSONDictionary];
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(bookmark, nil);
            } onMainThread:isMainThread];
        };
        fileOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
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

@end
