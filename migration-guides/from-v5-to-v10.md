# Migration guide: migrate from v5 to v10 of `Box iOS SDK`

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Introduction](#introduction)
- [Installation](#installation)
  - [Swift Package Manager](#swift-package-manager)
  - [Carthage](#carthage)
- [CocoaPods](#cocoapods)
- [Highlighting the Key Differences](#highlighting-the-key-differences)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Introduction

The v10 release of `Box iOS SDK` library helps developers to conveniently integrate with Box API.
In the contrary to the previous versions (v5 or lower), it is not manually maintained, but auto-generated
based on Open API Specification. This means you can leverage the most up-to-date Box API features in your
applications without delay. We introduced this major version bump to reflect the significant codebase changes
and to align with other Box SDKs, which will also adopt generated code starting from their v10 releases.
More information and benefits of using the new can be found in the
[README](https://github.com/box/box-ios-sdk/blob/sdk-gen/README.md) file.

## Installation

We have also introduced v6 version of Box iOS SDK that consolidates both the manually maintained `BoxSDK` module from v5
and the new, auto-generated `BoxSdkGen` module from v10.
If you would like to use a feature available only in the new SDK, you won't need to necessarily migrate all your code
to use generated SDK at once. You will be able to use a new feature from the `BoxSdkGen` project,
while keeping the rest of your code unchanged. However, we recommend to fully migrate to the v10 of the SDK eventually.
More information about v6 version can be found in the [migration guide from v5 to v6](./from-v5-to-v6.md).

### Swift Package Manager

[The Swift Package Manager](https://www.swift.org/package-manager/) is a tool for managing the distribution of Swift code.
It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To add a dependency to your Xcode project, click on Xcode project file on `Packages Dependencies` and click on the plus icon to add a package.
Then enter the following repository url https://github.com/box/box-ios-sdk.git and select the version by choosing `Up to Next Major Version` and entering `10.0.0` as the starting version.

Alternatively you can add a dependency to the dependencies value of your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/box/box-ios-sdk.git", .upToNextMajor(from: "10.0.0"))
]
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager which builds your dependencies and provides you with binary frameworks.

To add a dependency to the v10 version of `Box iOS SDK`, you need to add the following line to your `Cartfile` :

```shell
git "https://github.com/box/box-ios-sdk.git" >= 10.0.0
```

Then run:

```shell
carthage bootstrap --use-xcframeworks
```

And finally drag the built `xcframework` from Carthage/Build into your project.

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

## Highlighting the Key Differences

There are important differences between the `BoxSDK` (v5) and the generated `BoxSdkGen` (v10) modules. We have prepared a separate document that presents the main differences and provides guidance to help you migrate. For side-by-side code examples, see: [Migration guide: migrate from BoxSDK to BoxSdkGen](./from-BoxSDK-to-BoxSdkGen.md).
