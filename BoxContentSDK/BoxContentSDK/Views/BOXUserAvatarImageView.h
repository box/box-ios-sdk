//
//  BOXUserAvatarImageView.h
//  BoxContentSDK
//
//  Created by Rico Yao on 9/27/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BOXUser.h"
#import "BOXContentClient.h"

@interface BOXUserAvatarImageView : UIImageView

@property (nonatomic, readwrite, strong) BOXUserMini *user;
@property (nonatomic, readonly, strong) BOXContentClient *client;

- (instancetype)initWithFrame:(CGRect)frame
                         user:(BOXUserMini *)user
                       client:(BOXContentClient *)client;

- (instancetype)initWithFrame:(CGRect)frame
                       client:(BOXContentClient *)client;

- (void)refresh;

@end
