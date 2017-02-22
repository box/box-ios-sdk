Files
=====

Get Info about a Box File
----------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXFileRequest *fileInfoRequest = [contentClient fileInfoRequestWithID:@"file-id"];
[fileInfoRequest performRequestWithCompletion:^(BOXFile *file, NSError *error) {
	// If successful, file will be non-nil; otherwise, error will be non-nil.
}];
```

Update Properties of a Box File
-------------------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXFileUpdateRequest *fileUpdateRequest = [contentClient fileUpdateRequestWithID:@"file-id"];

// Update properties.
fileUpdateRequest.fileName = @"new file name.jpg";
fileUpdateRequest.fileDescription = @"new file description.";

[fileUpdateRequest performRequestWithCompletion:^(BOXFile *file, NSError *error) {
	// If successful, file will be non-nil and contain updated properties.
	// Otherwise, error will be non-nil.
}];
```

Delete a Box File
-----------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXFileDeleteRequest *fileDeleteRequest = [contentClient fileDeleteRequestWithID:@"file-id"];
[fileDeleteRequest performRequestWithCompletion:^(NSError *error) {
	// If successful, error will be nil.
}];
```

Download a Box File
-------------------
Download to a local file path:
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
NSString *localFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.jpg"];
BOXFileDownloadRequest *boxRequest = [contentClient fileDownloadRequestWithID:@"file-id" toLocalFilePath:localFilePath];
[boxRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
	// Update a progress bar, etc.
} completion:^(NSError *error) {
	// Download has completed. If it failed, error will contain reason (e.g. network connection)
}];
```
Download to an arbitrary NSOutputStream:
----------------------------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
NSString *localFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.jpg"];
NSURL *localFileURL = [NSURL fileURLWithPath:localFilePath];
NSOutputStream *outputStream = [[NSOutputStream alloc] initWithURL:localFileURL append:NO];
BOXFileDownloadRequest *boxRequest = [contentClient fileDownloadRequestWithID:@"file-id" toOutputStream:outputStream];
[boxRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
	// Update a progress bar, etc.
} completion:^(NSError *error) {
	// Download has completed. If it failed, error will contain reason (e.g. network connection)
}];
```

Upload a File
-------------
Upload from a local file:
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
NSString *localFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.jpg"];
BOXFileUploadRequest *uploadRequest = [contentClient fileUploadRequestToFolderWithID:BOXAPIFolderIDRoot fromLocalFilePath:localFilePath];

// Optional: By default the name of the file on the local filesystem will be used as the name on Box. However, you can
// set a different name for the file by configuring the request:
uploadRequest.fileName = @"A different file name.jpg";

[uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
	// Update a progress bar, etc.
} completion:^(BOXFile *file, NSError *error) {
	// Upload has completed. If successful, file will be non-nil; otherwise, error will be non-nil.
}];
```
Upload from NSData:
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXFileUploadRequest *uploadRequest = [contentClient fileUploadRequestToFolderWithID:BOXAPIFolderIDRoot fromData:[@"sample_data" dataUsingEncoding:NSUTF8StringEncoding] fileName:@"sample_file.txt"];
[uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
	// Update a progress bar, etc.
} completion:^(BOXFile *file, NSError *error) {
	// Upload has completed. If successful, file will be non-nil; otherwise, error will be non-nil.
}];
```

Create a Shared Link
--------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXFileShareRequest *shareRequest = [contentClient sharedLinkCreateRequestForFileWithID:@"file-id"];

// Optional: Customize the shared link to be created
shareRequest.accessLevel = BOXSharedLinkAccessLevelCompany;
shareRequest.expirationDate = [NSDate dateWithTimeInterval:3600 sinceDate:[NSDate date]];
shareRequest.canDownload = NO;
shareRequest.canPreview = YES;

[shareRequest performRequestWithCompletion:^(BOXFile *file, NSError *error) {
	// You can confirm creation of the shared link through the sharedLink 
	// property of the BOXFile that is returned.
	NSLog(@"Shared link URL: %@", file.sharedLink.url);
}]; 
```
