//
//  BOXContentClient+AppUser.h
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/8/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <BoxContentSDK/BoxContentSDK.h>

@interface BOXContentClient (AppUsers)


- (void)setAccessTokenDelegate:(id)delegate;
- (void)autheticateAppUserWithCompletionBlock:(void (^)(BOXUser *user, NSError *error))completion;

@end
