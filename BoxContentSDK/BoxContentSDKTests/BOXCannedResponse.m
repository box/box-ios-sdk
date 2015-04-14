//
//  BOXCannedResponse.m
//  BoxContentSDK
//
//  Created by Rico Yao on 12/30/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXCannedResponse.h"

@implementation BOXCannedResponse

- (instancetype)initWithURLResponse:(NSHTTPURLResponse *)URLResponse responseData:(NSData *)responseData
{
    if (self = [super init]) {
        _URLResponse = URLResponse;
        _responseData = responseData;
    }
    return self;
}

@end
