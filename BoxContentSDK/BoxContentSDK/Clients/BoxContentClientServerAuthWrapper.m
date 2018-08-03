#import "BoxContentClientServerAuthWrapper.h"
#import "BoxAbstractSession.h"

@interface BoxContentClientServerAuthWrapper ()

@property (nonatomic, readonly, strong) void (^fetchTokenBlock) (void (^completion)(NSString *, NSDate *, NSError *), NSString *userId);

@end

@implementation BoxContentClientServerAuthWrapper

- (instancetype)initWithToken:(NSString *)token
                    forUserId:(NSString *)userId
          withFetchTokenBlock:(void (^) (void (^)(NSString *, NSDate *, NSError *), NSString *userId))fetchTokenBlock
{
    BOXAssert(userId != nil, @"forUserId must be non-nil");
    BOXAssert(fetchTokenBlock != nil, @"withFetchTokenBlock must be non-nil");
    
    if (self = [super init]) {
        _userId = userId;
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
    _fetchTokenBlock(completion, _userId);
}

@end
