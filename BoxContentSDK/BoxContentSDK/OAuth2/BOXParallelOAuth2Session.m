//
//  BOXParallelOAuth2Session.m
//  BoxContentSDK
//
//  Created on 5/11/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXParallelOAuth2Session.h"
#import "BOXAPIOAuth2ToJSONOperation.h"
#import "BOXLog.h"
#import "BOXContentSDKConstants.h"

@interface BOXParallelOAuth2Session ()

@property (atomic, readwrite, strong) NSMutableSet *expiredOAuth2Tokens;

@end

@implementation BOXParallelOAuth2Session

@synthesize expiredOAuth2Tokens = _expiredOAuth2Tokens;

- (id)initWithClientID:(NSString *)ID secret:(NSString *)secret APIBaseURL:(NSString *)baseURL queueManager:(BOXAPIQueueManager *)queueManager
{
    self = [super initWithClientID:ID secret:secret APIBaseURL:baseURL queueManager:queueManager];
    if (self != nil)
    {
        _expiredOAuth2Tokens = [NSMutableSet set];
    }
    
    return self;
}

- (void)performRefreshTokenGrant:(NSString *)expiredAccessToken withCompletionBlock:(void(^)(BOXOAuth2Session *session, NSError *error))block
{
    @synchronized(self)
    {
        if ([self.expiredOAuth2Tokens containsObject:expiredAccessToken])
        {
            // Only attempt to refresh the token if this is the first time this access
            // token has expired
            return;
        }
        
        BOXLog(@"access token expired: %@", expiredAccessToken);
        BOXLog(@"refreshing tokens");
        if (expiredAccessToken)
        {
            [self.expiredOAuth2Tokens addObject:expiredAccessToken];
        }
        
        [super performRefreshTokenGrant:expiredAccessToken withCompletionBlock:block];
    }
}


@end
