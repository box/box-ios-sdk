//
//  BOXClientSessionTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 1/12/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXContentClientTestCase.h"
#import "BOXContentSDK.h"
#import "BOXUser_Private.h"
#import "BOXContentClient+Authentication.h"

@interface BOXContentClient ()

+ (void)resetInstancesForTesting;

@end

@interface BOXContentClientSessionTests : BOXContentClientTestCase
@end

@implementation BOXContentClientSessionTests

- (void)setUp
{
    [super setUp];
    [BOXContentClient resetInstancesForTesting];
    [BOXContentClient setClientID:@"sample_client_id" clientSecret:@"sample_client_secret"];
}

- (void)tearDown
{
    [BOXContentClient resetInstancesForTesting];
    [super tearDown];
}

- (void)test_that_defaultClient_returns_existing_session
{
    BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
    session.refreshToken = @"def";
    session.accessToken = @"abc";
    session.accessTokenExpiration = [NSDate date];

    BOXUserMini *user = [[BOXUserMini alloc] init];
    user.modelID = @"782";
    user.login = @"captain.kirk@starfleet.com";
    user.name = @"James Kirk";

    id sessionMock = [OCMockObject partialMockForObject:session];
    [[[sessionMock stub] andReturn:user] user];
  
    [session storeCredentialsToKeychain];
    
    BOXContentClient *defaultClient = [BOXContentClient defaultClient];
    [self assertModel:user isEquivalentTo:defaultClient.user];
    XCTAssertEqualObjects(session.accessToken, defaultClient.OAuth2Session.accessToken);
    XCTAssertEqualObjects([session.accessTokenExpiration box_ISO8601String], [defaultClient.OAuth2Session.accessTokenExpiration box_ISO8601String]);
    XCTAssertEqualObjects(session.refreshToken, defaultClient.OAuth2Session.refreshToken);
}

- (void)test_that_defaultClient_throws_exception_if_multiple_sessions_exist
{
    NSUInteger numCredentials = 3;
    for (NSUInteger i = 0; i < numCredentials; i++)
    {
        BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
        session.refreshToken = [NSString stringWithFormat:@"refresh_token_%lu", (unsigned long)i];
        session.accessToken = [NSString stringWithFormat:@"access_token_%lu", (unsigned long)i];
        session.accessTokenExpiration = [NSDate date];
        
        BOXUserMini *user = [[BOXUserMini alloc] init];
        user.modelID = [NSString stringWithFormat:@"user_id_%lu", (unsigned long)i];
        user.login = [NSString stringWithFormat:@"user_login_%lu", (unsigned long)i];
        user.name = [NSString stringWithFormat:@"user_name_%lu", (unsigned long)i];
        
        id sessionMock = [OCMockObject partialMockForObject:session];
        [[[sessionMock stub] andReturn:user] user];
        
        [session storeCredentialsToKeychain];
    }
    
    id exceptionMock = [OCMockObject mockForClass:[NSException class]];
    [[[exceptionMock expect] classMethod] raise:@"You cannot use 'defaultClient' if multiple users have established a session."
                                         format:@"Specify a user through clientForUser:"];
    
    [BOXContentClient defaultClient];
}

- (void)test_that_clientForUser_returns_existing_session_from_keychain
{
    BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
    session.refreshToken = @"def";
    session.accessToken = @"abc";
    session.accessTokenExpiration = [NSDate date];
    
    BOXUserMini *user = [[BOXUserMini alloc] init];
    user.modelID = @"782";
    user.login = @"captain.kirk@starfleet.com";
    user.name = @"James Kirk";
    
    id sessionMock = [OCMockObject partialMockForObject:session];
    [[[sessionMock stub] andReturn:user] user];
    
    [session storeCredentialsToKeychain];
    
    BOXContentClient *clientForUser = [BOXContentClient clientForUser:user];
    [self assertModel:user isEquivalentTo:clientForUser.user];
    XCTAssertEqualObjects(session.accessToken, clientForUser.OAuth2Session.accessToken);
    XCTAssertEqualObjects([session.accessTokenExpiration box_ISO8601String], [clientForUser.OAuth2Session.accessTokenExpiration box_ISO8601String]);
    XCTAssertEqualObjects(session.refreshToken, clientForUser.OAuth2Session.refreshToken);
}

- (void)test_that_defaultClient_returns_identical_client_object_in_memory
{
    BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
    session.refreshToken = @"def";
    session.accessToken = @"abc";
    session.accessTokenExpiration = [NSDate date];
    
    BOXUserMini *user = [[BOXUserMini alloc] init];
    user.modelID = @"782";
    user.login = @"captain.kirk@starfleet.com";
    user.name = @"James Kirk";
    
    id sessionMock = [OCMockObject partialMockForObject:session];
    [[[sessionMock stub] andReturn:user] user];
    
    [session storeCredentialsToKeychain];
    
    BOXContentClient *defaultCLient1 = [BOXContentClient defaultClient];
    BOXContentClient *defaultCLient2 = [BOXContentClient defaultClient];
    XCTAssertEqualObjects(defaultCLient1, defaultCLient2);
}

- (void)test_that_clientForUser_returns_identical_client_object_in_memory
{
    BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
    session.refreshToken = @"def";
    session.accessToken = @"abc";
    session.accessTokenExpiration = [NSDate date];
    
    BOXUserMini *user = [[BOXUserMini alloc] init];
    user.modelID = @"782";
    user.login = @"captain.kirk@starfleet.com";
    user.name = @"James Kirk";
    
    id sessionMock = [OCMockObject partialMockForObject:session];
    [[[sessionMock stub] andReturn:user] user];
    
    [session storeCredentialsToKeychain];
    
    BOXContentClient *clientForUser1 = [BOXContentClient clientForUser:user];
    BOXContentClient *clientForUser2 = [BOXContentClient clientForUser:user];
    XCTAssertEqualObjects(clientForUser1, clientForUser2);
}

- (void)test_that_clientForUser_and_defaultClient_returns_identical_client_object_in_memory_when_clientForUser_is_called_first
{
    BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
    session.refreshToken = @"def";
    session.accessToken = @"abc";
    session.accessTokenExpiration = [NSDate date];
    
    BOXUserMini *user = [[BOXUserMini alloc] init];
    user.modelID = @"782";
    user.login = @"captain.kirk@starfleet.com";
    user.name = @"James Kirk";
    
    id sessionMock = [OCMockObject partialMockForObject:session];
    [[[sessionMock stub] andReturn:user] user];
    
    [session storeCredentialsToKeychain];
    
    BOXContentClient *clientForUser = [BOXContentClient clientForUser:user];
    BOXContentClient *defaultClient = [BOXContentClient defaultClient];
    XCTAssertEqualObjects(clientForUser, defaultClient);
}

- (void)test_that_clientForUser_and_defaultClient_returns_identical_client_object_in_memory_when_defaultClient_is_called_first
{
    BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
    session.refreshToken = @"def";
    session.accessToken = @"abc";
    session.accessTokenExpiration = [NSDate date];
    
    BOXUserMini *user = [[BOXUserMini alloc] init];
    user.modelID = @"782";
    user.login = @"captain.kirk@starfleet.com";
    user.name = @"James Kirk";
    
    id sessionMock = [OCMockObject partialMockForObject:session];
    [[[sessionMock stub] andReturn:user] user];
    
    [session storeCredentialsToKeychain];
    
    BOXContentClient *defaultClient = [BOXContentClient defaultClient];
    BOXContentClient *clientForUser = [BOXContentClient clientForUser:user];
    XCTAssertEqualObjects(clientForUser, defaultClient);
}

- (void)test_that_clientForNewSession_returns_new_session_and_not_existing_session
{
    BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
    session.refreshToken = @"def";
    session.accessToken = @"abc";
    session.accessTokenExpiration = [NSDate date];
    
    BOXUserMini *user = [[BOXUserMini alloc] init];
    user.modelID = @"782";
    user.login = @"captain.kirk@starfleet.com";
    user.name = @"James Kirk";
    
    id sessionMock = [OCMockObject partialMockForObject:session];
    [[[sessionMock stub] andReturn:user] user];
    
    [session storeCredentialsToKeychain];
    
    BOXContentClient *client = [BOXContentClient clientForNewSession];
    XCTAssertNil(client.user);
    XCTAssertNil(client.OAuth2Session.accessToken);
    XCTAssertNil(client.OAuth2Session.accessTokenExpiration);
    XCTAssertNil(client.OAuth2Session.refreshToken);
}

- (void)test_that_session_cannot_be_retrieved_after_it_has_been_logged_out
{
    BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
    session.refreshToken = @"def";
    session.accessToken = @"abc";
    session.accessTokenExpiration = [NSDate date];
    
    BOXUserMini *user = [[BOXUserMini alloc] init];
    user.modelID = @"782";
    user.login = @"captain.kirk@starfleet.com";
    user.name = @"James Kirk";
    
    id sessionMock = [OCMockObject partialMockForObject:session];
    [[[sessionMock stub] andReturn:user] user];
    
    [session storeCredentialsToKeychain];
    
    BOXContentClient *defaultClient = [BOXContentClient defaultClient];
    [self assertModel:user isEquivalentTo:defaultClient.user];
    [defaultClient logOut];
    
    // Existing client object should now point to an empty session
    XCTAssertNil(defaultClient.user);
    XCTAssertNil(defaultClient.OAuth2Session.accessToken);
    XCTAssertNil(defaultClient.OAuth2Session.accessTokenExpiration);
    XCTAssertNil(defaultClient.OAuth2Session.refreshToken);
    
    // Another default client should point to an empty session
    BOXContentClient *anotherDefaultClient = [BOXContentClient defaultClient];
    XCTAssertNil(anotherDefaultClient.user);
    XCTAssertNil(anotherDefaultClient.OAuth2Session.accessToken);
    XCTAssertNil(anotherDefaultClient.OAuth2Session.accessTokenExpiration);
    XCTAssertNil(anotherDefaultClient.OAuth2Session.refreshToken);
    
    // Attempting to get a client for that user should return an empty session
    BOXContentClient *clientForUser = [BOXContentClient clientForUser:user];
    XCTAssertNil(clientForUser.user);
    XCTAssertNil(clientForUser.OAuth2Session.accessToken);
    XCTAssertNil(clientForUser.OAuth2Session.accessTokenExpiration);
    XCTAssertNil(clientForUser.OAuth2Session.refreshToken);
}

- (void)test_that_session_cannot_be_retrieved_after_logoutAll
{
    BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
    session.refreshToken = @"def";
    session.accessToken = @"abc";
    session.accessTokenExpiration = [NSDate date];
    
    BOXUserMini *user = [[BOXUserMini alloc] init];
    user.modelID = @"782";
    user.login = @"captain.kirk@starfleet.com";
    user.name = @"James Kirk";
    
    id sessionMock = [OCMockObject partialMockForObject:session];
    [[[sessionMock stub] andReturn:user] user];
    
    [session storeCredentialsToKeychain];
    
    BOXContentClient *defaultClient = [BOXContentClient defaultClient];
    [self assertModel:user isEquivalentTo:defaultClient.user];
    
    [BOXContentClient logOutAll];
    
    // Existing client object should now point to an empty session
    XCTAssertNil(defaultClient.user);
    XCTAssertNil(defaultClient.OAuth2Session.accessToken);
    XCTAssertNil(defaultClient.OAuth2Session.accessTokenExpiration);
    XCTAssertNil(defaultClient.OAuth2Session.refreshToken);
    
    // Another default client should point to an empty session
    BOXContentClient *anotherDefaultClient = [BOXContentClient defaultClient];
    XCTAssertNil(anotherDefaultClient.user);
    XCTAssertNil(anotherDefaultClient.OAuth2Session.accessToken);
    XCTAssertNil(anotherDefaultClient.OAuth2Session.accessTokenExpiration);
    XCTAssertNil(anotherDefaultClient.OAuth2Session.refreshToken);
    
    // Attempting to get a client for that user should return an empty session
    BOXContentClient *clientForUser = [BOXContentClient clientForUser:user];
    XCTAssertNil(clientForUser.user);
    XCTAssertNil(clientForUser.OAuth2Session.accessToken);
    XCTAssertNil(clientForUser.OAuth2Session.accessTokenExpiration);
    XCTAssertNil(clientForUser.OAuth2Session.refreshToken);
}

- (void)test_that_logout_notification_triggers_logout
{
    BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
    session.refreshToken = @"def";
    session.accessToken = @"abc";
    session.accessTokenExpiration = [NSDate date];
    
    BOXUserMini *user = [[BOXUserMini alloc] init];
    user.modelID = @"493";
    user.login = @"captain.kirk@starfleet.com";
    user.name = @"James Kirk";
    
    id sessionMock = [OCMockObject partialMockForObject:session];
    [[[sessionMock stub] andReturn:user] user];
    
    [session storeCredentialsToKeychain];
    
    BOXContentClient *client = [BOXContentClient clientForUser:user];
    id clientMock = [OCMockObject partialMockForObject:client];
    
    [[clientMock expect] logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:BOXUserWasLoggedOutDueToErrorNotification object:@{BOXUserIDKey : user.modelID}];
    [clientMock verify];
}

- (void)test_that_logout_notification_only_logs_out_correct_client
{
    BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
    session.refreshToken = @"def";
    session.accessToken = @"abc";
    session.accessTokenExpiration = [NSDate date];
    
    BOXOAuth2Session *session2 = [[BOXOAuth2Session alloc] init];
    session2.refreshToken = @"tyu";
    session2.accessToken = @"ghj";
    session2.accessTokenExpiration = [NSDate date];
    
    BOXUserMini *user1 = [[BOXUserMini alloc] init];
    user1.modelID = @"567";
    user1.login = @"captain.kirk@starfleet.com";
    user1.name = @"James Kirk";
    
    BOXUserMini *user2 = [[BOXUserMini alloc] init];
    user2.modelID = @"645";
    user2.login = @"person@test.com";
    user2.name = @"Person Name";
    
    id sessionMock = [OCMockObject partialMockForObject:session];
    [[[sessionMock stub] andReturn:user1] user];
    
    id sessionMock2 = [OCMockObject partialMockForObject:session2];
    [[[sessionMock2 stub] andReturn:user2] user];
    
    [session storeCredentialsToKeychain];
    [session2 storeCredentialsToKeychain];

    BOXContentClient *clientForUser1 = [BOXContentClient clientForUser:user1];
    id clientMockForUser1 = [OCMockObject partialMockForObject:clientForUser1];
    
    BOXContentClient *clientForUser2 = [BOXContentClient clientForUser:user2];
    id clientMockForUser2 = [OCMockObject partialMockForObject:clientForUser2];
    
    [[clientMockForUser1 expect] logOut];
    [[clientMockForUser2 reject] logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:BOXUserWasLoggedOutDueToErrorNotification object:@{BOXUserIDKey : user1.modelID}];
    [clientMockForUser1 verify];
    [clientMockForUser2 verify];
}

@end
