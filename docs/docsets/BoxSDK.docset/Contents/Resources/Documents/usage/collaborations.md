Collaborations
==============

Collaborations are used to share folders and files between users or groups. They also define what permissions a user
has for a folder or file.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Get Collaboration](#get-collaboration)
- [Add Collaboration](#add-collaboration)
- [Update Collaboration](#update-collaboration)
- [Delete Collaboration](#delete-collaboration)
- [Get Pending Collaborations](#get-pending-collaborations)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Get Collaboration
-----------------

To retrieve a Collaboration record from the API, call
[`client.collaborations.get(collaborationId:fields:completion:)`][get-collaboration]
with the ID of the collaboration.

<!-- sample get_collaborations_id -->
```swift
client.collaborations.get(collaborationId: "12345") { (result: Result<Collaboration, BoxSDKError>) in
    guard case let .success(collaboration) = result else {
        print("Error retrieving collaboration")
        return
    }

    let collaborator: String
    switch collaboration.accessibleBy.collaboratorValue {
    case let .user(user):
        collaborator = "user \(user.name)"
    case let .group(group):
        collaborator = "group \(group.name)"
    }

    let itemName: String
    switch collaboration.item {
    case let .file(file):
        itemName = file.name
    case let .folder(folder):
        itemName = folder.name
    case let .webLink(webLink):
        itemName = webLink.name
    }

    print("Collaboration \(collaboration.id) gives \(collaborator) access to \(itemName)")
}
```

[get-collaboration]: https://opensource.box.com/box-ios-sdk/Classes/CollaborationsModule.html#/s:6BoxSDK20CollaborationsModuleC3get15collaborationId6fields10completionySS_SaySSGSgys6ResultOyAA13CollaborationCAA0A8SDKErrorCGctF

Add Collaboration
-----------------

To add a collaborator to an item, call
[`client.collaborations.create(itemType:itemId:role:accessibleBy:accessibleByType:canViewPath:fields:notify:completion:)`][create-collaboration]
with the type and ID of the item, as well as the type and ID of the collaborator — a user or a group.  A `role` for the
collaborator must be specified, which will determine the permissions the collaborator receives on the item.

<!-- sample post_collaborations -->
```swift
client.collaborations.create(
    itemType: "folder",
    itemId: "22222",
    role: .editor,
    accessibleBy: "33333",
    accessibleByType: "user"
) { (result: Result<Collaboration, BoxSDKError>) in
    guard case let .success(collaboration) = result else {
        print("Error creating collaboration")
        return
    }

    print("Collaboration successfully created")
}
```

[create-collaboration]: https://opensource.box.com/box-ios-sdk/Classes/CollaborationsModule.html#/s:6BoxSDK20CollaborationsModuleC6create8itemType0F2Id4role12accessibleBy0jkG011canViewPath6fields6notify10completionySS_SSAA17CollaborationRoleOSSAA010AccessibleK0OSbSgSaySSGSgARys6ResultOyAA0R0CAA0A8SDKErrorCGctF

Update Collaboration
--------------------

To update a collaboration record, call
[`client.users.update(collaborationId:role:status:canViewPath:fields:completion:)`][update-collaboration]
with the ID of the collaboration to update and the properties to update, including at least the `role`.

<!-- sample put_collaborations_id -->
```swift
client.collaborations.update(collaborationId: "12345", role: .viewer) { (result: Result<Collaboration, BoxSDKError>) in
    guard case let .success(collaboration) = result else {
        print("Error updating collaboration")
        return
    }

    print("Updated collaboration")
}
```

[update-collaboration]: https://opensource.box.com/box-ios-sdk/Classes/CollaborationsModule.html#/s:6BoxSDK20CollaborationsModuleC6update15collaborationId4role6status11canViewPath6fields10completionySS_AA17CollaborationRoleOAA0O6StatusOSgSbSgSaySSGSgys6ResultOyAA0O0CAA0A8SDKErrorCGctF

Delete Collaboration
--------------------

To delete a collaboration, removing the collaborator's access to the relevant item, call
[`client.collaborations.delete(collaborationId:completion:)`][delete-collaboration]
with the ID of the collaboration to delete.

<!-- sample delete_collaborations_id -->
```swift
client.collaborations.delete(collaborationId: "12345") { (result: Result<Void, BoxSDKError>) in
    guard case .success = result else {
        print("Error deleting collaboration")
        return
    }

    print("Collaboration deleted")
}
```

[delete-collaboration]: https://opensource.box.com/box-ios-sdk/Classes/CollaborationsModule.html#/s:6BoxSDK20CollaborationsModuleC6delete15collaborationId10completionySS_ys6ResultOyytAA0A8SDKErrorCGctF

Get Pending Collaborations
--------------------------

To retrieve a list of the pending collaborations requiring the user to accept or reject them, call
[`client.collaborations.listPendingForEnterprise(offset:limit:fields:)`][get-pending-collaborations].
The method returns an iterator in the completion, which is used to get pending collaborations.

<!-- sample get_collaborations -->
```swift
client.collaborations.listPendingForEnterprise() { results in
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

[get-pending-collaborations]: https://opensource.box.com/box-ios-sdk/Classes/CollaborationsModule.html#/s:6BoxSDK20CollaborationsModuleC24listPendingForEnterprise6offset5limit6fields10completionySiSg_AISaySSGSgys6ResultOyAA14PagingIteratorCyAA13CollaborationCGAA0A8SDKErrorCGctF