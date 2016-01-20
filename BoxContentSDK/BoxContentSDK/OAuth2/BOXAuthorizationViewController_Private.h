//
//  BOXAuthorizationViewController_Private.h
//  Pods
//
//  Created by Chris Vasselli on 1/20/16.
//  Copyright (c) 2016 Box. All rights reserved.
//

#import "BOXAuthorizationViewController.h"

@protocol BOXAuthorizationViewControllerDeviceTrustDelegate

@required
- (void) authorizationViewController:(BOXAuthorizationViewController *)authorizationViewController
            runDeviceTrustForWebView:(UIWebView *)webView;

@end

@interface BOXAuthorizationViewController ()

@property (nonatomic, weak) id<BOXAuthorizationViewControllerDeviceTrustDelegate> deviceTrustDelegate;

@end