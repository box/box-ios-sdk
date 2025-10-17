# Migration guide: migrate from v5 to v6 of `Box iOS SDK`

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Introduction](#introduction)
- [Installation](#installation)
  - [Swift Package Manager](#swift-package-manager)
  - [Carthage](#carthage)
  - [CocoaPods](#cocoapods)
- [Supported Environments](#supported-environments)
- [Highlighting the Key Differences](#highlighting-the-key-differences)
- [Using both modules `BoxSdkGen` and `BoxSDK`](#using-both-modules-boxsdkgen-and-boxsdk)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Introduction

The version 6 of the `Box iOS SDK` is a transitional release designed to help you migrate from the legacy v5 SDK to the modern, auto-generated v10+ SDK.

It combines two modules into a single package:

- `BoxSDK`: The manually-maintained module from v5.
- `BoxSdkGen`: The new module, auto-generated from the OpenAPI specification (this is the same module that makes up the entirety of the v10 SDK).

This approach allows you to adopt new features from the `BoxSdkGen` module at your own pace, without needing to immediately rewrite your existing v5 integration.

## Installation

When migrating from v5 to v6, you will need to update the version dependency in your project. The examples below demonstrate how to do this depending on your integration method.

### Swift Package Manager

[The Swift Package Manager](https://www.swift.org/package-manager/) is a tool for managing the distribution of Swift code.
It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To update the dependency in your Xcode project, open your project file, go to `Package Dependencies`, select the Box SDK package, and set the version rule to `Up to Next Major Version` starting at `6.0.0`.

Alternatively you can update the dependency declaration in the dependencies value of your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/box/box-ios-sdk.git", .upToNextMajor(from: "6.0.0"))
]
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager which builds your dependencies and provides you with binary frameworks.

To use v6 of `Box iOS SDK`, update the entry in your `Cartfile` to:

```shell
git "https://github.com/box/box-ios-sdk.git" ~> 6.0.0
```

Then run:

```shell
carthage bootstrap --use-xcframeworks
```

And finally drag the built `xcframework` from Carthage/Build into your project.

### CocoaPods

CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects.
To use v6 with CocoaPods, update your `Podfile` to:

```shell
pod 'BoxSDK', '~> 6.0'
```

Then run the following command in your project directory:

```shell
$ pod install
```

## Supported Environments

Because v6 of the `Box iOS SDK` includes both the legacy v5 `BoxSDK` and the new `BoxSdkGen` module in a single package, it adopts the newer module’s minimum platform requirements.

v6 supports: iOS 13.0+, macOS 10.15+, tvOS 13.0+, and watchOS 6.0+. (By comparison, v5 supported iOS 11.0+, macOS 10.13+, tvOS 11.0+, and watchOS 4.0+.)

If your app currently targets older OS versions, update your deployment targets to meet these minimums.

This update aligns the SDK with current Apple development standards and is required to adopt the new features available in the `BoxSdkGen` module. For the latest submission and SDK toolchain requirements, see Apple’s SDK minimum requirements ([Apple Developer](https://developer.apple.com/news/upcoming-requirements/?id=02212025a)).

## Highlighting the Key Differences

The `BoxSDK` module usage in v6 remains the same as in v5 and is not covered in this document.

If you are migrating code from `BoxSDK` to `BoxSdkGen`, which we recommend, the key differences between the modules (imports, async/await, method signatures, authentication, configuration, convenience methods) are documented in:

- [Migration guide: BoxSDK → BoxSdkGen](./from-BoxSDK-to-BoxSdkGen.md)

## Using both modules `BoxSdkGen` and `BoxSDK`

After migrating to Box iOS SDK v6, you can use both the legacy `BoxSDK` module and the generated `BoxSdkGen` module in the same project. Import whichever module you need in each file.

However, some classes (such as `BoxClient` and `User`) exist in both modules. If you import both `BoxSDK` and `BoxSdkGen` in the same file, you'll get a compiler error due to ambiguity (for example: 'BoxClient' is ambiguous for type lookup in this context).

To avoid this, you can create a small file where you import only one module and define type aliases for the symbols you want to use elsewhere. For example, `BoxSDKAliases.swift`:

```swift
import BoxSDK

typealias LegacyBoxSDK = BoxSDK
typealias LegacyBoxClient = BoxClient
typealias LegacyUser = User
```

Then, in files where you want to use both modules, import `BoxSdkGen` directly and use the type aliases to reference types from `BoxSDK`.

```swift
import BoxSdkGen

// Use BoxSdkGen directly to list items in the root folder

let auth = BoxDeveloperTokenAuth(token: "DEVELOPER_TOKEN_GOES_HERE")
let client = BoxClient(auth: auth)

let items = try await client.folders.getFolderItems(folderId: "0")
if let entries = items.entries {
    for entry in entries {
        switch entry {
        case let .fileFull(file):
            print("file \(file.name!) [\(file.id)]")
        case let .folderMini(folder):
            print("folder \(folder.name!) [\(folder.id)]")
        case let .webLink(webLink):
            print("webLink \(webLink.name!) [\(webLink.id)]")
        }
    }
}

// Use BoxSDK via type aliases to get current user info

let legacyClient: LegacyBoxClient = LegacyBoxSDK.getClient(token: "DEVELOPER_TOKEN_GOES_HERE")
let user: LegacyUser = try await withCheckedThrowingContinuation { continuation in
    legacyClient.users.getCurrent(fields: ["name", "login"]) { result in
        switch result {
        case .success(let user):
            continuation.resume(returning: user)
        case .failure(let error):
            continuation.resume(throwing: error)
        }
    }
}

print("Authenticated as \(user.name), with login \(user.login)")
```

Alternatively, you can do the reverse: define type aliases for `BoxSdkGen` and import `BoxSDK` in files where you need both modules.
