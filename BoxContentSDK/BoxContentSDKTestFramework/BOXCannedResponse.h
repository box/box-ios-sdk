//
//  BOXCannedResponse.h
//  BoxContentSDK
//
//  Created by Rico Yao on 12/30/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HTTPBodyDataBlock)(NSData *bodyData);

@interface BOXCannedResponse : NSObject

- (instancetype)initWithURLResponse:(NSHTTPURLResponse *)URLResponse responseData:(NSData *)responseData;

// Canned URL response.
@property (nonatomic, readwrite, strong) NSHTTPURLResponse *URLResponse;

// Canned response data.
@property (nonatomic, readwrite, strong) NSData *responseData;

// The number of intermediate 202 responses that will be simulated. A 202 can be returned
// by Box's servers when content is not yet ready.
@property (nonatomic, readwrite, assign) NSInteger numberOfIntermediate202Responses;

// Block for examining data from HTTP body stream. If set, and there is a body stream, the
// contents of the stream will be piped out to NSData and reported through this block.
@property (nonatomic, readwrite, strong) HTTPBodyDataBlock httpBodyDataBlock;

@end
