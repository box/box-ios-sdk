//
//  BOXMetadataUpdateRequest.m
//  BoxContentSDK
//
//  Created on 6/14/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXMetadataUpdateRequest.h"
#import "BOXRequest+Metadata.h"
#import "BOXMetadataUpdateTask.h"

@interface BOXMetadataUpdateRequest ()

@property (nonatomic, readwrite, strong) NSString *fileID;

@end

@implementation BOXMetadataUpdateRequest

- (instancetype)initWithFileID:(NSString *)fileID template:(NSString *)templateName updateTasks:(NSArray *)updateTasks
{
    return [self initWithFileID:fileID scope:BOXAPITemplateScopeEnterprise template:templateName updateTasks:updateTasks];
}

- (instancetype)initWithFileID:(NSString *)fileID scope:(NSString *)scope template:(NSString *)templateName updateTasks:(NSArray *)updateTasks
{
    if (self = [super init]) {
        self.fileID = fileID;
        self.scope = scope;
        self.templateName = templateName;
        self.updateTasks = updateTasks;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    BOXAssert(self.fileID, @"BOXMetadataUpdateRequest FileID must not be nil.");
    BOXAssert(self.scope, @"BOXMetadataUpdateRequest Scope must not be nil.");
    BOXAssert(self.templateName, @"BOXMetadataUpdateRequest Template must not be nil.");
    BOXAssert(self.updateTasks, @"BOXMetadataUpdateRequest UpdateInfo must not be nil.");
    
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:BOXAPISubresourceMetadata
                                 scope:self.scope
                              template:self.templateName];
    
    NSDictionary *queryParameters = nil;
    
    NSMutableArray *bodyArray = [[NSMutableArray alloc]init];
    for (BOXMetadataUpdateTask *task in self.updateTasks) {
        NSString *instruction = [task BOXMetadataUpdateOperationToString:task.operation];
        NSString *path = task.path;
        NSString *value = task.value;
        NSMutableDictionary *taskDict = [[NSMutableDictionary alloc]init];
        
        if (instruction) {
            [taskDict setObject:instruction forKey:BOXAPIMetadataObjectKeyOperation];
        }
        
        if (path) {
            [taskDict setObject:path forKey:BOXAPIMetadataObjectKeyPath];
        }
        
        if (value) {
            [taskDict setObject:value forKey:BOXAPIMetadataObjectKeyValue];
        }
        
        [bodyArray addObject:taskDict];
    }
    
    BOXAPIJSONPatchOperation *JSONPatchOperation = [self JSONPatchOperationWithURL:URL
                                                                        HTTPMethod:BOXAPIHTTPMethodPUT
                                                             queryStringParameters:queryParameters
                                                                         bodyArray:bodyArray
                                                                  JSONSuccessBlock:nil
                                                                      failureBlock:nil];
    
    if ([self.notMatchingEtags count] > 0) {
        for (NSString *notMatchingEtags in self.notMatchingEtags) {
            [JSONPatchOperation.APIRequest addValue:notMatchingEtags forHTTPHeaderField:BOXAPIHTTPHeaderIfNoneMatch];
        }
    }
    
    return JSONPatchOperation;
}

- (void)performRequestWithCompletion:(BOXMetadataBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *metadataOperation = (BOXAPIJSONOperation *)self.operation;
    
    metadataOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                BOXMetadata *metadata = [[BOXMetadata alloc]initWithJSON:JSONDictionary];
                completionBlock(metadata, nil);
            } onMainThread:isMainThread];
        }
    };

    metadataOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
        if (completionBlock) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        }
    };
    [self performRequest];
}

- (void)setUpdateTasks:(NSArray *)updateTasks
{
    for (NSInteger i = 0; i < updateTasks.count; ++i) {
        BOXAssert([updateTasks[i] isKindOfClass:[BOXMetadataUpdateTask class]],
                  @"All entries in updateInfo must be of type BOXMetadataUpdateTask. updateTasks[%lu] is not of type BOXMetadataUpdateTask.", (long)i);
    }
    _updateTasks = updateTasks;
}

@end