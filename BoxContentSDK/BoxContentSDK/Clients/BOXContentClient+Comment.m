//
//  BOXClient+CommentAPI.m
//  BoxContentSDK
//
//  Created on 12/11/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXContentClient+Comment.h"
#import "BOXContentClient_Private.h"
#import "BOXCommentRequest.h"
#import "BOXFileCommentsRequest.h"
#import "BOXBookmarkCommentsRequest.h"
#import "BOXCommentAddRequest.h"
#import "BOXCommentDeleteRequest.h"
#import "BOXCommentUpdateRequest.h"

@implementation BOXContentClient (CommentAPI)


- (BOXFileCommentsRequest *)commentsRequestForFileWithID:(NSString *)fileID
{
    BOXFileCommentsRequest *request = [[BOXFileCommentsRequest alloc] initWithFileID:fileID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXBookmarkCommentsRequest *)commentsRequestForBookmarkWithID:(NSString *)bookmarkID
{
    BOXBookmarkCommentsRequest *request = [[BOXBookmarkCommentsRequest alloc] initWithBookmarkID:bookmarkID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXCommentRequest *)commentInfoRequestWithID:(NSString *)commentID
{
    BOXCommentRequest *request = [[BOXCommentRequest alloc] initWithCommentID:commentID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXCommentAddRequest *)commentAddRequestForFileWithID:(NSString *)fileID message:(NSString *)message
{
    BOXCommentAddRequest *request = [[BOXCommentAddRequest alloc] initWithFileID:fileID message:message];
    [self prepareRequest:request];
    
    return request;
}

- (BOXCommentAddRequest *)commentAddRequestForBookmarkWithID:(NSString *)bookmarkID message:(NSString *)message
{
    BOXCommentAddRequest *request = [[BOXCommentAddRequest alloc] initWithBookmarkID:bookmarkID message:message];
    [self prepareRequest:request];
    
    return request;
}
 
- (BOXCommentAddRequest *)commentReplyRequestToCommentWithID:(NSString *)commentID message:(NSString *)message
{
    BOXCommentAddRequest *request = [[BOXCommentAddRequest alloc] initWithCommentID:commentID message:message];
    [self prepareRequest:request];
    
    return request;
}

- (BOXCommentDeleteRequest *)commentDeleteRequestWithID:(NSString *)commentID
{
    BOXCommentDeleteRequest *request = [[BOXCommentDeleteRequest alloc] initWithCommentID:commentID];
    [self prepareRequest:request];
    
    return request;
}

- (BOXCommentUpdateRequest *)commentUpdateRequestWithID:(NSString *)commentID newMessage:(NSString *)newMessage
{
    BOXCommentUpdateRequest *request = [[BOXCommentUpdateRequest alloc] initWithCommentID:commentID 
                                                                           updatedMessage:newMessage];
    [self prepareRequest:request];
    
    return request;
}


@end
