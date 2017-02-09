//
//  BOXMetadataDeleteRequest.m
//  BoxContentSDK
//
//  Created on 6/14/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXRequest+Metadata.h"
#import "BOXMetadataDeleteRequest.h"

@interface BOXMetadataDeleteRequest ()

@property (nonatomic, readwrite, strong) NSString *fileID;

@end

@implementation BOXMetadataDeleteRequest

- (instancetype)initWithFileID:(NSString *)fileID template:(NSString *)templateName
{
    return [self initWithFileID:fileID scope:BOXAPITemplateScopeEnterprise template:templateName];
}

- (instancetype)initWithFileID:(NSString *)fileID scope:(NSString *)scope template:(NSString *)templateName
{
    if (self = [super init]) {
        self.fileID = fileID;
        self.scope = scope;
        self.templateName = templateName;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    BOXAssert(self.fileID, @"BOXMetadataDeleteRequest FileID must not be nil");
    BOXAssert(self.scope, @"BOXMetadataDeleteRequest Scope must not be nil");
    BOXAssert(self.templateName, @"BOXMetadataDeleteRequest Template must not be nil");
    
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:BOXAPISubresourceMetadata
                                 scope:self.scope
                              template:self.templateName];
    
    BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodDELETE
                                              queryStringParameters:nil
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    
    if ([self.notMatchingEtags count] > 0) {
        for (NSString *notMatchingEtags in self.notMatchingEtags) {
            [JSONOperation.APIRequest addValue:notMatchingEtags forHTTPHeaderField:BOXAPIHTTPHeaderIfNoneMatch];
        }
    }
    
    return JSONOperation;
}

- (void)performRequestWithCompletion:(BOXErrorBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *metadataOperation = (BOXAPIJSONOperation *)self.operation;

    metadataOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil);
            } onMainThread:isMainThread];
        }
    };
    metadataOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(error);
            } onMainThread:isMainThread];
        }
    };
    [self performRequest];
}

@end
