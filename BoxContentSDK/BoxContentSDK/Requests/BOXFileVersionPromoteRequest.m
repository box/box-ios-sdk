//
//  BOXFileVersionPromoteRequest.m
//  BoxContentSDK
//

#import "BOXFileVersionPromoteRequest.h"

#import "BOXFileVersion.h"

@interface BOXFileVersionPromoteRequest ()

@property (nonatomic, readwrite, strong) NSString *fileID;
@property (nonatomic, readwrite, strong) NSString *versionID;

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
    
    versionPromoteOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
        [BOXDispatchHelper callCompletionBlock:^{
            BOXFileVersion *fileVersion = [[BOXFileVersion alloc] initWithJSON:JSONDictionary];

            if ([self.cacheClient respondsToSelector:@selector(cacheFileVersionsRequest:withVersions:error:)]) {
                [self.cacheClient cacheFileVersionPromoteRequest:self
                                                     withVersion:fileVersion
                                                           error:nil];
            }
            if (completionBlock) {
                completionBlock(fileVersion, nil);
            }
        } onMainThread:isMainThread];
    };
    versionPromoteOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
        [BOXDispatchHelper callCompletionBlock:^{

            if ([self.cacheClient respondsToSelector:@selector(cacheFileVersionsRequest:withVersions:error:)]) {
                [self.cacheClient cacheFileVersionPromoteRequest:self
                                                     withVersion:nil
                                                           error:error];
            }
            if (completionBlock) {
                completionBlock(nil, error);
            }
        } onMainThread:isMainThread];
    };
    [self performRequest];
}

@end
