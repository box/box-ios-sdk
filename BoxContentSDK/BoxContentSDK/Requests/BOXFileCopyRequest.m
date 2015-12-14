//
//  BOXFileCopyRequest.m
//  BoxContentSDK
//

#import "BOXFileCopyRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXFile.h"
#import "BOXRequest_Private.h"

@implementation BOXFileCopyRequest

- (instancetype)initWithFileID:(NSString *)fileID
           destinationFolderID:(NSString *)destinationFolderID
{
    if (self = [super init]) {
        _fileID = fileID;
        _destinationFolderID = destinationFolderID;
    }

    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:BOXAPISubresourceCopy
                                 subID:nil];
    
    NSDictionary *queryParameters = nil;
    
    if (self.requestAllFileFields) {
        queryParameters = @{BOXAPIParameterKeyFields: [self fullFileFieldsParameterString]};
    }

    NSMutableDictionary *bodyDictionary = [NSMutableDictionary dictionary];
    
    if (self.destinationFolderID.length > 0) {
        bodyDictionary[BOXAPIObjectKeyParent] = @{BOXAPIObjectKeyID : self.destinationFolderID};
    }

    if (self.fileName.length > 0) {
        bodyDictionary[BOXAPIObjectKeyName] = self.fileName;
    }

    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodPOST
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:bodyDictionary
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    
    [self addSharedLinkHeaderToRequest:JSONoperation.APIRequest];

    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *fileOperation = (BOXAPIJSONOperation *)self.operation;

    fileOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
        BOXFile *file = [[BOXFile alloc] initWithJSON:JSONDictionary];

        if ([self.cacheClient respondsToSelector:@selector(cacheFileCopyRequest:withFile:error:)]) {
            [self.cacheClient cacheFileCopyRequest:self
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

        if ([self.cacheClient respondsToSelector:@selector(cacheFileCopyRequest:withFile:error:)]) {
            [self.cacheClient cacheFileCopyRequest:self
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
