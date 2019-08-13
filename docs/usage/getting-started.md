Getting Started
===============

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Installing the SDK](#installing-the-sdk)
- [Getting Started](#getting-started)
- [Sample Apps](#sample-apps)
  - [OAuth2 Sample App](#oauth2-sample-app)
  - [JWT Auth Sample App](#jwt-auth-sample-app)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Installing the SDK
------------------

__Step 1__: Add to your `Cartfile`
```ogdl
binary "https://raw.githubusercontent.com/box/box-ios-sdk/limited-beta-release/boxSDK.json" == 3.0.0-alpha.2
```

__Step 2__: Update dependencies
```shell
$ carthage update --platform iOS
```

__Step 3__: Drag the built framework from Carthage/Build/iOS into your project.

For more detailed instructions, please see the [official documentation for Carthage](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos).

Getting Started
---------------

To get started with the SDK, get a Developer Token from the Configuration page of your app in the
[Box Developer Console][dev-console].  You can use this token to make test calls for your own Box account.

```swift
import BoxSDK

let client = BoxSDK.getClient(token: "YOUR_DEVELOPER_TOKEN")
client.users.getCurrentUser() { result in
    switch result {
    case let .error(error):
        print("Error: \(error)")
    case let .success(user):
        print("\(user.name) (\(user.login)) is logged in")
    }
}
```

[dev-console]: https://app.box.com/developers/console

Sample Apps
-----------

### OAuth2 Sample App

A [sample app using OAuth2 Authentication][oauth2-sample-app] can be downloaded as a zip file.  This app demonstrates
how to use the SDK to make calls, and can be run directly by entering your own credentials to log in.

[oauth2-sample-app]: https://github.com/box/box-ios-sdk/blob/limited-beta-release/OAuth2SampleApp.zip?raw=true

To execute the sample app:
__Step 1__: Run carthage
```shell
$ cd SampleApps/Swift/OAuth2SampleApp
$ carthage update --platform iOS
```

__Step 2__: Open Workspace
```shell
$ open OAuth2SampleApp.xcworkspace
```

__Step 3__: Insert your client ID and client secret

First, find your OAuth2 app's client ID and secret from the [Box Developer Console][dev-console].  Then, add these
values to the sample app in the `Constants.swift` file in the sample app:
```swift
static let clientId = "YOUR CLIENT ID GOES HERE"
static let clientSecret = "YOUR CLIENT SECRET GOES HERE"
```

__Step 4__: Set redirect URL

Using the same client ID from the previous step, set the redirect URL for your application in the
[Box Developer Console][dev-console] to `boxsdk-<<YOUR CLIENT ID>>://boxsdkoauth2redirect`, where `<<YOUR CLIENT ID>>`
is replaced with your client ID.  For example, if your client ID were `vvxff7v61xi7gqveejo8jh9d2z9xhox5` the redirect
URL should be `boxsdk-vvxff7v61xi7gqveejo8jh9d2z9xhox5://boxsdkoauth2redirect`

__Step 5__: Insert your client ID to receive the redirect in the app

Open the `Info.plist` file in the sample app and find the key under `URL Types --> Item 0 --> URL Schemes --> Item 0`.
Using the same client ID from the previous step, set the value for Item 0 to
`boxsdk-<<YOUR CLIENT ID>>`, where `<<YOUR CLIENT ID>>` is replaced with your client ID.  For example, if your client
ID were `vvxff7v61xi7gqveejo8jh9d2z9xhox5` the redirect URL should be
`boxsdk-vvxff7v61xi7gqveejo8jh9d2z9xhox5`

![location to add redirect URL scheme in Xcode](./redirect-url-scheme.png)

__Step 6__: Run the sample app

### JWT Auth Sample App

A [sample app using JWT Authentication][jwt-sample-app] can be downloaded as a zip file.  This app demonstrates how to
set up JWT authentication with a remote authorization service, and will not run until you provide the code to retrieve
tokens.

[jwt-sample-app]: https://github.com/box/box-ios-sdk/blob/limited-beta-release/JWTSampleApp.zip?raw=true

To execute the sample app:
__Step 1__: Run carthage
```shell
$ cd SampleApps/Swift/JWTSampleApp
$ carthage update --platform iOS
```

__Step 2__: Open Workspace
```shell
$ open JWTSampleApp.xcworkspace
```

__Step 3__: Insert your client ID and client secret

First, find your OAuth2 app's client ID and secret from the [Box Developer Console][dev-console].  Then, add these
values to the sample app in the `Constants.swift` file in the sample app:
```swift
static let clientId = "YOUR CLIENT ID GOES HERE"
static let clientSecret = "YOUR CLIENT SECRET GOES HERE"
```

__Step 4__: Add code for retrieving access tokens

In the `ViewController.swift` file in the sample app, edit the
`obtainJWTTokenFromExternalSources()` method:
```swift
func obtainJWTTokenFromExternalSources() -> DelegatedAuthClosure {
    return { _, completion in
        // Retrieve access token from external source, for example a dedicated authentication service
        // Then, pass the access token and expiration time to the completion:
        //completion(.success((accessToken: accessToken, expiresIn: tokenTTLinSeconds)))
    }
}
```

__Step 5__: Run the sample app

License
-------

Any use of this software is governed by the attached [Box SDK Beta Agreement](../../BETA-AGREEMENT.md).
__If you do not accept the terms of the Box SDK Beta Agreement, you may not use this software.__
