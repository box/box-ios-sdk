#import "BOXContentClient.h"
#import "BOXAPIAccessTokenDelegate.h"

typedef void (^ServerAuthFetchTokenBlock)(NSString *userId, NSDictionary *userInfo, void (^)(NSString *, NSDate *, NSError *));

@interface BoxContentClientServerAuthWrapper : NSObject <BOXAPIAccessTokenDelegate>

@property (nonatomic, nonnull, readonly, strong) BOXContentClient *boxClient;
@property (nonatomic, nullable, readonly, strong) NSString *userId;
@property (nonatomic, nullable, readwrite, strong) NSDictionary *userInfo;


- (instancetype)initWithToken:(nullable NSString*)token
                       userId:(nullable NSString*)userId
                     userInfo:(nullable NSDictionary *)userInfo
              fetchTokenBlock:(nonnull ServerAuthFetchTokenBlock)fetchTokenBlock;

@end
