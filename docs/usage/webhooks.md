Webhooks
=======

 Webhooks enable you to attach event triggers to Box files and folders. Event triggers monitor events on Box objects and notify your application when they occur. A webhook notifies your application by sending HTTP requests to a URL of your choosing. A webhook object contains information about a webhook like the triggers, the URL, etc.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Get Webhooks](#get-webhooks)
- [Get Webhook Info](#get-webhook-info)
- [Create Webhook](#create-webhook)
- [Update Webhook](#update-webhook)
- [Delete Webhook](#delete-webhook)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Get Webhook Info
---------------

To retrieve information about a webhook, call
[`client.webhooks.get(webhookId: String, fields: [String]?, completion: @escaping Callback<Webhook>)`]
with the ID of the webhook.  You can control which fields are returned in the resulting `Webhook` object by passing the
`fields` parameter.

<!-- sample get_webhooks_id -->
```swift
client.folders.get(webhookId: "22222", fields: ["id", "created_at"]) { (result: Result<Webhook, BoxSDKError>) in
    guard case let .success(webhook) = result else {
        print("Error getting webhook information")
        return
    }

    print("Webhook \(webhook.id) was created at \(webhook.createdAt)")
}
```

Get Webhooks
----------------

To retrieve information about webhooks in an enterprise, call
[`client.webhook.list(webhookId: String, marker: String?, limit: Int?, fields: [String]?)`].  This method will return an iterator object in the completion, which is used to get the webhooks.

<!-- sample get_webhooks -->
```swift
client.webhooks.list() { results in
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(webhook):
                    print("Webhook \(webhook.id) was created at \(webhook.createdAt)")
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

Create Webhook
-------------

To create a new webhook, call
[`client.webhooks.create(targetType: String, targetId: String, triggers: [Webhook.EventTriggers], address: String, fields: [String]?, completion: @escaping Callback<Webhook>`]

<!-- sample post_webhooks -->
```swift
client.webhooks.create(targetType: "file", targetId: "1234", triggers: [.fileDownloaded], address: "www.testurl.com") { (result: Result<Webhook, BoxSDKError>) in
    guard case let .success(webhook) = result else {
        print("Error creating webhook")
        return
    }

    print("Created webhook \"\(webhook.id)\"")
}
```

Update Webhook
-------------

To update a webhook, call
[`client.webhooks.update(webhookId: String, targetType: String?, targetId: String?, triggers: [Webhook.EventTriggers]?, address: String?, fields: [String]?, completion: @escaping Callback<Webhook>`]

<!-- sample put_webhooks_id -->
```swift
client.webhooks.update(webhookId: "1234", targetType: "file", targetId: "1234", address: "www.testurl.com") { (result: Result<Webhook, BoxSDKError>) in
    guard case let .success(webhook) = result else {
        print("Error updating webhook")
        return
    }

    print("Updated webhook address to \"\(webhook.address)\"")
}
```

Delete Webhook
-------------

To delete a webhook, call
[`client.webhooks.delete(webhookId: String, completion: @escaping Callback<Void>`]

<!-- sample delete_webhooks_id -->
```swift
client.webhooks.delete(webhookId: "22222") { result: Result<Void, BoxSDKError>} in
    guard case .success = result else {
        print("Error deleting webhook")
        return
    }

    print("Webhook successfully deleted")
}
```
