//
//  NSStringBoxContentSDKAdditionsTests
//
//  Copyright (c) 2015 Box. All rights reserved.
//

@import BoxContentSDKTestFramework;

#import "NSString+BOXContentSDKAdditions.h"

@interface NSStringBoxContentSDKAdditionsTests : BOXContentSDKTestCase
@end

@implementation NSStringBoxContentSDKAdditionsTests

- (void)test_stringByTrailingSpacesInString_returns_expected_string
{
    // query string => expected dictionary
    NSDictionary *testCases = @{@"Ab cde" : @"Ab cde",
                                @"Ab  cde  " : @"Ab  cde",
                                @"   Ab cde    " : @"   Ab cde",
                                @"   " : @"",
                                @" " : @"",
                                @"" : @""
                                };

    [testCases enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *originalString = key;
        NSString *expectedString = obj;
        NSString *actualString = [originalString box_stringByTrimmingTrailingSpaces];
        XCTAssertEqualObjects(expectedString, actualString);
    }];

    // nil case
    NSString *nilString = nil;
    XCTAssertEqualObjects(nil, [nilString box_stringByTrimmingTrailingSpaces]);
}

@end
