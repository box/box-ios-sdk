Changelog
=========

## v3.0.0-alpha.3 [2019-08-29]

__Breaking Changes:__

- Changed File Entry Container "entries" from optional to not optional


__New Features and Enhancements:__

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


## v3.0.0-alpha.2 [2019-08-08]

__Breaking Changes:__

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


__New Features and Enhancements:__

- Added support for [token downscoping](./docs/usage/authentication.md#token-exchange)
- Added a `KeychainTokenStore` implementation to enable persisting authentication state on the Keychain
- The SDK now automatically clears the token store after destroying a client and revoking its tokens


## v3.0.0-alpha.1 [2019-07-25]

Initial beta release :tada:
