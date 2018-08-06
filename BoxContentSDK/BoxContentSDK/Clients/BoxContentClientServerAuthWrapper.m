#import "BoxContentClientServerAuthWrapper.h"
#import "BoxAbstractSession.h"

@interface BoxContentClientServerAuthWrapper ()

@property (nonatomic, readonly, strong) void (^fetchTokenBlock) (NSString *userId, NSDictionary *userInfo, void (^completion)(NSString *, NSDate *, NSError *));

@end

@implementation BoxContentClientServerAuthWrapper

- (instancetype)initWithToken:(NSString *)token
                       userId:(NSString *)userId
                     userInfo:(nullable NSDictionary *)userInfo
              fetchTokenBlock:(void (^) (NSString *userId, NSDictionary *userInfo, void (^)(NSString *, NSDate *, NSError *)))fetchTokenBlock
{
    BOXAssert(userId != nil, @"userId must be non-nil");
    BOXAssert(fetchTokenBlock != nil, @"fetchTokenBlock must be non-nil");
    
    if (self = [super init]) {
        _userId = userId;
        _userInfo = userInfo;
        _fetchTokenBlock = fetchTokenBlock;
        
        _boxClient = [BOXContentClient clientForNewSession];
        [_boxClient setAccessTokenDelegate:self];
        
        BOXAbstractSession *session = [_boxClient session];
        session.accessToken = token;
    }
    
    return self;
}

- (void)fetchAccessTokenWithCompletion:(void (^)(NSString *, NSDate *, NSError *))completion
{
    _fetchTokenBlock(_userId, _userInfo, completion);
}

@end
