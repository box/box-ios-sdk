//
//  BOXBookmarkShareRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXBookmarkShareRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXBookmark.h"

@interface BOXBookmarkShareRequest ()

@property (nonatomic, readwrite, strong) NSString *bookmarkID;
@property (nonatomic, readwrite, assign) BOOL shouldUseCanDownload;
@property (nonatomic, readwrite, assign) BOOL shouldUseCanPreview;

@end

@implementation BOXBookmarkShareRequest

@synthesize canDownload = _canDownload;
@synthesize canPreview = _canPreview;

- (instancetype)initWithBookmarkID:(NSString *)bookmarkID
{
    if (self = [super init]) {
        _bookmarkID = bookmarkID;
    }

    return self;
}

- (void)setCanDownload:(BOOL)canDownload
{
    self.shouldUseCanDownload = YES;

    _canDownload = canDownload;
}

- (void)setCanPreview:(BOOL)canPreview
{
    self.shouldUseCanPreview = YES;

    _canPreview = canPreview;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceBookmarks
                                    ID:self.bookmarkID
                           subresource:nil
                                 subID:nil];

    NSMutableDictionary *sharedLinkDictionary = [NSMutableDictionary dictionary];

    if (self.accessLevel.length > 0 || self.expirationDate != nil || self.shouldUseCanDownload || self.shouldUseCanPreview || self.removeExpirationDate) {
        sharedLinkDictionary[BOXAPIObjectKeyAccess] = self.accessLevel.length > 0 ? self.accessLevel : [NSNull null];

        if (self.removeExpirationDate) {
            sharedLinkDictionary[BOXAPIObjectKeyUnsharedAt] = [NSNull null];
        } else if (self.expirationDate != nil) {
            sharedLinkDictionary[BOXAPIObjectKeyUnsharedAt] = [self.expirationDate box_ISO8601String];
        }

        if (self.shouldUseCanDownload || self.shouldUseCanPreview) {
            NSMutableDictionary *permissionsDictionary = [NSMutableDictionary dictionary];

            if (self.shouldUseCanDownload) {
                permissionsDictionary[BOXAPIObjectKeyCanDownload] = [NSNumber numberWithBool:self.canDownload];
            }

            if (self.shouldUseCanPreview) {
                permissionsDictionary[BOXAPIObjectKeyCanPreview] = [NSNumber numberWithBool:self.canPreview];
            }
            sharedLinkDictionary[BOXAPIObjectKeyPermissions] = permissionsDictionary;
        }
    }

    NSDictionary *bodyDictionary = @{BOXAPIObjectKeySharedLink: sharedLinkDictionary};

    NSDictionary *queryParameters = @{BOXAPIParameterKeyFields: [self fullBookmarkFieldsParameterString]};
    
    BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodPUT
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:bodyDictionary
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    if ([self.matchingEtag length] > 0) {
        // Set up the If-Match header
        [JSONOperation.APIRequest setValue:self.matchingEtag forHTTPHeaderField:BOXAPIHTTPHeaderIfMatch];
    }

    [self addSharedLinkHeaderToRequest:JSONOperation.APIRequest];

    return JSONOperation;
}

- (void)performRequestWithCompletion:(BOXBookmarkBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *bookmarkOperation = (BOXAPIJSONOperation *)self.operation;

    bookmarkOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
        if (completionBlock) {
            BOXBookmark *bookmark = [[BOXBookmark alloc] initWithJSON:JSONDictionary];
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(bookmark, nil);
            } onMainThread:isMainThread];
        }
    };
    bookmarkOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
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
    return self.bookmarkID;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeWebLink;
}

@end
