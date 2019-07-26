//
//  BOXFileUpdateRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/12/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXFileUpdateRequest.h"
#import "BOXFile.h"
#import "BOXRequest_Private.h"
#import "NSURL+BOXURLHelper.h"

@interface BOXFileUpdateRequestTests : BOXRequestTestCase
@end

@implementation BOXFileUpdateRequestTests

- (void)test_that_update_request_with_no_params_has_expected_URLRequest
{
    NSString *fileID = @"123";
    BOXFileUpdateRequest *request = [[BOXFileUpdateRequest alloc] initWithFileID:fileID];
    
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/%@", [BOXContentClient APIBaseURL], fileID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"PUT", URLRequest.HTTPMethod);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
}

- (void)test_shared_link_properties
{
    NSString *fileID = @"123";
    BOXFileUpdateRequest *request = [[BOXFileUpdateRequest alloc] initWithFileID:fileID];
    
    XCTAssertEqualObjects([request itemIDForSharedLink], fileID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeFile);    
}

- (void)test_that_update_request_with_all_possible_params_has_expected_URLRequest
{
    NSString *fileID = @"123";
    NSString *newName = @"Hello";
    NSString *newParentFolderID = @"456";
    NSString *newDescription = @"Star trek rules. Star wars sucks.";
    NSString *matchingEtag = @"5849054tsefs";
    
    BOXSharedLinkAccessLevel *newAccessLevel = BOXSharedLinkAccessLevelCollaborators;
    NSDate *newSharedLinkExpirationDate = [NSDate distantFuture];
    BOOL newSharedLinkPermissionCanDownload = YES;
    BOOL newSharedLinkPermissionCanPreview = YES;
    
    BOXFileUpdateRequest *request = [[BOXFileUpdateRequest alloc] initWithFileID:fileID];
    request.requestAllFileFields = YES;
    request.fileName = newName;
    request.fileDescription = newDescription;
    request.parentID = newParentFolderID;
    request.sharedLinkAccessLevel = newAccessLevel;
    request.sharedLinkExpirationDate = newSharedLinkExpirationDate;
    request.sharedLinkPermissionCanDownload = newSharedLinkPermissionCanDownload;
    request.sharedLinkPermissionCanPreview = newSharedLinkPermissionCanPreview;
    request.matchingEtag = matchingEtag;
    
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    XCTAssertEqualObjects(@"PUT", URLRequest.HTTPMethod);
    
    NSString *expectedURLWithoutQueryString = [NSString stringWithFormat:@"%@/files/%@", [BOXContentClient APIBaseURL], fileID];
    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURLWithoutQueryString, actualURLWithoutQueryString);
    
    NSString *expectedFieldsString = [[[BOXRequest alloc] init] fullFileFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, [[[URLRequest.URL box_queryDictionary] objectForKey:@"fields"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{@"name" : newName,
                                             @"parent" : @{@"id" : newParentFolderID},
                                             @"description" : newDescription,
                                             @"shared_link" : @{@"access" : @"collaborators",
                                                                @"permissions" : @{@"can_download" : @1,
                                                                                   @"can_preview" : @1},
                                                                @"unshared_at" : [newSharedLinkExpirationDate box_ISO8601String]}
                                             };
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
    
    // HTTP header assertions
    NSString *actualIfMatchHeader = [URLRequest.allHTTPHeaderFields objectForKey:@"If-Match"];
    XCTAssertEqualObjects(matchingEtag, actualIfMatchHeader);
}

- (void)test_that_expected_file_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"file_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    
    // Expected BoxFolder response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXFile *expectedFile = [[BOXFile alloc] initWithJSON:jsonDictionary];
    
    // Set up BOXFolderRequest and attach canned response to it.
    BOXFileUpdateRequest *request = [[BOXFileUpdateRequest alloc] initWithFileID:expectedFile.modelID];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    // Peform request and assert that we received the expectedFolder as a response.
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(BOXFile *file, NSError *error) {
        [self assertModel:expectedFile isEquivalentTo:file];
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}


@end
