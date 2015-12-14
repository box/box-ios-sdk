//
//  BOXSharedItemRequest.m
//  BoxContentSDK
//

#import "BOXSharedItemRequest.h"

#import "BOXItem.h"
#import "BOXSharedLinkHeadersHelper.h"

@interface BOXSharedItemRequest ()

@property (nonatomic, readwrite, strong) NSString *sharedLinkURLString;
@property (nonatomic, readwrite, strong) NSString *sharedLinkPassword;

@end

@implementation BOXSharedItemRequest

- (instancetype)initWithURL:(NSURL *)sharedLinkURL password:(NSString *)password
{
    if (self = [super init]) {
        _sharedLinkURLString = sharedLinkURL.absoluteString;
        _sharedLinkPassword = password;
    }

    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceSharedItems
                                    ID:nil
                           subresource:nil
                                 subID:nil];

    BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:nil
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    // Set up the BoxApi header
    NSString *sharedLinkHeaderString = [BOXAPIObjectKeySharedLink stringByAppendingFormat:@"=%@", self.sharedLinkURLString];

    if ([self.sharedLinkPassword length] > 0) {
        sharedLinkHeaderString =
        [sharedLinkHeaderString stringByAppendingFormat:@"&%@=%@", BOXAPIObjectKeySharedLinkPassword, self.sharedLinkPassword];
    }
    [JSONOperation.APIRequest addValue:sharedLinkHeaderString
                    forHTTPHeaderField:BOXAPIHTTPHeaderBoxAPI];

    return JSONOperation;
}

- (void)performRequestWithCompletion:(BOXItemBlock)completion
{
    if (completion) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *sharedItemOperation = (BOXAPIJSONOperation *)self.operation;
        sharedItemOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {

            BOXItem *item = [BOXRequest itemWithJSON:JSONDictionary];

            // Store the shared link and password in case we need to do further API call on this item or any of its descendants.
            [self.sharedLinkHeadersHelper storeHeadersForItemWithID:item.modelID
                                                           itemType:item.type
                                                         sharedLink:self.sharedLinkURLString
                                                           password:self.sharedLinkPassword];

            if ([self.cacheClient respondsToSelector:@selector(cacheSharedItemRequest:withItem:error:)]) {
                [self.cacheClient cacheSharedItemRequest:self
                                                withItem:item
                                                   error:nil];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completion(item, nil);
            } onMainThread:isMainThread];
        };
        sharedItemOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

            if ([self.cacheClient respondsToSelector:@selector(cacheSharedItemRequest:withItem:error:)]) {
                [self.cacheClient cacheSharedItemRequest:self
                                                withItem:nil
                                                   error:error];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completion(nil, error);
            } onMainThread:isMainThread];
        };
        [self performRequest];
    }
}

- (void)performRequestWithCached:(BOXItemBlock)cacheBlock
                       refreshed:(BOXItemBlock)refreshBlock
{
    if (cacheBlock) {
        if ([self.cacheClient respondsToSelector:@selector(retrieveCacheForSharedItemRequest:completion:)]) {
            [self.cacheClient retrieveCacheForSharedItemRequest:self completion:cacheBlock];
        } else {
            cacheBlock(nil, nil);
        }
    }
    
    [self performRequestWithCompletion:refreshBlock];
}

@end
