Box Platform (App Users and Downscoped Tokens)
==============================================

Setup
-----

When creating an app that uses App Users and/or downscoped tokens, you do not use the OAuth2 capabilities of the SDK,
and all token creation must occur on a remote server that has access to the private keys for your Box application.  You
should never include the private key in your iOS app distribution.

In order to support this application architecture, there is class method on `BOXContentClient` for creating a client
with the capability of retrieving tokens from a remote server. It requires you to specify a `uniqueID` for the user, and
includes the ability to specify an optional initial token that you may have already retrieved and an optional Dictionary
of information you may need in your `fetchTokenBlock` code. The code block that will be called by the SDK when it
detects an expired token is required.  This code block is where you call your secure server with the information needed
in order to retrieve a new token for the user. The required `uniqueID` and optional `fetchTokenBlockInfo` are passed
into your code block. The `uniqueID` value can be, for example, a Box App User ID, or it can be any unique identifier
that enables your backend code to properly retrieve a new token for the user. The strategy you use will depend on your
overall application design.

__PLEASE NOTE:__ It is up to you as the app developer to ensure that the process of retrieving tokens is secured.
Typically this is done by passing a JSON Web Token in the Authorization header of the request to your remote server
that is signed by your authentication system.  That way you can verify that the incoming request is indeed originating
from an authorized app and device.

Below is an example of using a `BOXContentClient` instance to work with a specific `uniqueID`, including example code of
how to retrieve a new token when the SDK detects a token expiration. Note that you are not required to specify an
initial token as the SDK will simply invoke your `fetchTokenBlock`.

__Objective-C:__
```objectivec
ServerAuthFetchTokenBlock fetchTokens = ^(NSString *uniqueId, NSDictionary *fetchTokenBlockInfo, void (^completion)(NSString *, NSDate *, NSError *))
{
    // NOTE: This code is specific to your app; it is responsible for retrieving new tokens from a secure server
    NSLog(@"Attempting to retrieve new access token from server for uniqueId: %@", uniqueId);

    // Make a request to the secure sever for a token
    NSString *fullUrl = [NSString stringWithFormat:@"https://YOUR_SECURE_SERVER.example.com/token?id=%@", uniqueId];
    NSURL *url = [NSURL URLWithString:fullUrl];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                    NSLog(@"Failed to retrieve new access token from server");
                    completion(nil, nil, error);
                } else {
                    NSString *token = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"Succeeded in retrieving new access token: %@", token);

                    // Pass token and expiration time back to the client
                    completion(token, [NSDate dateWithTimeIntervalSinceNow:2700], nil);
                }
            }];
    [task resume];
};

// Create a client for the authenticated user; the client is keyed to that user's unique ID for caching purposes
// The unique ID can be any identifier for the user, or a dummy value
ServerAuthUser *authUser = [[ServerAuthUser alloc] initWithUniqueID:@"UNIQUE_ID"];
BOXContentClient *boxClient = [BOXContentClient clientForServerAuthUser:authUser
                                                initialToken:nil
                                                fetchTokenBlockInfo:nil
                                                fetchTokenBlock:fetchTokens];

// Example of making an API call
BOXUserRequest *request = [boxClient currentUserRequest];
[request performRequestWithCompletion:^(BOXUser *user, NSError *error) {
    if (error) {
        NSLog(@"Error getting user info");
    } else {
        NSLog(@"Retrieved user with login: %@", user.login);
    }
}];
```

__Swift:__
```swift
let fetchToken: ServerAuthFetchTokenBlock = { (
        uniqueID: String,
        fetchTokenBlockInfo: [AnyHashable: Any]?,
        completion: ((String?, Date?, Error?) -> Void)
    ) -> Void in
    
    // NOTE: This code is specific to your app; it is responsible for retrieving new tokens from a secure server
    NSLog("Attempting to retrieve new access token from server for unique ID: \(uniqueID)");
    
    // Make a request to the secure sever for a token
    let url = URL(string: "https://YOUR_SECURE_SERVER.example.com/token?id=\(uniqueID)")!
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        
        guard error == nil else {
            NSLog("Failed to retrieve new access token from server")
            completion(nil, nil, error)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            NSLog("Server returned incorrect response")
            completion(nil, nil, Error("Token sever returned incorrect response"))
            return
        }
        
        let token = String(data: data!, encoding: .utf8)!
        NSLog("Succeeded in retrieving new access token: \(token)")
        
        // Pass token and expiration time back to the client
        completion(token, Date(timeIntervalSinceNow: 2700), nil)
    }
    task.resume()
}

// Create a client for the authenticated user; the client is keyed to that user's unique ID for caching purposes
// The unique ID can be any identifier for the user, or a dummy value
let authUser = ServerAuthUser(uniqueID: "UNIQUE_ID")!
let client = BOXContentClient(for: authUser, initialToken: nil, fetchTokenBlockInfo: nil, fetchTokenBlock: fetchToken)!

// Example of making an API call
client.currentUserRequest().perform { (user: BOXUser?, error: Error?) in
    
    guard error == nil else {
        NSLog("Error getting user info");
        return
    }
    
    guard let user = user else {
        NSLog("User information unavailable");
        return
    }
    
    NSLog("Retrieved user with login: \(user.login!)")
}
```