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

[get-folder]: http://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC13getFolderInfo8folderId6fields10completionySS_SaySSGSgys6ResultOyAA0F0CAA0A5ErrorOGctF

Get Folder Items
----------------

To retrieve information about the items contained in a folder, call
[`client.folders.listItems(folderId:usemarker:marker:offset:limit:sort:direction:fields:)`][get-folder-items]
with the ID of the folder.  This method will return an iterator in the completion, which is used to retrieve folder items.

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

[get-folder-items]: http://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC14getFolderItems8folderId9usemarker6marker6offset5limit4sort9direction6fieldsAA18PaginationIteratorCyAA0F4ItemCGSS_SbSgSSSgSiSgAtA7OrderByOSgAA0T9DirectionOSgSaySSGSgtF

Create Folder
-------------

To create a new folder, call
[`client.folders.create(name:parentId:fields:completion:)`][create-folder]
with a name for the new folder and the ID of the folder to create the new folder in.  To create a new folder inside the
root folder ("All Files"), use ID `"0"`.

```swift
client.folders.create(name: "New Folder", parentId: "22222") { (result: Result<Folder, BoxSDKError>) in
    guard case let .success(folder) = result else {
        print("Error creating folder")
        return
    }

    print("Created folder \"\(folder.name)\" inside of folder \"\(folder.parent.name)\"")
}
```

[create-folder]: http://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC12createFolder4name8parentId6fields10completionySS_SSSaySSGSgys6ResultOyAA0F0CAA0A5ErrorOGctF


Delete Folder
-------------

To delete a folder, call
[`client.folders.delet(folderId:recursive:completion:)`][delete-folder]
with the ID of the folder to delete.  By default, the folder will only be deleted if it is empty and has no
items in it; if you wish to delete all the items in the folder as well, pass `recursive: true`.

```swift
client.folders.delete(folderId: "22222", recursive: true) { result: Result<Void, BoxSDKError>} in
    guard case .success = result else {
        print("Error deleting folder")
        return
    }

    print("Folder and contents successfully deleted")
}
```

[delete-folder]: http://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC12deleteFolder8folderId9recursive10completionySS_SbSgys6ResultOyytAA0A5ErrorOGctF

Copy Folder
-----------

To copy a folder from one parent folder to another, call
[`client.folders.copy(folderId:destinationFolderID:name:fields:completion:)`][copy-folder]
with the ID of the folder to copy and the ID of the destination parent folder.  To avoid a name conflict in the new
parent folder, pass an alternate name for the folder in the `name` parameter; the folder will be renamed to the
alternate name in case of a conflict.

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

[copy-folder]: http://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC10copyFolder8folderId011destinationF2ID4name6fields10completionySS_S2SSgSaySSGSgys6ResultOyAA0F0CAA0A5ErrorOGctF

NOTE: Is this an iterator or not?
Get Folder Collaborations
-------------------------

To retrieve a list of the collaborations on a folder, call
[`client.folders.listCollaborations(folderId:fields:)`][get-collaborations]
with the ID of the folder.

```swift
client.folders.listCollaborations(folderId: "22222") { (result: Result<[Collaboration], BoxSDKError>) in
    guard case let .success(collaborations) = result else {
        print("Error retrieving collaborations")
        return
    }

    print("Folder has \(collaborations.count) collaborators:")
    for collaboration in collaborations {
        print("- \(collaboration.accessibleBy?.name)")
    }
}
```

[get-collaborations]: http://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC23getFolderCollaborations8folderId6fieldsAA18PaginationIteratorCyAA13CollaborationCGSS_SaySSGSgtF

Add Folder to Favorites
-----------------------

To add a folder to the user's favorites, call
[`client.folders.addToFavorites(folderId:completion:)`][add-to-favorites]
with the ID of the folder.

```swift
client.folders.addToFavorites(folderId: "22222") { (result: Result<Void, BoxSDKError>) in
    guard case .success = result else {
        print("Error adding folder to favorites")
        return
    }

    print("Added folder to favorites")
}
```

[add-to-favorites]: http://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC9addFolder8folderId12toCollection10completionySS_SSys6ResultOyytAA0A5ErrorOGctF

Remove Folder from Favorites
----------------------------

To remove a folder from the user's favorites, call
[`client.folders.removeFromFavorites(folderId:completion:)`][remove-from-favorites]
with the ID of the folder.

[remove-from-favorites]: http://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC25removeFolderFromFavorites8folderId10completionySS_ys6ResultOyytAA0A5ErrorOGctF

Get Shared Link
---------------

To retrieve the shared link associated with a folder, call
[`client.folders.getSharedLink(forFolder:completion:)`][get-shared-link]
with the ID of the folder.

```swift
client.folders.getSharedLink(forFolder: "11111") { (result: Result<SharedLink, BoxSDKError>) in
    guard case let .success(sharedLink) = result else {
        print("Error retrieving folder shared link")
        return
    }

    print("Folder shared link URL is \(sharedLink.url), with \(sharedLink.access) access")
}
```

[get-shared-link]: http://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC13getSharedLink9forFolder10completionySS_ys6ResultOyAA0fG0CAA0A5ErrorOGctF

Set Shared Link
---------------

To add or update the shared link for a folder, call
[`client.folders.setSharedLink(forFolder:access:unsharedAt:password:canDownload:completion:)`][set-shared-link]
with the ID of the folder and the shared link properties to set.

```swift
client.folders.setSharedLink(forFolder: "11111", access: .open) { (result: Result<SharedLink, BoxSDKError>) in
    guard case let .success(sharedLink) = result else {
        print("Error setting folder shared link")
        return
    }

    print("Folder shared link URL is \(sharedLink.url), with \(sharedLink.access) access")
}
```

[set-shared-link]: http://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC13setSharedLink9forFolder6access10unsharedAt8password11canDownload10completionySS_AA0fG6AccessOSg10Foundation4DateVSgAA17OptionalParameterOySSGSgSbSgys6ResultOyAA0fG0CAA0A5ErrorOGctF

Remove Shared Link
------------------

To remove a file's shared link, call
[`client.folders.deleteSharedLink(forFolder:completion:)`][delete-shared-link]
with the ID of the folder.

```swift
client.folders.deleteSharedLink(forFolder: "11111") { (result: Result<Void, BoxSDKError>) in
    guard case .success = result else {
        print("Error removing folder shared link")
        return
    }

    print("Folder shared link removed")
}
```

[delete-shared-link]: http://opensource.box.com/box-ios-sdk/Classes/FoldersModule.html#/s:6BoxSDK13FoldersModuleC16deleteSharedLink9forFolder10completionySS_ys6ResultOyytAA0A5ErrorOGctF
