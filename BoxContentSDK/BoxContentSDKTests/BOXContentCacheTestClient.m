//
//  BOXContentCacheTestClient.m
//  BoxContentSDK
//

#import "BOXRequest.h"
#import "BOXContentCacheTestClient.h"

@implementation BOXContentCacheTestClient

#pragma mark - Comments

- (void)cacheBookmarkCommentsRequest:(BOXBookmarkCommentsRequest *)request
                        withComments:(NSArray *)comments
                               error:(NSError *)error
{
    //Do nothing.
}

- (void)retrieveCacheForBookmarkCommentsRequest:(BOXBookmarkCommentsRequest *)request
                                     completion:(BOXObjectsArrayCompletionBlock)completionBlock
{
    //Do nothing.
}

- (void)cacheCommentRequest:(BOXCommentRequest *)request
                withComment:(BOXComment *)comment
                      error:(NSError *)error
{
    //Do nothing.
}

- (void)retrieveCacheForCommentRequest:(BOXCommentRequest *)request
                            completion:(BOXCommentBlock)completionBlock
{
    //Do nothing.
}

- (void)cacheAddCommentRequest:(BOXCommentAddRequest *)request
                   withComment:(BOXComment *)comment
                         error:(NSError *)error
{
    //Do nothing.
}

- (void)cacheDeleteCommentRequest:(BOXCommentDeleteRequest *)request
                            error:(NSError *)error
{
    //Do nothing.
}

- (void)cacheUpdateCommentRequest:(BOXCommentUpdateRequest *)request
                      withComment:(BOXComment *)comment
                            error:(NSError *)error
{
    //Do nothing.
}

- (void)cacheFileCommentsRequest:(BOXFileCommentsRequest *)request
                    withComments:(NSArray *)comments
                           error:(NSError *)error
{
    //Do nothing.
}

- (void)retrieveCacheForFileCommentsRequest:(BOXFileCommentsRequest *)request
                                 completion:(BOXObjectsArrayCompletionBlock)completionBlock
{
    //Do nothing.
}

@end
