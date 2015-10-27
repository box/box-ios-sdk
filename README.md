[![Project Status](http://opensource.box.com/badges/active.svg)](http://opensource.box.com/badges)
[![Build Status](https://api.travis-ci.org/box/box-ios-content-sdk.svg)](https://travis-ci.org/box/box-ios-content-sdk)

Box iOS SDK
===================

This SDK makes it easy to use Box's [Content API](https://developers.box.com/docs/) in your iOS projects.

Developer Setup
---------------
* Ensure you have the latest version of [XCode](https://developer.apple.com/xcode/) installed.
* We encourage you to use [Cocoa Pods](http://cocoapods.org/) to import the SDK into your project. Cocoa Pods is a simple, but powerful dependency management tool. If you do not already use Cocoa Pods, it's very easy to [get started](http://guides.cocoapods.org/using/getting-started.html).

Quickstart
----------
Step 1: Add to your Podfile
```
pod 'box-ios-sdk'
```
Step 2: Install
```
pod install
```
Step 3: Import
```objectivec
#import <BoxContentSDK/BOXContentSDK.h>
```
Step 4: Set the Box Client ID and Client Secret that you obtain from [creating your app](doc/Setup.md). 
```objectivec
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // The UIApplicationDelegate is a good place to do this.
  [BOXContentClient setClientID:@"your-client-id" clientSecret:@"your-client-secret"];
}
```
Step 5: Authenticate a User
```objectivec
// This will present the necessary UI for a user to authenticate into Box
[[BOXContentClient defaultClient] authenticateWithCompletionBlock:^(BOXUser *user, NSError *error) {
  if (error == nil) {
    NSLog(@"Logged in user: %@", user.login);
  }
} cancelBlock:nil];
```

Sample App
----------
A sample app can be found in the [BoxContentSDKSampleApp](../../tree/master/BoxContentSDKSampleApp) folder. The sample app demonstrates how to authenticate a user, and manage the user's files and folders.

To execute the sample app:
Step 1: Install Pods
```
cd BoxContentSDKSampleApp
pod install
```
Step 2: Open Workspace
```
open BoxContentSDKSampleApp.xcworkspace
```

Tests
-----
Tests can be found in the 'BoxContentSDKTests' target. [Use XCode to execute the tests](https://developer.apple.com/library/ios/recipes/xcode_help-test_navigator/RunningTests/RunningTests.html#//apple_ref/doc/uid/TP40013329-CH4-SW1). Travis CI will also execute tests for pull requests and pushes to the repository.

Documentation
-------------
You can find guides and tutorials in the `doc` directory.

* [App Setup](doc/Setup.md)
* [Authentication](doc/Authentication.md)
* [Developer's Edition (App Users)](doc/AppUsers.md)
* [Files](doc/Files.md)
* [Folders](doc/Folders.md)
* [Metadata](doc/metadata.md)
* [Comments](doc/Comments.md)
* [Collaborations](doc/Collaborations.md)
* [Events](doc/Events.md)
* [Search](doc/Search.md)
* [Users](doc/Users.md)


Contributing
------------
See [CONTRIBUTING](CONTRIBUTING.md) on how to help out.


Copyright and License
---------------------
Copyright 2015 Box, Inc. All rights reserved.

 
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
