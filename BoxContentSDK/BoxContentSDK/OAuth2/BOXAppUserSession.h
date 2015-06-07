//
//  BOXAppSession.h
//  BoxContentSDK
//
//  Created by Andrew Chun on 6/3/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXAbstractSession.h"

@interface BOXAppUserSession : BOXAbstractSession

- (void)performAuthorizationWithCompletionBlock:(void (^)(BOXAppUserSession *session, NSError *error))block;
- (void)performAuthorizationCodeGrantWithReceivedURL:(NSURL *)URL withCompletionBlock:(void (^)(BOXAppUserSession *, NSError *))block;
- (void)performRefreshTokenGrant:(NSString *)expiredAccessToken withCompletionBlock:(void (^)(BOXAppUserSession *, NSError *))block;

@end
