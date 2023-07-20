<p align="center">
  <img src="https://github.com/box/sdks/blob/master/images/box-dev-logo.png" alt= “box-dev-logo” width="30%" height="50%">
</p>

# Box iOS SDK

[![Project Status](http://opensource.box.com/badges/active.svg)](http://opensource.box.com/badges)
[![Platforms](https://img.shields.io/cocoapods/p/BoxSDK.svg)](https://cocoapods.org/pods/BoxSDK)
[![License](https://img.shields.io/cocoapods/l/BoxSDK.svg)](https://raw.githubusercontent.com/box/box-ios-sdk/main/LICENSE) [![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
 [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
 [![CocoaPods compatible](https://img.shields.io/cocoapods/v/BoxSDK.svg)](https://cocoapods.org/pods/BoxSDK) [![Build Status](https://travis-ci.com/box/box-ios-sdk.svg?token=4tREKKzQDqwgYX8vMDUk&branch=main)](https://travis-ci.com/box/box-swift-sdk) [![Coverage](https://coveralls.io/repos/github/box/box-ios-sdk/badge.svg?branch=main)](https://coveralls.io/github/box/box-ios-sdk?branch=main)

Getting Started Docs: https://developer.box.com/guides/mobile/ios/quick-start/

NOTE:
===================

The Box iOS SDK in **Objective-C** (prior to v3.0.0) has been moved from the main branch to the [objective-c-maintenance branch](https://github.com/box/box-ios-sdk/tree/objective-c-maintenance).
Going forward, the main branch will contain the iOS SDK in **Swift**, starting with v3.0.0.

Box iOS SDK
- [Box iOS SDK](#box-ios-sdk)
- [NOTE:](#note)
  - [Requirements](#requirements)
  - [Installing the SDK](#installing-the-sdk)
    - [Carthage](#carthage)
    - [CocoaPods](#cocoapods)
    - [Swift Package Manager](#swift-package-manager)
      - [Importing BoxSDK into Project](#importing-boxsdk-into-project)
      - [Adding BoxSDK as a Dependency](#adding-boxsdk-as-a-dependency)
  - [Getting Started](#getting-started)
  - [Sample Apps](#sample-apps)
    - [OAuth2 Sample App](#oauth2-sample-app)
    - [JWT Auth Sample App](#jwt-auth-sample-app)
  - [FIPS 140-2 Compliance](#fips-140-2-compliance)
  - [Versions](#versions)
    - [Supported Version](#supported-version)
    - [Version schedule](#version-schedule)
  - [Copyright and License](#copyright-and-license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



Requirements
------------------

- iOS 11.0+ / Mac OS X 10.13+ / tvOS 11.0+ / watchOS 4.0+
- Xcode 10.0+

Installing the SDK
------------------

### Carthage

__Step 1__: Add to your `Cartfile`

```
git "https://github.com/box/box-ios-sdk.git" ~> 5.0
```

__Step 2__: Update dependencies
```shell
$ carthage update --use-xcframeworks --platform iOS
```

__Step 3__: Drag the built xcframework from Carthage/Build into your project.

For more detailed instructions, please see the [official documentation for Carthage](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos).

### CocoaPods

__Step 1__: Add to your `Podfile`

```
pod 'BoxSDK', '~> 5.0'
```

__Step 2__: Install pod by running the following command in the directory with the `Podfile`

```
$ pod install
```

For more detailed instructions, please see the [official documentation for Cocoapods](https://guides.cocoapods.org/using/using-cocoapods.html).

### Swift Package Manager

#### Importing BoxSDK into Project

__Step 1__: Click on Xcode project file

__Step 2__: Click on Swift Packages and click on the plus to add a package

__Step 3__: Enter the following repository url `https://github.com/box/box-ios-sdk.git` and click next

__Step 4__: Leave the default settings to get the most recent release and click next to finish importing

The process should look like below:

![Import Package](docs/usage/import-sdk-spm.gif)



#### Adding BoxSDK as a Dependency

For detailed instructions, please see the [official documentation for SPM](https://swift.org/package-manager/). 

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

The usage docs that show how to make calls to the Box API with the SDK can be found [here](https://github.com/box/box-ios-sdk/tree/main/docs/usage).

The Jazzy docs that show class, method, variable, etc definitions can be found [here](https://opensource.box.com/box-ios-sdk/).

Sample Apps
-----------

### OAuth2 Sample App

A sample app using OAuth2 Authentication can be found in the repository [here][oauth2-sample-app].  This app demonstrates
how to use the SDK to make calls, and can be run directly by entering your own credentials to log in.

[oauth2-sample-app]:
https://github.com/box/box-ios-sdk/tree/main/SampleApps/OAuth2SampleApp

To execute the sample app:

__Step 1__: Run carthage
```shell
$ cd SampleApps/OAuth2SampleApp
$ carthage update --use-xcframeworks --platform iOS
```

__Step 2__: Open Xcode Project File
```shell
$ open OAuth2SampleApp.xcodeproj
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

__Step 5__: Run the sample app

### JWT Auth Sample App

A sample app using JWT Authentication can be found in the repository [here][jwt-sample-app].  This app demonstrates how to
set up JWT authentication with a remote authorization service, and will not run until you provide the code to retrieve
tokens.

[jwt-sample-app]: https://github.com/box/box-ios-sdk/tree/main/SampleApps/JWTSampleApp

To execute the sample app:

__Step 1__: Run carthage
```shell
$ cd SampleApps/JWTSampleApp
$ carthage update --use-xcframeworks --platform iOS
```

__Step 2__: Open Xcode Project File
```shell
$ open JWTSampleApp.xcodeproj
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
    return { uniqueID, completion in
        #error("Obtain a JWT Token from your own service or a Developer Token for your app in the Box Developer Console at https://app.box.com/developers/console and return it in the completion.")
        // The code below is an example implementation of the delegate function
        // Please provide your own implementation
        
        // ...
    }
}
```

__Step 5__: Run the sample app

## FIPS 140-2 Compliance

 The Box iOS SDK uses the CommonCrypto library, which relies on Apple's corecrypto cryptographic module. This module has undergone multiple validations by the Cryptographic Module Validation Program (CMVP) and is confirmed to be compliant with FIPS 140-2 standards. For further information, please refer to [Apple's security certification](https://support.apple.com/en-gb/guide/certifications/apc30d0ed034/web) and [iOS security certifications](https://support.apple.com/en-gb/guide/certifications/apc3fa917cb49/1/web/1.0).

## Versions

We use a modified version of [Semantic Versioning](https://semver.org/) for all changes. See [version strategy](VERSIONS.md) for details which is effective from 30 July 2022.

### Supported Version

Only the current MAJOR version of SDK is supported. New features, functionality, bug fixes, and security updates will only be added to the current MAJOR version.

A current release is on the leading edge of our SDK development, and is intended for customers who are in active development and want the latest and greatest features.  Instead of stating a release date for a new feature, we set a fixed minor or patch release cadence of maximum 2-3 months (while we may release more often). At the same time, there is no schedule for major or breaking release. Instead, we will communicate one quarter in advance the upcoming breaking change to allow customers to plan for the upgrade. We always recommend that all users run the latest available minor release for whatever major version is in use. We highly recommend upgrading to the latest SDK major release at the earliest convenient time and before the EOL date.

### Version schedule

| Version | Supported Environments                                  | State     | First Release | EOL/Terminated |
|---------|---------------------------------------------------------|-----------|---------------|----------------|
| 5       | iOS 11.0+ / Mac OS X 10.13+ / tvOS 11.0+ / watchOS 4.0+ | Supported | 28 Oct 2021   | TBD            |
| 4       |                                                         | EOL       | 13 Feb 2020   | 28 Oct 2021    |
| 3       |                                                         | EOL       | 20 Nov 2019   | 13 Feb 2020    |


Copyright and License
-------

Copyright 2019 Box, Inc. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
