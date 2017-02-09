//
//  BOXAPIHeadOperation.h
//  BoxContentSDK
//
//  Created on 8/25/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import "BOXAPIAuthenticatedOperation.h"

typedef void (^BOXAPIHeaderSuccessBlock)(NSURLRequest *request, NSHTTPURLResponse *response);
typedef void (^BOXAPIHeaderFailureBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error);
@interface BOXAPIHeadOperation : BOXAPIAuthenticatedOperation

@property (nonatomic, readwrite, strong) BOXAPIHeaderSuccessBlock successBlock;
@property (nonatomic, readwrite, strong) BOXAPIHeaderFailureBlock failureBlock;

@end
