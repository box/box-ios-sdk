//
//  BOXBookmarkCopyRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXBookmarkCopyRequest.h"
#import "BOXAPIJSONOperation.h"
#import "BOXBookmark.h"

@implementation BOXBookmarkCopyRequest

- (instancetype)initWithBookmarkID:(NSString *)bookmarkID
               destinationFolderID:(NSString *)destinationFolderID
{
    if (self = [super init]) {
        _bookmarkID = bookmarkID;
        _destinationFolderID = destinationFolderID;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceBookmarks
                                    ID:self.bookmarkID
                           subresource:BOXAPISubresourceCopy
                                 subID:nil];
    
    NSMutableDictionary *bodyDictionary = [NSMutableDictionary dictionary];
    
    if (self.destinationFolderID.length > 0) {
        bodyDictionary[BOXAPIObjectKeyParent] = @{BOXAPIObjectKeyID : self.destinationFolderID};
    }
    
    if (self.bookmarkName.length > 0) {
        bodyDictionary[BOXAPIObjectKeyName] = self.bookmarkName;
    }
    
    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodPOST
                                              queryStringParameters:nil
                                                     bodyDictionary:bodyDictionary
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    
    [self addSharedLinkHeaderToRequest:JSONoperation.APIRequest];
    
    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXBookmarkBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *fileOperation = (BOXAPIJSONOperation *)self.operation;

    fileOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
        BOXBookmark *bookmark = [[BOXBookmark alloc] initWithJSON:JSONDictionary];

        if ([self.cacheClient respondsToSelector:@selector(cacheBookmarkCopyRequest:withBookmark:error:)]) {
            [self.cacheClient cacheBookmarkCopyRequest:self
                                          withBookmark:bookmark
                                                 error:nil];
        }
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(bookmark, nil);
            } onMainThread:isMainThread];
        }
    };
    fileOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
        if ([self.cacheClient respondsToSelector:@selector(cacheBookmarkCopyRequest:withBookmark:error:)]) {
            [self.cacheClient cacheBookmarkCopyRequest:self
                                          withBookmark:nil
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
    return self.bookmarkID;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeWebLink;
}

@end
