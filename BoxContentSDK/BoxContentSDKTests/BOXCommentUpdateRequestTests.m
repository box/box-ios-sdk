//
//  BOXCommentUpdateRequestTests.m
//  BoxContentSDK
//
//  Created on 12/10/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXComment.h"
#import "BOXCommentUpdateRequest.h"

@interface BOXCommentUpdateRequestTests : BOXRequestTestCase

@end


@implementation BOXCommentUpdateRequestTests


- (void)test_request_url_is_correct
{
    NSString *commentID = @"98765";
    BOXCommentUpdateRequest *commentUpdateRequest = [[BOXCommentUpdateRequest alloc] initWithCommentID:commentID updatedMessage:nil]; 
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@", BOXAPIBaseURL, BOXAPIVersion, BOXAPIResourceComments, commentID]];
    XCTAssertEqualObjects(commentUpdateRequest.urlRequest.URL, url);
    XCTAssertEqualObjects(commentUpdateRequest.urlRequest.HTTPMethod, BOXAPIHTTPMethodPUT);
}

- (void)test_json_body_is_correct
{
    NSString *updatedMessage = @"This is a new Message";
    NSString *commentID = @"9875";
    
    BOXCommentUpdateRequest *commentUpdateRequest = [[BOXCommentUpdateRequest alloc] initWithCommentID:commentID updatedMessage:updatedMessage];
    
    NSData *data = commentUpdateRequest.urlRequest.HTTPBody;
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    XCTAssertEqualObjects(bodyDictionary[BOXAPIObjectKeyMessage], updatedMessage);
}

- (void)test_request_returns_correct_comment
{
    BOXComment *originalComment = [self comment];
    originalComment.message = @"A different comment than the canned response";
    
    NSData *cannedData = [self cannedResponseDataWithName:@"comment_all_fields"];
    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:200 responseData:cannedData];
    
    NSDictionary *expectedResults = [NSJSONSerialization JSONObjectWithData:cannedData options:kNilOptions error:nil];
    BOXComment *expectedComment = [[BOXComment alloc] initWithJSON:expectedResults];
    
    BOXCommentUpdateRequest *commentUpdateRequest = [[BOXCommentUpdateRequest alloc] initWithCommentID:originalComment.modelID updatedMessage:expectedComment.message];
    [self setCannedURLResponse:response cannedResponseData:cannedData forRequest:commentUpdateRequest];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [commentUpdateRequest performRequestWithCompletion:^(BOXComment *comment, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(comment);
        XCTAssertEqualObjects(comment.message, expectedComment.message);
        XCTAssertEqualObjects(comment.modelID, expectedComment.modelID);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

#pragma mark - Private Helpers

- (BOXComment *)comment
{
    NSData *data = [self cannedResponseDataWithName:@"comment_all_fields"];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    return [[BOXComment alloc] initWithJSON:dict];
}

@end
