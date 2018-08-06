#import "BoxContentClientServerAuthWrapper.h"
#import "BoxAbstractSession.h"

@interface BoxContentClientServerAuthWrapper ()

@property (nonatomic, readonly, strong) void (^fetchTokenBlock) (void (^completion)(NSString *, NSDate *, NSError *), NSString *userId, NSDictionary *userInfo);

@end

@implementation BoxContentClientServerAuthWrapper

- (instancetype)initWithToken:(NSString *)token
                       userId:(NSString *)userId
                     userInfo:(nullable NSDictionary *)userInfo
              fetchTokenBlock:(void (^) (void (^)(NSString *, NSDate *, NSError *), NSString *userId, NSDictionary *userInfo))fetchTokenBlock
{
    BOXAssert(userId != nil, @"forUserId must be non-nil");
    BOXAssert(fetchTokenBlock != nil, @"withFetchTokenBlock must be non-nil");
    
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
    _fetchTokenBlock(completion, _userId, _userInfo);
}

@end
