Search
======

Search for files and folders
----------------------------

```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXSearchRequest *searchRequest = [contentClient searchRequestWithQuery:@"Search String" inRange:NSMakeRange(0, 1000)];

// Optional: Specify advanced search parameters. See BOXSearchRequest.h for the full list of parameters supported.
searchRequest.ancestorFolderIDs = @[@"folder-id-1", @"folder-id-2"]; // only items in these folders will be returned
searchRequest.fileExtensions = @[@"jpg", @"png"]; // only files with these extensions will be returned

[searchRequest performRequestWithCompletion:^(NSArray *items, NSUInteger totalCount, NSRange range, NSError *error) {
	// If successful, items will be non-nil and contain BOXItem model objects; otherwise, error will be non-nil.
}];
