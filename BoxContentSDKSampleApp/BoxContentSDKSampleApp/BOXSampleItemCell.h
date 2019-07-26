//
//  ItemCell.h
//  BoxContentSDKSampleApp
//
//  Created on 1/7/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BOXSampleItemCell : UITableViewCell

@property (nonatomic, readwrite, strong) BOXItem *item;
@property (nonatomic, readwrite, strong) BOXContentClient *client;

@end
