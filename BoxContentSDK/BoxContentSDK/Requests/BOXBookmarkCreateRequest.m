//
//  BOXBookmarkCreateRequest.m
//  BoxContentSDK
//

#import "BOXBookmarkCreateRequest.h"
#import "BOXBookmark.h"

@implementation BOXBookmarkCreateRequest

- (instancetype)initWithURL:(NSURL *)URL parentFolderID:(NSString *)parentFolderID
{
    if (self = [super init]) {
        _URL = URL;
        _parentFolderID = parentFolderID;
    }
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceBookmarks
                                    ID:nil
                           subresource:nil
                                 subID:nil];
    
    NSMutableDictionary *bodyDictionary =
        [NSMutableDictionary dictionaryWithDictionary:@{BOXAPIObjectKeyParent : @{BOXAPIObjectKeyID : self.parentFolderID},
                                                                                 BOXAPIObjectKeyURL : [self.URL absoluteString]}];
    
    if (self.bookmarkName.length > 0) {
        bodyDictionary[BOXAPIObjectKeyName] = self.bookmarkName;
    }
    
    if (self.bookmarkDescription.length > 0) {
        bodyDictionary[BOXAPIObjectKeyDescription] = self.bookmarkDescription;
    }
    
    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodPOST
                                              queryStringParameters:nil
                                                     bodyDictionary:bodyDictionary
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXBookmarkBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *bookmarkOperation = (BOXAPIJSONOperation *)self.operation;
    
    bookmarkOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
        BOXBookmark *bookmark = [[BOXBookmark alloc] initWithJSON:JSONDictionary];

        if ([self.cacheClient respondsToSelector:@selector(cacheBookmarkCreateRequest:withBookmark:error:)]) {
            [self.cacheClient cacheBookmarkCreateRequest:self
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

        if ([self.cacheClient respondsToSelector:@selector(cacheBookmarkCreateRequest:withBookmark:error:)]) {
            [self.cacheClient cacheBookmarkCreateRequest:self
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

@end
