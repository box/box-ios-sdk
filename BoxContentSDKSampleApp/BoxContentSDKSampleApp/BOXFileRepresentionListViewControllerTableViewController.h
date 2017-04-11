//
//  BOXFileRepresentionListViewControllerTableViewController.h
//  BoxContentSDKSampleApp
//
//  Created by Clement Rousselle on 3/2/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BOXFileRepresentionListViewControllerTableViewController : UITableViewController

- (instancetype)initWithFile:(BOXFile *)file contentClient:(BOXContentClient *)contentClient;

@end
