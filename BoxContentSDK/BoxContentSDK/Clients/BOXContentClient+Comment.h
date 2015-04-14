//
//  BOXClient+CommentAPI.h
//  BoxContentSDK
//
//  Created on 12/11/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXContentClient.h"

@class BOXCommentRequest;
@class BOXCommentAddRequest;
@class BOXCommentDeleteRequest;
@class BOXCommentUpdateRequest;
@class BOXFileCommentsRequest;
@class BOXBookmarkCommentsRequest;

@interface BOXContentClient (CommentAPI)

/**
 *  Generate a request to retrieve the comments that have been made on a file.
 *
 *  @param fileID File ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXFileCommentsRequest *)commentsRequestForFileWithID:(NSString *)fileID;

/**
 *  Generate a request to retrieve the comments that have been made on a bookmark.
 *
 *  @param bookmarkID File ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXBookmarkCommentsRequest *)commentsRequestForBookmarkWithID:(NSString *)bookmarkID;

/**
 *  Generate a request to retrieve information about a comment.
 *
 *  @param commentID Comment ID.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXCommentRequest *)commentInfoRequestWithID:(NSString *)commentID;

/**
 *  Generate a request to add a comment to a file.
 *
 *  @param fileID  File ID.
 *  @param message Comment message.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXCommentAddRequest *)commentAddRequestForFileWithID:(NSString *)fileID message:(NSString *)message;

/**
 *  Generate a request to add a comment to a bookmark.
 *
 *  @param bookmarkID  Bookmark ID.
 *  @param message Comment message.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXCommentAddRequest *)commentAddRequestForBookmarkWithID:(NSString *)bookmarkID message:(NSString *)message;

/**
 *  Generate a request to reply to a comment.
 *
 *  @param commentID Comment ID of the comment that you are replying to.
 *  @param message   Reply comment message.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXCommentAddRequest *)commentReplyRequestToCommentWithID:(NSString *)commentID message:(NSString *)message;

/**
 *  Generate a request to delete a comment.
 *
 *  @param commentID Comment ID of the comment to be deleted.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXCommentDeleteRequest *)commentDeleteRequestWithID:(NSString *)commentID;

/**
 *  Generate a request to update the message of a comment.
 *
 *  @param commentID  Comment ID of the comment to be updated.
 *  @param newMessage New comment message.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXCommentUpdateRequest *)commentUpdateRequestWithID:(NSString *)commentID newMessage:(NSString *)newMessage;

@end
