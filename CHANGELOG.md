# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

## [5.6.0](https://github.com/box/box-ios-sdk/compare/v5.5.0...v5.6.0) (2024-04-05)


### New Features and Enhancements

* Add privacy manifest files ([#924](https://github.com/box/box-ios-sdk/issues/924)) ([cbef168](https://github.com/box/box-ios-sdk/commit/cbef168bb872941899be26116c647ac29f5dd44b))
* Add support for `visionOS` ([#916](https://github.com/box/box-ios-sdk/issues/916)) ([a05b243](https://github.com/box/box-ios-sdk/commit/a05b2433f1b2d0c1ec72f946e0706d03a4548703))
* Add support for additional fields in `SignRequest` ([#919](https://github.com/box/box-ios-sdk/issues/919)) ([36f464c](https://github.com/box/box-ios-sdk/commit/36f464c23a161f5d0fcc6858c3615d884ce8ee07))
* Make fields from `TokenInfo` publicly available ([#920](https://github.com/box/box-ios-sdk/issues/920)) ([eb26f47](https://github.com/box/box-ios-sdk/commit/eb26f47bbde6749f44f149e95b3610e41c16d2f2))

## [5.5.0](https://github.com/box/box-ios-sdk/compare/v5.4.2...v5.5.0) (2023-08-08)


### New Features and Enhancements

* Add missing values in `SignRequestSignerInputContentType` and `SignRequestStatus` along with the tests ([#907](https://github.com/box/box-ios-sdk/issues/907)) ([56a8250](https://github.com/box/box-ios-sdk/commit/56a82500c0abe648825d8300979601a25f792c84))

### Bug Fixes

* Identify iPhone Simulator on Apple Silicon ([#902](https://github.com/box/box-ios-sdk/issues/902)) ([7731a7f](https://github.com/box/box-ios-sdk/commit/7731a7f434add74e163a76511fe1e2a3f26517f7))
* Make code compatible with macOS. ([#900](https://github.com/box/box-ios-sdk/issues/900)) ([3b0016e](https://github.com/box/box-ios-sdk/commit/3b0016e44e674db0ea429273c03e5a29177372bf))
* Remove use of deprecated string scanner API. ([#901](https://github.com/box/box-ios-sdk/issues/901)) ([af5f0e5](https://github.com/box/box-ios-sdk/commit/af5f0e52d184fbd27f56d972fb93b3e543547773))

### [5.4.2](https://github.com/box/box-ios-sdk/compare/v5.4.1...v5.4.2) (2023-04-19)


### Bug Fixes

* An emoty string `nextMarker` should be treated as end-of-paging. ([#893](https://github.com/box/box-ios-sdk/issues/893)) ([49c17de](https://github.com/box/box-ios-sdk/commit/49c17de588fcffcd2d151ce9047ebc09965f80ce))

### [5.4.1](https://github.com/box/box-ios-sdk/compare/v5.4.0...v5.4.1) (2023-02-24)


### Bug Fixes

* Fix `listAssignments` and `assign` methods in `RetentionPolicyModule` ([#886](https://github.com/box/box-ios-sdk/issues/886)) ([b668888](https://github.com/box/box-ios-sdk/commit/b668888f35136dd1239526b70cc31a10bdd04744))

## [5.4.0](https://github.com/box/box-ios-sdk/compare/v5.3.0...v5.4.0) (2022-11-08)


### New Features and Enhancements

* Add `content_type` field to Sign Requests signer ([#871](https://github.com/box/box-ios-sdk/issues/871)) ([1ec5b01](https://github.com/box/box-ios-sdk/commit/1ec5b0149f01cd3a18f5cba39b77e01678655932))
* Add `redirect_url` and `declined_redirect_url` to Sign Request ([#870](https://github.com/box/box-ios-sdk/issues/870)) ([f94d988](https://github.com/box/box-ios-sdk/commit/f94d98862d2fdb2603f4684b963d29d04e0fdb3d))
* Add support for `sign` webhook triggers ([#875](https://github.com/box/box-ios-sdk/issues/875)) ([994bfaf](https://github.com/box/box-ios-sdk/commit/994bfaf3ead983f5014808f6c9e5ffe167ab8e42))
* Added method to remove retention policy assignment ([#873](https://github.com/box/box-ios-sdk/issues/873)) ([c5f146c](https://github.com/box/box-ios-sdk/commit/c5f146c960bb1f940418975078d83fb63ff3bdec))
* Added support for Modifiable Retention Policies ([#872](https://github.com/box/box-ios-sdk/issues/872)) ([e2b7a17](https://github.com/box/box-ios-sdk/commit/e2b7a178c6592c9f7d1e7ce691c215680b3f45d0))

## [5.3.0](https://github.com/box/box-ios-sdk/compare/v5.2.1...v5.3.0) (2022-08-19)


### New Features and Enhancements

* add `version_number` to `FileVersion` ([#853](https://github.com/box/box-ios-sdk/issues/853)) ([ac81667](https://github.com/box/box-ios-sdk/commit/ac81667ea409cbbe3de9be0c316c630ec6fbc2f5))
* Add support for async API in `FoldersModule` ([#851](https://github.com/box/box-ios-sdk/issues/851)) ([58b9dde](https://github.com/box/box-ios-sdk/commit/58b9dde412eddc76915c99b960702f4af95b62a4))
* Add support for file request API ([#867](https://github.com/box/box-ios-sdk/issues/867)) ([ec7813e](https://github.com/box/box-ios-sdk/commit/ec7813e31706c08aaaeac75debdba8d7802786cb))
* Add support for upload and delete Avatar API ([#863](https://github.com/box/box-ios-sdk/issues/863)) ([1e967f5](https://github.com/box/box-ios-sdk/commit/1e967f5a3eaafbeb894cf8289032ad8ce8664266))
* Add support of Editable Shared Link ([#861](https://github.com/box/box-ios-sdk/issues/861)) ([bc6ea18](https://github.com/box/box-ios-sdk/commit/bc6ea18bf2e10bebeb62401a55001139f05c76df))
* Expose `send()` method public in `BoxClient` ([#843](https://github.com/box/box-ios-sdk/issues/843)) ([23caaca](https://github.com/box/box-ios-sdk/commit/23caaca5b6fe8ec1b23470193bc011a62c66d49f))

### Bug Fixes

* Respect Content-Type coming from custom headers ([#841](https://github.com/box/box-ios-sdk/issues/841)) ([a7c69a7](https://github.com/box/box-ios-sdk/commit/a7c69a73c6142d4b82c718d2d311098dd2b70250))

### [5.2.1](https://github.com/box/box-ios-sdk/compare/v5.2.0...v5.2.1) (2022-04-22)


### Bug Fixes

* Expose fields from `BoxResponse` for custom API calls ([#833](https://github.com/box/box-ios-sdk/issues/833)) ([bae1536](https://github.com/box/box-ios-sdk/commit/bae1536236a22de198281012b0ee43c84b0e3485))

## [5.2.0](https://github.com/box/box-ios-sdk/compare/v5.1.0...v5.2.0) (2022-03-18)


### New Features and Enhancements

* Add `disposition_at` field to the `File` object ([#814](https://github.com/box/box-ios-sdk/issues/814)) ([3c90df0](https://github.com/box/box-ios-sdk/commit/3c90df038b9f490a9d38af85404fa1d6ddcd5d0d))
* Add support for Client Credentials Grant authentication method ([#821](https://github.com/box/box-ios-sdk/issues/821)) ([f6d7542](https://github.com/box/box-ios-sdk/commit/f6d75424e8c0d91517e3ffb8df67f77ad3f2374b))

## [5.1.0](https://github.com/box/box-ios-sdk/compare/v5.0.0...v5.1.0) (2022-01-17)


### New Features and Enhancements

* Allow to customize URL for the `OAuth2` authorization page ([#811](https://github.com/box/box-ios-sdk/issues/811)) ([1901d29](https://github.com/box/box-ios-sdk/commit/1901d296a2be4b0f2eef25eda06928aebc81de9a))
* **Events:** Add support for `admin_logs_streaming` stream type ([#800](https://github.com/box/box-ios-sdk/issues/800)) ([0a3118e](https://github.com/box/box-ios-sdk/commit/0a3118ef95c2eb42b0080d0352784849e85eb422))
* **RetentionPolicy:** New API for get files and file versions under retention ([#807](https://github.com/box/box-ios-sdk/issues/807)) ([38327f0](https://github.com/box/box-ios-sdk/commit/38327f09a92dba7827e1866940a643d624757762))
* **SharedLink:** add support for `vanity_name` ([#799](https://github.com/box/box-ios-sdk/issues/799)) ([3ea6eb2](https://github.com/box/box-ios-sdk/commit/3ea6eb2a1c2b713fd0769e93a2dc4ee51da695fd))

### Bug Fixes

* **SignRequest:** Fix encoding `date_value` to `yyyy-mm-dd` format in `prefillTag` ([#806](https://github.com/box/box-ios-sdk/issues/806)) ([4f902a4](https://github.com/box/box-ios-sdk/commit/4f902a47482de55ec69b5522e6cf5affd653b4c8))

## [5.0.0](https://github.com/box/box-ios-sdk/compare/v4.4.0...v5.0.0) (2021-10-28)


### ⚠ BREAKING CHANGES

- Update PagingIterator to return pages and simplify logic ([#737](https://github.com/box/box-ios-sdk/pull/737))
- Remove insensitive language field `collaborationWhiteList` in BoxClient. Use `collaborationAllowList` instead. ([#790](https://github.com/box/box-ios-sdk/pull/790))

### New Features and Enhancements

- Replace insensitive event types ([#785](https://github.com/box/box-ios-sdk/pull/785))
- Add SignAPI support ([#792](https://github.com/box/box-ios-sdk/pull/792))

## [4.4.0](https://github.com/box/box-ios-sdk/compare/v4.3.0...v4.4.0) (2021-04-20)

### New Features and Enhancements

- Add support for search param to get shared link items ([#756](https://github.com/box/box-ios-sdk/pull/756))
- Add support for folder lock functionality ([#759](https://github.com/box/box-ios-sdk/pull/759))
- Add support for copyInstanceOnItemCopy field for metadata templates ([#763](https://github.com/box/box-ios-sdk/pull/763))
- Add support for stream upload of new file versions and add support for 'If-Match' header when uploading new file versions ([#766](https://github.com/box/box-ios-sdk/pull/766))
- Add additional details field for `Event` model ([#770](https://github.com/box/box-ios-sdk/pull/770))

### Bug Fixes

- Pass only a scheme to iOS Authentication APIs ([#755](https://github.com/box/box-ios-sdk/pull/755))
- Update `listEnterpriseGroups()` to use documented parameter for filtering by name ([#757](https://github.com/box/box-ios-sdk/pull/757))
- Fix bug for OAuth where the callback is not called if token has been revoked ([#762](https://github.com/box/box-ios-sdk/pull/762))

## [4.3.0](https://github.com/box/box-ios-sdk/compare/v4.2.0...v4.3.0) (2021-02-01)

### New Features and Enhancements

- Add support for OAuth 2 custom callback URL ([#746](https://github.com/box/box-ios-sdk/pull/746))
- Add support for zip download ([#749](https://github.com/box/box-ios-sdk/pull/749))

### Bug Fixes

- Update gems to patch kramdown vulnerability ([#742](https://github.com/box/box-ios-sdk/pull/742))
- Update gems to patch activesupport vulnerability ([#745](https://github.com/box/box-ios-sdk/pull/745))

## [4.2.0](https://github.com/box/box-ios-sdk/compare/v4.1.0...v4.2.0) (2020-11-16)

### New Features and Enhancements

- Add error information to OAuth web session failures

### Bug Fixes

- Fix bug with creating collaboration
- Fix bug with getting enterprise events

## [4.1.0](https://github.com/box/box-ios-sdk/compare/v4.0.0...v4.1.0) (2020-05-15)

### New Features and Enhancements

- Add ability to cancel uploads and downloads
- Add support for the uploader display name field for Files and File Versions
- Add support for the classification field for Files and Folders
- Add path parameter sanitization

### Bug Fixes

- Fix logging of API responses

## [4.0.0](https://github.com/box/box-ios-sdk/compare/v3.1.0...v4.0.0) (2020-02-13)

### ⚠ BREAKING CHANGES

- Change `status` field for task assignments from a String to an Enum
- Remove macOS, tvOS, and watchOS support

### New Features and Enhancements

- Make authentication session classes `OAuth2Session`, `SingleTokenSession`, and `DelegatedAuthSession` public


## [3.1.0](https://github.com/box/box-ios-sdk/compare/v3.0.0...v3.1.0) (2020-01-09)

### New Features and Enhancements

- Add shared link downscoping
- Add closure parameter for progress of uploads and downloads
- Add marker based pagination to list users endpoint


## [3.0.0](https://github.com/box/box-ios-sdk/compare/v3.0.0-rc.3...v3.0.0) (2019-11-18)

### New Features and Enhancements

- Added file specific icons for the Sample Apps.


## [3.0.0-rc.3](https://github.com/box/box-ios-sdk/compare/v3.0.0-rc.2...v3.0.0-rc.3) (2019-11-14)

### ⚠ BREAKING CHANGES

- For Module methods that returned a collection of objects, changed from returning a PaginationIterator to returning a PagingIterator in a completion.
- Modules are now automatically instantiated with the BoxClient object and no longer allow the client app to instantiate them 
- Related RetentionPolicy classes no longer allow rawData to be set by the client app
- UploadPartDescription made private
- Fixed bug with exponential backoff and changed SDK configuration item "retryAfterTime" to "retryBaseInterval"


### New Features and Enhancements

- RetentionPolicyModule methods made public 
- Added additional supporting types 
- Improved support for logging to file, allow for custom file path, and fixed some related bugs
- Improved console logging formatting
- Updated Sample Apps to use new PagingIterator responses 


## [3.0.0-rc.2](https://github.com/box/box-ios-sdk/compare/v3.0.0-rc.1...v3.0.0-rc.2) (2019-10-30)

### ⚠ BREAKING CHANGES

- Changed SDK errors from customValue enum cases to specific enum cases


### New Features and Enhancements

- Added Xcode 11 + iOS 13 support to Travis CI


## [3.0.0-rc.1](https://github.com/box/box-ios-sdk/compare/v3.0.0-alpha.3...v3.0.0-rc.1)  (2019-10-18)

### ⚠ BREAKING CHANGES

- Changed TaskAssignment.resolutionState from String to new AssignmentState enum type
- Changed Group.groupType from String to new GroupType enum type
- Changed Folder.allowedSharedLinkAccessLevels from [String] to new [SharedLinkAccess] enum type
- Changed File.allowedInviteeRoles from [String] to new [CollaborationRole] enum type
- Network responses with 4xx or 5xx status codes are now transformed into an API Error
- CollaborationItem changed from class to enum
- CommentItem changed from class to enum
- FolderItem changed from class to enum
- WebhookItem changed from class to enum
- TaskItem changed from class to enum
- JSON decoding errors now emit expected type
- Public method names changed to a new convention in many of the "module" classes
- Redesigned error classes and error hierarchy
- Temporarily removed progress closure for uploads and downloads


### New Features and Enhancements

- Added Xcode 11 support (SDK builds still target iOS 11.0)
- Removed AlamoFire dependency
- Added support for Device Pins
- Added SDK Configuration URL validation
- Added SDK-level constants rootFolder and currentUser for convenience
- Added support for Collaboration Whitelist endpoints
- Added support for Retention Policy endpoints
- Added support for Tasks endpoints
- Added support for Webhooks endpoints
- Added support for Groups and Group Membership endpoints
- Added support for Legal Holds endpoints
- Added support for Terms of Service endpoints
- Added support for Terms of Service User Status endpoints
- Added support for Watermarking endpoints
- Added support for Storage Policy endpoints
- Added support for Metadata Cascade Policy endpoints
- Added support for User endpoints
- Added support for Events endpoints

- Added Error Views in Sample Apps
- Improved structure and usability of Sample Apps


## [3.0.0-alpha.3](https://github.com/box/box-ios-sdk/compare/v3.0.0-alpha.2...v3.0.0-alpha.3) (2019-08-29)

### ⚠ BREAKING CHANGES

- Changed File Entry Container "entries" from optional to not optional


### New Features and Enhancements

- Added support for Web Links
- Added support for Trash endpoints
- Added support for Recent Items
- Added support for File Version endpoints
- Added support for Delete File endpoint
- Added support for Chunked Upload Endpoints
- Added support for upload preflight check
- Added support for downloading a representation of a file
- Added support for custom OAuth2 Callback URL
- Added KeychainTokenStore for OAuth2SampleApp


## [3.0.0-alpha.2](https://github.com/box/box-ios-sdk/compare/v3.0.0-alpha.1...v3.0.0-alpha.2) (2019-08-08)

### ⚠ BREAKING CHANGES

- Moved some constants to different namespaces:
    * `Box.rootFolder` is now `BoxSDK.Constants.rootFolder`
    * `Box.currentUser` is now `BoxSDK.Constants.currentUser`
- Updated the arguments that `client.files.updateFileInfo()` takes for consistency with the rest of the SDK
- Changed the type of the `expiresAt` arguments in `client.files.lockFile()` from `String` to `Date`
- Removed unused arguments from `client.files.unlockFile()`
- Changed the type of the `unsharedAt` and `password` arguments of `client.files.setSharedLink()` and
  `client.folders.setSharedLink()` to accept `.null` values
- Replaced the `access`, `password`, `unsharedAt`, and `canDownload` arguments of `client.folders.updateFolder()` with
  a single `sharedLink` argument to enable setting the entire shared link field to `.null` in order to remove the
  shared link
- Replaced `client.getFavoritesCollectionId()` with `client.collections.getFavoritesCollection()`
- Removed `client.collections.addItemsToCollection()` and `client.collections.deleteItemsFromCollection()`
- Changed the result type for `client.files.addFileToFavorites()`, `client.files.addFileToCollection()`,
  `client.files.removeFileFromFavorites()`, and `client.files.removeFileFromCollection()` from `Void` to `File`
- Changed the result type for `client.folders.addFolderToFavorites()`, `client.folders.addFolderToCollection()`,
  `client.folders.removeFolderFromFavorites()`, and `client.folders.removeFolderFromCollection()` from `Void` to
  `Folder`


### New Features and Enhancements

- Added support for [token downscoping](./docs/usage/authentication.md#token-exchange)
- Added a `KeychainTokenStore` implementation to enable persisting authentication state on the Keychain
- The SDK now automatically clears the token store after destroying a client and revoking its tokens


## [3.0.0-alpha.1] (2019-07-25)

Initial beta release :tada:
