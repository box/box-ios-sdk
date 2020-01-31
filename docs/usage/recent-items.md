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
[`client.recentItems.list(marker: String?, limit: Int?, fields: [String]?)`][get-recent-items]. This method will return an iterator object in the completion, which is used to retrieve recent items.

<!-- sample get_items_recent -->   
```swift
client.recentItems.list() { results in
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(item):
                    print("Interaction type is \(item.interactionType)")
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

[get-recent-items]: https://opensource.box.com/box-swift-sdk/Classes/RecentItemsModule.html#/s:6BoxSDK17RecentItemsModuleC03getcD06marker5limit6fieldsAA18PaginationIteratorCyAA0C4ItemCGSSSg_SiSgSaySSGSgtF
