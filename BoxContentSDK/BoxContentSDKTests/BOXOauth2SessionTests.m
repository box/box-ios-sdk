//
//  BOXOauth2SessionTests.m
//  BoxContentSDK
//
//  Created by Rico Yao on 1/7/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

@import BoxContentSDKTestFramework;

#import "BOXOAuth2Session.h"
#import "BOXKeychainItemWrapper.h"

@interface BOXOAuth2Session ()
- (void)didReceiveRevokeSessionNotification:(NSNotification *)notification;
@end

@interface BOXOauth2SessionTests : BOXContentSDKTestCase
@end

@implementation BOXOauth2SessionTests

- (void)test_that_credential_is_stored_to_keychain_correctly
{
    BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
    session.refreshToken = @"def";
    session.accessToken = @"abc";
    session.accessTokenExpiration = [self dateWithoutMillisecondsFromDate:[NSDate date]];
    
    BOXUserMini *user = [[BOXUserMini alloc] init];
    user.modelID = @"782";
    user.login = @"captain.kirk@starfleet.com";
    user.name = @"James Kirk";

    id sessionMock = [OCMockObject partialMockForObject:session];
    [[[sessionMock stub] andReturn:user] user];
    
    [session storeCredentialsToKeychain];
    
    BOXKeychainItemWrapper *keychain = [[BOXKeychainItemWrapper alloc] initWithIdentifier:[@"BoxCredential_" stringByAppendingString:user.modelID] accessGroup:nil];
    NSString *jsonString = [keychain objectForKey:(__bridge id)kSecValueData];
    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNil(error);
    
    NSDictionary *expectedDictionary = @{@"access_token" : session.accessToken,
                                         @"access_token_expiration" : [session.accessTokenExpiration box_ISO8601String],
                                         @"refresh_token" : session.refreshToken,
                                         @"user_id" : user.modelID,
                                         @"user_login" : user.login,
                                         @"user_name" : user.name};
    
    XCTAssertEqual(expectedDictionary.count, dictionary.count);
    XCTAssertEqualObjects(expectedDictionary, dictionary);
}

- (void)test_that_credential_is_retrieved_from_keychain_correctly
{
    BOXUserMini *user = [[BOXUserMini alloc] init];
    user.modelID = @"782";
    user.login = @"captain.kirk@starfleet.com";
    user.name = @"James Kirk";
    
    NSString *refreshToken = @"def";
    NSString *accessToken = @"abc";
    NSDate *accessTokenExpiration = [self dateWithoutMillisecondsFromDate:[NSDate date]];
    
    NSDictionary *dictionary = @{@"access_token" : accessToken,
                                 @"access_token_expiration" : [accessTokenExpiration box_ISO8601String],
                                 @"refresh_token" : refreshToken,
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
    
    XCTAssertEqualObjects(refreshToken, session.refreshToken);
    XCTAssertEqualObjects(accessToken, session.accessToken);
    XCTAssertEqualObjects(accessTokenExpiration, session.accessTokenExpiration);
    [self assertModel:user isEquivalentTo:session.user];
}

- (void)test_that_multiple_credentials_are_stored_to_keychain_correctly
{
    // Have BOXOauth2Session persist several credentials.
    NSUInteger numCredentials = 3;
    NSMutableDictionary *sessionsByUserID = [NSMutableDictionary dictionary];
    for (NSUInteger i = 0; i < numCredentials; i++)
    {
        BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
        session.refreshToken = [NSString stringWithFormat:@"refresh_token_%lu", (unsigned long)i];
        session.accessToken = [NSString stringWithFormat:@"access_token_%lu", (unsigned long)i];
        session.accessTokenExpiration = [self dateWithoutMillisecondsFromDate:[NSDate date]];
        
        BOXUserMini *user = [[BOXUserMini alloc] init];
        user.modelID = [NSString stringWithFormat:@"user_id_%lu", (unsigned long)i];
        user.login = [NSString stringWithFormat:@"user_login_%lu", (unsigned long)i];
        user.name = [NSString stringWithFormat:@"user_name_%lu", (unsigned long)i];
        
        id sessionMock = [OCMockObject partialMockForObject:session];
        [[[sessionMock stub] andReturn:user] user];
        
        [session storeCredentialsToKeychain];
        
        sessionsByUserID[user.modelID] = session;
    }
    
    // Query they keychain and ensure the expected entries are there.
    NSInteger matchesFoundInKeychain = 0;
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionaryWithDictionary:@{(__bridge id)kSecReturnAttributes : (__bridge id)kCFBooleanTrue,
                                                                                         (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitAll,
                                                                                         (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword}];
    CFArrayRef keychainQueryResult = NULL;
    SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keychainQueryResult);
    NSArray* keychainEntries = (__bridge_transfer NSArray*)keychainQueryResult;
    for (NSDictionary *dict in keychainEntries)
    {
        NSString *keychainIdentifier = [dict objectForKey:((__bridge NSString *)kSecAttrGeneric)];
        if ([keychainIdentifier hasPrefix:@"BoxCredential_"])
        {
            NSString *userID = [keychainIdentifier stringByReplacingOccurrencesOfString:@"BoxCredential_" withString:@""];
            if (userID.length > 0 && sessionsByUserID[userID])
            {
                matchesFoundInKeychain++;
                
                BOXKeychainItemWrapper *keychain = [[BOXKeychainItemWrapper alloc] initWithIdentifier:[@"BoxCredential_" stringByAppendingString:userID] accessGroup:nil];
                NSString *jsonString = [keychain objectForKey:(__bridge id)kSecValueData];
                NSError *error = nil;
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
                XCTAssertNil(error);
                
                BOXOAuth2Session *session = sessionsByUserID[userID];
                NSDictionary *expectedDictionary = @{@"access_token" : session.accessToken,
                                                     @"access_token_expiration" : [session.accessTokenExpiration box_ISO8601String],
                                                     @"refresh_token" : session.refreshToken,
                                                     @"user_id" : session.user.uniqueId,
                                                     @"user_login" : session.user.login,
                                                     @"user_name" : session.user.name};
                XCTAssertEqualObjects(expectedDictionary, dictionary);
            }
        }
    }
    
    XCTAssertEqual(numCredentials, matchesFoundInKeychain);
}

- (void)test_that_multiple_credentials_in_keychain_are_retrieved_from_keychain_correctly
{
    // Store several credentials to keychain directly
    NSUInteger numCredentials = 3;
    NSMutableDictionary *keychainEntriesByUserID = [NSMutableDictionary dictionary];
    for (NSUInteger i = 0; i < numCredentials; i++)
    {
        BOXUserMini *user = [[BOXUserMini alloc] init];
        user.modelID = [NSString stringWithFormat:@"user_id_%lu", (unsigned long)i];
        user.login = [NSString stringWithFormat:@"user_login_%lu", (unsigned long)i];
        user.name = [NSString stringWithFormat:@"user_name_%lu", (unsigned long)i];
        
        NSString *refreshToken = [NSString stringWithFormat:@"refresh_token_%lu", (unsigned long)i];
        NSString *accessToken = [NSString stringWithFormat:@"access_token_%lu", (unsigned long)i];
        NSDate *accessTokenExpiration = [self dateWithoutMillisecondsFromDate:[NSDate date]];
        
        NSDictionary *dictionary = @{@"access_token" : accessToken,
                                     @"access_token_expiration" : [accessTokenExpiration box_ISO8601String],
                                     @"refresh_token" : refreshToken,
                                     @"user_id" : user.modelID,
                                     @"user_login" : user.login,
                                     @"user_name" : user.name};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        BOXKeychainItemWrapper *keychain = [[BOXKeychainItemWrapper alloc] initWithIdentifier:[@"BoxCredential_" stringByAppendingString:user.modelID] accessGroup:nil];
        [keychain resetKeychainItem];
        [keychain setObject:jsonString forKey:(__bridge id)kSecValueData];
        
        keychainEntriesByUserID[user.modelID] = dictionary;
    }
    
    // Verify that we can retrieve all the keychain entries through BOXOAuth2Session
    for (NSString *userID in [keychainEntriesByUserID allKeys])
    {
        BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
        [session restoreCredentialsFromKeychainForUserWithID:userID];
        
        XCTAssertEqualObjects(keychainEntriesByUserID[userID][@"refresh_token"], session.refreshToken);
        XCTAssertEqualObjects(keychainEntriesByUserID[userID][@"access_token"], session.accessToken);
        XCTAssertEqualObjects(keychainEntriesByUserID[userID][@"access_token_expiration"], [session.accessTokenExpiration box_ISO8601String]);
        XCTAssertEqualObjects(keychainEntriesByUserID[userID][@"user_id"], session.user.uniqueId);
        XCTAssertEqualObjects(keychainEntriesByUserID[userID][@"user_login"], session.user.login);
        XCTAssertEqualObjects(keychainEntriesByUserID[userID][@"user_name"], session.user.name);
    }
}

- (void)test_that_multiple_credentials_are_retrieved_in_alphabetical_order_by_user_login
{
    NSArray *userLogins = @[@"zzz", @"aaa", @"ggg", @"BBB"];
    
    for (NSString *userLogin in userLogins)
    {
        BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
        session.refreshToken = [NSString stringWithFormat:@"refresh_token_%@", userLogin];
        session.accessToken = [NSString stringWithFormat:@"access_token_%@", userLogin];
        session.accessTokenExpiration = [NSDate date];
        
        BOXUserMini *user = [[BOXUserMini alloc] init];
        user.login = userLogin;
        user.modelID = [NSString stringWithFormat:@"user_id_%@", userLogin];
        user.name = [NSString stringWithFormat:@"user_name_%@", userLogin];
        
        id sessionMock = [OCMockObject partialMockForObject:session];
        [[[sessionMock stub] andReturn:user] user];
        
        [session storeCredentialsToKeychain];
    }
    
    NSArray *users = [BOXOAuth2Session usersInKeychain];
    
    NSArray *sortedUserLogins = @[@"aaa", @"BBB", @"ggg", @"zzz"];
    for (NSUInteger i = 0 ; i < users.count; i++)
    {
        XCTAssertEqualObjects(sortedUserLogins[i], ((BOXUserMini *)users[i]).login);
    }
}

- (void)test_keychain_entry_is_removed_when_credential_is_revoked
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
    
    [session revokeCredentials];
    
    BOXOAuth2Session *session2 = [[BOXOAuth2Session alloc] init];
    [session2 restoreCredentialsFromKeychainForUserWithID:user.modelID];
    XCTAssertNil(session2.user);
    XCTAssertNil(session2.refreshToken);
    XCTAssertNil(session2.accessToken);
    XCTAssertNil(session2.accessTokenExpiration);
}

- (void)test_all_keychain_entries_are_removed_when_all_credentials_are_revoked
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
    
    [BOXOAuth2Session revokeAllCredentials];
    
    XCTAssertEqual(0, [BOXOAuth2Session usersInKeychain].count);
}

- (void)test_that_credential_is_not_stored_in_keychain_if_credential_persistence_is_disabled
{
    BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
    session.credentialsPersistenceEnabled = NO;
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
    
    BOXKeychainItemWrapper *keychain = [[BOXKeychainItemWrapper alloc] initWithIdentifier:[@"BoxCredential_" stringByAppendingString:user.modelID] accessGroup:nil];
    NSString *jsonString = [keychain objectForKey:(__bridge id)kSecValueData];
    NSError *error = nil;
    XCTAssertNil(error);
    XCTAssertEqual(0, jsonString.length);
}

- (void)test_that_token_refresh_grant_throws_error_when_there_is_no_authenticated_user
{
    BOXOAuth2Session *session = [[BOXOAuth2Session alloc] init];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [session performRefreshTokenGrant:@"abc" withCompletionBlock:^(BOXOAuth2Session *session, NSError *error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

#pragma mark - Private Helper

- (NSDate *)dateWithoutMillisecondsFromDate:(NSDate *)date
{
    return [NSDate dateWithTimeIntervalSinceReferenceDate:floor([date timeIntervalSinceReferenceDate])];
}

@end
