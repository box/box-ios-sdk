//
//  BOXBookmarkDeleteRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXBookmarkDeleteRequest.h"
#import "BOXAPIJSONOperation.h"

@interface BOXBookmarkDeleteRequest ()

@property (nonatomic, readwrite, assign) BOOL isTrashed;

@end

@implementation BOXBookmarkDeleteRequest

- (instancetype)initWithBookmarkID:(NSString *)bookmarkID
{
    return [self initWithBookmarkID:bookmarkID isTrashed:NO];
}

- (instancetype)initWithBookmarkID:(NSString *)bookmarkID isTrashed:(BOOL)isTrashed
{
    if (self = [super init]) {
        _bookmarkID = bookmarkID;
        _isTrashed = isTrashed;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSString *subresource = nil;

    if (self.isTrashed) {
        subresource = BOXAPISubresourceTrash;
    }
    NSURL *URL = [self URLWithResource:BOXAPIResourceBookmarks
                                    ID:self.bookmarkID
                           subresource:subresource
                                 subID:nil];
    
    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodDELETE
                                              queryStringParameters:nil
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    if ([self.matchingEtag length] > 0) {
        [JSONoperation.APIRequest setValue:self.matchingEtag forHTTPHeaderField:BOXAPIHTTPHeaderIfMatch];
    }
    
    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXErrorBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *folderOperation = (BOXAPIJSONOperation *)self.operation;

    folderOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {

        if ([self.cacheClient respondsToSelector:@selector(cacheBookmarkDeleteRequest:error:)]) {
            [self.cacheClient cacheBookmarkDeleteRequest:self error:nil];
        }

        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil);
            } onMainThread:isMainThread];
        }
    };
    folderOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

        if ([self.cacheClient respondsToSelector:@selector(cacheBookmarkDeleteRequest:error:)]) {
            [self.cacheClient cacheBookmarkDeleteRequest:self error:error];
        }

        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(error);
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
