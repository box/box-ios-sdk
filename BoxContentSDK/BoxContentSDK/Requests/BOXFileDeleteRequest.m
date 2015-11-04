//
//  BOXFileDeleteRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFileDeleteRequest.h"
#import "BOXAPIJSONOperation.h"

@interface BOXFileDeleteRequest ()

@property (nonatomic, readwrite, assign) BOOL isTrashed;

@property (nonatomic, readwrite, strong) NSString *fileID;

@end

@implementation BOXFileDeleteRequest

- (instancetype)initWithFileID:(NSString *)fileID
{
    return [self initWithFileID:fileID isTrashed:NO];
}

- (instancetype)initWithFileID:(NSString *)fileID isTrashed:(BOOL)isTrashed
{
    if (self = [super init]) {
        _fileID = fileID;
        _isTrashed = isTrashed;
    }

    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSString *subresource = nil;

    if (self.isTrashed) {
        subresource = BOXAPISubresourceTrash;
    }
    
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:subresource
                                 subID:nil];

    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodDELETE
                                              queryStringParameters:nil
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    if ([self.matchingEtag length] > 0) {
        [JSONoperation.APIRequest setValue:self.matchingEtag forHTTPHeaderField:BOXAPIHTTPHeaderIfMatch];
    }

    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXErrorBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *folderOperation = (BOXAPIJSONOperation *)self.operation;
    
    folderOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {

        if ([self.cacheClient respondsToSelector:@selector(cacheFileDeleteRequest:error:)]) {
            [self.cacheClient cacheFileDeleteRequest:self error:nil];
        }
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil);
            } onMainThread:isMainThread];
        }
    };
    folderOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

        if ([self.cacheClient respondsToSelector:@selector(cacheFileDeleteRequest:error:)]) {
            [self.cacheClient cacheFileDeleteRequest:self error:error];
        }
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(error);
            } onMainThread:isMainThread];
        }
    };
    [self performRequest];
}

#pragma mark - Superclass overidden methods

- (NSString *)itemIDForSharedLink
{
    return self.fileID;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeFile;
}

@end
