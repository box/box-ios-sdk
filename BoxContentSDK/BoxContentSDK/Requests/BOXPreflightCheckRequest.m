//
//  BOXPreflightCheckRequest.m
//  BoxContentSDK
//

#import "BOXPreflightCheckRequest.h"

@implementation BOXPreflightCheckRequest

- (instancetype)initWithFileName:(NSString *)fileName fileID:(NSString *)fileID
{
    if (self = [super init]) {
        _fileName = fileName;
        _fileID = fileID;
    }
    return self;
}

- (instancetype)initWithFileName:(NSString *)fileName parentFolderID:(NSString *)parentFolderID
{
    if (self = [super init]) {
        _fileName = fileName;
        _parentFolderID = parentFolderID;
    }
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSMutableDictionary *bodyDictionary = [NSMutableDictionary dictionary];
    
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:BOXAPISubresourceContent
                                 subID:nil];
    
    if (self.fileName.length > 0) {
        bodyDictionary[BOXAPIObjectKeyName] = self.fileName;
    }
    
    if (self.parentFolderID.length > 0) {
        NSDictionary *parentID = @{BOXAPIObjectKeyID : self.parentFolderID};
        bodyDictionary[BOXAPIObjectKeyParent] = parentID;
    }
    
    bodyDictionary[BOXAPIObjectKeySize] = [NSNumber numberWithUnsignedLong:self.fileSize];
    
    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodOPTIONS
                                              queryStringParameters:nil
                                                     bodyDictionary:bodyDictionary
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    
    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXErrorBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *folderOperation = (BOXAPIJSONOperation *)self.operation;
    folderOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil);
            } onMainThread:isMainThread];
        }
    };
    folderOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(error);
            } onMainThread:isMainThread];
        }
    };
    
    [self performRequest];
}

@end
