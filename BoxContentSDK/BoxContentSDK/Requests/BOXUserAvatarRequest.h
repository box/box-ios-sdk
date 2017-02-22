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

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock
                        completion:(BOXImageBlock)completionBlock;

@end
