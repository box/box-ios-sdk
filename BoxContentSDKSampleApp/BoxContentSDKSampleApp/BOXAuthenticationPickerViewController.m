//
//  BOXAuthenticationPickerViewController.m
//  BoxContentSDKSampleApp
//
//  Created by Andrew Chun on 6/11/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXAuthenticationPickerViewController.h"
#import "BOXSampleAccountsViewController.h"

@interface BOXAuthenticationPickerViewController ()

@property (nonatomic, readwrite, strong) UIButton *oauthButton;
@property (nonatomic, readwrite, strong) UIButton *appUsersButton;

@end

@implementation BOXAuthenticationPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Authorization";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.oauthButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.oauthButton.frame = CGRectMake(0, 0, 200, 50);
    self.oauthButton.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
    [self.oauthButton setTitle:@"OAuth Accounts" forState:UIControlStateNormal];
    [self.oauthButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.oauthButton];
    
    self.appUsersButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.appUsersButton.frame = CGRectMake(0, 0, 200, 50);
    self.appUsersButton.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
    [self.appUsersButton setTitle:@"AppUser Accounts" forState:UIControlStateNormal];
    [self.appUsersButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.appUsersButton];
}

- (void)buttonPressed:(UIButton *)button
{
    BOXSampleAccountsViewController *accountsViewController = nil;
    
    if (button == self.oauthButton) {
        accountsViewController = [[BOXSampleAccountsViewController alloc]initWithAppUsers:NO];
    } else if (button == self.appUsersButton) {
        accountsViewController = [[BOXSampleAccountsViewController alloc]initWithAppUsers:YES];
    } else {
        NSLog(@"Unknown button pressed. %@", button);
    }
    
    [self.navigationController pushViewController:accountsViewController animated:YES];
}

@end
