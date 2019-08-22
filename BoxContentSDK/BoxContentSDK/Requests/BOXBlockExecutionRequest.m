//
//  BOXBlockExecutionRequest.m
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 8/21/19.
//  Copyright © 2019 Box. All rights reserved.
//

#import <BOXContentSDK/BOXBlockExecutionRequest.h>
#import "BOXBlockExecutionOperation.h"
#import "BOXRequest_Private.h"
#import "BOXAPIQueueManager.h"
#import "BOXDispatchHelper.h"

@implementation BOXBlockExecutionRequest


- (BOXAPIOperation *)createOperation
{
    BOXBlockExecutionOperation *operation = [[BOXBlockExecutionOperation alloc] init];
    operation.session = self.queueManager.session;
    return operation;
}

- (void)performRequestWithBlock:(void(^)(void))block completion:(void(^)(NSError *error))completionBlock
{
    BOXBlockExecutionOperation *op = (BOXBlockExecutionOperation *)self.operation;
    op.execution = block;

    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];

        op.success = ^() {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil);
            } onMainThread:isMainThread];
        };
        op.failure = ^(NSError *error) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(error);
            } onMainThread:isMainThread];
        };
    }
    [self performRequest];
}

@end
