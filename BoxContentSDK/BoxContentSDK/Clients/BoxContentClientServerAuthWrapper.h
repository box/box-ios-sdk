#import "BOXContentClient.h"
#import "BOXAPIAccessTokenDelegate.h"

@interface BoxContentClientServerAuthWrapper : NSObject <BOXAPIAccessTokenDelegate>

@property (nonatomic, readonly, strong) BOXContentClient *boxClient;
@property (nonatomic, readonly, strong) NSString *userId;
@property (nonatomic, readonly, strong) NSDictionary *userInfo;


- (instancetype)initWithToken:(NSString*)token
                       userId:(NSString*)userId
                     userInfo:(nullable NSDictionary *)userInfo
              fetchTokenBlock:(void (^) (NSString *userId, NSDictionary *userInfo, void (^)(NSString *, NSDate *, NSError *)))fetchTokenBlock;

@end
