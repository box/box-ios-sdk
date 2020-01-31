Search
======

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Content Search](#content-search)
- [Metadata Search](#metadata-search)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Content Search
--------------

To get a list of items matching a search query, call [`client.search.query(query:...)`][search] with the
string to query for.  There are many possible options for advanced search filtering, which can be used to narrow down
the search results. This method will return an iterator object in the completion, which is used to get the results.

<!-- sample get_search -->   
```swift
client.search.query(query: "Quarterly Business Review") { results in
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(item):
                    switch item {
                    case let .file(file):
                        print("- File \(file.name) (ID: \(file.id))")
                    case let .folder(folder):
                        print("- Folder \(file.name) (ID: \(file.id))")
                    case let .webLink(webLink):
                        print("- Web Link \(file.name) (ID: \(file.id))")
                    }
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

[search]: http://opensource.box.com/box-ios-sdk/Classes/SearchModule.html#/s:6BoxSDK12SearchModuleC5queryAD5scope14fileExtensions12createdAfter0I6Before07updatedJ00lK011sizeAtLeast0mN4Most12ownerUserIDs014ancestorFolderS08searchIn8itemType0V5Trash6fields6offset5limitAA18PaginationIteratorCyAA0U4ItemCGSS_AA0C5ScopeOSgSaySSGSg10Foundation4DateVSgA6_A6_A6_s5Int64VSgA9_A2_A2_SayAA0c7ContentY0OGSgAA0c4ItemY0OSgSbSgA2_SiSgA18_tF

Metadata Search
---------------

To search within metadata for specific values, use the helper methods included in the SDK to construct the metadata
query and call [`client.search.query(query:...)`][search] with the metadata filters and optionally a
search query.  If no additional content query string is needed, just set the `query` parameter to `nil`. This method will return an iterator object in the completion, which is used to get the results. 

```swift
let metadataFilters = MetadataSearchFilter()
metadataFilters.addFilter(templateKey: "contract", fieldKey: "contractType", fieldValue: "NDA")
metadataFilters.addFilter(templateKey: "contract", fieldKey: "date", fieldValue: "2019-01-01T00:00:00Z", relation: .greaterThan)
client.search.query(query: nil, metadataFilter: metadataFilters) { results in
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(item):
                    switch item {
                    case let .file(file):
                        print("- File \(file.name) (ID: \(file.id))")
                    case let .folder(folder):
                        print("- Folder \(file.name) (ID: \(file.id))")
                    case let .webLink(webLink):
                        print("- Web Link \(file.name) (ID: \(file.id))")
                    }
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
