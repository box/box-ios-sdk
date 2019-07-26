//
//  BOXFolderItemsRequest+Metadata.m
//  BoxContentSDK
//
//  Created by Mina Hattori on 7/19/18.
//  Copyright © 2018 Box. All rights reserved.
//

#import "BOXFolderItemsRequest+Metadata.h"
#import <objc/runtime.h>

static const void *kmetadataScope;
static const void *kmetadataTemplateKey;

@implementation BOXFolderItemsRequest (Metadata)

- (BOXMetadataScope)metadataScope
{
    return (BOXMetadataScope) objc_getAssociatedObject(self,&kmetadataScope);
}

- (NSString *)metadataTemplateKey
{
    return (NSString *) objc_getAssociatedObject(self,&kmetadataTemplateKey);
}

- (void)setMetadataScope:(BOXMetadataScope)metadataScope
{
    objc_setAssociatedObject(self,&kmetadataScope,metadataScope,OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setMetadataTemplateKey:(NSString *)metadataTemplateKey
{
    objc_setAssociatedObject(self,&kmetadataTemplateKey,metadataTemplateKey,OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (instancetype)initWithFolderID:(NSString *)folderID metadataTemplateKey:(NSString *)metadataTemplateKey metadataScope:(BOXMetadataScope)metadataScope
 {
    if (self = [super init]){
        self.folderID = folderID;
        [self setMetadataTemplateKey:metadataTemplateKey];
        [self setMetadataScope:metadataScope];
    }
    return self;
}

@end

