//
//  BOXURLSessionIdentifier.m
//  BoxContentSDK
//
//  Created by James Lawton on 12/14/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import "BOXURLSessionIdentifier.h"
#import "BOXUser.h"

NS_ASSUME_NONNULL_BEGIN

// The prefix shouldn't contain the separator
#define BOXURLSessionIdentifierPrefix @"BOXURLSession"
#define BOXURLSessionIdentifierSeparator @":"

@interface BOXURLSessionIdentifier ()
@property (nonatomic, readonly, copy) NSString *mainBundleIdentifier;
@end

@implementation BOXURLSessionIdentifier

- (instancetype)initWithUser:(BOXUserMini *)user
{
    BOXAssert(user.modelID, @"A valid user is required.");

    self = [super init];
    if (self) {
        _mainBundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        _userID = [user.modelID copy];
    }
    return self;
}

- (nullable instancetype)initWithIdentifierString:(NSString *)identifier
{
    NSArray<NSString *> *parts = [identifier componentsSeparatedByString:BOXURLSessionIdentifierSeparator];
    BOXAssert(parts.count == 3 && [parts[0] isEqualToString:BOXURLSessionIdentifierPrefix], @"Invalid identifier string.");

    self = [super init];
    if (self)
    {
        _mainBundleIdentifier = parts[1];
        _userID = parts[2];
    }
    return self;
}

- (BOOL)wasCreatedFromCurrentBundle
{
    return [self.mainBundleIdentifier isEqualToString:[[NSBundle mainBundle] bundleIdentifier]];
}

- (NSString *)stringValue
{
    return [[self class] identifierStringForUserID:self.userID bundleID:self.mainBundleIdentifier];
}

- (NSString *)description
{
    return self.stringValue;
}

#pragma mark - Private

+ (NSString *)identifierStringForUserID:(NSString *)userID bundleID:(NSString *)bundleID
{
    NSArray<NSString *> *parts = @[BOXURLSessionIdentifierPrefix, bundleID, userID];
    return [parts componentsJoinedByString:BOXURLSessionIdentifierSeparator];
}

@end

NS_ASSUME_NONNULL_END
