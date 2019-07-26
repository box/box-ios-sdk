//
//  ViewController.m
//  BoxContentSDKSampleApp
//
//  Created on 1/5/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXSampleAccountsViewController.h"
#import "BOXSampleFolderViewController.h"
#import "BOXSampleAppSessionManager.h"

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
        [self reconnectWithBackgroundTasks:client];
    }
    
    self.users = users;
    
    [self.tableView reloadData];
}

- (void)reconnectWithBackgroundTasks:(BOXContentClient *)client
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSString *userId = client.user.modelID;
        BOXSampleAppSessionManager *appSessionManager = [BOXSampleAppSessionManager defaultManager];
        NSDictionary *associateIdToSessionTaskInfo = [appSessionManager associateIdToSessionTaskInfoForUserId:userId];

        for (NSString *associateId in associateIdToSessionTaskInfo.allKeys) {
            BOXSampleAppSessionInfo *info = associateIdToSessionTaskInfo[associateId];
            if (info.destinationPath != nil) {
                //recreate download task
                BOXFileDownloadRequest *downloadRequest = [client fileDownloadRequestWithID:info.fileID toLocalFilePath:info.destinationPath associateId:associateId];

                [downloadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                    NSLog(@"!!!!!!!download request progress %lld/%lld, info (%@, %@)", totalBytesTransferred, totalBytesExpectedToTransfer, info.fileID, info.destinationPath);
                } completion:^(NSError *error) {
                    NSLog(@"!!!!!!!download request completed, error: %@, info (%@, %@)", error, info.fileID, info.destinationPath);
                    [appSessionManager removeUserId:userId associateId:associateId];
                }];
            } else {
                //Note: for simulator testing purposes, we need to re-create the path to the dummy upload file
                //instead of the previous simulator path which no longer exists after app restarts
                NSString *dummyImageName = @"Logo_Box_Blue_Whitebg_480x480.jpg";
                NSString *path = [[NSBundle mainBundle] pathForResource:dummyImageName ofType:nil];

                NSString *tempFileName = [BOXSampleAppSessionManager generateRandomStringWithLength:32];
                NSString *tempPath = [[[BOXSampleAppSessionManager defaultManager] boxURLRequestCacheDir] stringByAppendingPathComponent:tempFileName];

                if (info.fileID != nil) {

                    //recreate new version upload task
                    BOXFileUploadNewVersionRequest *newVersionRequest = [client fileUploadNewVersionRequestInBackgroundWithFileID:info.fileID fromLocalFilePath:path uploadMultipartCopyFilePath:tempPath associateId:associateId];

                    [newVersionRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                        NSLog(@"!!!!!!!new version upload request progress %lld/%lld, info (%@, %@, %@)", totalBytesTransferred, totalBytesExpectedToTransfer, info.fileID, info.uploadFromLocalFilePath, info.uploadMultipartCopyFilePath);
                    } completion:^(BOXFile *file, NSError *error) {
                        [appSessionManager removeUserId:userId associateId:associateId];
                    }];
                } else {

                    //recreate new file upload task
                    BOXFileUploadRequest *uploadRequest = [client fileUploadRequestInBackgroundToFolderWithID:info.folderID fromLocalFilePath:path uploadMultipartCopyFilePath:tempPath associateId:associateId];

                    [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
                        NSLog(@"!!!!!!new file upload request progress %lld/%lld, info (%@, %@, %@)", totalBytesTransferred, totalBytesExpectedToTransfer, info.folderID, info.uploadFromLocalFilePath, info.uploadMultipartCopyFilePath);
                    } completion:^(BOXFile *file, NSError *error) {
                        [appSessionManager removeUserId:userId associateId:associateId];
                    }];
                }
            }
        }
    });
}

- (void)barButtonPressed:(UIBarButtonItem *)sender
{
    // Create a new client for the account we want to add.
    BOXContentClient *client = [BOXContentClient clientForNewSession];

    [self reconnectWithBackgroundTasks:client];

    if (self.isAppUsers) {
        [client setAccessTokenDelegate:self];
    }
    
    [client authenticateWithCompletionBlock:^(BOXUser *user, NSError *error) {
        if (error) {
            if ([error.domain isEqualToString:BOXContentSDKErrorDomain] && error.code == BOXContentSDKAPIUserCancelledError) {
                BOXLog(@"Authentication was cancelled, please try again.");
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                         message:@"Login failed, please try again"
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     [self dismissViewControllerAnimated:YES
                                                                                              completion:nil];
                                                                 }];
                [alertController addAction:OKAction];
                [self presentViewController:alertController
                                   animated:YES
                                 completion:nil];
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

/** 
 * fetchAccessTokenWithCompletion is a delegate method from the @see BOXAPIAccessTokenDelegate protocol.
 *
 * In order to use Developer's Edition (Aka App Users) to authenticate users with Box,
 * fetchAccessTokenWithCompletion must be implemented and @see BOXContentCliet's delegate must be set.
 * Authenticating users through the Developer's Edition bypasses OAuth2 and uses JWT Authentication instead.
 *
 * **NOTE**
 * Access Token Expiration strings must be converted into NSDate's using the method [NSDate box_dateWithISO8601String:]
 * Access Token Expiration dates must be converted into NSStrings using the method [NSDate box_ISO8601String]
 *
 * More details on how to retrieve access tokens through the Developer's Edition can be found in the link below.
 * https://developers.box.com/developer-edition/
 */
- (void)fetchAccessTokenWithCompletion:(void (^)(NSString *, NSDate *, NSError *))completion
{
#warning Include logic to retrieve access token with the Developer's Edition (App Users) or use Developer Token found at https://developers.box.com/
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
                                              [[BOXSampleAppSessionManager defaultManager] cleanUpForUserId:user.modelID];
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
