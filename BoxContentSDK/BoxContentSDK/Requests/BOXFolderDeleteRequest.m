//
//  BOXFolderDeleteRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFolderDeleteRequest.h"
#import "BOXAPIJSONOperation.h"

@interface BOXFolderDeleteRequest ()
@property (nonatomic, readwrite, assign) BOOL isTrashed;
@end

@implementation BOXFolderDeleteRequest

- (instancetype)initWithFolderID:(NSString *)folderID
{
    return [self initWithFolderID:folderID isTrashed:NO];
}

- (instancetype)initWithFolderID:(NSString *)folderID isTrashed:(BOOL)isTrashed
{
    self = [super init];
    if (self != nil) {
        _folderID = folderID;
        _recursive = YES;
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
    
    NSURL *URL = [self URLWithResource:BOXAPIResourceFolders
                                    ID:self.folderID
                           subresource:subresource
                                 subID:nil];

    NSDictionary *queryParameters = nil;

    if (self.recursive) {
        queryParameters = @{BOXAPIParameterKeyRecursive : @"true"};
    }

    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodDELETE
                                              queryStringParameters:queryParameters
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

        if ([self.cacheClient respondsToSelector:@selector(cacheFolderDeleteRequest:error:)]) {
            [self.cacheClient cacheFolderDeleteRequest:self error:nil];
        }
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil);
            } onMainThread:isMainThread];
        }
    };
    folderOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

        if ([self.cacheClient respondsToSelector:@selector(cacheFolderDeleteRequest:error:)]) {
            [self.cacheClient cacheFolderDeleteRequest:self error:error];
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
    return self.folderID;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeFolder;
}

@end
