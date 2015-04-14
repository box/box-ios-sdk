//
//  BOXInputStreamTestHelper.m
//  BoxContentSDK
//
//  Created by Jeremy Pang on 1/9/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXInputStreamTestHelper.h"

@interface BOXInputStreamTestHelper ()

@property (nonatomic, readwrite, strong) void (^completion)(NSString *);

@end

@implementation BOXInputStreamTestHelper

- (instancetype)initWithInputStream:(NSInputStream *)inputStream completion:(void (^)(NSString *))completion {
    
    self = [super init];
    
    if (self) {
        _completion = completion;
        inputStream.delegate = self;
        [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [inputStream open];
    }

    return self;
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    switch(eventCode) {
        case NSStreamEventHasBytesAvailable:
        {
            NSMutableData *dataFromStream = [NSMutableData data];
            uint8_t byteBuffer[4096];
            NSInteger bytesRead;
            while ((bytesRead = [(NSInputStream *)stream read:byteBuffer maxLength:4096]) != 0) {
                if (bytesRead > 0) {
                    [dataFromStream appendBytes:byteBuffer length:bytesRead];
                }
            }
            [stream close];
            NSString *string = [[NSString alloc] initWithData:dataFromStream encoding:NSUTF8StringEncoding];
            if (self.completion) {
                self.completion(string);
            };
            break;
        }
        default:
            break;
    }
}

@end
