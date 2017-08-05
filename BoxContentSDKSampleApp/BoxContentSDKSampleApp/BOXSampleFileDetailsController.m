//
//  FileDetailsController.m
//  BoxContentSDKSampleApp
//
//  Created by Clement Rousselle on 1/7/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXSampleFileDetailsController.h"
#import "BOXSampleProgressView.h"
#import "BOXSampleAppSessionManager.h"
#import "BOXFileRepresentionListViewControllerTableViewController.h"
#import "BOXItemCollectionService.h"

NS_ENUM(NSInteger, FileDetailsControllerSection) {
    FileDetailsControllerSectionFileInfo = 0,
    FileDetailsControllerSectionOwnerInfo,
    FileDetailsControllerSectionDownload,
    FileDetailsControllerSectionCount
};

static NSString *const favoritesCollectionId = @"2921865";

@interface BOXSampleFileDetailsController ()

@property (nonatomic, readwrite, strong) NSString *itemID;
@property (nonatomic, readwrite, strong) BOXItem *item;
@property (nonatomic, readwrite, strong) BOXAPIItemType *itemType;
@property (nonatomic, readwrite, strong) BOXContentClient *client;
@property (nonatomic, readwrite, strong) BOXFileDownloadRequest *lastDownloadWithResumeRequest;
@property (nonatomic, readwrite, copy) NSString *lastDownloadWithResumeAssociateId;
@property (nonatomic, readwrite, strong) BOXItemCollectionService *itemCollectionService;
@property (nonatomic, readwrite, strong) BOXRequest *request;

@end

@implementation BOXSampleFileDetailsController

- (instancetype)initWithClient:(BOXContentClient *)client itemID:(NSString *)itemID itemType:(BOXAPIItemType *)itemType
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        _client = client;
        _itemID = itemID;
        _itemType = itemType;
    }
    
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    _itemCollectionService = [BOXItemCollectionService new];
    
    if ([self.itemType isEqualToString:BOXAPIItemTypeFile]) {
        
        BOXFileRequest *request = [self.client fileInfoRequestWithID:self.itemID];
        // We want to get all the fields for our file. Not setting this property to YES will result in the API returning only the default fields.
        request.requestAllFileFields = YES;
        [request performRequestWithCompletion:^(BOXFile *file, NSError *error) {
            if (error == nil) {
                self.item = file;
                [self.tableView reloadData];
            }
        }];
        
    } else if ([self.itemType isEqualToString:BOXAPIItemTypeWebLink]) {

        BOXBookmarkRequest *request = [self.client bookmarkInfoRequestWithID:self.itemID];
        // We want to get all the fields for our bookmark. Not setting this property to YES will result in the API returning only the default fields.
        request.requestAllBookmarkFields = YES;
        [request performRequestWithCompletion:^(BOXBookmark *bookmark, NSError *error) {
            if (error == nil) {
                self.item = bookmark;
                [self.tableView reloadData];
            }
        }];
        
    } else {
        BOXLog(@"Unknown file type");
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    if (self.item ==nil) {
        return 0;
    }
    return FileDetailsControllerSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (self.item ==nil) {
        return 0;
    }
    
    NSInteger rows = 0;
    
    switch (section) {
        case FileDetailsControllerSectionFileInfo:
            rows = 6;
            break;
        case FileDetailsControllerSectionOwnerInfo:
            rows = 2;
            break;
        case FileDetailsControllerSectionDownload:
            rows = 4;
            break;
        default:
            break;
    }
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    
    switch (section) {
        case FileDetailsControllerSectionFileInfo:
            title = @"General informations";
            break;
        case FileDetailsControllerSectionOwnerInfo:
            title = @"Owner";
            break;
        default:
            break;
    }

    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *UserTableViewCellIdentifier = @"UserTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserTableViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UserTableViewCellIdentifier];
    }

    switch (indexPath.section) {
        case FileDetailsControllerSectionFileInfo:
            if (indexPath.row == 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"Name: %@", self.item.name];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = [NSString stringWithFormat:@"Description: %@", self.item.itemDescription];
            } else if (indexPath.row == 2) {
                cell.textLabel.text = [NSString stringWithFormat:@"Created at: %@", self.item.createdDate];
            } else if (indexPath.row == 3) {
                cell.textLabel.text = [NSString stringWithFormat:@"Modified at: %@", self.item.modifiedDate];
            } else if (indexPath.row == 4) {
                cell.textLabel.text = [NSString stringWithFormat:@"%ld KB", ([self.item.size integerValue] / (long)1024)];
            } else if (indexPath.row == 5) {
                NSNumber *numberOfComments = nil;
                if ([self.item isKindOfClass:[BOXFile class]]) {
                    numberOfComments = ((BOXFile *)self.item).commentCount;
                } else {
                    numberOfComments = ((BOXBookmark *)self.item).commentCount;
                }
                cell.textLabel.text = [NSString stringWithFormat:@"%@ comment(s)", numberOfComments];
            }
            break;
            
        case FileDetailsControllerSectionOwnerInfo:
            if (indexPath.row == 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"Name: %@",self.item.owner.name];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = [NSString stringWithFormat:@"Login: %@",self.item.owner.login];
            }
            break;
            
        case FileDetailsControllerSectionDownload:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Download";
                if ([self.item isKindOfClass:[BOXFile class]]) {
                    cell.textLabel.textColor = [UIColor blackColor];
                } else {
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                }
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"Download with Resume";
                if ([self.item isKindOfClass:[BOXFile class]]) {
                    cell.textLabel.textColor = [UIColor blackColor];
                } else {
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                }
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"See Representations";
            } else if (indexPath.row == 3) {
                cell.textLabel.text = @"Favorite Item";
            }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == FileDetailsControllerSectionDownload && [self.item isKindOfClass:[BOXFile class]]) {
        return indexPath;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self downloadCurrentItem];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *label = cell.textLabel.text;

        // Click "Download with Resume" to create a new bg download
        // Click "Cancel Download" to cancel current download
        // Click "Resume Download", resume it
        // Upon completion of download or resume, the label goes back to "Download with Resume"

        if ([label isEqualToString:@"Download with Resume"] == YES) {
            self.lastDownloadWithResumeAssociateId = [BOXSampleAppSessionManager generateRandomStringWithLength:32];
            self.lastDownloadWithResumeRequest = [self downloadCurrentItemWithAssociateId:self.lastDownloadWithResumeAssociateId completion:^(NSError *error) {
                if ([cell.textLabel.text isEqualToString:@"Resume Download"] == NO) {
                    cell.textLabel.text = @"Download with Resume";
                }
            }];
            cell.textLabel.text = @"Cancel Download";
        } else if ([label isEqualToString:@"Cancel Download"] == YES) {
            [self.lastDownloadWithResumeRequest cancelWithIntentionToResume];
            cell.textLabel.text = @"Resume Download";
        } else if ([label isEqualToString:@"Resume Download"] == YES) {
            self.lastDownloadWithResumeRequest = [self downloadCurrentItemWithAssociateId:self.lastDownloadWithResumeAssociateId completion:^(NSError *error) {
                cell.textLabel.text = @"Download with Resume";
            }];
            cell.textLabel.text = @"Cancel Download";
        }
    } else if (indexPath.row == 2) {
        if (self.item.isFile) {
            [self displayRepresentations];
        }
    } else  if (indexPath.row == 3) {
        // Click "Favorite Item" add item to favorites
        // Click "Unfavorite Item" remove item from favorites
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *label = cell.textLabel.text;
        
        if ([label isEqualToString:@"Favorite Item"] == YES) {
            cell.textLabel.text = @"Unfavorite Item";
            
            self.request = [self.itemCollectionService addItem:self.item
                                            toCollectionWithID:favoritesCollectionId
                                               completionBlock:nil];
        } else {
            cell.textLabel.text = @"Favorite Item";
            
            self.request = [self.itemCollectionService removeItem:self.item
                                             fromCollectionWithID:favoritesCollectionId
                                                  completionBlock:nil];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Helpers

- (void)displayRepresentations
{
    BOXFileRepresentionListViewControllerTableViewController *controller = [[BOXFileRepresentionListViewControllerTableViewController alloc] initWithFile:(BOXFile *)self.item contentClient:self.client];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Private Helpers
- (void)downloadCurrentItem
{
    NSString *associateId = [BOXSampleAppSessionManager generateRandomStringWithLength:32];
    [self downloadCurrentItemWithAssociateId:associateId completion:nil];
}

- (BOXFileDownloadRequest *)downloadCurrentItemWithAssociateId:(NSString *)associateId completion:(BOXErrorBlock)completionBlock
{
    // Setup our download path (the download can alternatively be done via a NSOutputStream using fileDownloadRequestWithFileID:toOutputStream:
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentRootPath = [documentPaths objectAtIndex:0];
    NSString *finalPath = [documentRootPath stringByAppendingPathComponent:((BOXFile *)self.item).name];

    //save information about this background download to allow reconnection to it upon app restarts
    NSString *userId = self.client.user.modelID;
    BOXSampleAppSessionManager *appSessionManager = [BOXSampleAppSessionManager defaultManager];
    BOXSampleAppSessionInfo *info = [BOXSampleAppSessionInfo new];
    info.fileID = self.itemID;
    info.destinationPath = finalPath;
    [appSessionManager saveUserId:userId associateId:associateId withInfo:info];

    // Setup some UI to track our download progress
    BOXFileDownloadRequest *request = [self.client fileDownloadRequestWithID:self.itemID
                                                             toLocalFilePath:finalPath
                                                                 associateId:associateId];
    [self performRequest:request associateId:associateId completion:completionBlock];
    return request;
}

- (void)performRequest:(BOXFileDownloadRequest *)request associateId:(NSString *)associateId completion:(BOXErrorBlock)completionBlock
{
    NSString *userId = self.client.user.modelID;
    BOXSampleProgressView *progressHeaderView = [[BOXSampleProgressView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), 50.0f)];
    self.tableView.tableHeaderView = progressHeaderView;

    [request performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
        float progress = (float)totalBytesTransferred / (float)totalBytesExpectedToTransfer;
        [progressHeaderView.progressView setProgress:progress animated:YES];
    } completion:^(NSError *error) {
        [[BOXSampleAppSessionManager defaultManager] removeUserId:userId associateId:associateId];
        self.tableView.tableHeaderView = nil;
        NSString *message = [NSString stringWithFormat:@"Your file %@ in the documents directory.", error == nil ? @"was downloaded" : @"failed to download"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:message
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
        if (completionBlock != nil) {
            completionBlock(error);
        }
    }];

//    //Alternative donwload method via a NSOutputStream
//    NSOutputStream *outputStream = [[NSOutputStream alloc] initToMemory];
//    BOXFileDownloadRequest *request = [client fileDownloadRequestWithFileID:self.itemID toOutputStream:outputStream];
//    [request performRequestWithProgress:nil completion:^(NSError *error) {
//        // your file data here
//        NSData *data = [outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
//    }];
}

@end
