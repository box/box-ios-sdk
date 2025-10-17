# Migration guide: migrate from `Box Swift SDK Gen` (v0.X) to `Box iOS SDK` v6.X or v10.X

Note: This guide applies only to migrations targeting Box iOS SDK v6.X.Y or v10.X.Y. It does not apply to other major versions (e.g., v7.X, v11.X).

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Introduction](#introduction)
  - [Installation](#installation)
    - [How to migrate](#how-to-migrate)
      - [Swift Package Manager](#swift-package-manager)
      - [Carthage](#carthage)
      - [CocoaPods](#cocoapods)
  - [Union classes name changes](#union-classes-name-changes)
    - [How to migrate](#how-to-migrate-1)
  - [Removed unused models from schemas namespace](#removed-unused-models-from-schemas-namespace)
    - [How to migrate](#how-to-migrate-2)
  - [Usage](#usage)
    - [Using the Box iOS SDK v10](#using-the-box-ios-sdk-v10)
    - [Using the Box iOS SDK v6](#using-the-box-ios-sdk-v6)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Introduction

From the beta version of box-swift-sdk-gen in version v0.X.Y you can migrate either to v6 or v10 of the Box iOS SDK and your choice should depend on whether you want to continue using the legacy SDK (Box iOS SDK v5) alongside the generated one or not.

The v6 version of the Box iOS SDK contains both the legacy SDK module `BoxSDK` and the generated one `BoxSdkGen`.
If previously you were using both of SDKs `BoxSDK` v5 and `BoxSdkGen` v0.X.Y, you should migrate to v6 version of the Box iOS SDK which contains `BoxSDK` and `BoxSdkGen` modules.

If however you were only using the generated SDK module `BoxSdkGen` in version v0.X.Y you should migrate to v10 version of the Box iOS SDK which contains only the generated SDK module `BoxSdkGen`.

| Scenario                                     | Your current usage                                   | Recommended target | Modules included in target                  | Why this choice                                                          | Notes                                                                                               |
| -------------------------------------------- | ---------------------------------------------------- | ------------------ | ------------------------------------------- | ------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------- |
| Using both legacy and generated SDK together | `BoxSDK` v5 + `BoxSdkGen` v0.X.Y in the same project | v6.X.Y             | `BoxSDK` (legacy) + `BoxSdkGen` (generated) | Keep existing v5 code while adopting new features from the generated SDK | Run both modules side-by-side; use type aliases to avoid name conflicts (e.g., `BoxClient`, `User`) |
| Using only the generated SDK                 | `BoxSdkGen` v0.X.Y only                              | v10.X.Y            | `BoxSdkGen` (generated) only                | Clean upgrade path with no legacy module; simpler dependency surface     | Best when you don’t need the legacy `BoxSDK` module                                                 |

## Installation

The installation process for v6 and v10 versions of the Box iOS SDK is similar, but there are just some differences in the version number you need to set.

In order to start using v6 or v10 version of the Box iOS SDK, you need to change the dependency in your project,
since it's no longer the repository https://github.com/box/box-swift-sdk-gen but https://github.com/box/box-ios-sdk.
You also need to set the version to `6.0.0` if you are migrating to v6 or `10.0.0` if you are migrating to v10.
Finally, the name of the product you need to reference has changed from `BoxSdkGen` to `BoxSDK`.

### How to migrate

#### Swift Package Manager

To start using the new version of Box iOS SDK in XCode project you need to change the package URL and version.
You need to click on Xcode project file on `Packages Dependencies`, remove the entry for `BoxSdkGen` and click on the plus icon to add a package.
Then enter the following repository url https://github.com/box/box-ios-sdk.git and select the version by choosing `Up to Next Major Version`.

**New (`box-ios-sdk-v6`)**
If you are migrating to v6, which contains both the legacy SDK module `BoxSDK` and the generated one `BoxSdkGen`, enter `6.0.0` as the starting version.

**New (`box-ios-sdk-v10`)**
If you are migrating to v10, which contains only the generated SDK module `BoxSdkGen`, enter `10.0.0` as the starting version.

Alternatively, open the package file `Package.swift` and replace the dependencies:

- in the top-level `dependencies` array:

  **Old (`box-swift-sdk-gen-v0`)**

  ```swift
  dependencies: [
      .package(url: "https://github.com/box/box-swift-sdk-gen", from: "0.6.0")
  ]
  ```

  **New (`box-ios-sdk-v6`)**

  ```swift
  dependencies: [
    .package(url: "https://github.com/box/box-ios-sdk.git", .upToNextMajor(from: "6.0.0"))
  ]
  ```

  **New (`box-ios-sdk-v10`)**

  ```swift
  dependencies: [
    .package(url: "https://github.com/box/box-ios-sdk.git", from: "10.0.0")
  ]
  ```

- in your target's `dependencies`:

  **Old (`box-swift-sdk-gen-v0`)**

  ```swift
  dependencies: [
        .product(name: "BoxSdkGen", package: "box-swift-sdk-gen")
  ])
  ```

  **New (`box-ios-sdk-v6` or `box-ios-sdk-v10`)**

  ```swift
  dependencies: [
        .product(name: "BoxSDK", package: "box-ios-sdk")
  ])
  ```

#### Carthage

To start using either v6 or v10 version of Box iOS SDK using Carthage you need to replace the dependency in your `Cartfile` file.

**Old (`box-swift-sdk-gen-v0`)**

```shell
git "https://github.com/box/box-swift-sdk-gen.git"
```

**New (`box-ios-sdk-v6`)**

```shell
git "https://github.com/box/box-ios-sdk.git" ~> 6.0.0
```

**New (`box-ios-sdk-v10`)**

```shell
git "https://github.com/box/box-ios-sdk.git" >= 10.0.0
```

Then after running the command `carthage bootstrap --use-xcframeworks`, you need to drag the built `xcframework` from Carthage/Build into your project.

#### CocoaPods

To start using either v6 or v10 version of Box iOS SDK using CocoaPods you need to replace the dependency in your `Podfile` file.

**Old (`box-swift-sdk-gen-v0`)**

```shell
pod 'BoxSdkGen'
```

**New (`box-ios-sdk-v6`)**

```shell
pod 'BoxSDK', '~> 6.0'
```

**New (`box-ios-sdk-v10`)**

```shell
pod 'BoxSDK', '>= 10.0.0'
```

## Union classes name changes

In the beta version of the `box-swift-sdk-gen` we were generating enums with associated values for unions from the OpenAPI specification by generating name of the enum based on the included variants.
This often resulted in overly long names that were difficult to work with in tools like Git. For example: `MetadataFieldFilterDateRangeOrMetadataFieldFilterFloatRangeOrArrayOfStringOrNumberOrString`.
Additionally, every time the new variant was added to the union, the enum name itself changed.
Starting with the new SDK (v6 and v10), the names of those enums representing unions are defined directly in the specification. This ensures that they are meaningful, short, and stable over time.

### How to migrate

If your code references any of the renamed enums, replace the old name with the new one.
If you were not explicitly using the type names, no changes are needed, since only the enum names changed and their behavior remains the same.

List of changed enums and types associated with them:

| Old name                                                                                   | New name                                                           |
| ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------ |
| AiAgentAskOrAiAgentExtractOrAiAgentExtractStructuredOrAiAgentTextGen                       | AiAgent                                                            |
| AiAgentAskOrAiAgentReference                                                               | AiAskAgent                                                         |
| AiAgentExtractOrAiAgentReference                                                           | AiExtractAgent                                                     |
| AiAgentExtractStructuredOrAiAgentReference                                                 | AiExtractStructuredAgent                                           |
| AiAgentReferenceOrAiAgentTextGen                                                           | AiTextGenAgent                                                     |
| AppItemEventSourceOrEventSourceOrFileOrFolderOrGenericSourceOrUser                         | EventSourceResource                                                |
| FileBaseOrFolderBaseOrWebLinkBase                                                          | AppItemAssociatedItem                                              |
| FileFullOrFolderFull                                                                       | MetadataQueryResultItem                                            |
| FileFullOrFolderFullOrWebLink                                                              | SearchResultWithSharedLinkItem/RecentItemResource/SearchResultItem |
| FileFullOrFolderMiniOrWebLink                                                              | Item                                                               |
| FileMiniOrFolderMini                                                                       | Resource                                                           |
| FileOrFolderOrWebLink                                                                      | LegalHoldPolicyAssignedItem/CollaborationItem                      |
| FileOrFolderScope                                                                          | ResourceScope                                                      |
| FileOrFolderScopeScopeField                                                                | ResourceScopeScopeField                                            |
| FileReferenceOrFolderReferenceOrWeblinkReferenceV2025R0                                    | HubItemReferenceV2025R0                                            |
| GroupMiniOrUserCollaborations                                                              | CollaborationAccessGrantee                                         |
| IntegrationMappingPartnerItemSlackUnion                                                    | IntegrationMappingPartnerItemSlack                                 |
| IntegrationMappingPartnerItemTeamsUnion                                                    | IntegrationMappingPartnerItemTeams                                 |
| KeywordSkillCardOrStatusSkillCardOrTimelineSkillCardOrTranscriptSkillCard                  | SkillCard                                                          |
| MetadataFieldFilterDateRangeOrMetadataFieldFilterFloatRangeOrArrayOfStringOrNumberOrString | MetadataFilterValue                                                |
| SearchResultsOrSearchResultsWithSharedLinks                                                | SearchResultsResponse                                              |

Some enums were split into multiple ones depending on context.

Manager functions affected by these changes:

| Function                               | Old return type                                                      | New return type       |
| -------------------------------------- | -------------------------------------------------------------------- | --------------------- |
| AiManager.getAiAgentDefaultConfig(...) | AiAgentAskOrAiAgentExtractOrAiAgentExtractStructuredOrAiAgentTextGen | AiAgent               |
| SearchManager.searchForContent(...)    | SearchResultsOrSearchResultsWithSharedLinks                          | SearchResultsResponse |

## Removed unused models from schemas namespace

Several unused types (classes and enums) have been removed from the schemas because they were not used by any SDK functions or by the Box API.

### How to migrate

Here is the full list of removed types:

| Removed classes/enums                      |
| ------------------------------------------ |
| FileOrFolder                               |
| HubActionV2025R0                           |
| MetadataQueryIndex                         |
| MetadataQueryIndexFieldsField              |
| MetadataQueryIndexFieldsSortDirectionField |
| MetadataQueryIndexStatusField              |
| RetentionPolicyAssignmentBase              |
| RetentionPolicyAssignmentBaseTypeField     |
| SkillInvocation                            |
| SkillInvocationEnterpriseField             |
| SkillInvocationEnterpriseTypeField         |
| SkillInvocationSkillField                  |
| SkillInvocationSkillTypeField              |
| SkillInvocationStatusField                 |
| SkillInvocationStatusStateField            |
| SkillInvocationTokenField                  |
| SkillInvocationTokenReadField              |
| SkillInvocationTokenReadTokenTypeField     |
| SkillInvocationTokenWriteField             |
| SkillInvocationTokenWriteTokenTypeField    |
| SkillInvocationTypeField                   |
| WebhookInvocation                          |
| WebhookInvocationTriggerField              |
| WebhookInvocationTypeField                 |
| WorkflowFull                               |

If your code references any of these types, remove those references.

## Usage

### Using the Box iOS SDK v10

After migration from box-swift-sdk-gen in version v0.X.Y to v10 version of the Box iOS SDK, you can still use the BoxSdkGen module in the same way as before.
You have to import the BoxSdkGen module as it was before and use the BoxClient class to create an instance of the client.

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

### Using the Box iOS SDK v6

After migration to Box iOS SDK v6, you can use both the legacy Box iOS SDK module `BoxSDK` and the generated one `BoxSdkGen`.
You just have to import the appropriate module depending on which SDK you want to use, which is either `BoxSDK` or `BoxSdkGen`.
However, some classes (like `BoxClient` and `User`) exist in both modules. If you import both `BoxSDK` and `BoxSdkGen` in the same file, you will get a compiler error due to this ambiguity: `'BoxClient' is ambiguous for type lookup in this context'`.

To avoid this ambiguity you can create a file where you import only one of the modules and create a typealias for the classes you want to use from that module.
For example, you can create a file named `BoxSDKAliases.swift` and add the following code:

```swift
import BoxSDK

typealias LegacyBoxSDK = BoxSDK
typealias LegacyBoxClient = BoxClient
typealias LegacyUser = User
```

Then in other files in which you want to use both modules, you can just import the `BoxSdkGen` module to use classes from it and you can also use the typealiases you created to use classes from the `BoxSDK` module.

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

// Use BoxSDK via typealiases to get current user info

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
