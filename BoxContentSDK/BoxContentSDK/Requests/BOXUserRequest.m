//
//  BOXUserRequest.m
//  BoxContentSDK
//

#import "BOXUserRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXContentSDKConstants.h"
#import "BOXUser.h"

@implementation BOXUserRequest

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceUsers
                                    ID:@"me"
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
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *folderOperation = (BOXAPIJSONOperation *)self.operation;

    if (completionBlock) {
        folderOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            BOXUser *user = [[BOXUser alloc] initWithJSON:JSONDictionary];
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(user, nil);
            } onMainThread:isMainThread];
        };
        folderOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        };
    }

    [self performRequest];
}

@end
