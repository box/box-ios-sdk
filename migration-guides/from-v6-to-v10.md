# Migration guide: migrate from v6 to v10 of `Box iOS SDK`

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Introduction](#introduction)
- [Installation](#installation)
  - [Swift Package Manager](#swift-package-manager)
  - [Carthage](#carthage)
  - [CocoaPods](#cocoapods)
- [Supported Environments](#supported-environments)
- [Migration Scope and Module Compatibility](#migration-scope-and-module-compatibility)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Introduction

Version 10 of the `Box iOS SDK` is a modern, auto-generated SDK built entirely from the `BoxSdkGen` module.

In version 6, the SDK shipped two modules side-by-side: the legacy manually-maintained `BoxSDK` and the generated `BoxSdkGen`. In version 10 and later, `BoxSDK` is removed and only `BoxSdkGen` module remains.

This document helps teams migrate projects currently on v6 to v10 by:

- Moving any remaining `BoxSDK` usage to the `BoxSdkGen` API surface
- Aligning configuration, authentication, and convenience APIs with v10 conventions

If you are migrating code between the modules themselves (BoxSDK → BoxSdkGen), see also the dedicated module guide [Migration guide: migrate from BoxSDK to BoxSdkGen](./from-BoxSDK-to-BoxSdkGen.md).

## Installation

Starting with v10, the legacy `BoxSDK` module is no longer included. Installing v10 provides only the `BoxSdkGen` module.

### Swift Package Manager

[The Swift Package Manager](https://www.swift.org/package-manager/) is a tool for managing the distribution of Swift code.
It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To update the dependency in your Xcode project, click your project file, open `Package Dependencies`, select the Box SDK package, and set the version rule to `Up to Next Major Version` starting at `10.0.0`.

Alternatively you can update the dependency declaration in the dependencies value of your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/box/box-ios-sdk.git", .upToNextMajor(from: "10.0.0"))
]
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager which builds your dependencies and provides you with binary frameworks.

To use v10 of `Box iOS SDK`, update the entry in your `Cartfile` to:

```shell
git "https://github.com/box/box-ios-sdk.git" ~> 10.0.0
```

Then run:

```shell
carthage bootstrap --use-xcframeworks
```

And finally drag the built `xcframework` from Carthage/Build into your project.

### CocoaPods

CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects.
To use v10 with CocoaPods, update your `Podfile` to:

```shell
pod 'BoxSDK', '~> 10.0'
```

Then run the following command in your project directory:

```shell
$ pod install
```

## Supported Environments

Both v6 and v10 of the `Box iOS SDK` share the same minimum platform requirements. No platform changes are required when moving from v6 to v10.

- iOS 13.0+
- macOS 10.15+
- tvOS 13.0+
- watchOS 6.0+

## Migration Scope and Module Compatibility

If your project only uses `BoxSdkGen` from v6, no code changes are needed to migrate to v10. The generated API surface is the same in v6 and v10.

If you still have code using the legacy `BoxSDK` module, follow the dedicated guide to update that code: [Migration guide: migrate from BoxSDK to BoxSdkGen](./from-BoxSDK-to-BoxSdkGen.md).
