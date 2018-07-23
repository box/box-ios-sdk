//
//  BOXFolderItemsRequest+Metadata.h
//  BoxContentSDK
//
//  Created by Mina Hattori on 7/19/18.
//  Copyright © 2018 Box. All rights reserved.
//

#import "BOXFolderItemsRequest.h"
#import "BOXContentSDKConstants.h"

@interface BOXFolderItemsRequest (Metadata)

@property (nonatomic, readwrite, copy) NSString *folderID;

//Metadata information parameters
@property (nonatomic, readwrite, copy) NSString *metadataTemplateKey;
@property (nonatomic, readwrite, copy) BOXMetadataScope metadataScope;

- (BOXMetadataScope)metadataScope;
- (NSString *)metadataTemplateKey;

- (instancetype)initWithFolderID:(NSString *)folderID metadataTemplateKey:(NSString *)metadataTemplateKey metadataScope:(BOXMetadataScope)metadataScope;

@end
