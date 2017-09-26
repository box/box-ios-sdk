//
//  BOXUserAvatarRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"
#import "BOXContentSDKConstants.h"

@interface BOXUserAvatarRequest : BOXRequest

@property (nonatomic, readonly, strong) NSString *userID;
@property (nonatomic, readwrite, assign) BOXAvatarType avatarType;

- (instancetype)initWithUserID:(NSString *)userID;

- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock
                            cached:(BOXImageBlock)cacheBlock
                         refreshed:(BOXImageBlock)completionBlock;

- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock
                        completion:(BOXImageBlock)completionBlock;

@end
