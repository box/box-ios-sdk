# Migration guide from beta release (v0.X.Y) of the `box-swift-sdk-gen` to the v10 version of the `box-ios-sdk`

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Installation](#installation)
  - [How to migrate](#how-to-migrate)
    - [Swift Package Manager](#swift-package-manager)
    - [Carthage](#carthage)
    - [CocoaPods](#cocoapods)
- [Union classes name changes](#union-classes-name-changes)
  - [How to migrate](#how-to-migrate-1)
- [Removed unused models from schemas namespace](#removed-unused-models-from-schemas-namespace)
  - [How to migrate](#how-to-migrate-2)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Installation

In order to start using v10 version of the Box iOS SDK, you need to change the dependency in your project,
since it's no longer the repository https://github.com/box/box-swift-sdk-gen but https://github.com/box/box-ios-sdk.
You also need to set the version to `10.0.0` or higher.

### How to migrate

#### Swift Package Manager

To start using v10 version of Box iOS SDK in XCode project you need to change the package URL and version.
You need to click on Xcode project file on `Packages Dependencies`, remove the entry for `BoxSdkGen` and click on the plus icon to add a package.
Then enter the following repository url https://github.com/box/box-ios-sdk.git and select the version by choosing `Up to Next Major Version` and entering `10.0.0` as the starting version.

Alternatively, open th package file `Package.swift` and replace the dependencies:

- in the top-level `dependencies` array:

  **Old (`box-swift-sdk-gen-v0`)**

  ```swift
  dependencies: [
      .package(url: "https://github.com/box/box-swift-sdk-gen", from: "0.6.0")
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

  **New (`box-ios-sdk-v10`)**

  ```swift
  dependencies: [
        .product(name: "BoxSDK", package: "box-ios-sdk")
  ])
  ```

#### Carthage

To start using v10 version of Box iOS SDK using Carthage your need to replace the dependency in your `Cartfile` file.

**Old (`box-swift-sdk-gen-v0`)**

```shell
git "https://github.com/box/box-swift-sdk-gen.git"
```

**New (`box-ios-sdk-v10`)**

```shell
git "https://github.com/box/box-ios-sdk.git" >= 10.0.0
```

Then after running the command `carthage bootstrap --use-xcframeworks`, you need to drag the built `xcframework` from Carthage/Build into your project.

#### CocoaPods

To start using v10 version of Box iOS SDK using CocoaPods your need to replace the dependency in your `Podfile` file.

**Old (`box-swift-sdk-gen-v0`)**

```shell
pod 'BoxSdkGen'
```

**New (`box-ios-sdk-v10`)**

```shell
pod 'BoxSDK', '>= 10.0.0'
```

## Union classes name changes

In the beta version of the `box-swift-sdk-gen` we were generating enums with associated values for unions from the OpenAPI specification by generating name of the enum based on the included variants.
This often resulted in overly long names that were difficult to work with in tools like Git. For example: `MetadataFieldFilterDateRangeOrMetadataFieldFilterFloatRangeOrArrayOfStringOrNumberOrString`.
What is more, every time the new variant was added to the union, the enum name itself changed.
Starting in v10, the names of those enums representing unions are defined directly in the specification. This ensures that they are meaningful, short, and stable over time.

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
