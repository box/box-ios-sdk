//
//  BOXRequestTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 11/25/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXRequest_Private.h"
#import "BOXAPIOperation_Private.h"
#import "BOXAPIQueueManager.h"
#import "BOXAPIOAuth2ToJSONOperation.h"
#import "BOXDispatchHelper.h"

@interface BOXRequest (Testing)

- (void)performRequestWithCompletion:(void (^)(void))completion;

@end

@implementation BOXRequest (Testing)

- (void)performRequestWithCompletion:(void (^)(void))completionBlock {
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *operation = (BOXAPIJSONOperation *)self.operation;
    
    if (completionBlock) {
        operation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock();
            } onMainThread:isMainThread];
        };
        operation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock();
            } onMainThread:isMainThread];
        };
    }
    
    [self performRequest];
}

@end

@interface BOXRequest ()

- (NSString *)deviceModelName;
- (NSString *)userAgent;

@end

@interface BOXRequestTests : BOXRequestTestCase
@end

@implementation BOXRequestTests

- (void)test_that_full_fields_string_for_files_is_correct
{
    NSString *expectedFieldsString = @"type,id,sequence_id,etag,sha1,watermark_info,name,description,size,path_collection,created_at,modified_at,trashed_at,purged_at,content_created_at,content_modified_at,created_by,modified_by,owned_by,shared_link,parent,item_status,version_number,comment_count,permissions,lock,extension,is_package,has_collaborations,is_externally_owned,allowed_invitee_roles,default_invitee_role,allowed_shared_link_access_levels,collections,collection_memberships";
    NSString *actualFieldsString = [[[BOXRequest alloc] init] fullFileFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, actualFieldsString);
}

- (void)test_that_full_fields_string_for_folders_is_correct
{
    NSString *expectedFieldsString = @"type,id,sequence_id,etag,name,description,size,path_collection,created_at,modified_at,trashed_at,purged_at,content_created_at,content_modified_at,created_by,modified_by,owned_by,shared_link,parent,item_status,permissions,lock,extension,is_package,allowed_shared_link_access_levels,collections,collection_memberships,folder_upload_email,sync_state,has_collaborations,is_externally_owned,can_non_owners_invite,allowed_invitee_roles,default_invitee_role";
    NSString *actualFieldsString = [[[BOXRequest alloc] init] fullFolderFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, actualFieldsString);
}

- (void)test_that_full_fields_string_for_bookmarks_is_correct
{
    NSString *expectedFieldsString = @"type,id,sequence_id,etag,name,url,created_at,modified_at,description,path_collection,trashed_at,purged_at,created_by,modified_by,owned_by,parent,item_status,shared_link,comment_count,permissions,allowed_shared_link_access_levels,collections";
    NSString *actualFieldsString = [[[BOXRequest alloc] init] fullBookmarkFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, actualFieldsString);
}

- (void)test_that_full_fields_string_for_items_is_correct
{
    NSString *expectedFieldsString = @"type,id,sequence_id,etag,name,description,size,path_collection,created_at,modified_at,trashed_at,purged_at,content_created_at,content_modified_at,created_by,modified_by,owned_by,shared_link,parent,item_status,permissions,lock,extension,is_package,allowed_shared_link_access_levels,collections,collection_memberships,folder_upload_email,sync_state,has_collaborations,is_externally_owned,can_non_owners_invite,allowed_invitee_roles,default_invitee_role,sha1,watermark_info,version_number,comment_count,url";
    NSString *actualFieldsString = [[[BOXRequest alloc] init] fullItemFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, actualFieldsString);
}

- (void)test_that_full_fields_string_for_comments_is_correct
{
    NSString *expectedFieldsString = @"message,tagged_message,created_at,created_by,is_reply_comment,modified_at,item";
    NSString *actualFieldsString = [[[BOXRequest alloc] init] fullCommentFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, actualFieldsString);
}

- (void)test_that_full_fields_string_for_users_is_correct
{
    NSString *expectedFieldsString = @"type,id,name,login,created_at,modified_at,role,language,timezone,space_amount,space_used,max_upload_size,tracking_codes,can_see_managed_users,is_sync_enabled,is_external_collab_restricted,status,job_title,phone,address,avatar_url,has_custom_avatar,is_exempt_from_device_limits,is_exempt_from_login_verification,enterprise,is_boxnotes_creation_enabled";
    NSString *actualFieldsString = [[[BOXRequest alloc] init] fullUserFieldsParameterString];
    XCTAssertEqualObjects(expectedFieldsString, actualFieldsString);
}

- (void)test_that_invalid_grant_400_error_triggers_logout_notification
{
    BOXRequest *request = [[BOXRequest alloc] init];
    
    NSData *cannedResponseData =  [self cannedResponseDataWithName:@"invalid_grant"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:400 responseData:cannedResponseData];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    request.operation = [[BOXAPIJSONOperation alloc] initWithURL:[request URLWithResource:nil ID:nil subresource:nil subID:nil] HTTPMethod:BOXAPIHTTPMethodGET body:nil queryParams:nil session:request.queueManager.session];

    [request performRequest];

    [self expectationForNotification:BOXUserWasLoggedOutDueToErrorNotification object:nil handler:nil];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)test_that_unauthorized_device_400_error_triggers_logout_notification
{
    BOXRequest *request = [[BOXRequest alloc] init];
    
    NSData *cannedResponseData =  [self cannedResponseDataWithName:@"unauthorized_device"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:400 responseData:cannedResponseData];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    request.operation = [[BOXAPIJSONOperation alloc] initWithURL:[request URLWithResource:nil ID:nil subresource:nil subID:nil] HTTPMethod:BOXAPIHTTPMethodGET body:nil queryParams:nil session:request.queueManager.session];
    
    [request performRequest];
    
    [self expectationForNotification:BOXUserWasLoggedOutDueToErrorNotification object:nil handler:nil];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)test_that_exceeded_device_limit_400_error_triggers_logout_notification
{
    BOXRequest *request = [[BOXRequest alloc] init];
    
    NSData *cannedResponseData =  [self cannedResponseDataWithName:@"exceeded_device_limits"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:400 responseData:cannedResponseData];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    request.operation = [[BOXAPIJSONOperation alloc] initWithURL:[request URLWithResource:nil ID:nil subresource:nil subID:nil] HTTPMethod:BOXAPIHTTPMethodGET body:nil queryParams:nil session:request.queueManager.session];
    
    [request performRequest];
    
    [self expectationForNotification:BOXUserWasLoggedOutDueToErrorNotification object:nil handler:nil];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)test_that_missing_device_id_400_error_triggers_logout_notification
{
    BOXRequest *request = [[BOXRequest alloc] init];
    
    NSData *cannedResponseData =  [self cannedResponseDataWithName:@"missing_device_id"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:400 responseData:cannedResponseData];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    request.operation = [[BOXAPIJSONOperation alloc] initWithURL:[request URLWithResource:nil ID:nil subresource:nil subID:nil] HTTPMethod:BOXAPIHTTPMethodGET body:nil queryParams:nil session:request.queueManager.session];
    
    [request performRequest];
    
    [self expectationForNotification:BOXUserWasLoggedOutDueToErrorNotification object:nil handler:nil];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)test_that_unsupported_device_pinning_runtime_400_error_triggers_logout_notification
{
    BOXRequest *request = [[BOXRequest alloc] init];
    
    NSData *cannedResponseData =  [self cannedResponseDataWithName:@"unsupported_device_pinning_runtime"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:400 responseData:cannedResponseData];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    request.operation = [[BOXAPIJSONOperation alloc] initWithURL:[request URLWithResource:nil ID:nil subresource:nil subID:nil] HTTPMethod:BOXAPIHTTPMethodGET body:nil queryParams:nil session:request.queueManager.session];
    
    [request performRequest];
    
    [self expectationForNotification:BOXUserWasLoggedOutDueToErrorNotification object:nil handler:nil];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)test_that_account_deactivated_400_error_triggers_logout_notification
{
    BOXRequest *request = [[BOXRequest alloc] init];
    
    NSData *cannedResponseData =  [self cannedResponseDataWithName:@"account_deactivated"];
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:400 responseData:cannedResponseData];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    request.operation = [[BOXAPIJSONOperation alloc] initWithURL:[request URLWithResource:nil ID:nil subresource:nil subID:nil] HTTPMethod:BOXAPIHTTPMethodGET body:nil queryParams:nil session:request.queueManager.session];
    
    [request performRequest];
    
    [self expectationForNotification:BOXUserWasLoggedOutDueToErrorNotification object:nil handler:nil];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)test_that_forbidden_403_error_triggers_logout_notification_for_token_requests
{
    BOXRequest *request = [[BOXRequest alloc] init];
    
    NSData *cannedResponseData =  [self cannedResponseDataWithName:@"empty"]; // we don't care what the JSON response is, but we need valid json
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:403 responseData:cannedResponseData];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    // Specifically testing BOXAPIOAuth2ToJSONOperation because 403 in other operations should NOT trigger a logout.
    // (see test_that_forbidden_403_error_does_not_trigger_logout_notification_for_non_token_requests)
    request.operation = [[BOXAPIOAuth2ToJSONOperation alloc] initWithURL:[request URLWithResource:nil ID:nil subresource:nil subID:nil] HTTPMethod:BOXAPIHTTPMethodPOST body:nil queryParams:nil session:request.queueManager.session];
    
    [request performRequest];
    
    [self expectationForNotification:BOXUserWasLoggedOutDueToErrorNotification object:nil handler:nil];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)test_that_forbidden_403_error_does_not_trigger_logout_notification_for_non_token_requests
{
    BOXRequest *request = [[BOXRequest alloc] init];
    
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:403 responseData:nil];
    [self setCannedURLResponse:URLResponse cannedResponseData:nil forRequest:request];
    request.operation = [[BOXAPIJSONOperation alloc] initWithURL:[request URLWithResource:nil ID:nil subresource:nil subID:nil] HTTPMethod:BOXAPIHTTPMethodGET body:nil queryParams:nil session:request.queueManager.session];

    id operationMock = [OCMockObject partialMockForObject:request.operation];
    [[operationMock reject] sendLogoutNotification];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^{
        XCTAssertEqual(403, request.operation.HTTPResponse.statusCode);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];

    [operationMock verify];
}

- (void)test_that_unauthorized_401_error_triggers_logout_notification
{
    BOXRequest *request = [[BOXRequest alloc] init];
    
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:401 responseData:nil];
    [self setCannedURLResponse:URLResponse cannedResponseData:nil forRequest:request];
    request.operation = [[BOXAPIJSONOperation alloc] initWithURL:[request URLWithResource:nil ID:nil subresource:nil subID:nil] HTTPMethod:BOXAPIHTTPMethodGET body:nil queryParams:nil session:request.queueManager.session];
    
    [request performRequest];
    
    [self expectationForNotification:BOXUserWasLoggedOutDueToErrorNotification object:nil handler:nil];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)test_that_user_agent_is_correct
{
    BOXRequest *request = [[BOXRequest alloc] init];
    
    id requestMock = [OCMockObject partialMockForObject:request];
    NSString *fakeDeviceModelName = @"test_device";
    [[[requestMock stub] andReturn:fakeDeviceModelName] deviceModelName];
    
    NSString *expectedUserAgent = [NSString stringWithFormat:@"iOS/%@;Apple/%@;%@/%@;%@",
                                   [[UIDevice currentDevice] systemVersion],
                                   fakeDeviceModelName,
                                   BOX_CONTENT_SDK_IDENTIFIER,
                                   BOX_CONTENT_SDK_VERSION,
                                   [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    
    XCTAssertEqualObjects(expectedUserAgent, request.userAgent);
}

- (void)test_that_user_agent_sdk_identifier_and_version_can_be_customized
{
    NSString *expectedSDKIdentifier = @"test_sdk_identifier";
    NSString *expectedSDKVersion = @"test_sdk_version";
    
    BOXRequest *request = [[BOXRequest alloc] init];
    request.SDKIdentifier = expectedSDKIdentifier;
    request.SDKVersion = expectedSDKVersion;
    
    id requestMock = [OCMockObject partialMockForObject:request];
    NSString *fakeDeviceModelName = @"test_device";
    [[[requestMock stub] andReturn:fakeDeviceModelName] deviceModelName];
    
    NSString *expectedUserAgent = [NSString stringWithFormat:@"iOS/%@;Apple/%@;%@/%@;%@",
                                   [[UIDevice currentDevice] systemVersion],
                                   fakeDeviceModelName,
                                   expectedSDKIdentifier,
                                   expectedSDKVersion,
                                   [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    
    XCTAssertEqualObjects(expectedUserAgent, request.userAgent);
}

- (void)test_that_user_agent_prefix_is_included_when_set
{
    NSString *expectedPrefix = @"test_prefix";
    
    BOXRequest *request = [[BOXRequest alloc] init];
    request.userAgentPrefix = expectedPrefix;
    
    id requestMock = [OCMockObject partialMockForObject:request];
    NSString *fakeDeviceModelName = @"test_device";
    [[[requestMock stub] andReturn:fakeDeviceModelName] deviceModelName];
    
    NSString *expectedUserAgent = [NSString stringWithFormat:@"%@;iOS/%@;Apple/%@;%@/%@;%@",
                                   expectedPrefix,
                                   [[UIDevice currentDevice] systemVersion],
                                   fakeDeviceModelName,
                                   BOX_CONTENT_SDK_IDENTIFIER,
                                   BOX_CONTENT_SDK_VERSION,
                                   [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    
    XCTAssertEqualObjects(expectedUserAgent, request.userAgent);
}

- (void)test_that_user_agent_gets_set_when_performing_request
{
    BOXRequest *request = [[BOXRequest alloc] init];
    
    BOXAPIOperation *operation = [[BOXAPIJSONOperation alloc] initWithURL:[request URLWithResource:nil ID:nil subresource:nil subID:nil] HTTPMethod:BOXAPIHTTPMethodGET body:nil queryParams:nil session:request.queueManager.session];
    request.operation = operation;
    
    [request performRequest];
    
    XCTAssertEqualObjects(request.userAgent, [request.urlRequest valueForHTTPHeaderField:@"User-Agent"]);
}

@end
