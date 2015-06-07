//
//  BOXAPIAccessTokenDelegate.h
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/6/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

@protocol BOXAPIAccessTokenDelegate <NSObject>

- (void)fetchAccessTokenWithCompletion:(void (^)(NSString *, NSDate *, NSError *))completion;

@end