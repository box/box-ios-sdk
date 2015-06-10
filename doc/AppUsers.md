App Users
==============

Authetication + Single User Mode
--------------------
The SDK does not handle authetication of an App User and so developers should conform to the BOXAccessTokenDelegate in order to autheticate accounts. Also, in order to use App Users, developers must set the delegate when initializing a BOXContentClient instance.

```objectivec
@implementation BOXClass <BOXAPIAccessTokenDelegate>

- (void)fetchAccessTokenWithCompletion:(void (^)(NSString *, NSDate, NSError *))completion
{
  // Do things to retrieve access token and access token expiration date.
  completion(accessToken, accessTokenExpiration, error);
}

- (void)buttonPressed:(UIButton *)button
{

  BOXContentClient *client = [BOXContentClient defaultClient];
  [client setAccessTokenDelegate: self];
  [client autheticateWithCompletionBlock: ^(BOXUser *user, NSError *error){
    if (error) {
      //Do stuff in case of error.
    } else {
      //Do stuff if authetication was successful.
    }
  }];

}

@end
```

When you no longer need the session, it is a good practice to logout.
```objectivec
BOXUser *user = //Get the desired BOXUser instance.
BOXContentClient *contentClient = [BOXContentClient clientForUser:user];
[contentClient logOut]
```

Multi-Account Mode
------------------------
Implement the BOXAccessTokenDelegate method to retrieve the access token for corresponding user.
```objectivec
- (void)fetchAccessTokenWithCompletion:(void (^)(NSString *, NSDate *, NSError))completion
{
  // Do things to retrieve access tokens and access token expiration dates.
  completion(accessToken, accessTokenExpiration, error);
}
```

Check for existing Box Users that the SDK has authenticated.
```objectivec
NSArray *boxUsers = [BOXContentClient users];
```

Get a BOXContentClient for an existing Box User that the SDK has authenticated
```objectivec
for (BOXUser *boxUser in boxUsers) {
	BOXContentClient *contentClient = [BOXContentClient clientForUser:boxUser];
	[contentClient setAccessTokenDelegate: self];
	// You can now do something with the contentClient...
}
```

Authenticate a new account:
```objectivec
BOXContentClient *client = [BOXContentClient clientForNewSession];
[client setAccessTokenDelegate: self];
[client autheticateWithCompletionBlock: ^(BOXUser *user, NSError *error){
  if (error) {
    //Do stuff in case of error.
  } else {
    //Do stuff if authetication was successful.
  }
}];
```

Log all users out.
```objectivec
[BOXContentClient logOutAll];
```
