//
//  BOXBookmarkRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXBookmarkRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXBookmark.h"
#import "BOXSharedLinkHeadersHelper.h"

@interface BOXBookmarkRequest ()

@property (nonatomic, readwrite, strong) NSString *bookmarkID;

@end

@implementation BOXBookmarkRequest

- (instancetype)initWithBookmarkID:(NSString *)bookmarkID
{
    if (self = [super init]) {
        _bookmarkID = bookmarkID;
    }

    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceBookmarks
                                    ID:self.bookmarkID
                           subresource:nil
                                 subID:nil];

    NSDictionary *queryParameters = nil;
    if (self.requestAllBookmarkFields) {
        queryParameters = @{BOXAPIParameterKeyFields : [self fullBookmarkFieldsParameterString]};
    }

    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    if ([self.notMatchingEtags count] > 0) {
        // Set up the If-None-Match header
        for (NSString *notMatchingEtag in self.notMatchingEtags) {
            [JSONoperation.APIRequest addValue:notMatchingEtag forHTTPHeaderField:BOXAPIHTTPHeaderIfNoneMatch];
        }
    }
    [self addSharedLinkHeaderToRequest:JSONoperation.APIRequest];

    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXBookmarkBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *bookmarkOperation = (BOXAPIJSONOperation *)self.operation;

        bookmarkOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            BOXBookmark *bookmark = [[BOXBookmark alloc] initWithJSON:JSONDictionary];
            
            [self.sharedLinkHeadersHelper storeHeadersFromAncestorsIfNecessaryForItemWithID:bookmark.modelID
                                                                                   itemType:BOXAPIItemTypeWebLink
                                                                                  ancestors:bookmark.pathFolders];

            if ([self.cacheClient respondsToSelector:@selector(cacheBookmarkRequest:withBookmark:error:)]) {
                [self.cacheClient cacheBookmarkRequest:self
                                          withBookmark:bookmark
                                                 error:nil];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(bookmark, nil);
            } onMainThread:isMainThread];
        };
        bookmarkOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

            if ([self.cacheClient respondsToSelector:@selector(cacheBookmarkRequest:withBookmark:error:)]) {
                [self.cacheClient cacheBookmarkRequest:self
                                          withBookmark:nil
                                                 error:error];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        };

        [self performRequest];
    }
}

- (void)performRequestWithCached:(BOXBookmarkBlock)cacheBlock
                       refreshed:(BOXBookmarkBlock)refreshBlock
{
    if (cacheBlock) {
        if ([self.cacheClient respondsToSelector:@selector(retrieveCacheForBookmarkRequest:completion:)]) {
            [self.cacheClient retrieveCacheForBookmarkRequest:self completion:cacheBlock];
        } else {
            cacheBlock(nil, nil);
        }
    }

    [self performRequestWithCompletion:refreshBlock];
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
