//
//  BOXClientTestCase.m
//  BoxContentSDK
//
//  Created by Rico Yao on 1/12/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXContentClientTestCase.h"
#import "BOXContentClient.h"
#import "BOXAPIAccessTokenDelegate.h"
#import "BOXContentClient+Folder.h"
#import "BOXContentClient_Private.h"
#import "BOXFolderRequest.h"
#import "BOXRequest_Private.h"
#import "BOXContentClient+Authentication.h"
#import "BOXContentSDKErrors.h"
#import "BOXAppUserSession.h"
#import "BOXOAuth2Session.h"
#import "BOXCannedURLProtocol.h"
#import "BOXURLSessionManager_Private.h"

@interface BOXContentClientTestCase ()

@property (nonatomic, readwrite, strong) NSString *accessToken;

@end

@implementation BOXContentClientTestCase

- (void)fetchAccessTokenWithCompletion:(void (^)(NSString *, NSDate *, NSError *))completion
{
    completion(self.accessToken, [NSDate dateWithTimeIntervalSinceNow:100], nil);
}

- (void)test_content_client_with_app_user
{
    ServerAuthUser *user = [[ServerAuthUser alloc] initWithUniqueID:@"user_id"];
    BOXContentClient *client = [BOXContentClient clientForServerAuthUser:user
                                                 initialToken:nil
                                                 fetchTokenBlockInfo:nil
                                                 fetchTokenBlock:^(NSString * _Nonnull uniqueID, NSDictionary * _Nullable fetchTokenInfo, void (^ _Nonnull completion)(NSString * _Nullable, NSDate * _Nullable, NSError * _Nullable)) {
                                                     completion(@"token", nil, nil);
                                                 }];
    
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
    
    ServerAuthUser *user = [[ServerAuthUser alloc] initWithUniqueID:@"user_id"];
    XCTAssertThrows([client setAccessTokenDelegate:self serverAuthUser:user]);
}

- (void)test_app_users_should_require_delegate_set
{
    BOXContentClient *client = [BOXContentClient clientForNewSession];
    BOXURLSessionManager *urlSessionManager = [[BOXURLSessionManager alloc] initWithProtocolClasses:@[[BOXCannedURLProtocol class]]];
    client.session = [[BOXAppUserSession alloc] initWithQueueManager:client.queueManager urlSessionManager:urlSessionManager];
    
    BOXFolderRequest *request = [client folderInfoRequestWithID:@"mock_id"];
    XCTAssertThrows([request performRequestWithCompletion:^(BOXFolder *folder, NSError *error) {
    }]);
}

- (void)test_cant_set_nil_to_access_token_delegate
{
    BOXContentClient *client = [BOXContentClient clientForNewSession];
    
    ServerAuthUser *user = [[ServerAuthUser alloc] initWithUniqueID:@"user_id"];
    XCTAssertThrows([client setAccessTokenDelegate:nil serverAuthUser:user]);
}

// Access token is fed in from the delegate method "fetchAccessTokenWithCompletion:" above.
- (void)test_request_authorization_header_is_signed_with_correct_access_token
{
    self.accessToken = @"access_token";
    BOXContentClient *client = [BOXContentClient clientForNewSession];
    ServerAuthUser *user = [[ServerAuthUser alloc] initWithUniqueID:@"user_id"];
    [client setAccessTokenDelegate:self serverAuthUser:user];
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

- (void)test_content_client_returns_invalid_access_token_error
{
    self.accessToken = nil;
    
    BOXContentClient *client = [BOXContentClient clientForNewSession];
    ServerAuthUser *user = [[ServerAuthUser alloc] initWithUniqueID:@"user_id"];
    [client setAccessTokenDelegate:self serverAuthUser:user];
    
    XCTestExpectation *clientExpectation = [self expectationWithDescription:@"expectation"];
    [client authenticateWithCompletionBlock:^(BOXUser *user, NSError *error) {
        NSInteger expectedErrorCode = BOXContentSDKAppUserErrorAccessTokenInvalid;
        NSString *expectedErrorDomain = @"accessToken and accessTokenExpiration should be non-nil";
        
        XCTAssert(expectedErrorCode == error.code);
        XCTAssert([expectedErrorDomain isEqualToString:error.domain]);
        [clientExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
