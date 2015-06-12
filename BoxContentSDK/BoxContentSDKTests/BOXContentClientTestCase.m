//
//  BOXClientTestCase.m
//  BoxContentSDK
//
//  Created by Rico Yao on 1/12/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXContentClientTestCase.h"
#import "BOXContentClient.h"
#import "BOXContentClient+AppUser.h"
#import "BOXAPIAccessTokenDelegate.h"
#import "BOXContentClient+Folder.h"

@implementation BOXContentClientTestCase

- (void)fetchAccessTokenWithCompletion:(void (^)(NSString *, NSDate *, NSError *))completion
{
    completion(@"access_token", [NSDate dateWithTimeIntervalSinceNow:100], nil);
}

- (void)test_content_client_with_app_user
{
    BOXContentClient *client = [BOXContentClient clientForNewSession];
    [client setAccessTokenDelegate:self];
    
    XCTAssert([client.session isKindOfClass:[BOXAppUserSession class]]);
}

- (void)test_content_client_with_oauth
{
    BOXContentClient *client = [BOXContentClient clientForNewSession];
    
    XCTAssert([client.session isKindOfClass:[BOXOAuth2Session class]]);
}

- (void)test_oauth_shouldnt_be_convertible_to_app_users_after_authentication
{
    BOXContentClient *client = [BOXContentClient clientForNewSession];
    client.session.accessToken = @"abc";
    client.session.accessTokenExpiration = [NSDate dateWithTimeIntervalSince1970:1];
    ((BOXOAuth2Session *)client.session).refreshToken = @"ghi";
    
    XCTAssertThrows([client setAccessTokenDelegate:self]);
}

- (void)test_app_users_should_require_delegate_set
{
    BOXContentClient *client = [BOXContentClient clientForNewSession];
    client.session = [[BOXAppUserSession alloc]initWithAPIBaseURL:BOXAPIBaseURL queueManager:client.queueManager];
    
    BOXFolderRequest *request = [client folderInfoRequestWithID:@"mock_id"];
    XCTAssertThrows([request performRequestWithCompletion:nil]);
}

- (void)test_cant_set_nil_to_access_token_delegate
{
    BOXContentClient *client = [BOXContentClient clientForNewSession];
    
    XCTAssertThrows([client setAccessTokenDelegate:nil]);
}

// Access token is fed in from the delegate method "fetchAccessTokenWithCompletion:" above.
- (void)test_request_authorization_header_is_signed_with_correct_access_token
{
    BOXContentClient *client = [BOXContentClient clientForNewSession];
    [client setAccessTokenDelegate:self];
    [client.queueManager.delegate fetchAccessTokenWithCompletion:^(NSString *accessToken, NSDate *accessTokenExpiration, NSError *error) {
        client.session.accessToken = accessToken;
        client.session.accessTokenExpiration = accessTokenExpiration;
    }];
    
    BOXFolderRequest *request = [client folderInfoRequestWithID:@"mock_id"];
    [request.operation prepareAPIRequest];
    NSDictionary *headers = [request.urlRequest allHTTPHeaderFields];
    NSString *expectedAuthorizationHeader = @"Authorization: Bearer access_token";
    NSString *actualAuthorizationHeader = [NSString stringWithFormat:@"%@: %@", @"Authorization", headers[@"Authorization"]];
    
    XCTAssertTrue([expectedAuthorizationHeader isEqualToString:actualAuthorizationHeader]);
}

@end
