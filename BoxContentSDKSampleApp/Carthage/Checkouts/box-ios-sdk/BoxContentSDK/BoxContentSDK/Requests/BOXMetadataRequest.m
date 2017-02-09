//
//  BOXMetadataRequest.m
//  BoxContentSDK
//
//  Created on 6/12/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXRequest_Private.h"
#import "BOXMetadataRequest.h"
#import "BOXMetadata.h"
#import "BOXDispatchHelper.h"
#import "BOXRequest+Metadata.h"

@interface BOXMetadataRequest ()

@property (nonatomic, readwrite, strong) NSString *fileID;

@end

@implementation BOXMetadataRequest

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
    BOXAssert(self.fileID, @"BOXMetadataRequest FileID must be not be nil.");
    BOXAssert((self.scope && self.templateName) || (!self.scope && !self.templateName), @"BOXMetadataRequest Scope and Template must both be set or both be nil");
    
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:BOXAPISubresourceMetadata
                                 scope:self.scope
                              template:self.templateName];
    
    // Are there query parameters for metedata?
    NSDictionary *queryParameters = nil;
    
    BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:queryParameters
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

- (void)performRequestWithCompletion:(BOXMetadatasBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *metadataOperation = (BOXAPIJSONOperation *)self.operation;

        metadataOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                NSArray *entries = JSONDictionary[@"entries"];
                if (entries) {
                    NSMutableArray *metadatas = [[NSMutableArray alloc]init];
                    for (NSDictionary *currMetadata in entries) {
                        BOXMetadata *metadata = [[BOXMetadata alloc]initWithJSON:currMetadata];
                        [metadatas addObject:metadata];
                    }
                    completionBlock(metadatas, nil);
                } else {
                    BOXMetadata *metadata = [[BOXMetadata alloc]initWithJSON:JSONDictionary];
                    completionBlock(@[metadata], nil);
                }
            } onMainThread:isMainThread];
        };
        
        metadataOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        };
        [self performRequest];
    }
}

@end