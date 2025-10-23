<p align="center">
  <img src="https://github.com/box/sdks/blob/master/images/box-dev-logo.png" alt= “box-dev-logo” width="30%" height="50%">
</p>

# Box iOS SDK v10

[![Project Status](http://opensource.box.com/badges/active.svg)](http://opensource.box.com/badges)
![build](https://github.com/box/box-ios-sdk/actions/workflows/build_and_test.yml/badge.svg?branch=sdk-gen)
[![Platforms](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS_visionOS_Linux-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS_visionOS_Linux-yellowgreen?style=flat-square)
[![Coverage Status](https://coveralls.io/repos/github/box/box-ios-sdk/badge.svg?branch=sdk-gen)](https://coveralls.io/github/box/box-ios-sdk?branch=sdk-gen)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/badge/CocoaPods-compatible-orange.svg)](https://cocoapods.org/pods/BoxSDK)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Introduction](#introduction)
- [Supported versions](#supported-versions)
    - [Version v6](#version-v6)
    - [Version v10](#version-v10)
    - [Which Version Should I Use?](#which-version-should-i-use)
- [Requirements](#requirements)
- [Installing](#installing)
    - [Swift Package Manager](#swift-package-manager)
    - [Carthage](#carthage)
    - [CocoaPods](#cocoapods)
- [Getting Started](#getting-started)
- [Authentication](#authentication)
- [Documentation](#documentation)
- [Migration guides](#migration-guides)
- [Versioning](#versioning)
    - [Version schedule](#version-schedule)
- [Contributing](#contributing)
- [FIPS 140-2 Compliance](#fips-140-2-compliance)
- [Questions, Bugs, and Feature Requests?](#questions-bugs-and-feature-requests)
- [Copyright and License](#copyright-and-license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Introduction

We are excited to introduce the v10 major release of the Box iOS SDK,
designed to elevate the developer experience and streamline your integration with the Box Content Cloud.

With this SDK version, we provide the `BoxSdkGen` module, which gives you access to:

1. Full API Support: The new generation of Box SDKs empowers developers with complete coverage of the Box API ecosystem. You can now access all the latest features and functionalities offered by Box, allowing you to build even more sophisticated and feature-rich applications.
2. Rapid API Updates: Say goodbye to waiting for new Box APIs to be incorporated into the SDK. With our new auto-generation development approach, we can now add new Box APIs to the SDK at a much faster pace (in a matter of days). This means you can leverage the most up-to-date features in your applications without delay.
3. Embedded Documentation: We understand that easy access to information is crucial for developers. With our new approach, we have included comprehensive documentation for all objects and parameters directly in the source code of the SDK. This means you no longer need to look up this information on the developer portal, saving you time and streamlining your development process.
4. Enhanced Convenience Methods: Our commitment to enhancing your development experience continues with the introduction of convenience methods. These methods cover various aspects such as chunk uploads, classification, and much more.
5. Seamless Start: The new SDKs integrate essential functionalities like authentication, automatic retries with exponential backoff, exception handling, request cancellation, and type checking, enabling you to focus solely on your application's business logic.

Embrace the new generation of Box SDKs and unlock the full potential of the Box Content Cloud.

# Supported versions

To enhance developer experience, we have introduced the new generated codebase through the `BoxSdkGen` module.
The `BoxSdkGen` module is available in two major supported versions: v6 and v10.

## Version v6

In v6 of the Box iOS SDK, we are introducing a version that consolidates both the manually written module (`BoxSDK`)
and the new generated module (`BoxSdkGen`). This allows developers to use both modules simultaneously within a single project

The codebase for v6 of the Box iOS SDK is currently available on the [combined-sdk](https://github.com/box/box-ios-sdk/tree/combined-sdk) branch.
Migration guide which would help with migration from `BoxSDK` to `BoxSdkGen` can be found [here](https://github.com/box/box-ios-sdk/blob/sdk-gen/migration-guides/from-BoxSDK-to-BoxSdkGen.md).

Version v6 is intended for:

- Existing developers of the Box iOS SDK v5 who want to access new API features while keeping their current codebase largely unchanged.
- Existing developers who are in the process of migrating to `BoxSdkGen`, but do not want to move all their code to the new module immediately.

## Version v10

Starting with v10, the SDK is built entirely on the generated `BoxSdkGen` module, which fully and exclusively replaces the old `BoxSDK` module.
The codebase for v10 of the Box iOS SDK is currently available on the [sdk-gen](https://github.com/box/box-ios-sdk/tree/sdk-gen) branch.

Version v10 is intended for:

- New users of the Box iOS SDK.
- Developers already working with the generated Box iOS SDK previously available under the [Box Swift SDK Gen repository](https://github.com/box/box-swift-sdk-gen).

## Which Version Should I Use?

| Scenario                                                                                                              | Recommended Version                                                   | Example Dependency (SPM / CocoaPods)                                                                                                         |
| --------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| Creating a new application                                                                                            | Use [v10](https://github.com/box/box-ios-sdk/tree/sdk-gen)            | **SPM:** `.package(url: "https://github.com/box/box-ios-sdk.git", from: "10.0.0")`<br>**CocoaPods:** `pod 'BoxSdkGen', '~> 10.0.0'`          |
| App using [BoxSdkGen](https://github.com/box/box-swift-sdk-gen)                                                       | Migrate to [v10](https://github.com/box/box-ios-sdk/tree/sdk-gen)     | **SPM:** `.package(url: "https://github.com/box/box-ios-sdk.git", from: "10.0.0")`<br>**CocoaPods:** `pod 'BoxSdkGen', '~> 10.0.0'`          |
| App using both [BoxSdkGen](https://github.com/box/box-swift-sdk-gen) and [BoxSDK](https://github.com/box/box-ios-sdk) | Upgrade to [v6](https://github.com/box/box-ios-sdk/tree/combined-sdk) | **SPM:** `.package(url: "https://github.com/box/box-ios-sdk.git", .upToNextMajor(from: "6.0.0"))`<br>**CocoaPods:** `pod 'BoxSDK', '~> 6.0'` |
| App using v5 of [BoxSDK](https://github.com/box/box-ios-sdk)                                                          | Upgrade to [v6](https://github.com/box/box-ios-sdk/tree/combined-sdk) | **SPM:** `.package(url: "https://github.com/box/box-ios-sdk.git", .upToNextMajor(from: "6.0.0"))`<br>**CocoaPods:** `pod 'BoxSDK', '~> 6.0'` |

For full guidance on SDK versioning, see the [Box SDK Versioning Guide](https://developer.box.com/guides/tooling/sdks/sdk-versioning/).

# Requirements

- iOS 13.0+ / Mac OS X 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Xcode 13.3+

# Installing

The next generation of the SDK starts with version `10.0.0`.

## Swift Package Manager

The Swift Package Manager is a tool for managing the distribution of Swift code.
It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To add a dependency to your Xcode project, click on Xcode project file on `Packages Dependencies` and click on the plus icon to add a package.
Then enter the following repository url https://github.com/box/box-ios-sdk.git and select the version by choosing `Up to Next Major Version` and entering `10.0.0` as the starting version.

Alternatively, add the package in your `Package.swift` under the top-level `dependencies` array:

```swift
dependencies: [
  .package(url: "https://github.com/box/box-ios-sdk.git", .upToNextMajor(from: "10.0.0"))
]
```

Then add the `BoxSDK` product to your target's `dependencies`:

```swift
   .product(name: "BoxSDK", package: "box-ios-sdk")
```

For detailed instructions, please see the [official documentation for SPM](https://www.swift.org/package-manager/).

## Carthage

Carthage is a decentralized dependency manager which builds your dependencies and provides you with binary frameworks.

To add a dependency to SDK, you need to add the following line to your `Cartfile` :

```shell
git "https://github.com/box/box-ios-sdk.git" >= 10.0.0
```

Then run:

```shell
carthage bootstrap --use-xcframeworks
```

And finally drag the built `xcframework` from Carthage/Build into your project.

For more detailed instructions, please see the [official documentation for Carthage](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).

## CocoaPods

CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects.
To start using `BoxSDK` with CocoaPods, you need to add `BoxSDK` dependency to your `Podfile`:

```shell
pod 'BoxSDK', '>= 10.0.0'
```

Then run the following command in your project directory:

```shell
$ pod install
```

Now open your [project].xcworkspace and build.

For more detailed instructions, please see the [official documentation for Cocoapods](https://guides.cocoapods.org/using/using-cocoapods.html).

# Getting Started

To get started with the SDK, get a Developer Token from the Configuration page of your app in the [Box Developer
Console](https://app.box.com/developers/console). You can use this token to make test calls for your own Box account.

The SDK provides a `BoxDeveloperTokenAuth` class, which allows you to authenticate using your Developer Token.
Use instance of `BoxDeveloperTokenAuth` to initialize `BoxClient` object.
Using `BoxClient` object you can access managers, which allow you to perform some operations on your Box account.

> **Important:** Before using those classes, make sure to import `BoxSdkGen` module in your file.

The example below demonstrates how to authenticate with Developer Token and print names of all items inside a root folder.

```swift
import BoxSdkGen

let auth = BoxDeveloperTokenAuth(token: "DEVELOPER_TOKEN_GOES_HERE")
let client = BoxClient(auth: auth)

let items = try await client.folders.getFolderItems(folderId: "0")
if let entries = items.entries {
    for entry in entries {
        switch entry {
        case let .fileMini(file):
            print("file \(file.name!) [\(file.id)]")
        case let .folderMini(folder):
            print("folder \(folder.name!) [\(folder.id)]")
        case let .webLinkMini(webLink):
            print("webLink \(webLink.name!) [\(webLink.id)]")
        }
    }
}
```

# Authentication

Box iOS SDK v10 supports multiple authentication methods including Developer Token, OAuth 2.0,
Client Credentials Grant, and JSON Web Token (JWT).

You can find detailed instructions and example code for each authentication method in
[Authentication](https://github.com/box/box-ios-sdk/blob/sdk-gen/docs/Authentication.md) document.

# Documentation

Browse the [docs](https://github.com/box/box-ios-sdk/blob/sdk-gen/docs/README.md) or see [API Reference](https://developer.box.com/reference/) for more information.

# Migration guides

Migration guides which help you to migrate to supported major SDK versions can be found [here](https://github.com/box/box-ios-sdk/tree/sdk-gen/migration-guides).

# Versioning

We use a modified version of [Semantic Versioning](https://semver.org/) for all changes. See [version strategy](https://github.com/box/box-ios-sdk/blob/sdk-gen/VERSIONS.md) for details which is effective from 30 July 2022.

A current release is on the leading edge of our SDK development, and is intended for customers who are in active development and want the latest and greatest features.  
Instead of stating a release date for a new feature, we set a fixed minor or patch release cadence of maximum 2-3 months (while we may release more often). At the same time, there is no schedule for major or breaking release.
Instead, we will communicate one quarter in advance the upcoming breaking change to allow customers to plan for the upgrade.
We always recommend that all users run the latest available minor release for whatever major version is in use.
We highly recommend upgrading to the latest SDK major release at the earliest convenient time and before the EOL date.

### Version schedule

| Version | Supported Environments                                  | State     | First Release | EOL/Terminated         |
| ------- | ------------------------------------------------------- | --------- | ------------- | ---------------------- |
| 10      | iOS 13.0+ / Mac OS X 10.15+ / tvOS 13.0+ / watchOS 6.0+ | Supported | 17 Sep 2025   | TBD                    |
| 6       | iOS 13.0+ / Mac OS X 10.15+ / tvOS 13.0+ / watchOS 6.0+ | Supported | 23 Oct 2025   | 2027 or v7 is released |
| 5       | iOS 11.0+ / Mac OS X 10.13+ / tvOS 11.0+ / watchOS 4.0+ | EOL       | 28 Oct 2021   | 23 Oct 2025            |
| 4       |                                                         | EOL       | 13 Feb 2020   | 28 Oct 2021            |
| 3       |                                                         | EOL       | 20 Nov 2019   | 13 Feb 2020            |

# Contributing

See [CONTRIBUTING.md](https://github.com/box/box-ios-sdk/blob/sdk-gen/CONTRIBUTING.md).

# FIPS 140-2 Compliance

The Box iOS SDK uses the CommonCrypto library, which relies on Apple's corecrypto cryptographic module. This module has undergone multiple validations by the Cryptographic Module Validation Program (CMVP) and is confirmed to be compliant with FIPS 140-2 standards. For further information, please refer to [Apple's security certification](https://support.apple.com/en-gb/guide/certifications/apc30d0ed034/web) and [iOS security certifications](https://support.apple.com/en-gb/guide/certifications/apc3fa917cb49/1/web/1.0).

# Questions, Bugs, and Feature Requests?

Need to contact us directly? [Browse the issues tickets](https://github.com/box/box-ios-sdk/issues)! Or, if that
doesn't work, [file a new one](https://github.com/box/box-ios-sdk/issues/new) and we will get
back to you. If you have general questions about the Box API, you can post to the [Box Developer Forum](https://community.box.com/box-platform-5).

# Copyright and License

Copyright 2025 Box, Inc. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
