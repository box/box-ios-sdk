Recent Items
=======

A recent item object represents a file that has been recently accessed by a user. Items accessed either in the last 90 days or the last 1000 accessed items are tracked.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Get Recent Items](#get-recent-items)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Get Recent Items
----------------

To get recently accessed items, call
[`client.recentItems.list(marker: String?, limit: Int?, fields: [String]?)`][get-recent-items]. This method will return an iterator object you can use to retrieve successive pages of
results, where each page contains some of the recent items.

```swift
let recentItems = client.folders.list()

// Get the first page of items
recentItems.getNextItems() { (result: Result<[FolderItem], BoxError>) in
    guard case let .success(items) = result else {
        print("Error getting recent items")
        return
    }

    // Print out first page of recent items
    for item in items {
       print("Interaction type is \(item.interactionType)")
       print("File ID is \(item.item.id)")
    }
}
```

[get-recent-items]: https://opensource.box.com/box-swift-sdk/Classes/RecentItemsModule.html#/s:6BoxSDK17RecentItemsModuleC03getcD06marker5limit6fieldsAA18PaginationIteratorCyAA0C4ItemCGSSSg_SiSgSaySSGSgtF
