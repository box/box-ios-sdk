Web Links
======

Web links are objects that point to URLs. These objects are also known as
bookmarks within the Box web application. Web link objects are treated
similarly to file objects.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Create Web Link](#create-web-link)
- [Get Web Link](#get-web-link)
- [Update Web Link](#update-web-link)
- [Delete Web Link](#delete-web-link)
- [Set Shared Link](#set-shared-link)
- [Remove Shared Link](#remove-shared-link)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Create Web Link
---------------

To create a web link with a specified name and description, call
[`client.webLinks.create(url:parentId:name:description:fields:completion:)`][create-web-link].

<!-- sample post_web_links -->
```swift
client.webLinks.create(
    url: "https://www.example.com",
    parentId: "22222",
    name: "Link to Example",
    description: "This goes to an example page"
) { (result: Result<WebLink, BoxSDKError>) in
    guard case let .success(webLink) = result else {
        print("Error creating web link")
        return
    }

    print("WebLink \(webLink.name) was created at \(webLink.createdAt)")
}
```

[create-web-link]: https://opensource.box.com/box-ios-sdk/Classes/WebLinksModule.html#/s:6BoxSDK14WebLinksModuleC6create3url8parentId4name11description6fields10completionySS_S2SSgAKSaySSGSgys6ResultOyAA0C4LinkCAA0A8SDKErrorCGctF

Get Web Link
------------

To retrieve information about a web link, call
[`client.webLinks.get(webLinkId:fields:completion:)`][get-web-link]
with the ID of web link.  You can control which fields are returned in the resulting `WebLink` object by passing the
`fields` parameter.

<!-- sample get_web_links_id -->
```swift
client.webLinks.get(webLinkId: "11111", fields: ["name", "created_at"]) { (result: Result<WebLink, BoxSDKError>) in
    guard case let .success(webLink) = result else {
        print("Error retrieving web link information")
        return
    }

    print("WebLink \(webLink.name) was created at \(webLink.createdAt)")
}
```

[get-web-link]: https://opensource.box.com/box-ios-sdk/Classes/WebLinksModule.html#/s:6BoxSDK14WebLinksModuleC3get9webLinkId6fields10completionySS_SaySSGSgys6ResultOyAA0cH0CAA0A8SDKErrorCGctF

Update Web Link
---------------

To update a web link record, call
[`client.webLinks.update(webLinkId:url:parentId:name:description:sharedLink:fields:completion:)`][update-web-link]
with the ID of the web link to update and the properties to update.

<!-- sample put_web_links_id -->
```swift
client.webLinks.update(webLinkId: "11111", name: "new name for weblink") { (result: Result<WebLink, BoxSDKError>) in
    guard case let .success(webLink) = result else {
        print("Error updating web link information")
        return
    }

    print("WebLink \(webLink.name) was updated successfully")
}
```

[update-web-link]: https://opensource.box.com/box-ios-sdk/Classes/WebLinksModule.html#/s:6BoxSDK14WebLinksModuleC6update9webLinkId3url06parentI04name11description06sharedH06fields10completionySS_SSSgA3mA17NullableParameterOyAA06SharedH4DataVGSgSaySSGSgys6ResultOyAA0cH0CAA0A8SDKErrorCGctF

Delete Web Link
---------------

To delete a web link, call
[`client.webLinks.delete(webLinkId:completion:)`][delete-web-link]
with the ID of the web link to delete. 

<!-- sample delete_web_links_id -->
```swift
client.webLinks.delete(webLinkId: "11111") { (result: Result<Void, BoxSDKError>) in
    guard case .success = result else {
        print("Error removing web link")
        return
    }

    print("WebLink removed")
}
```

[delete-web-link]: https://opensource.box.com/box-ios-sdk/Classes/WebLinksModule.html#/s:6BoxSDK14WebLinksModuleC6delete9webLinkId10completionySS_ys6ResultOyytAA0A8SDKErrorCGctF

Set Shared Link
---------------

To add or update the shared link for a web link, call [`client.webLinks.setSharedLink(forWebLink:access:unsharedAt:vanityName:password:completion:)`][set-shared-link]
with the ID of the web link and the shared link properties to set.

<!-- sample put_web_links_id add_shared_link -->
```swift
client.webLinks.setSharedLink(forWebLink: "11111", access: .open) { (result: Result<SharedLink, BoxSDKError>) in
    guard case let .success(sharedLink) = result else {
        print("Error setting weblink shared link")
        return
    }

    print("WebLink shared link URL is \(sharedLink.url), with \(sharedLink.access) access")
}
```

[set-shared-link]: https://opensource.box.com/box-ios-sdk/Classes/WebLinksModule.html#/s:6BoxSDK14WebLinksModuleC13setSharedLink03forcH06access10unsharedAt10vanityName8password10completionySS_AA0gH6AccessOSgAA17NullableParameterOy10Foundation4DateVGSgAOySSGSgAVys6ResultOyAA0gH0CAA0A8SDKErrorCGctF

Remove Shared Link
------------------

To remove a webLink's shared link, call
[`client.webLinks.deleteSharedLink(forWebLink:completion:)`][delete-shared-link]
with the ID of the file.

<!-- sample put_web_links_id remove_shared_link -->
```swift
client.webLinks.deleteSharedLink(forWebLink: "11111") { (result: Result<Void, BoxSDKError>) in
    guard case .success = result else {
        print("Error removing weblink shared link")
        return
    }

    print("WebLink shared link removed")
}
```

[delete-shared-link]: https://opensource.box.com/box-ios-sdk/Classes/WebLinksModule.html#/s:6BoxSDK14WebLinksModuleC16deleteSharedLink03forcH010completionySS_ys6ResultOyytAA0A8SDKErrorCGctF
