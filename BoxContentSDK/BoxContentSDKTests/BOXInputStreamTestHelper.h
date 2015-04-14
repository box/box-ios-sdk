//
//  BOXInputStreamTestHelper.h
//  BoxContentSDK
//
//  Created by Jeremy Pang on 1/9/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOXInputStreamTestHelper : NSObject <NSStreamDelegate>

- (instancetype)initWithInputStream:(NSInputStream *)inputStream completion:(void (^)(NSString *bodyDataString))completion;

@end
