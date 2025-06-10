Search
======

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Content Search](#content-search)
- [Content Search with Shared Link Items](#content-search-with-shared-link-items)
- [Metadata Search](#metadata-search)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Content Search
--------------

To get a list of items matching a search query, call [`client.search.query(query:...)`][search] with the
string to query for.  There are many possible options for advanced search filtering, which can be used to narrow down
the search results. This method will return an iterator object, which is used to get the results.

<!-- sample get_search -->   
```swift
let iterator = client.search.query(query: "Quarterly Business Review")
iterator.next { results in
    switch results {
    case let .success(page):
        for item in page.entries {
            switch item {
            case let .file(file):
                print("- File \(file.name) (ID: \(file.id))")
            case let .folder(folder):
                print("- Folder \(file.name) (ID: \(file.id))")
            case let .webLink(webLink):
                print("- Web Link \(file.name) (ID: \(file.id))")
            }
        }

    case let .failure(error):
        print(error)
    }
}
```

[search]: https://opensource.box.com/box-ios-sdk/Classes/SearchModule.html#/s:6BoxSDK12SearchModuleC5queryAD5scope14fileExtensions12createdAfter0I6Before07updatedJ00lK011sizeAtLeast0mN4Most12ownerUserIDs014ancestorFolderS08searchIn8itemType0V5Trash14metadataFilter6fields6offset5limit10completionySSSg_AA0C5ScopeOSgSaySSGSg10Foundation4DateVSgA4_A4_A4_s5Int64VSgA7_A0_A0_SayAA0c7ContentY0OGSgAA0c4ItemY0OSgSbSgAA08MetadataC6FilterCSgA0_SiSgA19_ys6ResultOyAA14PagingIteratorCyAA0U4ItemOGAA0A8SDKErrorCGctF

Content Search with Shared Link Items
--------------

To get a list of items matching a search query, including items that a user might have accessed recently through a shared link, call [`client.search.queryWithSharedLinks(query:...)`][search_with_shared_link_items] with the
string to query for.  There are many possible options for advanced search filtering, which can be used to narrow down
the search results. This method will return an iterator object, which is used to get the results.

<!-- sample get_search_with_shared_link_items -->
```swift
let iterator = client.search.queryWithSharedLinks(query: "Quarterly Business Review")
iterator.next { results in
    switch results {
    case let .success(page):
        for searchResult in page.entries {
            let item = searchResult.item
            switch item {
            case let .file(file):
                print("- File \(file.name) (ID: \(file.id))")
            case let .folder(folder):
                print("- Folder \(file.name) (ID: \(file.id))")
            case let .webLink(webLink):
                print("- Web Link \(file.name) (ID: \(file.id))")
            }
        }

    case let .failure(error):
        print(error)
    }
}
```

[search_with_shared_link_items]: https://opensource.box.com/box-ios-sdk/Classes/SearchModule.html#/s:6BoxSDK12SearchModuleC5queryAD5scope14fileExtensions12createdAfter0I6Before07updatedJ00lK011sizeAtLeast0mN4Most12ownerUserIDs014ancestorFolderS08searchIn8itemType0V5Trash14metadataFilter6fields6offset5limit10completionySSSg_AA0C5ScopeOSgSaySSGSg10Foundation4DateVSgA4_A4_A4_s5Int64VSgA7_A0_A0_SayAA0c7ContentY0OGSgAA0c4ItemY0OSgSbSgAA08MetadataC6FilterCSgA0_SiSgA19_ys6ResultOyAA14PagingIteratorCyAA0U4ItemOGAA0A8SDKErrorCGctF

Metadata Search
---------------

To search within metadata for specific values, use the helper methods included in the SDK to construct the metadata
query and call [`client.search.query(query:...)`][search] with the metadata filters and optionally a
search query.  If no additional content query string is needed, just set the `query` parameter to `nil`. This method will return an iterator object, which is used to get the results. 

```swift
let metadataFilters = MetadataSearchFilter()
metadataFilters.addFilter(templateKey: "contract", fieldKey: "contractType", fieldValue: "NDA")
metadataFilters.addFilter(templateKey: "contract", fieldKey: "date", fieldValue: "2019-01-01T00:00:00Z", relation: .greaterThan)
let iterator = client.search.query(query: nil, metadataFilter: metadataFilters)
iterator.next { results in
    switch results {
    case let .success(page):
        for item in page.entries {
            switch item {
            case let .file(file):
                print("- File \(file.name) (ID: \(file.id))")
            case let .folder(folder):
                print("- Folder \(file.name) (ID: \(file.id))")
            case let .webLink(webLink):
                print("- Web Link \(file.name) (ID: \(file.id))")
            }
        }

    case let .failure(error):
        print(error)
    }  
}
```
