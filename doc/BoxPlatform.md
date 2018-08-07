Box Platform (App Users and downscoped tokens)
==============

Setup
--------------------
When creating an app that uses App Users and/or downscoped tokens, you do not use the OAuth2 capabilities of the SDK, and all token creation must occur on a remote server that has access to the private keys for your Box application.  You should never include the private key in your iOS app distribution.

In order to support this application architecture, there is a wrapper class included in the SDK to handle the mechanics of retrieving tokens for a user from the remote server. It includes the ability to specify an initial token that you may have already retrieved, and allows you to specify a code block that will be called by the SDK when it detects an expired token.  This code block is where you call your secure server with whatever information you need in order to retrieve a new token for the user.

<b>PLEASE NOTE:</b> It is up to you as the app developer to ensure that the process of retrieving tokens is secured.  Typically this is done by passing a JSON Web Token in the Authorization header of the request to your remote server that is signed by your authentication system.  That way you can verify that the incoming request is indeed originating from an authorized app and device.

Below is an example of configuring the <b>BoxContentClientServerAuthWrapper</b> instance to work with a specific App User Id, including example code of how to retrieve a new token when the SDK detects a token expiration. Note that you are not require to specify an initial token as the SDK will simply invoke your fetchTokenBlock. However, in some cases you may already have a token (for example, a downscoped token) that you wish to initialize the wrapper with.  The userInfo parameter is a dictionary for specifying arbitrary information you may need in your fetchTokenBlock code.

```objectivec
#import "AppDelegate.h"

@import BoxContentSDK;

@interface AppDelegate ()

@property (nonatomic, readonly, strong) BoxContentClientServerAuthWrapper *boxClientWrapper;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _boxClientWrapper = [[BoxContentClientServerAuthWrapper alloc] initWithToken:@"INITIAL_TOKEN_FROM_SERVER"
                                                                          userId:@"APP_USER_ID"
                                                                        userInfo:nil
                                                                 fetchTokenBlock:myFetchTokenBlock];
    
    //Example of making an API call; Note that the actual BOXContentClient is a property of the wrapper
    BOXContentClient *client = _boxClientWrapper.boxClient;

    BOXUserRequest *request = [client currentUserRequest];
    [request performRequestWithCompletion:^(BOXUser *user, NSError *error) {
        if (error){
            NSLog(@"Error getting user info");
        }
        else {
            NSLog(@"Retrieved app user info. Login=%@", user.login);
        }
    }];

    return YES;
}

ServerAuthFetchTokenBlock myFetchTokenBlock = ^(NSString *userId, NSDictionary *userInfo, void (^completion)(NSString *, NSDate *, NSError *))
{
    //this code is specific to your app; it is responsible for retrieving new tokens from a secure server
    NSLog(@"Attempting to retrieve new access token from server for user Id: %@", userId);
    
    NSString *fullUrl = [NSString stringWithFormat:@"https://your.secure.server/token?id=%@", userId];
    NSURL *url = [NSURL URLWithString:fullUrl];
    
    __block NSString *token;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                         if(error){
                                             NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:kCFURLErrorUnknown userInfo:nil];
                                             NSLog(@"Failed to retrieve new access token from server");
                                             completion(nil, nil, error);
                                         }
                                         else{
                                             token = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                             NSLog(@"Succeeded in retrieving new access token: %@", token);
                                             completion(token, [NSDate dateWithTimeIntervalSinceNow:2700] ,nil) //expires in 45 minutes;
                                         }
                                     }];
    [task resume];
};
```