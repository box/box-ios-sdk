//
//  BOXCommentRequestTests.m
//  BoxContentSDK
//
//  Created on 12/10/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXCommentRequest.h"
#import "BOXComment.h"

@interface BOXCommentRequestTests : BOXRequestTestCase

@end


@implementation BOXCommentRequestTests 

- (void)test_request_url_is_correct
{
    NSString *commentID = @"987654";
    
    BOXCommentRequest *commentDeleteRequest = [[BOXCommentRequest  alloc] initWithCommentID:commentID];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@", BOXAPIBaseURL, BOXAPIVersion, BOXAPIResourceComments, commentID]];
    
    XCTAssertEqualObjects(url, commentDeleteRequest.urlRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodGET, commentDeleteRequest.urlRequest.HTTPMethod);
}

- (void)test_request_returns_correct_comment
{
    NSData *cannedData = [self cannedResponseDataWithName:@"comment_all_fields"];
    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:200 responseData:cannedData];

    NSDictionary *expectedResults = [NSJSONSerialization JSONObjectWithData:cannedData options:kNilOptions error:nil];
    BOXComment *expectedComment = [[BOXComment alloc] initWithJSON:expectedResults];
    
    BOXCommentRequest *commentRequest = [[BOXCommentRequest alloc] initWithCommentID:expectedComment.modelID];
    [self setCannedURLResponse:response cannedResponseData:cannedData forRequest:commentRequest];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [commentRequest performRequestWithCompletion:^(BOXComment *comment, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(comment);
        [self assertModel:comment isEquivalentTo:expectedComment];
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end