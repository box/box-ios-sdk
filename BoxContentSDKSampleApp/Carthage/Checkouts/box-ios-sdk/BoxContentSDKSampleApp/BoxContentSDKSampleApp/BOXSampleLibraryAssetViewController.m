//
//  BOXSampleLibraryAssetViewController.m
//  BoxContentSDKSampleApp
//
//  Created by Sowmiya Narayanan on 4/6/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXSampleLibraryAssetViewController.h"
#import <Photos/Photos.h>

@interface BOXSampleLibraryAssetViewController ()
@property (nonatomic, readwrite, strong) PHFetchResult *assetsFetchResults;
@property (nonatomic, readwrite, strong) NSMutableArray *selectedAssets;
@end

@implementation BOXSampleLibraryAssetViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout]) {
        _selectedAssets = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *uploadButton = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStylePlain target:self action:@selector(uploadAction:)];
    self.navigationItem.rightBarButtonItem = uploadButton;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.allowsSelection = YES;
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.backgroundColor = [UIColor colorWithWhite:252.0f/255.0f alpha:1];
    
    //Photos framework - Request permission from user to access the library
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([PHPhotoLibrary authorizationStatus] ==  PHAuthorizationStatusAuthorized) {
                [self fetchAssetsFromLibrary];
            }
            else {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"No Photo Permissions" message:@"Please grant photo permissions in Settings"  preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        });
    }];
}

- (void)fetchAssetsFromLibrary
{
    //Photos framework - Fetch all assets sorted by ascending order of creation date
    PHFetchOptions * options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:true]];
    self.assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetsFetchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    PHAsset * asset = [self.assetsFetchResults objectAtIndex:indexPath.item];
    
    //Photos framework - Request data for each PHAsset object. The info dictionary contains the fileURL that we will need to upload to box.
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
        cell.backgroundView = imageView;
        
    }];
        
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset * asset = [self.assetsFetchResults objectAtIndex:indexPath.item];
    [self.selectedAssets addObject:asset];
    
    UICollectionViewCell  *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor blueColor].CGColor;
    cell.layer.borderWidth = 2.0;
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset * asset = [self.assetsFetchResults objectAtIndex:indexPath.item];
    [self.selectedAssets removeObject:asset];
    
    UICollectionViewCell  *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor clearColor].CGColor;
    cell.layer.borderWidth = 0.0;
}

- (void)uploadAction:(id)sender
{
    self.assetSelectionCompletionBlock(self.selectedAssets);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
