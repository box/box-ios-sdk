//
//  BOXTrashedFileRestoreRequest.m
//  BoxContentSDK
//

#import "BOXTrashedFileRestoreRequest.h"

#import "BOXFile.h"

@implementation BOXTrashedFileRestoreRequest

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
    
    NSMutableDictionary *bodyDictionary = [NSMutableDictionary dictionary];
    if (self.fileName.length > 0) {
        bodyDictionary[BOXAPIObjectKeyName] = self.fileName;
    }
    if (self.parentFolderID.length > 0) {
        bodyDictionary[BOXAPIObjectKeyParent] = @{BOXAPIObjectKeyID : self.parentFolderID};
    }
    
    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodPOST
                                              queryStringParameters:nil
                                                     bodyDictionary:bodyDictionary
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    
    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *fileOperation = (BOXAPIJSONOperation *)self.operation;
    
    if (completionBlock) {
        fileOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            BOXFile *file = [[BOXFile alloc] initWithJSON:JSONDictionary];
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(file, nil);
            } onMainThread:isMainThread];
        };
        fileOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        };
    }
    
    [self performRequest];
}

@end
