//
//  BOXFileVersionsRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFileVersionRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXFileVersion.h"
#import "BOXDispatchHelper.h"

@interface BOXFileVersionRequest ()

@property (nonatomic, readwrite, strong) NSString *fileID;
@property (nonatomic, readwrite, strong) NSString *versionID;

@end

@implementation BOXFileVersionRequest

- (instancetype)initWithFileID:(NSString *)fileID versionID:(NSString *)versionID
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
                                 subID:self.versionID];
    
    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:nil
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    
    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXFileVersionBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *fileVersionOperation = (BOXAPIJSONOperation *)self.operation;

        fileVersionOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            BOXFileVersion* fileVersion = [[BOXFileVersion alloc] initWithJSON:JSONDictionary];
            
            if ([self.cacheClient respondsToSelector:@selector(cacheFileVersionRequest:withVersion:error:)]) {
                [self.cacheClient cacheFileVersionRequest:self
                                              withVersion:fileVersion
                                                     error:nil];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(fileVersion ,nil);
            } onMainThread:isMainThread];
        };
        fileVersionOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

            if ([self.cacheClient respondsToSelector:@selector(cacheFileVersionRequest:withVersion:error:)]) {
                [self.cacheClient cacheFileVersionRequest:self
                                              withVersion:nil
                                                     error:error];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil,error);
            } onMainThread:isMainThread];
        };
        [self performRequest];
    }
}

- (void)performRequestWithCached:(BOXFileVersionBlock)cacheBlock
                       refreshed:(BOXFileVersionBlock)refreshBlock
{
    if (cacheBlock) {
        if ([self.cacheClient respondsToSelector:@selector(retrieveCacheForFileVersionRequest:completion:)]) {
            [self.cacheClient retrieveCacheForFileVersionRequest:self completion:cacheBlock];
        } else {
            cacheBlock(nil, nil);
        }
    }

    [self performRequestWithCompletion:refreshBlock];
}


#pragma mark - Superclass overidden methods

// TODO: I am not sure about the meaning of this - let's discuss it please
- (NSString *)itemIDForSharedLink
{
    return self.fileID;
}

// TODO: I am not sure about the meaning of this - let's discuss it please
- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeFileVersion;
}

@end
