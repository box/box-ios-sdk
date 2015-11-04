//
//  BOXBookmarkCommentsRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXBookmarkCommentsRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXComment.h"

@interface BOXBookmarkCommentsRequest ()

@property (nonatomic, readwrite, strong) NSString *bookmarkID;

@end

@implementation BOXBookmarkCommentsRequest 

- (instancetype)initWithBookmarkID:(NSString *)bookmarkID
{
    if (self = [super init]) {
        _bookmarkID = bookmarkID;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    BOXAPIOperation *operation = nil;
    
    NSURL *url = [self URLWithResource:BOXAPIResourceBookmarks
                                    ID:self.bookmarkID
                           subresource:BOXAPISubresourceComments
                                 subID:nil];
    
    operation = [self JSONOperationWithURL:url 
                                HTTPMethod:BOXAPIHTTPMethodGET 
                     queryStringParameters:nil 
                            bodyDictionary:nil 
                          JSONSuccessBlock:nil 
                              failureBlock:nil];
    
    return operation;
}


- (void)performRequestWithCompletion:(BOXObjectsArrayCompletionBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *commentsOperation = (BOXAPIJSONOperation *)self.operation;

        commentsOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            NSArray *comments = [self commentsFromJSONDictionary:JSONDictionary];

            if ([self.cacheClient respondsToSelector:@selector(cacheBookmarkCommentsRequest:withComments:error:)]) {
                [self.cacheClient cacheBookmarkCommentsRequest:self
                                                  withComments:comments
                                                         error:nil];
            }
            
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(comments ,nil);
            } onMainThread:isMainThread];
        };
        commentsOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

            if ([self.cacheClient respondsToSelector:@selector(cacheBookmarkCommentsRequest:withComments:error:)]) {
                [self.cacheClient cacheBookmarkCommentsRequest:self
                                                  withComments:nil
                                                         error:error];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil,error);
            } onMainThread:isMainThread];
        };

        [self performRequest];
    }
}

- (void)performRequestWithCached:(BOXObjectsArrayCompletionBlock)cacheBlock
                       refreshed:(BOXObjectsArrayCompletionBlock)refreshBlock
{
    if (cacheBlock) {
        if ([self.cacheClient respondsToSelector:@selector(retrieveCacheForBookmarkCommentsRequest:completion:)]) {
            [self.cacheClient retrieveCacheForBookmarkCommentsRequest:self
                                                           completion:cacheBlock];
        } else {
            cacheBlock(nil, nil);
        }
    }

    [self performRequestWithCompletion:refreshBlock];
}

#pragma mark - Private Helpers

- (NSArray *)commentsFromJSONDictionary:(NSDictionary *)JSONDictionary
{
    NSArray *commentsDicts = JSONDictionary[@"entries"];
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:commentsDicts.count];
    
    for (NSDictionary *dict in commentsDicts) {
        [comments addObject:[[BOXComment alloc] initWithJSON:dict]];
    }
    
    return comments;
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
