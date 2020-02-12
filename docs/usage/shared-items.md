Shared Items
============

Shared Items represent files and folders on Box available via a shared link.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Get Shared Item](#get-shared-item)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Get Shared Item
---------------

To get the file or folder information for a shared link, call
[`client.sharedItems.getSharedItem(sharedLinkURL:sharedLinkPassword:fields:completion:)`][get-shared-item]
with the URL of the shared link. The `sharedLinkPassword` parameter should be provided if the shared link is
password-protected.

<!-- sample get_shared_items -->   
```swift
client.sharedItems.get(
    sharedLinkURL: "https://app.box.com/s/qqwertyuiopasdfghjklzxcvbnm123456"
) { (result: Result<SharedItem, BoxSDKError>) in
    guard case let .success(item) = result else {
        print("Error resolving shared item")
        return
    }

    print("The shared link resolves to item:")
    switch item {
    case let .file(file):
        print("- File \(file.name) (ID: \(file.id))")
    case let .folder(folder):
        print("- Folder \(file.name) (ID: \(file.id))")
    case let .webLink(webLink):
        print("- Web Link \(file.name) (ID: \(file.id))")
    }
}
```

[get-shared-item]: https://opensource.box.com/box-ios-sdk/Classes/SharedItemsModule.html#/s:6BoxSDK17SharedItemsModuleC3get13sharedLinkURL0gH8Password6fields10completionySS_SSSgSaySSGSgys6ResultOyAA0C4ItemCAA0A8SDKErrorCGctF