Authentication
==============

Single User Mode
---------------------
The SDK can take care of all UI interaction for authenticating a user. If necessary, a View Controller will be presented from your app's window to collect credentials from the user. 
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
[contentClient authenticateWithCompletionBlock:^(BOXUser *user, NSError *error) {
	// BOXUser is returned if authentication was successful.
	// Otherwise, error will contain the reason for failure (e.g. network connection)
	// If the user canceled the authentication flow, error will be have domain:BOXContentSDKErrorDomain code:BOXContentSDKAPIUserCancelledError
}];
```

Alternatively, if you prefer to present View Controllers on your own:
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXAuthorizationViewController *boxAuthViewController = [[BOXAuthorizationViewController alloc] 
	initWithSDKClient:contentClient 
	completionBlock:^(BOXAuthorizationViewController *authorizationViewController, BOXUser *user, NSError *error) {
	// BOXUser is returned if authentication was successful.
	// Otherwise, error will contain the reason for failure (e.g. network connection)
	// You should dismiss authorizationViewController here.
} cancelBlock:^(BOXAuthorizationViewController *authorizationViewController){
	// User has canceled the login process.
	// You should dismiss authorizationViewController here.
}];
[self presentViewController:boxAuthViewController animated:YES completion:nil];
```

When you no longer need the session, it is a good practice to logout.
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
[contentClient logOut];
```

Multi-Account Mode
------------------------
Check for existing Box Users that the SDK has authenticated.
```objectivec
NSArray *boxUsers = [BOXContentClient users];
```

Get a BOXContentClient for an existing Box User that the SDK has authenticated
```objectivec
for (BOXUser *boxUser in boxUsers) {
	BOXContentClient *contentClient = [BOXContentClient clientForUser:boxUser];
	// You can now do something with the contentClient...
}
```

Authenticate a new account:
```objectivec
BOXContentClient *contentClient = [BOXContentClient clientForNewSession];
[contentClient authenticateWithCompletionBlock:^(BOXUser *user, NSError *error) {
	// BOXUser is returned if authentication was successful.
	// Otherwise, error will contain the reason for failure (e.g. network connection)	
}];
```

Log all users out.
```objectivec
[BOXContentClient logOutAll];
```
