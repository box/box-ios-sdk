Files
=====

File objects represent individual files in Box. They can be used to download a
file's contents, upload new versions, and perform other common file operations
(move, copy, delete, etc.).

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Get File Info](#get-file-info)
- [Update File](#update-file)
- [Upload File](#upload-file)
- [Upload New File Version](#upload-new-file-version)
- [Download File](#download-file)
- [Copy File](#copy-file)
- [Lock File](#lock-file)
- [Unlock File](#unlock-file)
- [Get File Thumbnail Image](#get-file-thumbnail-image)
- [Get File Embed Link](#get-file-embed-link)
- [Get File Collaborations](#get-file-collaborations)
- [Get File Comments](#get-file-comments)
- [Get File Tasks](#get-file-tasks)
- [Add File to Favorites](#add-file-to-favorites)
- [Remove File from Favorites](#remove-file-from-favorites)
- [Get Shared Link](#get-shared-link)
- [Set Shared Link](#set-shared-link)
- [Remove Shared Link](#remove-shared-link)
- [Get Representations](#get-representations)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Get File Info
-------------

To retrieve information about a file, call
[`client.files.get(fileId:fields:completion:)`][get-file]
with the ID of the file.  You can control which fields are returned on the resulting `File` object by passing the
desired field names in the optional `fields` parameter.

<!-- sample get_files_id -->
```swift
client.files.get(fileId: "11111", fields: ["name", "created_at"]) { (result: Result<File, BoxSDKError>) in
    guard case let .success(file) = result else {
        print("Error retrieving file information")
        return
    }

    print("File \(file.name) was created at \(file.createdAt)")
}
```

[get-file]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC3get6fileId6fields10completionySS_SaySSGSgys6ResultOyAA4FileCAA0A8SDKErrorCGctF

Update File
-----------

To update a file record, call
[`client.files.updateFileInfo(fileId:name:description:parentId:sharedLink:tags:collections:lock:ifMatch:fields:completion:)`][update-file]
with the ID of the file to update and the properties to update.

<!-- sample put_files_id -->
```swift
client.files.update(fileId: "11111", name: "New file name.docx") { (result: Result<File, BoxSDKError>) in
    guard case let .success(file) = result else {
        print("Error updating file information")
        return
    }

    print("File \(file.name) was updated at \(file.modifiedAt)")
}
```

[update-file]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC6update6fileId4name11description06parentG010sharedLink4tags11collections4lock7ifMatch6fields10completionySS_SSSgA2pA17NullableParameterOyAA06SharedL4DataVGSgSaySSGSgAxRyAA04LockW0VGSgApXys6ResultOyAA4FileCAA0A8SDKErrorCGctF

Upload File
-----------

To upload a file from data in memory, call
[`client.files.upload(data:name:parentId:progress:completion:)`][upload-file]
with the data to be uploaded, the name of the file, and the ID of the folder into which the file should be uploaded.
Use ID `"0"` to upload a file into the root folder, "All Files".

<!-- sample post_files_content -->
```swift
let data = "test content".data(using: .utf8)

client.files.upload(data: data, name: "Test File.txt", parentId: "0") { (result: Result<File, BoxSDKError>) in
    guard case let .success(file) = result else {
        print("Error uploading file")
        return
    }

    print("File \(file.name) was uploaded at \(file.createdAt) into \"\(file.parent.name)\"")
}
```

To upload a file from a stream, use
[`client.files.streamUpload(stream:fileSize:name:parentId:progress:completion:)`][upload-file-stream].

```swift
let data = "test content".data(using: .utf8)
let stream = InputStream(data: data)

client.files.streamUpload(
    stream: stream,
    fileSize: 12,
    name: "Test File.txt",
    parentId: "0"
) { (result: Result<File, BoxSDKError>) in
    guard case let .success(file) = result else {
        print("Error uploading file")
        return
    }

    print("File \(file.name) was uploaded at \(file.createdAt) into \"\(file.parent.name)\"")
}
```

[upload-file]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC6upload4data4name8parentId8progress21performPreflightCheck10completiony10Foundation4DataV_S2SySo10NSProgressCcSbys6ResultOyAA4FileCAA0A8SDKErrorCGctF
[upload-file-stream]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC12streamUpload0E08fileSize4name8parentId8progress21performPreflightCheck10completionySo13NSInputStreamC_SiS2SySo10NSProgressCcSbys6ResultOyAA4FileCAA0A8SDKErrorCGctF

Upload New File Version
-----------------------

To upload a new version of an existing file, call
[`client.files.uploadVersion(forFile:name:contentModifiedAt:data:progress:completion:)`][upload-file-version]
with the ID of the file and the file contents to be uploaded.

<!-- sample post_files_id_content -->
```swift
let data = "updated file content".data(using: .utf8)
client.files.uploadVersion(
    forFile: "11111",
    name: "New file name.txt",
    contentModifiedAt: "2019-08-07T09:19:13-07:00",
    data: data
) { (result: Result<File, BoxSDKError>) in
    guard case let .success(file) = result else {
        print("Error uploading file version")
        return
    }

    print("New version of \(file.name) was uploaded")
}
```

[upload-file-version]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC13uploadVersion7forFile4name17contentModifiedAt4data8progress21performPreflightCheck10completionySS_SSSgAL10Foundation4DataVySo10NSProgressCcSbys6ResultOyAA0H0CAA0A8SDKErrorCGctF

Download File
-------------

To download a file to the device, call
[`client.files.download(fileId:version:destinationURL:progress:completion:)`][download-file]
with the ID of the file to download and a URL to the location where the file should be downloaded to.

<!-- sample get_files_id_content -->
```swift
let url = FileManager.default.homeDirectoryForCurrentUser

client.files.download(fileId: "11111", destinationURL: url) { (result: Result<Void, BoxSDKError>) in
    guard case .success = result else {
        print("Error downloading file")
        return
    }

    print("File downloaded successfully")
}
```

[download-file]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC8download6fileId14destinationURL7version8progress10completionySS_10Foundation0I0VSSSgySo10NSProgressCcys6ResultOyytAA0A8SDKErrorCGctF


Copy File
---------

To make a copy of a file, call
[`client.files.copy(fileId:parentId:name:version:fields:completion:)`][copy-file]
with the ID of the file to copy and the ID of the folder into which the copy should be placed.  In case an item with the
same name already exists in the destination folder, the `name` parameter can be used to provide a new name for the
copied file.  You can copy a specific file version by passing the version ID in the `version` parameter.

<!-- sample post_files_id_copy -->
```swift
client.files.copy(fileId: "11111", parentId: "0") { (result: Result<File, BoxSDKError>) in
    guard case let .success(copiedFile) = result else {
        print("Error copying file")
        return
    }

    print("Copied file \(copiedFile.name) into folder \(copiedFile.parent.name); copy has file ID \(copiedFile.id)")
}
```

[copy-file]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC4copy6fileId06parentG04name7version6fields10completionySS_S2SSgAKSaySSGSgys6ResultOyAA4FileCAA0A8SDKErrorCGctF

Lock File
---------

To lock a file and prevent others from modifying it, call
[`client.files.lock(fileId:expiresAt:isDownloadPrevented:fields:completion:)`][lock-file]
with the ID of the file.  To also prevent others from downloading the file while it is locked, set the
`isDownloadPrevented` parameter to `true`.

<!-- sample put_files_id lock -->
```swift
client.files.lock(fileId: "11111") { (result: Result<File, BoxSDKError>) in
    guard case let .success(file) = result else {
        print("Error locking file")
        return
    }

    print("File \(file.name) locked")
}
```

[lock-file]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC4lock6fileId9expiresAt19isDownloadPrevented6fields10completionySS_10Foundation4DateVSgSbSgSaySSGSgys6ResultOyAA4FileCAA0A8SDKErrorCGctF

Unlock File
-----------

To unlock a file, call [`client.files.unlock(fileId:fields:completion:)][unlock-file] with the ID of the file.

<!-- sample put_files_id unlock -->
```swift
client.files.unlock(fileId: "11111") { (result: Result<File, BoxSDKError>) in
    guard case let .success(file) = result else {
        print("Error unlocking file")
        return
    }

    print("File \(file.name) unlocked")
}
```

[unlock-file]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC6unlock6fileId6fields10completionySS_SaySSGSgys6ResultOyAA4FileCAA0A8SDKErrorCGctF

Get File Thumbnail Image
------------------------

To retrieve the thumbnail image for a file, call
[`client.files.getThumbnail(forFile:extension:minHeight:minWidth:maxHeight:maxWidth:completion:)`][get-thumbnail]
with the ID of the file and the desired image format extension.  Optionally, constraints on the image
dimensions can be specified in the `minHeight`, `minWidth`, `maxHeight`, and `maxWidth` parameters.

<!-- sample get_files_id_thumbnail_id -->
```swift
client.files.getThumbnail(forFile: "11111", extension: .png) { (result: Result<Data, BoxSDKError>) in
    guard case let .success(thumbnailData) = result else {
        print("Error getting file thumbnail")
        return
    }

    let thumbnailImage = UIImage(data: thumbnailData)
}
```

[get-thumbnail]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC12getThumbnail7forFile9extension9minHeight0J5Width03maxK00mL010completionySS_AA0F9ExtensionOSiSgA3Nys6ResultOy10Foundation4DataVAA0A8SDKErrorCGctF

Get File Embed Link
-------------------

To retrieve a URL that can be embedded in a web page `<iframe>` to display a file preview, call
[`client.files.getEmbedLink(forFile:completion:)`][get-embed-link]
with the ID of the file.

<!-- sample get_files_id embed_link -->
```swift
client.files.getEmbedLink(forFile: "11111") { (result: Result<ExpiringEmbedLink, BoxSDKError>) in
    guard case let .success(embedLink) = result else {
        print("Error generating file embed link")
        return
    }

    print("File embed URL is \(embedLink.url)")
}
```

[get-embed-link]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC12getEmbedLink7forFile10completionySS_ys6ResultOyAA08ExpiringfG0CAA0A8SDKErrorCGctF

Get File Collaborations
-----------------------

To retrieve a list of collaborations on a file, call
[`client.files.listCollaborations(forFile:marker:limit:fields:)`][get-collaborations]
with the ID of the file.  This method returns an iterator in the completion, which is used to retrieve file collaborations.

<!-- sample get_files_id_collaborations -->
```swift
client.files.listCollaborations(forFile: "11111") { result in
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(collaboration):
                    print("Collaboration created by \(collaboration.createdBy?.name)")
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

[get-collaborations]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC18listCollaborations7forFile6marker5limit6fields10completionySS_SSSgSiSgSaySSGSgys6ResultOyAA14PagingIteratorCyAA13CollaborationCGAA0A8SDKErrorCGctF

Get File Comments
-----------------

To retrieve a list of comments on the file, call
[`client.files.listComments(forFile:offset:limit:fields:)`][get-comments]
with the ID of the file.  This method returns an iterator in the completion, which is used to page through the collection
of file comments.

<!-- sample get_files_id_comments -->
```swift
client.files.listComments(forFile: "11111"){ results in
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(comment):
                    print(comment.message)
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

[get-comments]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC12listComments7forFile6offset5limit6fields10completionySS_SiSgAJSaySSGSgys6ResultOyAA14PagingIteratorCyAA7CommentCGAA0A8SDKErrorCGctF

Get File Tasks
--------------

To retrieve a list of file tasks, call [`client.files.listTasks(forFile:fields:)`][get-tasks] with the ID of the
file.  This method returns an iterator in the completion, which is used to retrieve file comments.

<!-- sample get_files_id_tasks -->
```swift
client.files.listTasks(forFile: "11111") { results in
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(item):
                    print("Task messsage: \(task.message)")
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

[get-tasks]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC9listTasks7forFile6fields10completionySS_SaySSGSgys6ResultOyAA14PagingIteratorCyAA4TaskCGAA0A8SDKErrorCGctF

Add File to Favorites
---------------------

To add a file to the user's favorites collection, call
[`client.files.addToFavorites(fileId:completion:)`][add-to-favorites]
with the ID of the file.

<!-- sample put_files_id add_to_collection -->
```swift
client.files.addToFavorites(fileId: "11111") { (result: Result<Void, BoxSDKError>) in
    guard case .success = result else {
        print("Error adding file to favorites")
        return
    }

    print("File added to favorites")
}
```

[add-to-favorites]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC14addToFavorites6fileId10completionySS_ys6ResultOyAA4FileCAA0A8SDKErrorCGctF

Remove File from Favorites
--------------------------

To remove a file from the user's favorites collection, call
[`client.files.removeFromFavorites(fileId:completion:)`][remove-from-favorites]
with the ID of the file.

<!-- sample put_files_id remove_from_collection -->
```swift
client.files.removeFromFavorites(fileId: "11111") { (result: Result<Void, BoxSDKError>) in
    guard case .success = result else {
        print("Error removing file from favorites")
        return
    }

    print("File removed from favorites")
}
```

[remove-from-favorites]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC19removeFromFavorites6fileId10completionySS_ys6ResultOyAA4FileCAA0A8SDKErrorCGctF

Get Shared Link
---------------

To retrieve the shared link associated with a file, call
[`client.files.getSharedLink(forFile:completion:)`][get-shared-link]
with the ID of the file.

<!-- sample get_files_id get_shared_link -->
```swift
client.files.getSharedLink(forFile: "11111") { (result: Result<SharedLink, BoxSDKError>) in
    guard case let .success(sharedLink) = result else {
        print("Error retrieving file shared link")
        return
    }

    print("File shared link URL is \(sharedLink.url), with \(sharedLink.access) access")
}
```

[get-shared-link]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC13getSharedLink7forFile10completionySS_ys6ResultOyAA0fG0CAA0A8SDKErrorCGctF

Set Shared Link
---------------

To add or update the shared link for a file, call
[`client.files.setSharedLink(forFile:unsharedAt:access:password:canDownload:completion:)][set-shared-link]
with the ID of the file and the shared link properties to set.

<!-- sample put_files_id create_shared_link -->
```swift
client.files.setSharedLink(forFile: "11111", access: .open) { (result: Result<SharedLink, BoxSDKError>) in
    guard case let .success(sharedLink) = result else {
        print("Error setting file shared link")
        return
    }

    print("File shared link URL is \(sharedLink.url), with \(sharedLink.access) access")
}
```

[set-shared-link]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC13setSharedLink7forFile10unsharedAt6access8password11canDownload10completionySS_AA17NullableParameterOy10Foundation4DateVGSgAA0fG6AccessOSgALySSGSgSbSgys6ResultOyAA0fG0CAA0A8SDKErrorCGctF

Remove Shared Link
------------------

To remove a file's shared link, call
[`client.files.deleteSharedLink(forFile:completion:)`][delete-shared-link]
with the ID of the file.

<!-- sample put_files_id remove_shared_link -->
```swift
client.files.deleteSharedLink(fileId: "11111") { (result: Result<Void, BoxSDKError>) in
    guard case .success = result else {
        print("Error removing file shared link")
        return
    }

    print("File shared link removed")
}
```

[delete-shared-link]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC16deleteSharedLink7forFile10completionySS_ys6ResultOyytAA0A8SDKErrorCGctF

List Representations
-------------------

To retrieve information about available preview representations for a file, call
[`client.files.listRepresentations(fileId:representationHint:completion:)`][get-representations]
with the ID of the file.  Omitting the `representationHint` parameter will provide summary information about
all available representations; in order to retrieve the representation status and URL, the `representationHint` parameter
must be passed to select the desired representation.

<!-- sample put_files_id get_representations -->
```swift
// Get full information about PDF representation
client.files.listRepresentations(
    fileId: "11111",
    representationHint: "[pdf]"
) { (result: Result<[FileRepresentation], BoxSDKError>) in
    guard case let .success(representations) = result else {
        print("Error fetching representations")
        return
    }

    print("PDF representation generation status: \(representations[0]?.status?.state)")
}
```

[get-representations]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC19listRepresentations6fileId18representationHint10completionySS_AA018FileRepresentationJ0OSgys6ResultOySayAA0lM0VGAA0A8SDKErrorCGctF