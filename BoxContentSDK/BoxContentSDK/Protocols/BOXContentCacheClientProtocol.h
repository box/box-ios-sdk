//
//  BOXContentCacheClientProtocol.h
//  BoxContentSDK
//
//  Created by Scott Liu on 10/13/15.
//  Copyright © 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BOXBookmarkCommentsRequest;
@class BOXCommentRequest;
@class BOXCommentAddRequest;
@class BOXCommentDeleteRequest;
@class BOXCommentUpdateRequest;
@class BOXFileCommentsRequest;

@protocol BOXContentCacheClientProtocol <NSObject>

@optional

#pragma mark - Comments

- (void)cacheBookmarkCommentsRequest:(BOXBookmarkCommentsRequest *)request
                        withComments:(NSArray *)comments
                               error:(NSError *)error;

- (void)retrieveCacheForBookmarkCommentsRequest:(BOXBookmarkCommentsRequest *)request
                                     completion:(BOXObjectsArrayCompletionBlock)completionBlock;

- (void)cacheCommentRequest:(BOXCommentRequest *)request
                withComment:(BOXComment *)comment
                      error:(NSError *)error;

- (void)retrieveCacheForCommentRequest:(BOXCommentRequest *)request
                            completion:(BOXCommentBlock)completionBlock;

- (void)cacheAddCommentRequest:(BOXCommentAddRequest *)request
                   withComment:(BOXComment *)comment
                         error:(NSError *)error;

- (void)cacheDeleteCommentRequest:(BOXCommentDeleteRequest *)request
                            error:(NSError *)error;

- (void)cacheUpdateCommentRequest:(BOXCommentUpdateRequest *)request
                      withComment:(BOXComment *)comment
                            error:(NSError *)error;

- (void)cacheFileCommentsRequest:(BOXFileCommentsRequest *)request
                    withComments:(NSArray *)comments
                           error:(NSError *)error;

- (void)retrieveCacheForFileCommentsRequest:(BOXFileCommentsRequest *)request
                                 completion:(BOXObjectsArrayCompletionBlock)completionBlock;

@end
