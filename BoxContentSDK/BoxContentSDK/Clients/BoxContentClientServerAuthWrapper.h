#import "BOXContentClient.h"
#import "BOXAPIAccessTokenDelegate.h"

typedef void (^ServerAuthFetchTokenBlock)(NSString *userId, NSDictionary *userInfo, void (^)(NSString *, NSDate *, NSError *));

@interface BoxContentClientServerAuthWrapper : NSObject <BOXAPIAccessTokenDelegate>

@property (nonatomic, readonly, strong) BOXContentClient *boxClient;
@property (nonatomic, readonly, strong) NSString *userId;
@property (nonatomic, readonly, strong) NSDictionary *userInfo;


- (instancetype)initWithToken:(NSString*)token
                       userId:(NSString*)userId
                     userInfo:(nullable NSDictionary *)userInfo
              fetchTokenBlock:(ServerAuthFetchTokenBlock)fetchTokenBlock;

@end
