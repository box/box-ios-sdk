//
//  BOXAppUserSessionTests.m
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/10/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@import BoxContentSDKTestFramework;

#import "BOXAppUserSession.h"
#import "BOXAPIAccessTokenDelegate.h"
#import "BOXContentClient_Private.h"
#import "BOXKeychainItemWrapper.h"
#import "BOXOAuth2Session.h"
#import "BOXCannedURLProtocol.h"
#import "BOXURLSessionManager_Private.h"

@interface BOXAppUserSessionTests : BOXContentSDKTestCase <BOXAPIAccessTokenDelegate>

@end

@implementation BOXAppUserSessionTests

- (void)setUp
{
    [super setUp];
    [BOXContentClient setClientID:@"sample_client_id" clientSecret:@"sample_client_secret"];
}

- (void)fetchAccessTokenWithCompletion:(void (^)(NSString *, NSDate *, NSError *))completion
{
    completion(@"accessToken", [NSDate dateWithTimeIntervalSince1970:1], nil);
}

- (void)test_queue_manager_retrieves_access_token
{
    BOXAPIQueueManager *queueManager = [[BOXAPIQueueManager alloc]init];
    queueManager.delegate = self;
    [queueManager.delegate fetchAccessTokenWithCompletion:^(NSString *accessToken, NSDate *accessTokenExpiration, NSError *error) {
        NSString *expectedAccessToken = @"accessToken";
        NSDate *expectedAccessTokenExpiration = [NSDate dateWithTimeIntervalSince1970:1];
        
        XCTAssert([expectedAccessToken isEqualToString:accessToken]);
        XCTAssert([expectedAccessTokenExpiration isEqualToDate:accessTokenExpiration]);
        XCTAssertNil(error);
    }];
}

- (void)test_content_client_delegate_sets_queue_manager_delegate
{
    BOXContentClient *client = [BOXContentClient clientForNewSession];
    ServerAuthUser *user = [[ServerAuthUser alloc] initWithUniqueID:@"user_id"];
    [client setAccessTokenDelegate:self serverAuthUser:user];
    
    XCTAssertEqual(self, client.queueManager.delegate);
}


- (void)test_content_client_session_reassignment
{
    BOXAPIQueueManager *queueManager = [[BOXAPIQueueManager alloc]init];
    BOXContentClient *client = [BOXContentClient clientForNewSession];
    XCTAssert([client.session isKindOfClass:[BOXOAuth2Session class]]);
    BOXURLSessionManager *urlSessionManager = [[BOXURLSessionManager alloc] initWithProtocolClasses:@[[BOXCannedURLProtocol class]]];
    BOXAppUserSession *expectedSession = [[BOXAppUserSession alloc] initWithQueueManager:queueManager urlSessionManager:urlSessionManager];
    client.session = expectedSession;
    
    XCTAssertEqual(expectedSession.queueManager, queueManager);
    XCTAssertEqual(expectedSession, client.session);
    XCTAssertEqual(expectedSession, client.appSession);
    XCTAssertEqual(expectedSession, client.queueManager.session);
    XCTAssertNil(client.OAuth2Session);
}

- (void)test_store_keychain_with_app_users
{
    BOXAPIQueueManager *queueManager = [[BOXAPIQueueManager alloc]init];
    BOXURLSessionManager *urlSessionManager = [[BOXURLSessionManager alloc] initWithProtocolClasses:@[[BOXCannedURLProtocol class]]];
    BOXAppUserSession *session = [[BOXAppUserSession alloc] initWithQueueManager:queueManager urlSessionManager:urlSessionManager];
    BOXUserMini *user = [[BOXUserMini alloc]init];
    
    user.modelID = @"782";
    user.login = @"captain.kirk@starfleet.com";
    user.name = @"James Kirk";
    
    queueManager.session = session;
    queueManager.delegate = self;
    [queueManager.delegate fetchAccessTokenWithCompletion:^(NSString *accessToken, NSDate *accessTokenExpiration, NSError *error) {
        session.accessToken = accessToken;
        session.accessTokenExpiration = accessTokenExpiration;
        
        XCTAssertNil(error);
    }];
    
    id sessionMock = [OCMockObject partialMockForObject:session];
    [[[sessionMock stub] andReturn:user] user];
    
    [session storeCredentialsToKeychain];
    
    BOXKeychainItemWrapper *keychain = [[BOXKeychainItemWrapper alloc] initWithIdentifier:[NSString stringWithFormat:@"BoxCredential_%@", user.modelID] accessGroup:nil];
    NSString *jsonString = [keychain objectForKey:(__bridge id)kSecValueData];
    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNil(error);
    
    NSDictionary *expectedDictionary = @{@"access_token" : session.accessToken,
                                         @"access_token_expiration" : [session.accessTokenExpiration box_ISO8601String],
                                         @"user_id" : user.modelID,
                                         @"user_login" : user.login,
                                         @"user_name" : user.name};
    
    XCTAssertEqual(expectedDictionary.count, dictionary.count);
    XCTAssertEqualObjects(expectedDictionary, dictionary);
}

- (void)test_restore_from_keychain_with_app_users
{
    BOXUserMini *user = [[BOXUserMini alloc] init];
    user.modelID = @"782";
    user.login = @"captain.kirk@starfleet.com";
    user.name = @"James Kirk";
    
    __block NSString *expectedRefreshToken = nil;
    __block NSString *expectedAccessToken = nil;
    __block NSDate *expectedAccessTokenExpiration = nil;
    
    BOXAPIQueueManager *queueManager = [[BOXAPIQueueManager alloc]init];
    queueManager.delegate = self;
    [queueManager.delegate fetchAccessTokenWithCompletion:^(NSString *accessToken, NSDate *accessTokenExpiration, NSError *error) {
        expectedAccessToken = accessToken;
        expectedAccessTokenExpiration = accessTokenExpiration;
    }];
    
    NSDictionary *dictionary = @{@"access_token" : expectedAccessToken,
                                 @"access_token_expiration" : [expectedAccessTokenExpiration box_ISO8601String],
                                 @"user_id" : user.modelID,
                                 @"user_login" : user.login,
                                 @"user_name" : user.name};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    BOXKeychainItemWrapper *keychain = [[BOXKeychainItemWrapper alloc] initWithIdentifier:[@"BoxCredential_" stringByAppendingString:user.modelID] accessGroup:nil];
    [keychain resetKeychainItem];
    [keychain setObject:jsonString forKey:(__bridge id)kSecValueData];
    
    BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
    [session restoreCredentialsFromKeychainForUserWithID:user.modelID];
    
    XCTAssertEqualObjects(expectedRefreshToken, session.refreshToken);
    XCTAssertEqualObjects(expectedAccessToken, session.accessToken);
    XCTAssertEqualObjects(expectedAccessTokenExpiration, session.accessTokenExpiration);
    [self assertModel:user isEquivalentTo:session.user];
}

@end
