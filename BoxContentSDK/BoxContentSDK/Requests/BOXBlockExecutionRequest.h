//
//  BOXBlockExecutionRequest.h
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 8/21/19.
//  Copyright © 2019 Box. All rights reserved.
//

#import <BOXContentSDK/BOXRequest.h>

@interface BOXBlockExecutionRequest : BOXRequest

- (void)performRequestWithBlock:(void(^)(void))block completion:(void(^)(NSError *error))completionBlock;

@end
