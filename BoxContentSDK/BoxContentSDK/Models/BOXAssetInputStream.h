//
//  BOXAPIStreamingUploadHelper.h
//  BoxCore
//
//  Created by Boris Suvorov on 7/10/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAssetRepresentation;
@class ALAssetsLibrary;

@interface BOXAssetInputStream : NSInputStream <NSStreamDelegate>

- (instancetype)initWithAssetRepresentation:(ALAssetRepresentation *)assetRepresentation assetsLibrary:(ALAssetsLibrary *)assetsLibrary;

@end
