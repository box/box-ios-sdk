//
//  BOXFileThumbnailRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFileThumbnailRequest.h"

#import "BOXAPIDataOperation.h"

@interface BOXFileThumbnailRequest ()

@property (nonatomic, readonly, strong) NSOutputStream *outputStream;

@end

@implementation BOXFileThumbnailRequest

- (instancetype)initWithFileID:(NSString *)fileID
{
    if (self = [super init]) {
        _fileID = fileID;
        _outputStream = [[NSOutputStream alloc] initToMemory];
    }
    return self;
}

- (instancetype)initWithFileID:(NSString *)fileID size:(BOXThumbnailSize)size
{
    if (self = [self initWithFileID:fileID]) {
        _maxWidth = [NSNumber numberWithInteger:size];
        _maxHeight = [NSNumber numberWithInteger:size];
    }
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:BOXAPISubresourceThumnailPNG
                                 subID:nil];
    
    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionary];

    if (self.minWidth) {
        queryParameters[BOXAPIParameterKeyMinWidth] = [NSString stringWithFormat:@"%lld", [self.minWidth longLongValue]];
    }

    if (self.minHeight) {
        queryParameters[BOXAPIParameterKeyMinHeight] = [NSString stringWithFormat:@"%lld", [self.minHeight longLongValue]];
    }

    if (self.maxWidth) {
        queryParameters[BOXAPIParameterKeyMaxWidth] = [NSString stringWithFormat:@"%lld", [self.maxWidth longLongValue]];
    }

    if (self.maxHeight) {
        queryParameters[BOXAPIParameterKeyMaxHeight] = [NSString stringWithFormat:@"%lld", [self.maxHeight longLongValue]];
    }

    BOXAPIDataOperation *dataOperation = [self dataOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:nil
                                                       successBlock:nil
                                                       failureBlock:nil];
    dataOperation.fileID = self.fileID;
    dataOperation.outputStream = self.outputStream;

    [self addSharedLinkHeaderToRequest:dataOperation.APIRequest];

    return dataOperation;
}

- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock completion:(BOXImageBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIDataOperation *dataOperation = (BOXAPIDataOperation *)self.operation;

        if (progressBlock) {
            dataOperation.progressBlock = ^(long long expectedTotalBytes, unsigned long long bytesReceived) {
                [BOXDispatchHelper callCompletionBlock:^{
                    progressBlock(bytesReceived, expectedTotalBytes);
                } onMainThread:isMainThread];
            };
        }

        NSOutputStream *outputStream = self.outputStream;
        dataOperation.successBlock = ^(NSString *fileID, long long expectedTotalBytes) {
            NSData *data = [outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
            UIImage *image = [UIImage imageWithData:data scale:[[UIScreen mainScreen] scale]];
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(image, nil);
            } onMainThread:isMainThread];
        };
        dataOperation.failureBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        };
        [self performRequest];
    }
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
