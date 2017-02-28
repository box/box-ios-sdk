Comments
========

Get the existing Comments of a Box File
---------------------------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXFileCommentsRequest *fileCommentsRequest = [contentClient commentsRequestForFileWithID:@"file-id"];
[fileCommentsRequest performRequestWithCompletion:^(NSArray *objects, NSError *error) {
	// If successful, objects will be non-nil and contain BOXComment model objects; otherwise, error will be non-nil.
}];
```

Get the info of an existing Comment
-----------------------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXCommentRequest *commentRequest = [contentClient commentInfoRequestWithID:@"comment-id"];
[commentRequest performRequestWithCompletion:^(BOXComment *comment, NSError *error) {
	// If successful, comment will be non-nil; otherwise, error will be non-nil.
}];
```

Add a new Comment to a Box File
-------------------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXCommentAddRequest *commentAddRequest = [contentClient commentAddRequestForFileWithID:@"file-id" message:@"Comment message"];
[commentAddRequest performRequestWithCompletion:^(BOXComment *comment, NSError *error) {
	// If successful, comment will be non-nil; otherwise, error will be non-nil.
}];
```

Reply to an Existing Comment
----------------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXCommentAddRequest *commentReplyRequest = [contentClient commentReplyRequestToCommentWithID:@"comment-id" message:@"Comment message"];
[commentReplyRequest performRequestWithCompletion:^(BOXComment *comment, NSError *error) {
	// If successful, comment will be non-nil; otherwise, error will be non-nil.
}];
```

Update an existing Comment
--------------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXCommentUpdateRequest *commentUpdateRequest = [contentClient commentUpdateRequestWithID:@"comment-id" newMessage:@"Updated message"];
[commentUpdateRequest performRequestWithCompletion:^(BOXComment *comment, NSError *error) {
	// If successful, comment will be non-nil; otherwise, error will be non-nil.
}];
```

Delete a Comment
----------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXCommentDeleteRequest *commentDeleteRequest = [contentClient commentDeleteRequestWithID:@"comment-id"];
[commentDeleteRequest performRequestWithCompletion:^(NSError *error) {
	// If successful, error will be nil.
}];
```
