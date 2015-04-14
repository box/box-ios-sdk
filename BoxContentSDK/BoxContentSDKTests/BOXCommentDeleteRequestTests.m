//
//  BOXCommentDeleteRequestTests.m
//  BoxContentSDK
//
//  Created on 12/10/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXComment.h"
#import "BOXCommentDeleteRequest.h"

@interface BOXCommentDeleteRequestTests : BOXRequestTestCase

@end


@implementation BOXCommentDeleteRequestTests 

- (void)test_request_url_is_correct
{
    NSString *commentID = @"987654";
    
    BOXCommentDeleteRequest *commentDeleteRequest = [[BOXCommentDeleteRequest alloc] initWithCommentID:commentID];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@", BOXAPIBaseURL, BOXAPIVersion, BOXAPIResourceComments, commentID]];

    XCTAssertEqualObjects(url, commentDeleteRequest.urlRequest.URL);
    XCTAssertEqualObjects(BOXAPIHTTPMethodDELETE, commentDeleteRequest.urlRequest.HTTPMethod);
}


@end