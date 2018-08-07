#import "BoxContentClientServerAuthWrapper.h"
#import "BoxAbstractSession.h"

@interface BoxContentClientServerAuthWrapper ()

@property (nonnull, nonatomic, readonly, strong) ServerAuthFetchTokenBlock fetchTokenBlock;

@end

@implementation BoxContentClientServerAuthWrapper

- (instancetype)initWithToken:(nullable NSString *)token
                       userId:(nullable NSString *)userId
                     userInfo:(nullable NSDictionary *)userInfo
              fetchTokenBlock:(nonnull ServerAuthFetchTokenBlock)fetchTokenBlock
{
    BOXAssert(fetchTokenBlock != nil, @"fetchTokenBlock must be non-nil");
    
    if (self = [super init]) {
        _userId = userId;
        _userInfo = userInfo;
        _fetchTokenBlock = fetchTokenBlock;
        
        _boxClient = [BOXContentClient clientForNewSession];
        [_boxClient setAccessTokenDelegate:self];
        
        [_boxClient session].accessToken = token;
    }
    
    return self;
}

- (void)fetchAccessTokenWithCompletion:(void (^)(NSString *, NSDate *, NSError *))completion
{
    _fetchTokenBlock(_userId, _userInfo, completion);
}

@end
