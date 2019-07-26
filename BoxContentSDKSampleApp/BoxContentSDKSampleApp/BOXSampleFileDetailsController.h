//
//  FileDetailsController.h
//  BoxContentSDKSampleApp
//
//  Created by Clement Rousselle on 1/7/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BOXSampleFileDetailsController : UITableViewController

- (instancetype)initWithClient:(BOXContentClient *)client itemID:(NSString *)itemID itemType:(BOXAPIItemType *)itemType;

@end
