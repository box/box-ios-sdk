//
//  BOXRepresentationDownloadRequest.m
//  BoxContentSDK
//
//  Created by Clement Rousselle on 3/2/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import "BOXRequest_Private.h"
#import "BOXFileRepresentationDownloadRequest.h"
#import "BOXRepresentation.h"
#import "BOXAPIDataOperation.h"
#import "BOXLog.h"
#import "BOXDispatchHelper.h"

@interface BOXFileRepresentationDownloadRequest ()

@property (nonatomic, readonly, strong) NSString *destinationPath;
@property (nonatomic, readonly, strong) NSOutputStream *outputStream;
@property (nonatomic, readonly, strong) NSString *fileID;
@property (nonatomic, readwrite, strong) BOXRepresentation *representation;
@end

@implementation BOXFileRepresentationDownloadRequest

- (instancetype)initWithLocalDestination:(NSString *)destinationPath
                                  fileID:(NSString *)fileID
                          representation:(BOXRepresentation *)representation
{
    if (self = [super init]) {
        _destinationPath = destinationPath;
        _fileID = fileID;
        _representation = representation;
        _ignoreLocalURLRequestCache = NO;
    }
    return self;
}

- (instancetype)initWithOutputStream:(NSOutputStream *)outputStream
                              fileID:(NSString *)fileID
                      representation:(BOXRepresentation *)representation
{
    if (self = [super init]) {
        _outputStream = outputStream;
        _fileID = fileID;
        _representation = representation;
    }
    return self;
}

- (void) setIgnoreLocalURLRequestCache:(BOOL)ignoreLocalURLRequestCache {
    if(ignoreLocalURLRequestCache) {
        [self.operation.APIRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    } else {
        [self.operation.APIRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    }
}

- (NSURL *)representationURL
{
    NSURL *url = self.representation.contentURL;
    
    NSString *urlString = url.absoluteString;
    NSRange versionStartRange = [urlString rangeOfString:@"versions/"];
    NSRange versionEndRange = [urlString rangeOfString:@"/representations"];
    
    NSInteger startIndex = versionStartRange.location + versionStartRange.length;
    
    NSString *versionString = [urlString substringWithRange:NSMakeRange(startIndex, versionEndRange.location - startIndex)];
    NSString *newVersionString = nil;
    
    if (self.versionID.length > 0) {
        newVersionString = self.versionID;
    } else {
        newVersionString = @"current";
    }
    urlString = [urlString stringByReplacingOccurrencesOfString:versionString withString:newVersionString];
    
    return url = [NSURL URLWithString:urlString];
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self representationURL];
    
    BOXAPIDataOperation *dataOperation = [self dataOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:nil
                                                     bodyDictionary:nil
                                                       successBlock:nil
                                                       failureBlock:nil];
    
    BOXAssert(self.representation != nil, @"A representation must be specified.");
    BOXAssert(self.outputStream != nil || self.destinationPath != nil, @"An output stream or destination file path must be specified.");
    BOXAssert(!(self.outputStream != nil && self.destinationPath != nil), @"You cannot specify both an outputStream and a destination file path.");
    
    if (self.outputStream != nil) {
        dataOperation.outputStream = self.outputStream;
    } else {
        dataOperation.outputStream = [[NSOutputStream alloc] initToFileAtPath:self.destinationPath append:NO];
    }
    
    [self addSharedLinkHeaderToRequest:dataOperation.APIRequest];
    
    return dataOperation;
}

- (void)performRequestWithProgress:(BOXProgressBlock)progressBlock completion:(BOXErrorBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        
        BOXAPIDataOperation *fileOperation = (BOXAPIDataOperation *)self.operation;
        if (progressBlock) {
            fileOperation.progressBlock = ^(long long expectedTotalBytes, unsigned long long bytesReceived) {
                [BOXDispatchHelper callCompletionBlock:^{
                    progressBlock(bytesReceived, expectedTotalBytes);
                } onMainThread:isMainThread];
            };
        }
        
        fileOperation.successBlock = ^(NSString *modelID, long long expectedTotalBytes) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil);
            } onMainThread:isMainThread];
        };
        fileOperation.failureBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(error);
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

