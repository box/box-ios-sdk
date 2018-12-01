Box Platform (App Users and downscoped tokens)
==============

Setup
--------------------
When creating an app that uses App Users and/or downscoped tokens, you do not use the OAuth2 capabilities of the SDK, and all token creation must occur on a remote server that has access to the private keys for your Box application.  You should never include the private key in your iOS app distribution.

In order to support this application architecture, there is class method on BOXContentClient for creating a client with the capability of retrieving tokens from a remote server. It requires you to specify a uniqueId for the user, and includes the ability to specify an optional initial token that you may have already retrieved and an optional Dictionary of information you may need in your fetchTokenBlock code. The code block that will be called by the SDK when it detects an expired token is required.  This code block is where you call your secure server with the information needed in order to retrieve a new token for the user. The required uniqueId and optional fetchTokenBlockInfo are passed into your code block. The uniqueId value can be, for example, a Box App User Id, or it can be any unique identifier that enables your backend code to properly retrieve a new token for the user. The strategy you use will depend on your overall application design.

<b>PLEASE NOTE:</b> It is up to you as the app developer to ensure that the process of retrieving tokens is secured.  Typically this is done by passing a JSON Web Token in the Authorization header of the request to your remote server that is signed by your authentication system.  That way you can verify that the incoming request is indeed originating from an authorized app and device.

Below is an example of using a BOXContentClient instance to work with a specific uniqueId, including example code of how to retrieve a new token when the SDK detects a token expiration. Note that you are not required to specify an initial token as the SDK will simply invoke your fetchTokenBlock.

```objectivec
#import "AppDelegate.h"

@import BoxContentSDK;

@interface AppDelegate ()

@property (nonatomic, readonly, strong) BOXContentClient *boxClient;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    _boxClient = [BOXContentClient clientForServerAuthUniqueId:@"A_UNIQUE_ID"
                                                  initialToken:nil
                                           fetchTokenBlockInfo:nil
                                               fetchTokenBlock:fetchTokenBlock];                                                          
    
    //Example of making an API call
    BOXUserRequest *request = [_boxClient currentUserRequest];
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

ServerAuthFetchTokenBlock myFetchTokenBlock = ^(NSString *uniqueId, NSDictionary *fetchTokenBlockInfo, void (^completion)(NSString *, NSDate *, NSError *))
{
    //this code is specific to your app; it is responsible for retrieving new tokens from a secure server
    NSLog(@"Attempting to retrieve new access token from server for uniqueId: %@", unique);
    
    NSString *fullUrl = [NSString stringWithFormat:@"https://your.secure.server/token?id=%@", uniqueId];
    NSURL *url = [NSURL URLWithString:fullUrl];
    
    __block NSString *token;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                         if(error){
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