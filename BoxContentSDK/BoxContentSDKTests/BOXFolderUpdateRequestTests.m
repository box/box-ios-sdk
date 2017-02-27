//
//  BOXFolderUpdateRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/10/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXFolderUpdateRequest.h"
#import "BOXRequest_Private.h"
#import "BOXFolder.h"
#import "NSURL+BOXURLHelper.h"

@interface BOXFolderUpdateRequestTests : BOXRequestTestCase
@end

@implementation BOXFolderUpdateRequestTests

- (void)test_that_update_request_with_no_params_has_expected_URLRequest
{
    NSString *folderID = @"123";
    BOXFolderUpdateRequest *request = [[BOXFolderUpdateRequest alloc] initWithFolderID:folderID];
    
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/folders/%@", [BOXContentClient APIBaseURL], folderID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"PUT", URLRequest.HTTPMethod);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
}

- (void)test_shared_link_properties
{
    NSString *folderID = @"123";
    BOXFolderUpdateRequest *request = [[BOXFolderUpdateRequest alloc] initWithFolderID:folderID];
    
    XCTAssertEqualObjects([request itemIDForSharedLink], folderID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeFolder);    
}

- (void)test_that_update_request_with_all_possible_params_has_expected_URLRequest
{
    NSString *folderID = @"123";
    NSString *newName = @"Hello";
    NSString *newParentFolderID = @"456";
    NSString *newDescription = @"Star trek rules. Star wars sucks.";
    
    BOXSharedLinkAccessLevel *newAccessLevel = BOXSharedLinkAccessLevelCollaborators;
    NSDate *newSharedLinkExpirationDate = [NSDate distantFuture];
    BOOL newSharedLinkPermissionCanDownload = YES;
    BOOL newSharedLinkPermissionCanPreview = YES;
    
    NSString *newFolderUploadEmailAddress = @"captain_kirk@trek.com";
    BOXFolderUploadEmailAccessLevel *newFolderUploadEmailAccess = BOXFolderUploadEmailAccessLevelCollaborators;
    NSString *newOwnerUserID = @"54395";
    NSString *newSyncState = @"not_synced";
    NSString *matchingEtag = @"5849054tsefs";
    
    BOXFolderUpdateRequest *request = [[BOXFolderUpdateRequest alloc] initWithFolderID:folderID];
    request.requestAllFolderFields = YES;
    request.folderName = newName;
    request.folderDescription = newDescription;
    request.parentID = newParentFolderID;
    request.sharedLinkAccessLevel = newAccessLevel;
    request.sharedLinkExpirationDate = newSharedLinkExpirationDate;
    request.sharedLinkPermissionCanDownload = newSharedLinkPermissionCanDownload;
    request.sharedLinkPermissionCanPreview = newSharedLinkPermissionCanPreview;
    request.folderUploadEmailAddress = newFolderUploadEmailAddress;
    request.folderUploadEmailAccess = newFolderUploadEmailAccess;
    request.ownerUserID = newOwnerUserID;
    request.syncState = newSyncState;
    request.matchingEtag = matchingEtag;
    
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    XCTAssertEqualObjects(@"PUT", URLRequest.HTTPMethod);
    
    NSString *expectedURLWithoutQueryString = [NSString stringWithFormat:@"%@/folders/%@", [BOXContentClient APIBaseURL], folderID];
    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];
    XCTAssertEqualObjects(expectedURLWithoutQueryString, actualURLWithoutQueryString);
    
    NSString *expectedFieldsString = [[[BOXRequest alloc] init] fullFolderFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, [[[URLRequest.URL box_queryDictionary] objectForKey:@"fields"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    // HTTP body assertions
    NSDictionary *expectedBodyDictionary = @{@"name" : newName,
                                             @"parent" : @{@"id" : newParentFolderID},
                                             @"description" : newDescription,
                                             @"shared_link" : @{@"access" : @"collaborators",
                                                                @"permissions" : @{@"can_download" : @1,
                                                                                   @"can_preview" : @1},
                                                                @"unshared_at" : [newSharedLinkExpirationDate box_ISO8601String]},
                                             @"folder_upload_email" : @{@"email" : newFolderUploadEmailAddress,
                                                                        @"access" : newFolderUploadEmailAccess},
                                             @"owned_by" : @{@"id" : newOwnerUserID},
                                             @"sync_state" : newSyncState};
    NSDictionary *actualBodyDictionary = [NSJSONSerialization JSONObjectWithData:URLRequest.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(expectedBodyDictionary, actualBodyDictionary);
    
    // HTTP header assertions
    NSString *actualIfMatchHeader = [URLRequest.allHTTPHeaderFields objectForKey:@"If-Match"];
    XCTAssertEqualObjects(matchingEtag, actualIfMatchHeader);
}

- (void)test_that_expected_folder_is_returned_when_request_is_performed
{
    // Canned response json.
    NSData *cannedResponseData = [self cannedResponseDataWithName:@"folder_default_fields"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    
    // Expected BoxFolder response object based on the same canned response json.
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:cannedResponseData options:kNilOptions error:nil];
    BOXFolder *expectedFolder = [[BOXFolder alloc] initWithJSON:jsonDictionary];
    
    // Set up BOXFolderRequest and attach canned response to it.
    BOXFolderUpdateRequest *request = [[BOXFolderUpdateRequest alloc] initWithFolderID:expectedFolder.modelID];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    // Peform request and assert that we received the expectedFolder as a response.
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(BOXFolder *folder, NSError *error) {
        [self assertModel:expectedFolder isEquivalentTo:folder];
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
