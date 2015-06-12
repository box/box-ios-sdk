//
//  ViewController.m
//  BoxContentSDKSampleApp
//
//  Created on 1/5/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXSampleAccountsViewController.h"
#import "BOXSampleFolderViewController.h"

@interface BOXSampleAccountsViewController ()

@property (nonatomic, readwrite, strong) NSArray *users;
@property (nonatomic, readwrite, assign) BOOL isAppUsers;

@end

@implementation BOXSampleAccountsViewController

- (instancetype)initWithAppUsers:(BOOL)appUsers
{
    if ([self init]) {
        self.isAppUsers = appUsers;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.title = @"Accounts";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(barButtonPressed:)];
    
    NSMutableArray *users = [[NSMutableArray alloc]init];
    for (BOXUser *user in [BOXContentClient users]) {
        BOXContentClient *client = [BOXContentClient clientForUser:user];
        if (   ([client.session isKindOfClass:[BOXOAuth2Session class]] && !self.isAppUsers)
            || ([client.session isKindOfClass:[BOXAppUserSession class]] && self.isAppUsers)) {
            [users addObject:user];
        }
    }
    
    self.users = users;
    
    [self.tableView reloadData];
}

- (void)barButtonPressed:(UIBarButtonItem *)sender
{
    // Create a new client for the account we want to add.
    BOXContentClient *client = [BOXContentClient clientForNewSession];
    
    if (self.isAppUsers) {
        [client setAccessTokenDelegate:self];
    }
    
    [client authenticateWithCompletionBlock:^(BOXUser *user, NSError *error) {
        if (error) {
            if ([error.domain isEqualToString:BOXContentSDKErrorDomain] && error.code == BOXContentSDKAPIUserCancelledError) {
                BOXLog(@"Authentication was cancelled, please try again.");
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"Login failed, please try again"
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                [alertView show];
            }
        } else {
            BOXContentClient *tmpClient = [BOXContentClient clientForUser:user];
            
            if ([tmpClient.user.modelID isEqualToString:client.user.modelID] && ![tmpClient.session.accessToken isEqualToString:client.session.accessToken]) {
                [tmpClient logOut];
                [self barButtonPressed:nil];
            } else {
                self.users = [self.users arrayByAddingObject:user];
                [self.tableView reloadData];
            }
        }
    }];
}

- (void)fetchAccessTokenWithCompletion:(void (^)(NSString *, NSDate *, NSError *))completion
{
#warning Include logic to retrieve access token or use Developer Token found at https://developers.box.com/
    completion(@"your_access_token", [NSDate dateWithTimeIntervalSinceNow:1000], nil);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *logoutButton = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                            title:@"Log Out" 
                                                                          handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                          {   
                                              // Logout the user so that we remove any credential informations.
                                              BOXUser *user = self.users[indexPath.row];
                                              [[BOXContentClient clientForUser:user] logOut];
                                              
                                              NSMutableArray *mutableUsers = [self.users mutableCopy];
                                              [mutableUsers removeObject:user];
                                              self.users = [mutableUsers copy];
                                              [self.tableView reloadData];
                                          }];
    
    return @[logoutButton];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UserTableViewCellIdentifier = @"UserTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserTableViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:UserTableViewCellIdentifier];
    }
    
    BOXUser *user = self.users[indexPath.row];

    if (user.name.length > 0) {
        cell.textLabel.text = user.name;
        cell.detailTextLabel.text = user.login;
    } else {
        cell.textLabel.text = user.login;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOXUser *user = self.users[indexPath.row];
    BOXContentClient *client = [BOXContentClient clientForUser:user];
    
    if (self.isAppUsers) {
        [client setAccessTokenDelegate:self];
    }
    
    BOXSampleFolderViewController *folderListingController = [[BOXSampleFolderViewController alloc] initWithClient:client folderID:BOXAPIFolderIDRoot];
    [self.navigationController pushViewController:folderListingController animated:YES];
}

@end
