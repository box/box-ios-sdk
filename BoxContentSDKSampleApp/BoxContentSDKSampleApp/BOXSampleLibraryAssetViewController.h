//
//  BOXSampleLibraryAssetViewController.h
//  BoxContentSDKSampleApp
//
//  Created by Sowmiya Narayanan on 4/6/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BOXSampleLibraryAssetViewController : UICollectionViewController
@property (nonatomic, readwrite, strong) void (^assetSelectionCompletionBlock)(NSArray *selectedAssetLocalPaths);
@end
