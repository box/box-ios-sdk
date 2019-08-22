//
//  BOXBlockExecutionOperation.h
//  BoxContentSDK
//
//  Created by Thuy Nguyen on 8/21/19.
//  Copyright © 2019 Box. All rights reserved.
//

#import "BOXAPIOperation.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^BOXExecutionBlock)(void);
typedef void (^BOXSuccessBlock)(void);
typedef void (^BOXFailureBlock)(NSError *error);

@interface BOXBlockExecutionOperation : BOXAPIOperation

/** @name Callbacks */

/**
 * Called when operation executes
 */
@property (nonatomic, readwrite, strong) BOXExecutionBlock execution;

/**
 * Called when the execution call completes
 */
@property (nonatomic, readwrite, strong) BOXSuccessBlock success;

/**
 * Called when the execution call has not completes because this operation is cancelled
 */
@property (nonatomic, readwrite, strong) BOXFailureBlock failure;
@end

NS_ASSUME_NONNULL_END
