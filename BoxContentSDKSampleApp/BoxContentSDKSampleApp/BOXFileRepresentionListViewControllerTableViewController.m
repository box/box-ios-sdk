//
//  BOXFileRepresentionListViewControllerTableViewController.m
//  BoxContentSDKSampleApp
//
//  Created by Clement Rousselle on 3/2/17.
//  Copyright © 2017 Box. All rights reserved.
//

#import "BOXFileRepresentionListViewControllerTableViewController.h"
#import <BOXContentSDK/BOXRepresentation.h>

@interface BOXFileRepresentionListViewControllerTableViewController ()

@property (nonatomic, readwrite, strong) BOXFile *file;
@property (nonatomic, readwrite, strong) BOXContentClient *client;

@end

@implementation BOXFileRepresentionListViewControllerTableViewController

- (instancetype)initWithFile:(BOXFile *)file contentClient:(BOXContentClient *)contentClient
{
    if (self = [super init]) {
        _file = file;
        _client = contentClient;
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.file.representations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *UserTableViewCellIdentifier = @"representationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserTableViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UserTableViewCellIdentifier];
    }
    BOXRepresentation *rep = self.file.representations[indexPath.row];
    cell.textLabel.text = rep.type;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self downloadRepresentation:self.file.representations[indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)downloadRepresentation:(BOXRepresentation *)representation
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentRootPath = [documentPaths objectAtIndex:0];
    NSString *representationsFolder = [documentRootPath stringByAppendingPathComponent:self.file.SHA1];
    [[NSFileManager defaultManager] createDirectoryAtPath:representationsFolder withIntermediateDirectories:NO attributes:nil error:nil];
    NSString *fileName = (representation.dimensions) ? [representation.type stringByAppendingString:representation.dimensions] : representation.type;
    NSString *finalPath = [representationsFolder stringByAppendingPathComponent:fileName];
    
    BOXFileRepresentationDownloadRequest *request = [self.client fileRepresentationDownloadRequestWithID:self.file.modelID
                                                                                         toLocalFilePath:finalPath
                                                                                          representation:representation];
    
    [request performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
        BOXLog(@"%ld", totalBytesTransferred);
    } completion:^(NSError *error) {
        NSString *title = nil;
        NSString *message = nil;
        
        if (error) {
            title = @"Error";
            message = @"Could not download the representation";
        } else {
            title = @"Representation Downloaded !";
            message = [NSString stringWithFormat:@"Asset Path : %@", finalPath];
        }
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:controller animated:YES completion:nil];
        });
    }];
}

@end
