//
//  ALAssetRepresentationMock.h
//  BoxContentSDK
//
//  Created by Jeremy Pang on 1/6/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetRepresentationMock : ALAssetRepresentation

@property (nonatomic, readwrite) NSString *filename;
@property (nonatomic, readwrite) NSData *data;

@end
