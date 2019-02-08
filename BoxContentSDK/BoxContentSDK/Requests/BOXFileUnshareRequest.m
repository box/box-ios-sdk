//
//  BOXFileUnshareRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFileUnshareRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXFile.h"
#import "BOXDispatchHelper.h"

@interface BOXFileUnshareRequest ()

@property (nonatomic, readwrite, copy) NSString *fileID;

@end


@implementation BOXFileUnshareRequest

- (instancetype)initWithFileID:(NSString *)fileID
{
    if (self = [super init]) {
        _fileID = fileID;
    }

    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:nil
                                 subID:nil];

    NSDictionary *bodyDictionary = @{BOXAPIObjectKeySharedLink: [NSNull null]};
    
    NSDictionary *queryParameters = @{BOXAPIParameterKeyFields: [self fullFileFieldsParameterString]};

    BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodPUT
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:bodyDictionary
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    if ([self.matchingEtag length] > 0) {
        // Set up the If-Match header
        [JSONOperation.APIRequest setValue:self.matchingEtag forHTTPHeaderField:BOXAPIHTTPHeaderIfMatch];
    }

    [self addSharedLinkHeaderToRequest:JSONOperation.APIRequest];

    return JSONOperation;
}

- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *fileOperation = (BOXAPIJSONOperation *)self.operation;

    fileOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
        BOXFile *file = [[BOXFile alloc] initWithJSON:JSONDictionary];
        if ([self.cacheClient respondsToSelector:@selector(cacheFileUnshareRequest:withFile:error:)]) {
            [self.cacheClient cacheFileUnshareRequest:self
                                             withFile:file
                                                error:nil];
        }
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(file, nil);
            } onMainThread:isMainThread];
        }
    };
    fileOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
        if ([self.cacheClient respondsToSelector:@selector(cacheFileUnshareRequest:withFile:error:)]) {
            [self.cacheClient cacheFileUnshareRequest:self
                                             withFile:nil
                                                error:error];
        }
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
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
