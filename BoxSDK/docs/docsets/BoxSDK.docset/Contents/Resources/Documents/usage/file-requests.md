File Requests
=============

File request objects represent a file request associated with a folder.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Get a File Request's Information](#get-a-file-requests-information)
- [Copy a File Request's Information](#copy-a-file-requests-information)
- [Update a File Request's Information](#update-a-file-requests-information)
- [Delete a File Request](#delete-a-file-request)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Get a File Request's Information
------------------------

To retrieve information about a file request, call
[`client.fileRequests.get(fileRequestId::completion:)`][get-file-request]
with the ID of the file request.

<!-- sample get_file_requests_id -->
```swift
client.fileRequests.get(fileRequestId: "123456") { result in
    guard case let .success(fileRequest) = result else {
        print("Error getting file request")
        return
    }
    
    print("File request title: \(fileRequest.title ?? "n/a"), description: \(fileRequest.description ?? "n/a")")
}
```

[get-file-request]: https://opensource.box.com/box-ios-sdk/Classes/FileRequestsModule.html#/s:6BoxSDK18FileRequestsModuleC3get13fileRequestId10completionySS_ys6ResultOyAA0cH0CAA0A8SDKErrorCGctF

Copy a File Request's Information
---------------------------

To copy an existing file request that is already present on one folder, and applies it to another folder, call
[`client.fileRequests.copy(fileRequestId:copyRequest:completion:)`][copy-file-request].
You must provide the ID of file request you want to copy, and an instance of the [`FileRequestCopyRequest`][file-request-copy-request] class,
where you can set fields to replace fields from source file request.

<!-- sample post_file_requests_id_copy -->
```swift
let destinationFolder = FolderEntity(id: "33333")

let copyRequest = FileRequestCopyRequest(
    title: "New file request title",
    description: "New file request description",
    isEmailRequired: true,
    isDescriptionRequired: false,
    folder: destinationFolder
)

client.fileRequests.copy(fileRequestId: "123456", copyRequest: copyRequest) { result in
    guard case let .success(fileRequest) = result else {
        print("Error copying file request")
        return
    }
    
    print("Copied file request title: \(fileRequest.title ?? "n/a"), description: \(fileRequest.description ?? "n/a")")
}
```

[copy-file-request]: https://opensource.box.com/box-ios-sdk/Classes/FileRequestsModule.html#/s:6BoxSDK18FileRequestsModuleC4copy13fileRequestId0fH010completionySS_AA0ch4CopyH0Vys6ResultOyAA0cH0CAA0A8SDKErrorCGctF

[file-request-copy-request]: https://opensource.box.com/box-ios-sdk/Structs/FileRequestCopyRequest.html#/s:6BoxSDK015FileRequestCopyD0V5titleSSSgvp

Update a File Request's Information
---------------------------

To update a file request, call
[`client.fileRequests.update(fileRequestId:ifMatch:updateRequest:completion:)`][update-file-request]
with the ID of the file request and with an instance of the [`FileRequestUpdateRequest`][file-request-update-request] class,
where you can set fields you want to update. If you want to make sure that an item hasn't changed recently before making changes, you can pass the last observed `etag` value to the `ifMatch` parameter.

This call can be used to activate or deactivate a file request.

<!-- sample put_file_requests_id -->
```swift
let updateRequest = FileRequestUpdateRequest(
    title: "Updated file request title",
    description: "Updated file request description",
    status: .inactive,
    isEmailRequired: false,
    isDescriptionRequired: true
)

client.fileRequests.update(fileRequestId: "123456", updateRequest: updateRequest) { result in
    guard case let .success(fileRequest) = result else {
        print("Error updating file request")
        return
    }
    
    print("Updated file request title: \(fileRequest.title ?? "n/a"), description: \(fileRequest.description ?? "n/a")")
}
```

[update-file-request]: https://opensource.box.com/box-ios-sdk/Classes/FileRequestsModule.html#/s:6BoxSDK18FileRequestsModuleC6update13fileRequestId7ifMatch0fH010completionySS_SSSgAA0ch6UpdateH0Vys6ResultOyAA0cH0CAA0A8SDKErrorCGctF

[file-request-update-request]: https://opensource.box.com/box-ios-sdk/Structs/FileRequestUpdateRequest.html

Delete a File Request
-------------

To delete a file request permanently, call
[`client.fileRequests.delete(fileRequestId:completion:)`][delete-file-request]
with the ID of the file request to delete.

<!-- sample delete_file_requests_id -->
```swift
client.fileRequests.delete(fileRequestId: "123456") { result in
    guard case .success = result else {
        print("Error removing file request")
        return
    }

    print("File request removed")
}
```

[delete-file-request]: https://opensource.box.com/box-ios-sdk/Classes/FileRequestsModule.html#/s:6BoxSDK18FileRequestsModuleC6delete13fileRequestId10completionySS_ys6ResultOyytAA0A8SDKErrorCGctF