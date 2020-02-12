Folders
=======

Folder objects represent a folder from a user's account. They can be used to iterate through a folder's contents,
collaborate a folder with another user or group, and perform other common folder operations (move, copy, delete, etc.).

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


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

[get-folder]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC3get8folderId6fields10completionySS_SaySSGSgys6ResultOyAA6FolderCAA0A8SDKErrorCGctF

Get Folder Items
----------------

To retrieve information about the items contained in a folder, call
[`client.folders.listItems(folderId:usemarker:marker:offset:limit:sort:direction:fields:)`][get-folder-items]
with the ID of the folder.  This method will return an iterator in the completion, which is used to retrieve folder items.

<!-- sample get_folders_id_items -->
```swift
let folderItems = client.folders.listItems(folderId: "22222", sort: .name, direction: .ascending) { results in
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(item):
                    switch item {
                    case let .file(file):
                        print("File \(file.name) (ID: \(file.id)) is in the folder")
                    case let .folder(folder):
                        print("Subfolder \(folder.name) (ID: \(folder.id)) is in the folder")
                    case let .webLink(webLink):
                        print("Web link \(webLink.name) (ID: \(webLink.id)) is in the folder")
                    }
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

    print("Created folder \"\(folder.name)\" inside of folder \"\(folder.parent.name)\"")
}
```

[create-folder]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC6create4name8parentId6fields10completionySS_SSSaySSGSgys6ResultOyAA6FolderCAA0A8SDKErrorCGctF


Delete Folder
-------------

To delete a folder, call
[`client.folders.delet(folderId:recursive:completion:)`][delete-folder]
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

[delete-folder]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC6delete8folderId9recursive10completionySS_SbSgys6ResultOyytAA0A8SDKErrorCGctF

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

[copy-folder]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC4copy8folderId19destinationFolderID4name6fields10completionySS_S2SSgSaySSGSgys6ResultOyAA0I0CAA0A8SDKErrorCGctF

Get Folder Collaborations
-------------------------

To retrieve a list of the collaborations on a folder, call
[`client.folders.listCollaborations(folderId:fields:)`][get-collaborations]
with the ID of the folder.

<!-- sample get_folders_id_collaborations -->
```swift
client.folders.listCollaborations(folderId: "22222") { results in
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(collaboration):
                    print("- \(collaboration.accessibleBy?.name)")
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

[get-collaborations]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC18listCollaborations8folderId6fields10completionySS_SaySSGSgys6ResultOyAA14PagingIteratorCyAA13CollaborationCGAA0A8SDKErrorCGctF

Add Folder to Favorites
-----------------------

To add a folder to the user's favorites, call
[`client.folders.addToFavorites(folderId:completion:)`][add-to-favorites]
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

[add-to-favorites]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC14addToFavorites8folderId10completionySS_ys6ResultOyAA6FolderCAA0A8SDKErrorCGctF

Remove Folder from Favorites
----------------------------

To remove a folder from the user's favorites, call
[`client.folders.removeFromFavorites(folderId:completion:)`][remove-from-favorites]
with the ID of the folder.

[remove-from-favorites]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC19removeFromFavorites8folderId10completionySS_ys6ResultOyAA6FolderCAA0A8SDKErrorCGctF

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

[get-shared-link]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC13getSharedLink9forFolder10completionySS_ys6ResultOyAA0fG0CAA0A8SDKErrorCGctF

Set Shared Link
---------------

To add or update the shared link for a folder, call
[`client.folders.setSharedLink(forFolder:access:unsharedAt:password:canDownload:completion:)`][set-shared-link]
with the ID of the folder and the shared link properties to set.

<!-- sample get_folders_id create_shared_link -->
```swift
client.folders.setSharedLink(forFolder: "11111", access: .open) { (result: Result<SharedLink, BoxSDKError>) in
    guard case let .success(sharedLink) = result else {
        print("Error setting folder shared link")
        return
    }

    print("Folder shared link URL is \(sharedLink.url), with \(sharedLink.access) access")
}
```

[set-shared-link]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC13setSharedLink9forFolder6access10unsharedAt8password11canDownload10completionySS_AA0fG6AccessOSgAA17NullableParameterOy10Foundation4DateVGSgAOySSGSgSbSgys6ResultOyAA0fG0CAA0A8SDKErrorCGctF

Remove Shared Link
------------------

To remove a file's shared link, call
[`client.folders.deleteSharedLink(forFolder:completion:)`][delete-shared-link]
with the ID of the folder.

<!-- sample get_folders_id delete_shared_link -->
```swift
client.folders.deleteSharedLink(forFolder: "11111") { (result: Result<Void, BoxSDKError>) in
    guard case .success = result else {
        print("Error removing folder shared link")
        return
    }

    print("Folder shared link removed")
}
```

[delete-shared-link]: https://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC16deleteSharedLink9forFolder10completionySS_ys6ResultOyytAA0A8SDKErrorCGctF