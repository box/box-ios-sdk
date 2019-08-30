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

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Get Folder Info
---------------

To retrieve information about a folder, call
[`client.folders.getFolderInfo(folderId: String, fields: [String]?, completion: @escaping Callback<Folder>)`][get-folder]
with the ID of the folder.  You can control which fields are returned in the resulting `Folder` object by passing the
`fields` parameter.

```swift
client.folders.getFolderInfo(folderId: "22222", fields: ["name", "created_at"]) { (result: Result<Folder, BoxError>) in
    guard case let .success(folder) = result else {
        print("Error getting folder information")
        return
    }

    print("Folder \(folder.name) was created at \(folder.createdAt)")
}
```

Get Folder Items
----------------

To retrieve information about the items contained in a folder, call
[`client.folders.getFolderItems(folderId: String, usemarker: Bool?, marker: String?, offset: Int?, limit: Int?, sort: OrderBy?, direction: OrderDirection?, fields: [String]?)`][get-folder-items]
with the ID of the folder.  This method will return an iterator object you can use to retrieve successive pages of
results, where each page contains some of the items in the folder.

```swift
let folderItems = client.folders.getFolderItems(folderId: "22222", sort: .name, direction: .ascending)

// Get the first page of items
folderItems.nextPage() { (result: Result<[FolderItem], BoxError>) in
    guard case let .success(items) = result else {
        print("Error getting folder items")
        return
    }

    // Print out first page of items in the folder
    for item in items {
        switch item.itemValue {
        case let .file(file):
            print("File \(file.name) (ID: \(file.id)) is in the folder")
        case let .folder(folder):
            print("Subfolder \(folder.name) (ID: \(folder.id)) is in the folder")
        case let .webLink(webLink):
            print("Web link \(webLink.name) (ID: \(webLink.id)) is in the folder")
        }
    }
}
```

Create Folder
-------------

To create a new folder, call
[`client.folders.createFolder(name: String, parentId: String, fields: [String]?, completion: @escaping Callback<Folder>`][create-folder]
with a name for the new folder and the ID of the folder to create the new folder in.  To create a new folder inside the
root folder ("All Files"), use ID `"0"`.

```swift
client.folders.createFolder(name: "New Folder", parentId: "22222") { (result: Result<Folder, BoxError>) in
    guard case let .success(folder) = result else {
        print("Error creating folder")
        return
    }

    print("Created folder \"\(folder.name)\" inside of folder \"\(folder.parent.name)\"")
}
```

<!-- TODO: Add Update Folder when interface is updated -->

Delete Folder
-------------

To delete a folder, call
[`client.folders.deleteFolder(folderId: String, recursive: Bool?, completion: @escaping Callback<Void>`][delete-folder]
with the ID of the folder to delete.  By default, the folder will only be deleted if it is empty and has no
items in it; if you wish to delete all the items in the folder as well, pass `recursive: true`.

```swift
client.folders.deleteFolder(folderId: "22222", recursive: true) { result: Result<Void, BoxError>} in
    guard case .success = result else {
        print("Error deleting folder")
        return
    }

    print("Folder and contents successfully deleted")
}
```
