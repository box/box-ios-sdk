Comments
========

Comment objects represent a user-created comment on a file. They can be added directly to a file.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Get Comment](#get-comment)
- [Create Comment](#create-comment)
- [Update Comment](#update-comment)
- [Delete Comment](#delete-comment)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Get Comment
-----------

To retrieve information about a comment, call
[`client.comments.get(commentId:fields:completion:)`][get-comment]
with the ID of the comment.

```swift
client.comments.get(commentId: "55555") { (result: Result<Comment, BoxSDKError>) in
    guard case let .success(comment) = result else {
        print("Error retrieving comment")
        return
    }

    print("Comment reads: \"\(comment.message)\"")
}
```

[get-comment]: http://opensource.box.com/box-ios-sdk/Classes/CommentsModule.html#/s:6BoxSDK14CommentsModuleC14get9commentId6fields10completionySS_SaySSGSgys6ResultOyAA0F0CAA0A5ErrorOGctF

Create Comment
--------------

To create a comment, call
[`client.comments.create(itemId:itemType:message:fields:completion:)`][create-comment]
with the type and ID of the item to add a comment to, as well as the comment message.

```swift
client.comments.create(
    itemId: "11111",
    itemType: "file",
    message: "Thanks!"
) { (result: Result<Comment, BoxSDKError>) in
    guard case let .success(comment) = result else {
        print("Error creating comment")
        return
    }

    print("Added comment to \(comment.item.name): \"\(comment.message)\"")
}
```

[create-comment]: http://opensource.box.com/box-ios-sdk/Classes/CommentsModule.html#/s:6BoxSDK14CommentsModuleC13create6itemId0G4Type7message6fields10completionySS_S2SSaySSGSgys6ResultOyAA0F0CAA0A5ErrorOGctF

Update Comment
--------------

To update a comment, call
[`client.comments.update(commentId:message:fields:completion:)`][update-comment]
with the ID of the comment to update and the properties to update.

```swift
client.comments.update(
    commentId: "55555",
    message: "Updated message"
) { (result: Result<Comment, BoxSDKError>) in
    guard case let .success(comment) = result else {
        print("Error updating comment")
        return
    }

    print("Comment message updated")
}
```

[update-comment]: http://opensource.box.com/box-ios-sdk/Classes/CommentsModule.html#/s:6BoxSDK14CommentsModuleC17update9commentId7message6fields10completionySS_SSSaySSGSgys6ResultOyAA0F0CAA0A5ErrorOGctF

Delete Comment
--------------

To delete a comment, call [`client.comments.delete(commentId:completion:)`][delete-comment]
with the ID of the comment to delete.

```swift
client.comments.delete(commentId: "55555") { (result: Result<Void, BoxSDKError>) in
    guard case .success = result else {
        print("Error deleting comment")
        return
    }

    print("Comment deleted")
}
```

[delete-comment]: http://opensource.box.com/box-ios-sdk/Classes/CommentsModule.html#/s:6BoxSDK14CommentsModuleC13delete9commentId10completionySS_ys6ResultOyytAA0A5ErrorOGctF
