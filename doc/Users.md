Users
=====

Get the current User
--------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXUserRequest *currentUserRequest = [contentClient currentUserRequest];
[currentUserRequest performRequestWithCompletion:^(BOXUser *user, NSError *error) {
	// If successful, user will be non-nil; otherwise, error will be non-nil.
}];
```
