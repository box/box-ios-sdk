//
//  BOXMetadataCreateRequest.m
//  BoxContentSDK
//
//  Created on 6/14/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXMetadataCreateRequest.h"
#import "BOXRequest+Metadata.h"

@interface BOXMetadataCreateRequest ()

@property (nonatomic, readwrite, strong) NSString *fileID;

@end

@implementation BOXMetadataCreateRequest

- (instancetype)initWithFileID:(NSString *)fileID scope:(NSString *)scope template:(NSString *)template tasks:(NSArray *)tasks
{
    if (self = [super init]) {
        self.fileID = fileID;
        self.scope = scope;
        self.template = template;
        self.tasks = tasks;
    }
    
    return self;
}

- (instancetype)initWithFileID:(NSString *)fileID template:(NSString *)template tasks:(NSArray *)tasks
{
    return [self initWithFileID:fileID scope:BOXAPITemplateScopeEnterprise template:template tasks:tasks];
}

- (BOXAPIOperation *)createOperation
{
    BOXAssert(self.fileID, @"BOXMetadataCreateRequest FileID must not be nil.");
    BOXAssert(self.scope, @"BOXMetadataCreateRequest Scope must not be nil");
    BOXAssert(self.template, @"BOXMetadataCreateRequest Template must not be nil.");
    BOXAssert(self.tasks, @"BOXMetadataCreateRequest Info must not be nil.");
    
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:BOXAPISubresourceMetadata
                                 scope:self.scope
                              template:self.template];
    
    NSDictionary *queryParameters = nil;
    
    NSMutableDictionary *bodyDictionary = [[NSMutableDictionary alloc]init];
    for (BOXMetadataKeyValue *task in self.tasks) {
        NSString *key = task.path;
        NSString *value = task.value;
        
        if (key && value) {
            [bodyDictionary setObject:value forKey:key];
        }
    }
    
    BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodPOST
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:bodyDictionary
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    
    if ([self.notMatchingEtags count] > 0) {
        for (NSString *notMatchingEtags in self.notMatchingEtags) {
            [JSONOperation.APIRequest addValue:notMatchingEtags forHTTPHeaderField:BOXAPIHTTPHeaderIfNoneMatch];
        }
    }
    
    return JSONOperation;
}

- (void)performRequestWithCompletion:(BOXMetadataBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *metadataOperation = (BOXAPIJSONOperation *)self.operation;
    
    if (completionBlock) {
        metadataOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                BOXMetadata *metadata = [[BOXMetadata alloc]initWithJSON:JSONDictionary];
                completionBlock(metadata, nil);
            } onMainThread:isMainThread];
        };
        
        metadataOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        };
    }
    
    [self performRequest];
}

- (void)setTasks:(NSArray *)tasks
{
    for (NSUInteger i = 0; i < tasks.count; i++) {
        BOXAssert([tasks[i] isKindOfClass:[BOXMetadataKeyValue class]],
                  @"All entries in tasks must be of type BOXMetadataKeyValue. tasks[%lu] is not of type BOXMetadataKeyValue.", (long)i);
    }
    
    _tasks = tasks;
}

@end
