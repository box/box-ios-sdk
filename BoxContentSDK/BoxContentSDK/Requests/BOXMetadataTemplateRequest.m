//
//  BOXMetadataTemplateRequest.m
//  BoxContentSDK
//
//  Created on 6/15/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXMetadataTemplateRequest.h"
#import "BOXRequest+Metadata.h"

@interface BOXMetadataTemplateRequest ()

@end

@implementation BOXMetadataTemplateRequest

- (instancetype)init
{
    return [self initWithScope:BOXAPITemplateScopeEnterprise];
}

- (instancetype)initWithScope:(NSString *)scope
{
    if (self = [super init]) {
        self.scope = scope;
    }
    
    return self;
}

- (instancetype)initWithScope:(NSString *)scope template:(NSString *)templateName
{
    if (self = [self initWithScope:scope]) {
        self.templateName = templateName;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    BOXAssert(self.scope, @"BOXMetadataTemplateRequest Scope must not be nil.");
    
    NSURL *URL = [self URLWithResource:BOXAPIResourceMetadataTemplates
                                    ID:nil
                           subresource:nil
                                 scope:BOXAPITemplateScopeEnterprise
                              template:self.templateName];
    
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

- (void)performRequestWithCompletion:(BOXMetadataTemplatesBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *metadataOperation = (BOXAPIJSONOperation *)self.operation;

        metadataOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                NSMutableArray *metadataTemplates = [[NSMutableArray alloc]init];
                NSArray *entries = JSONDictionary[@"entries"];
                if (entries) {
                    for (NSDictionary *currTemplate in entries) {
                        BOXMetadataTemplate *templateObj = [[BOXMetadataTemplate alloc]initWithJSON:currTemplate];
                        [metadataTemplates addObject:templateObj];
                    }
                    completionBlock(metadataTemplates, nil);
                } else {
                    BOXMetadataTemplate *templateObj = [[BOXMetadataTemplate alloc]initWithJSON:JSONDictionary];
                    completionBlock(@[templateObj], nil);
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
