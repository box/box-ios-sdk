//
//  BOXHashHelperTests.m
//  BoxContentSDKTests
//
//  Created by Prithvi Jutur on 5/22/18.
//  Copyright © 2018 Box. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BOXStreamingHashHelper.h"

@interface BOXStreamingHashHelperTests : XCTestCase
@end

@implementation BOXStreamingHashHelperTests

- (void) test_that_streaming_hash_function_calculates_sha1 {
    BOXStreamingHashHelper *streamingHashHelper = [[BOXStreamingHashHelper alloc] init];
    NSString *testString = @"ABCDEFG";
    const char *utfString = [testString UTF8String];
    NSUInteger length = strlen(utfString);
    const NSUInteger break_index = 2;
    NSRange range1 = {0, break_index};
    NSRange range2 = {break_index, (length - break_index)};
    NSData *data, *part1, *part2;
    data = [NSData dataWithBytes:utfString length:length];
    part1 = [data subdataWithRange:range1];
    part2 = [data subdataWithRange:range2];

    [streamingHashHelper open];
    [streamingHashHelper processData:part1];
    [streamingHashHelper processData:part2];
    NSString *sha1Hash = [streamingHashHelper close];

    XCTAssertEqualObjects(@"93be4612c41d23af1891dac5fd0d535736ffc4e3", sha1Hash);
}

@end
