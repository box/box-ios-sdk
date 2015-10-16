//
//  BOXContentClient+Metadata.m
//  BoxContentSDK
//
//  Created on 6/12/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXContentClient+Metadata.h"
#import "BOXMetadataRequest.h"

@implementation BOXContentClient (Metadata)

- (BOXMetadataRequest *)metadataInfoRequestWithFileID:(NSString *)fileID template:(NSString *)templateName
{
    BOXMetadataRequest *request = [[BOXMetadataRequest alloc]initWithFileID:fileID template:templateName];
    [self prepareRequest:request];
    
    return request;
}

- (BOXMetadataRequest *)metadataInfoRequestWithFileID:(NSString *)fileID scope:(NSString *)scope template:(NSString *)templateName
{
    BOXMetadataRequest *request = [[BOXMetadataRequest alloc]initWithFileID:fileID scope:scope template:templateName];
    [self prepareRequest:request];
    
    return request;
}

- (BOXMetadataRequest *)metadataAllInfoRequestWithFileID:(NSString *)fileID
{
    BOXMetadataRequest *request = [[BOXMetadataRequest alloc]initWithFileID:fileID scope:nil template:nil];
    [self prepareRequest:request];

    return request;
}

- (BOXMetadataDeleteRequest *)metadataDeleteRequestWithFileID:(NSString *)fileID template:(NSString *)templateName
{
    BOXMetadataDeleteRequest *request = [[BOXMetadataDeleteRequest alloc]initWithFileID:fileID template:templateName];
    [self prepareRequest:request];
    
    return request;
}

- (BOXMetadataDeleteRequest *)metadataDeleteRequestWithFileID:(NSString *)fileID scope:(NSString *)scope template:(NSString *)templateName
{
    BOXMetadataDeleteRequest *request = [[BOXMetadataDeleteRequest alloc]initWithFileID:fileID scope:scope template:templateName];
    [self prepareRequest:request];
    
    return request;
}

- (BOXMetadataCreateRequest *)metadataCreateRequestWithFileID:(NSString *)fileID template:(NSString *)templateName tasks:(NSArray *)tasks;
{
    BOXMetadataCreateRequest *request = [[BOXMetadataCreateRequest alloc]initWithFileID:fileID template:templateName tasks:tasks];
    [self prepareRequest:request];
    
    return request;
}

- (BOXMetadataCreateRequest *)metadataCreateRequestWithFileID:(NSString *)fileID scope:(NSString *)scope template:(NSString *)templateName tasks:(NSArray *)tasks
{
    BOXMetadataCreateRequest *request = [[BOXMetadataCreateRequest alloc]initWithFileID:fileID scope:scope template:templateName tasks:tasks];
    [self prepareRequest:request];
    
    return request;
}

- (BOXMetadataUpdateRequest *)metadataUpdateRequestWithFileID:(NSString *)fileID template:(NSString *)templateName updateTasks:(NSArray *)updateTasks
{
    BOXMetadataUpdateRequest *request = [[BOXMetadataUpdateRequest alloc]initWithFileID:fileID template:templateName updateTasks:updateTasks];
    [self prepareRequest:request];
    
    return request;
}

- (BOXMetadataUpdateRequest *)metadataUpdateRequestWithFileID:(NSString *)fileID scope:(NSString *)scope template:(NSString *)templateName updateTasks:(NSArray *)updateTasks
{
    BOXMetadataUpdateRequest *request = [[BOXMetadataUpdateRequest alloc]initWithFileID:fileID scope:scope template:templateName updateTasks:updateTasks];
    [self prepareRequest:request];
    
    return request;
}

- (BOXMetadataTemplateRequest *)metadataTemplatesInfoRequest
{
    BOXMetadataTemplateRequest *request = [[BOXMetadataTemplateRequest alloc]init];
    [self prepareRequest:request];
    
    return request;
}

- (BOXMetadataTemplateRequest *)metadataTemplatesInfoRequestWithScope:(NSString *)scope
{
    BOXMetadataTemplateRequest *request = [[BOXMetadataTemplateRequest alloc]initWithScope:scope];
    [self prepareRequest:request];
    
    return request;
}

- (BOXMetadataTemplateRequest *)metadataTemplateInfoRequestWithScope:(NSString *)scope template:(NSString *)templateName
{
    BOXMetadataTemplateRequest *request = [[BOXMetadataTemplateRequest alloc]initWithScope:scope template:templateName];
    [self prepareRequest:request];
    
    return request;
}

@end
