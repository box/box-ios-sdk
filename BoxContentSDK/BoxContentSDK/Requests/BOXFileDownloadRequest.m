//
//  BOXFileDownloadRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFileDownloadRequest.h"

#import "BOXAPIDataOperation.h"


@interface BOXFileAccessRequest ()

@property (nonatomic, readonly, strong) NSOutputStream *outputStream;

@property (nonatomic, readonly, strong) NSString *destinationPath;

@end

@interface BOXFileDownloadRequest ()

@end

@implementation BOXFileDownloadRequest

- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock completion:(BOXErrorBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];

    BOXAPIDataOperation *fileOperation = (BOXAPIDataOperation *)self.operation;
    if (progressBlock) {
        fileOperation.progressBlock = ^(long long expectedTotalBytes, unsigned long long bytesReceived) {
            [BOXDispatchHelper callCompletionBlock:^{
                progressBlock(bytesReceived, expectedTotalBytes);
            } onMainThread:isMainThread];
        };
    }
    
    if (completionBlock) {
        fileOperation.successBlock = ^(NSString *fileID, long long expectedTotalBytes) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil);
            } onMainThread:isMainThread];
        };
        fileOperation.failureBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(error);
            } onMainThread:isMainThread];
        };
    }

    [self performRequest];
}

@end
