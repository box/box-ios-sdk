//
//  BOXUserRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXUserRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXContentSDKConstants.h"
#import "BOXUser.h"
#import "BOXDispatchHelper.h"

@implementation BOXUserRequest

- (instancetype)initWithUserID:(NSString *)userID
{
    if (self = [super init]) {
        _userID = userID;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSString *currentUserID = @"me";
    
    if ([self.userID length] > 0) {
        currentUserID = self.userID;
    }
    NSURL *URL = [self URLWithResource:BOXAPIResourceUsers
                                    ID:currentUserID
                           subresource:nil
                                 subID:nil];

    NSDictionary *queryParameters = nil;
    
    if (self.requestAllUserFields) {
        queryParameters = @{BOXAPIParameterKeyFields : [self fullUserFieldsParameterString]};
    }

    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];

    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXUserBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *folderOperation = (BOXAPIJSONOperation *)self.operation;

        folderOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            BOXUser *user = [[BOXUser alloc] initWithJSON:JSONDictionary];

            if ([self.cacheClient respondsToSelector:@selector(cacheUserRequest:withUser:error:)]) {
                [self.cacheClient cacheUserRequest:self
                                          withUser:user
                                             error:nil];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(user, nil);
            } onMainThread:isMainThread];
        };
        folderOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

            if ([self.cacheClient respondsToSelector:@selector(cacheUserRequest:withUser:error:)]) {
                [self.cacheClient cacheUserRequest:self
                                          withUser:nil
                                             error:error];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        };
        [self performRequest];
    }
}

- (void)performRequestWithCached:(BOXUserBlock)cacheBlock
                       refreshed:(BOXUserBlock)refreshBlock
{
    if (cacheBlock) {
        if ([self.cacheClient respondsToSelector:@selector(retrieveCacheForUserRequest:completion:)]) {
            [self.cacheClient retrieveCacheForUserRequest:self completion:cacheBlock];
        } else {
            cacheBlock(nil, nil);
        }
    }

    [self performRequestWithCompletion:refreshBlock];
}

@end
