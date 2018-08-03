#import "BOXContentClient.h"
#import "BOXAPIAccessTokenDelegate.h"

@interface BoxContentClientServerAuthWrapper : NSObject <BOXAPIAccessTokenDelegate>

@property (nonatomic, readonly, strong) BOXContentClient *boxClient;
@property (nonatomic, readonly, strong) NSString *userId;


- (instancetype)initWithInitialToken:(NSString*)token
                           forUserId:(NSString*)userId
                 withFetchTokenBlock:(void (^) (void (^)(NSString *, NSDate *, NSError *), NSString *userId))fetchTokenBlock;

@end
