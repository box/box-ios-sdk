Folders
=======

Folder objects represent a folder from a user's account. They can be used to iterate through a folder's contents,
collaborate a folder with another user or group, and perform other common folder operations (move, copy, delete, etc.).

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Folders](#folders)
  - [Get Folder Info](#get-folder-info)
  - [Get Folder Items](#get-folder-items)
  - [Create Folder](#create-folder)
  - [Delete Folder](#delete-folder)
  - [Copy Folder](#copy-folder)
  - [Get Folder Collaborations](#get-folder-collaborations)
  - [Add Folder to Favorites](#add-folder-to-favorites)
  - [Remove Folder from Favorites](#remove-folder-from-favorites)
  - [Get Shared Link](#get-shared-link)
  - [Set Shared Link](#set-shared-link)
  - [Remove Shared Link](#remove-shared-link)
  - [Get Folder Locks](#get-folder-locks)
  - [Create Folder Lock](#create-folder-lock)
  - [Delete Folder Lock](#delete-folder-lock)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Get Folder Info
---------------

To retrieve information about a folder, call
[`client.folders.get(folderId:fields:completion:)`][get-folder]
with the ID of the folder.  You can control which fields are returned in the resulting `Folder` object by passing the
`fields` parameter.

<!-- sample get_folders_id -->
```swift
client.folders.get(
    folderId: "22222",
    fields: ["name", "created_at"]
) { (result: Result<Folder, BoxSDKError>) in
    guard case let .success(folder) = result else {
        print("Error getting folder information")
        return
    }

    print("Folder \(folder.name) was created at \(folder.createdAt)")
}
```

As an alternative, you can call `async` method
[`client.folders.get(folderId:fields)`][get-folder-async]

```swift
do {
    let folder = try await client.folders.get(
        folderId: "111111",
        fields: ["name", "created_at"]
    )
    
    print("Folder \(folder.name) was created at \(folder.createdAt)")
}
catch {
    print("Error getting folder information")
}
```


[get-folder]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC3get8folderId6fields10completionySS_SaySSGSgys6ResultOyAA6FolderCAA0A8SDKErrorCGctF

[get-folder-async]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC3get8folderId6fieldsAA6FolderCSS_SaySSGSgtYaKF

Get Folder Items
----------------

To retrieve information about the items contained in a folder, call
[`client.folders.listItems(folderId:usemarker:marker:offset:limit:sort:direction:fields:)`][get-folder-items]
with the ID of the folder. This method will return an iterator, which is used to retrieve folder items.

<!-- sample get_folders_id_items -->
```swift
let iterator = client.folders.listItems(folderId: "22222", sort: .name, direction: .ascending)
iterator.next { results in
    switch results {
    case let .success(page):
        for item in page.entries {
            switch item {
            case let .file(file):
                print("File \(file.name) (ID: \(file.id)) is in the folder")
            case let .folder(folder):
                print("Subfolder \(folder.name) (ID: \(folder.id)) is in the folder")
            case let .webLink(webLink):
                print("Web link \(webLink.name) (ID: \(webLink.id)) is in the folder")
            }
        }

    case let .failure(error):
        print(error)
    }
}
```

As an alternative, you can retrieve folder items by iterator in `async` way.
For instance, to fetch all folder items, call:

```swift
let iterator = client.folders.listItems(folderId: "22222", sort: .name, direction: .ascending)

var allItems: [FolderItem] = []

do {
    repeat {
        let items = try await iterator.next()
        allItems.append(contentsOf: items.entries)
    } while true
}
catch let error as BoxSDKError where error.message == .endOfList {
    print("The end of the list has been reached")
}
catch {
    print("An error occurred: \(error)")
}
```

[get-folder-items]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC9listItems8folderId9usemarker6marker6offset5limit4sort9direction6fields10completionySS_SbSgSSSgSiSgApA06FolderF7OrderByOSgAA0R9DirectionOSgSaySSGSgys6ResultOyAA14PagingIteratorCyAA0Q4ItemOGAA0A8SDKErrorCGctF

Create Folder
-------------

To create a new folder, call
[`client.folders.create(name:parentId:fields:completion:)`][create-folder]
with a name for the new folder and the ID of the folder to create the new folder in.  To create a new folder inside the
root folder ("All Files"), use ID `"0"`.

<!-- sample post_folders -->
```swift
client.folders.create(name: "New Folder", parentId: "22222") { (result: Result<Folder, BoxSDKError>) in
    guard case let .success(folder) = result else {
        print("Error creating folder")
        return
    }

    print("Created folder \"\(folder.name)\" inside of folder \"\(folder.parent?.name)\"")
}
```

As an alternative, you can call `async` method
[`client.folders.create(name:parentId:fields)`][create-folder-async].

```swift
do {
    let folder = try await client.folders.create(name: "New Folder", parentId: "22222")
     print("Created folder \"\(folder.name)\" inside of folder \"\(folder.parent?.name)\"")
}
catch {
    print("Error getting folder information")
}
```


[create-folder]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC6create4name8parentId6fields10completionySS_SSSaySSGSgys6ResultOyAA6FolderCAA0A8SDKErrorCGctF

[create-folder-async]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC6create4name8parentId6fieldsAA6FolderCSS_SSSaySSGSgtYaKF

Delete Folder
-------------

To delete a folder, call
[`client.folders.delete(folderId:recursive:completion:)`][delete-folder]
with the ID of the folder to delete.  By default, the folder will only be deleted if it is empty and has no
items in it; if you wish to delete all the items in the folder as well, pass `recursive: true`.

<!-- sample delete_folders_id -->
```swift
client.folders.delete(folderId: "22222", recursive: true) { result: Result<Void, BoxSDKError>} in
    guard case .success = result else {
        print("Error deleting folder")
        return
    }

    print("Folder and contents successfully deleted")
}
```

As an alternative, you can call `async` method
[`client.folders.delete(folderId:recursive)`][delete-folder-async]

```swift
do {
    let folder = try await client.folders.delete(folderId: "22222", recursive: true)
    print("Folder and contents successfully deleted")
}
catch {
    print("Error deleting folder")
}
```

[delete-folder]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC6delete8folderId9recursive10completionySS_SbSgys6ResultOyytAA0A8SDKErrorCGctF

[delete-folder-async]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC6delete8folderId9recursiveySS_SbSgtYaKF

Copy Folder
-----------

To copy a folder from one parent folder to another, call
[`client.folders.copy(folderId:destinationFolderID:name:fields:completion:)`][copy-folder]
with the ID of the folder to copy and the ID of the destination parent folder.  To avoid a name conflict in the new
parent folder, pass an alternate name for the folder in the `name` parameter; the folder will be renamed to the
alternate name in case of a conflict.

<!-- sample post_folders_id_copy -->
```swift
client.folders.copy(
    folderId: "22222",
    destinationFolderID: "12345"
) { (result: Result<Folder, BoxSDKError>) in
    guard case let .success(folderCopy) = result else {
        print("Error copying folder")
        return
    }

    print("Copied folder \(folderCopy.name) to destination \(folderCopy.parent?.name)")
}
```

As an alternative, you can call `async` method
[`client.folders.copy(folderId:destinationFolderId:name:fields:)`][copy-folder-async]

```swift
do {
    let folderCopy = try await client.folders.copy(folderId: "22222", destinationFolderId: "12345")
    print("Copied folder \(folderCopy.name) to destination \(folderCopy.parent?.name)")
}
catch {
    print("Error copying folder")
}
```

[copy-folder]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC4copy8folderId19destinationFolderID4name6fields10completionySS_S2SSgSaySSGSgys6ResultOyAA0I0CAA0A8SDKErrorCGctF

[copy-folder-async]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC4copy8folderId017destinationFolderG04name6fieldsAA0I0CSS_S2SSgSaySSGSgtYaKF

Get Folder Collaborations
-------------------------

To retrieve a list of the collaborations on a folder, call
[`client.folders.listCollaborations(folderId:fields:)`][get-collaborations]
with the ID of the folder.

<!-- sample get_folders_id_collaborations -->
```swift
let iterator = client.folders.listCollaborations(folderId: "22222")
iterator.next { results in
    switch results {
    case let .success(page):
        for collaboration in page.entries {
            if let collaborator = collaboration.accessibleBy {
                switch collaborator.collaboratorValue {
                case .user(let user):
                    print("- user: \(user.name ?? "")")
                case .group(let group):
                    print("- group: \(group.name ?? "")")
                }
            }
        }

    case let .failure(error):
        print(error)
    }
}
```

As an alternative, you can retrieve collaborations items by iterator in `async` way.

```swift
let iterator = client.folders.listCollaborations(folderId: "163571796480")
do {
    let page = try await iterator.next()

    for collaboration in page.entries {
        if let collaborator = collaboration.accessibleBy {
            switch collaborator.collaboratorValue {
            case .user(let user):
                print("- user: \(user.name ?? "")")
            case .group(let group):
                print("- group: \(group.name ?? "")")
            }
        }
    }
}
catch {
    print("An error occurred: \(error)")
}
```

[get-collaborations]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC18listCollaborations8folderId6fields10completionySS_SaySSGSgys6ResultOyAA14PagingIteratorCyAA13CollaborationCGAA0A8SDKErrorCGctF

Add Folder to Favorites
-----------------------

To add a folder to the user's favorites, call
[`client.folders.addToFavorites(folderId:fields:completion:)`][add-to-favorites]
with the ID of the folder.

<!-- sample put_folders_id add_to_favorites -->
```swift
client.folders.addToFavorites(folderId: "22222") { (result: Result<Void, BoxSDKError>) in
    guard case .success = result else {
        print("Error adding folder to favorites")
        return
    }

    print("Added folder to favorites")
}
```

As an alternative, you can call `async` method
[`client.folders.addToFavorites(folderId:fields:)`][add-to-favorites-async].

```swift
do {
    try await client.folders.addToFavorites(folderId: "22222")
    print("Added folder to favorites")
}
catch {
    print("Error adding folder to favorites")
}
```

[add-to-favorites]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC14addToFavorites8folderId6fields10completionySS_SaySSGSgys6ResultOyAA6FolderCAA0A8SDKErrorCGctF

[add-to-favorites-async]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC14addToFavorites8folderId6fieldsAA6FolderCSS_SaySSGtYaKF

Remove Folder from Favorites
----------------------------

To remove a folder from the user's favorites, call
[`client.folders.removeFromFavorites(folderId:fields:completion:)`][remove-from-favorites]
with the ID of the folder.

```swift
client.folders.removeFromFavorites(folderId: "22222") { result in
    guard case .success = result else {
        print("Error removing folder from favorites")
        return
    }

    print("Removed folder to favorites")
}
```

As an alternative, you can call `async` method
[`client.folders.removeFromFavorites(folderId:fields:)`][remove-from-favorites-async].

```swift
do {
    try await client.folders.removeFromFavorites(folderId: "22222")
    print("Removed folder to favorites")
}
catch {
    print("Error removing folder from favorites")
}
```

[remove-from-favorites]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC19removeFromFavorites8folderId6fields10completionySS_SaySSGSgys6ResultOyAA6FolderCAA0A8SDKErrorCGctF

[remove-from-favorites-async]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC19removeFromFavorites8folderId6fieldsAA6FolderCSS_SaySSGSgtYaKF


Get Shared Link
---------------

To retrieve the shared link associated with a folder, call
[`client.folders.getSharedLink(forFolder:completion:)`][get-shared-link]
with the ID of the folder.

<!-- sample get_folders_id get_shared_link -->
```swift
client.folders.getSharedLink(forFolder: "11111") { (result: Result<SharedLink, BoxSDKError>) in
    guard case let .success(sharedLink) = result else {
        print("Error retrieving folder shared link")
        return
    }

    print("Folder shared link URL is \(sharedLink.url), with \(sharedLink.access) access")
}
```

As an alternative, you can call `async` method
[`client.folders.getSharedLink(forFolder:)`][get-shared-link-async].

```swift
do {
    let sharedLink = try await client.folders.getSharedLink(forFolder: "11111")
    print("Folder shared link URL is \(sharedLink.url), with \(sharedLink.access) access")
}
catch {
    print("Error retrieving folder shared link")
}
```

[get-shared-link]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC13getSharedLink9forFolder10completionySS_ys6ResultOyAA0fG0CAA0A8SDKErrorCGctF

[get-shared-link-async]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC13getSharedLink9forFolder10completionySS_ys6ResultOyAA0fG0CAA0A8SDKErrorCGctF

Set Shared Link
---------------

To add or update the shared link for a folder, call
[`client.folders.setSharedLink(forFolder:access:unsharedAt:vanityName:password:canDownload:completion:)`][set-shared-link]
with the ID of the folder and the shared link properties to set.

<!-- sample put_folders_id add_shared_link -->
```swift
client.folders.setSharedLink(forFolder: "11111", access: .open) { (result: Result<SharedLink, BoxSDKError>) in
    guard case let .success(sharedLink) = result else {
        print("Error setting folder shared link")
        return
    }

    print("Folder shared link URL is \(sharedLink.url), with \(sharedLink.access) access")
}
```

As an alternative, you can call `async` method
[`client.folders.setSharedLink(forFolder:access:unsharedAt:vanityName:password:canDownload:)`][set-shared-link-async].

```swift
do {
    let sharedLink = try await client.folders.setSharedLink(forFolder: "163571796480", access: .open)
    print("Folder shared link URL is \(sharedLink.url), with \(sharedLink.access) access")
}
catch {
    print("Error setting folder shared link")
}
```

[set-shared-link]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC13setSharedLink9forFolder6access10unsharedAt10vanityName8password11canDownload10completionySS_AA0fG6AccessOSgAA17NullableParameterOy10Foundation4DateVGSgAPySSGSgAWSbSgys6ResultOyAA0fG0CAA0A8SDKErrorCGctF

[set-shared-link-async]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC13setSharedLink9forFolder6access10unsharedAt10vanityName8password11canDownloadAA0fG0CSS_AA0fG6AccessOSgAA17NullableParameterOy10Foundation4DateVGSgAQySSGSgAXSbSgtYaKF

Remove Shared Link
------------------

To remove a file's shared link, call
[`client.folders.deleteSharedLink(forFolder:completion:)`][delete-shared-link]
with the ID of the folder.

<!-- sample put_folders_id remove_shared_link -->
```swift
client.folders.deleteSharedLink(forFolder: "11111") { (result: Result<Void, BoxSDKError>) in
    guard case .success = result else {
        print("Error removing folder shared link")
        return
    }

    print("Folder shared link removed")
}
```

As an alternative, you can call `async` method
[`client.folders.deleteSharedLink(forFolder:)`][delete-shared-link-async].

```swift
do {
    try await client.folders.deleteSharedLink(forFolder: "11111")
    print("Folder shared link removed")
} catch {
    print("Error removing folder shared link")
}
```

[delete-shared-link]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC16deleteSharedLink9forFolder10completionySS_ys6ResultOyytAA0A8SDKErrorCGctF

[delete-shared-link-async]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC16deleteSharedLink9forFolderySS_tYaKF

Get Folder Locks
-------------------------

To retrieve a list of the locks on a folder, call
[`client.folders.listLocks(folderId:completion:)`][get-folder-locks]
with the ID of the folder. Folder locks define access restrictions placed by folder owners to prevent specific folders from being moved or deleted.

<!-- sample get_folder_locks -->
```swift
client.folders.listLocks(folderId: "22222") { results in
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(folderLock):
                    print("- \(folderLock.id)")
                case let .failure(error):
                    print(error)
                }
            }
        }
    case let .failure(error):
        print(error)
    }
}
```

As an alternative, you can retrieve all folder locks by iterator in `async` way.

```swift
let iterator = client.folders.listLocks(folderId: "22222")
do {
    repeat {
        let page = try await iterator.next()
        for folderLock in page.entries {
            print("- \(folderLock.id)")
        }
    } while true
}
catch let error as BoxSDKError where error.message == .endOfList {
    print("The are no more items to fetch")
}
catch {
    print("An error occurred: \(error)")
}
```
Create Folder Lock
-------------

To lock a folder, call
[`client.folders.createLock(folderId:completion:)`][create-folder-lock]
with the ID of the folder. This prevents the folder from being moved and/or deleted.

<!-- sample post_folder_locks -->
```swift
client.folders.createLock(folderId: "22222") { (result: Result<FolderLock, BoxSDKError>) in
    guard case let .success(folderLock) = result else {
        print("Error creating folder lock")
        return
    }

    print("Created folder lock with id \"\(folderLock.id)\" inside of folder with id \"\(folderLock.folder?.id)\"")
}
```

As an alternative, you can call `async` method
[`client.folders.createLock(folderId: "22222")`][create-folder-lock-async].

```swift
do {
    let folderLock = try await client.folders.createLock(folderId: "163571796480")
    print("Created folder lock with id \"\(folderLock.id)\" inside of folder with id \"\(folderLock.folder?.id)\"")
}
catch {
    print("Error creating folder lock")
}
```

[create-folder-lock]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC10createLock8folderId10completionySS_ys6ResultOyAA06FolderF0CAA0A8SDKErrorCGctF

[create-folder-lock-async]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC10createLock8folderIdAA06FolderF0CSS_tYaKF


Delete Folder Lock
------------------

To remove a folder lock, call
[`client.folders.deleteLock(folderLockId:completion:)`][delete-folder-lock]
with the ID of the folder lock.

<!-- sample delete_folder_lock -->
```swift
client.folders.deleteLock(folderLockId: "11111") { (result: Result<Void, BoxSDKError>) in
    guard case .success = result else {
        print("Error removing folder lock")
        return
    }

    print("Folder lock removed")
}
```
As an alternative, you can call `async` method
[`client.folders.deleteLock(folderId: "22222")`][delete-folder-lock-async].

```swift
do {
    try await client.folders.deleteSharedLink(forFolder: "11111")
    print("Folder shared link removed")
} catch {
    print("Error removing folder shared link")
}
```

[delete-folder-lock]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC10deleteLock06folderF2Id10completionySS_ys6ResultOyytAA0A8SDKErrorCGctF

[delete-folder-lock-async]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC10deleteLock06folderF2IdySS_tYaKF
