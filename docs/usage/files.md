Files
=====

File objects represent individual files in Box. They can be used to download a
file's contents, upload new versions, and perform other common file operations
(move, copy, delete, etc.).

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Get File Info](#get-file-info)
- [Upload File](#upload-file)
- [Download File](#download-file)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Get File Info
-------------

To retrieve information about a file, call
[`client.files.getFileInfo(fileId: String, fields: [String]?, completion: @escaping Callback<File>)`][get-file]
with the ID of the file.  You can control which fields are returned on the resulting `File` object by passing the
desired field names in the optional `fields` parameter.

```swift
client.files.getFileInfo(fileId: "11111", fields: ["name", "created_at"]) { (result: Result<File, BoxError>) in
    guard case let .success(file) = result else {
        print("Error retrieving file information")
        return
    }

    print("File \(file.name) was created at \(file.createdAt)")
}
```

<!-- TODO: Document update file info once method is updated -->

Upload File
-----------

To upload a file from data in memory, call
[`client.files.uploadFile(data: Data, name: String, parentId: String, progress: @escaping ((Progress) -> Void)?, completion: @escaping Callback<File>)`][upload-file]
with the data to be uploaded, the name of the file, and the ID of the folder into which the file should be uploaded.
Use ID `"0"` to upload a file into the root folder, "All Files".

```swift
let data = "test content".data(using: .utf8)

client.files.uploadFile(data: data, name: "Test File.txt", parentId: "0") { (result: Result<File, BoxError>) in
    guard case let .success(file) = result else {
        print("Error uploading file")
        return
    }

    print("File \(file.name) was uploaded at \(file.createdAt) into \"\(file.parent.name)\"")
}
```

To upload a file from a stream, use
[`client.files.streamUploadFile(stream: InputStream, fileSize: Int, name: String, parentId: String, progress: @escaping ((Progress) -> Void)?, completion: @escaping Callback<File>)`][upload-file-stream].

```swift
let data = "test content".data(using: .utf8)
let stream = InputStream(data: data)

client.files.streamUploadFile(stream: stream, fileSize: 12, name: "Test File.txt", parentId: "0") { (result: Result<File, BoxError>) in
    guard case let .success(file) = result else {
        print("Error uploading file")
        return
    }

    print("File \(file.name) was uploaded at \(file.createdAt) into \"\(file.parent.name)\"")
}
```

<!-- Add upload file version when interface is fixed -->

Download File
-------------

To download a file to the device, call
[`client.files.downloadFile(fileId: String, version: String?, destinationURL: URL, progress: @escaping ((Progress) -> Void)?, completion: @escaping Callback<Void>)`][download-file]
with the ID of the file to download and a URL to the location where the file should be downloaded to.

```swift
let url = FileManager.default.homeDirectoryForCurrentUser

client.files.downloadFile(fileId: "11111", destinationURL: url) { (result: Result<Void, BoxError>) in
    guard case .success = result else {
        print("Error downloading file")
        return
    }

    print("File downloaded successfully")
}
```

<!-- TODO: Document delete file once it's implemented -->

Copy File
---------

To make a copy of a file, call
[`client.files.copyFile(fileId: String, parentId: String, name: String?, version: String?, fields: [String]?, completion: @escaping Callback<File>)`][copy-file]
with the ID of the file to copy and the ID of the folder into which the copy should be placed.  In case an item with the
same name already exists in the destination folder, the `name` parameter can be used to provide a new name for the
copied file.  You can copy a specific file version by passing the version ID in the `version` parameter.

```swift
client.files.copyFile(fileId: "11111", parentId: "0") { (result: Result<File, BoxError>) in
    guard case let .success(copiedFile) = result else {
        print("Error copying file")
        return
    }

    print("Copied file \(copiedFile.name) into folder \(copiedFile.parent.name); copy has file ID \(copiedFile.id)")
}
```
