//
//  BOXFileVersionPromoteRequest.m
//  BoxContentSDK
//

#import "BOXFileVersionPromoteRequest.h"

#import "BOXFileVersion.h"

@interface BOXFileVersionPromoteRequest ()
@property (nonatomic, readonly, strong) NSString *fileID;
@property (nonatomic, readonly, strong) NSString *versionID;
@end

@implementation BOXFileVersionPromoteRequest

- (instancetype)initWithFileID:(NSString *)fileID targetVersionID:(NSString *)versionID
{
    if (self = [super init]) {
        _fileID = fileID;
        _versionID = versionID;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:BOXAPISubresourceVersions
                                 subID:BOXAPISubresourceCurrent];
    
    NSDictionary *bodyDictionary = @{BOXAPIObjectKeyType : BOXAPIItemTypeFileVersion,
                                     BOXAPIObjectKeyID : self.versionID};
    
    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodPOST
                                              queryStringParameters:nil
                                                     bodyDictionary:bodyDictionary
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    
    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXFileVersionBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *versionPromoteOperation = (BOXAPIJSONOperation *)self.operation;
    
    if (completionBlock) {
        versionPromoteOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                BOXFileVersion *fileVersion = [[BOXFileVersion alloc] initWithJSON:JSONDictionary];
                completionBlock(fileVersion, nil);
            } onMainThread:isMainThread];
        };
        versionPromoteOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        };
    }
    
    [self performRequest];
}

@end
