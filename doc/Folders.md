Folders
=======

Get Info about a Box Folder
---------------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXFolderRequest *folderInfoRequest = [contentClient folderInfoRequestWithID:@"folder-id"];
[folderInfoRequest performRequestWithCompletion:^(BOXFolder *folder, NSError *error) {
	// If successful, folder will be non-nil; otherwise, error will be non-nil.
}];
```

Get the items in a Box Folder
--------------------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXFolderItemsRequest *folderItemsRequest = [contentClient folderItemsRequestWithID:@"folder-id"];
[folderItemsRequest performRequestWithCompletion:^(NSArray *items, NSError *error) {
	// If successful, items will be non-nil and contain the list of items; otherwise, error will be non-nil.
}];
```

Update Properties of a Box Folder
---------------------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXFolderUpdateRequest *folderUpdateRequest = [contentClient folderUpdateRequestWithID:@"folder-id"];

// Update properties.
folderUpdateRequest.folderName = @"new folder name.jpg";
folderUpdateRequest.folderDescription = @"new folder description.";

[folderUpdateRequest performRequestWithCompletion:^(BOXFolder *folder, NSError *error) {
	// If successful, folder will be non-nil and contain updated properties.
	// Otherwise, error will be non-nil.
}];
```

Delete a Box Folder
-------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXFolderDeleteRequest *folderDeleteRequest = [contentClient folderDeleteRequestWithID:@"folder-id"];

// Optional: By default the folder will be deleted including all the files/folders within.
// Set 'recursive' to false to only allow for the deletion if the folder is empty.
folderDeleteRequest.recursive = NO;

[folderDeleteRequest performRequestWithCompletion:^(NSError *error) {
	// If successful, error will be nil.
}];
```

Create a new Box Folder
-----------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXFolderCreateRequest *folderCreateRequest = [contentClient folderCreateRequestWithName:@"New Folder" parentFolderID:BOXAPIFolderIDRoot];
[folderCreateRequest performRequestWithCompletion:^(BOXFolder *folder, NSError *error) {
	// If successful, folder will be non-nil and represent the newly created folder on Box; otherwise, error will be non-nil.
}];
```
