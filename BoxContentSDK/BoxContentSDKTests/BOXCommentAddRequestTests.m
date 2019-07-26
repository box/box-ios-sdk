//
//  BOXCommentAddRequestTests.m
//  BoxContentSDK
//
//  Created on 12/10/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXRequest_Private.h"
#import "BOXCommentAddRequest.h"
#import "BOXFile.h"
#import "BOXComment.h"
#import "BOXBookmark.h"
#import "BOXContentCacheTestClient.h"

@interface BOXCommentAddRequestTests : BOXRequestTestCase

@end

@implementation BOXCommentAddRequestTests 
    
- (void)test_request_url_is_correct
{
    BOXFile *file = [self file];
    BOXCommentAddRequest *commentAddRequest = [[BOXCommentAddRequest alloc] initWithFileID:file.modelID message:nil];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [BOXContentClient APIBaseURL], BOXAPIResourceComments]];
    XCTAssertEqualObjects(commentAddRequest.urlRequest.URL, url);
    XCTAssertEqualObjects(commentAddRequest.urlRequest.HTTPMethod, BOXAPIHTTPMethodPOST);
}

- (void)test_json_body_is_correct_when_commenting_a_file
{
    BOXFile *file = [self file];
    NSString *message = @"My comment";
    BOXCommentAddRequest *commentAddRequest = [[BOXCommentAddRequest alloc] initWithFileID:file.modelID message:message];
    
    NSData *data = commentAddRequest.urlRequest.HTTPBody;
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSDictionary *expectedDictionary = @{BOXAPIObjectKeyItem : @{BOXAPIObjectKeyType : file.type,
                                                                 BOXAPIObjectKeyID : file.modelID},
                                         BOXAPIObjectKeyMessage : message};
    XCTAssertEqualObjects(expectedDictionary, bodyDictionary);
}


- (void)test_json_body_is_correct_when_commenting_a_bookmark
{
    BOXBookmark *bookmark = [self bookmark];
    NSString *message = @"My comment";
    BOXCommentAddRequest *commentAddRequest = [[BOXCommentAddRequest alloc] initWithBookmarkID:bookmark.modelID message:message];
    
    NSData *data = commentAddRequest.urlRequest.HTTPBody;
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSDictionary *expectedDictionary = @{BOXAPIObjectKeyItem : @{BOXAPIObjectKeyType : bookmark.type,
                                                                 BOXAPIObjectKeyID : bookmark.modelID},
                                         BOXAPIObjectKeyMessage : message};
    XCTAssertEqualObjects(expectedDictionary, bodyDictionary);
}


- (void)test_json_body_is_correct_when_replying_to_a_comment
{
    BOXComment *comment = [self comment];
    NSString *message = @"My comment";
    BOXCommentAddRequest *commentAddRequest = [[BOXCommentAddRequest alloc] initWithCommentID:comment.modelID message:message];
    
    NSData *data = commentAddRequest.urlRequest.HTTPBody;
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSDictionary *expectedDictionary = @{BOXAPIObjectKeyItem : @{BOXAPIObjectKeyType : comment.type,
                                                                 BOXAPIObjectKeyID : comment.modelID},
                                         BOXAPIObjectKeyMessage : message};
    XCTAssertEqualObjects(expectedDictionary, bodyDictionary);
}

- (void)test_request_returns_correct_comment
{
    BOXFile *file = [self file];
    BOXCommentAddRequest *commentAddRequest = [[BOXCommentAddRequest alloc] initWithFileID:file.modelID message:nil];
    BOXContentCacheTestClient *cacheClient = [[BOXContentCacheTestClient alloc] init];
    commentAddRequest.cacheClient = cacheClient;

    id cacheClientMock = [OCMockObject partialMockForObject:cacheClient];
   
    NSData *cannedData = [self cannedResponseDataWithName:@"comment_all_fields"];
    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:200 responseData:cannedData];
    
    NSDictionary *expectedResults = [NSJSONSerialization JSONObjectWithData:cannedData options:kNilOptions error:nil];
    BOXComment *expectedComment = [[BOXComment alloc] initWithJSON:expectedResults];
    
    [self setCannedURLResponse:response cannedResponseData:cannedData forRequest:commentAddRequest];

    [[cacheClientMock expect] cacheAddCommentRequest:commentAddRequest
                                         withComment:[OCMArg isNotNil]
                                               error:nil];

    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];

    [commentAddRequest performRequestWithCompletion:^(BOXComment *comment, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(comment);
        [self assertModel:comment isEquivalentTo:expectedComment];
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    [cacheClientMock verify];
}

- (void)test_request_handles_error
{
    BOXFile *file = [self file];
    BOXCommentAddRequest *commentAddRequest = [[BOXCommentAddRequest alloc] initWithFileID:file.modelID message:nil];
    BOXContentCacheTestClient *cacheClient = [[BOXContentCacheTestClient alloc] init];
    commentAddRequest.cacheClient = cacheClient;

    id cacheClientMock = [OCMockObject partialMockForObject:cacheClient];

    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:404 responseData:nil];

    [self setCannedURLResponse:response cannedResponseData:nil forRequest:commentAddRequest];

    [[cacheClientMock expect] cacheAddCommentRequest:commentAddRequest
                                         withComment:nil
                                               error:[OCMArg isNotNil]];

    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];

    [commentAddRequest performRequestWithCompletion:^(BOXComment *comment, NSError *error) {
        XCTAssertNotNil(error);
        XCTAssertNil(comment);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    [cacheClientMock verify];
}

#pragma mark - Private Helpers

// Should we try to get a factory system similarly to the main app ?
- (BOXFile *)file
{
    NSData *data = [self cannedResponseDataWithName:@"file_default_fields"];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    return [[BOXFile alloc] initWithJSON:dict];
}

- (BOXBookmark *)bookmark
{
    NSData *data = [self cannedResponseDataWithName:@"bookmark_default_fields"];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    return [[BOXBookmark alloc] initWithJSON:dict];
}

- (BOXComment *)comment
{
    NSData *data = [self cannedResponseDataWithName:@"comment_all_fields"];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    return [[BOXComment alloc] initWithJSON:dict];
}

@end
