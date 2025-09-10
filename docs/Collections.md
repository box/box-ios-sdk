# CollectionsManager


- [List all collections](#list-all-collections)
- [List collection items](#list-collection-items)
- [Get collection by ID](#get-collection-by-id)

## List all collections

Retrieves all collections for a given user.

Currently, only the `favorites` collection
is supported.

This operation is performed by calling function `getCollections`.

See the endpoint docs at
[API Reference](https://developer.box.com/reference/get-collections/).

<!-- sample get_collections -->
```
try await client.collections.getCollections()
```

### Arguments

- queryParams `GetCollectionsQueryParams`
  - Query parameters of getCollections method
- headers `GetCollectionsHeaders`
  - Headers of getCollections method


### Returns

This function returns a value of type `Collections`.

Returns all collections for the given user.


## List collection items

Retrieves the files and/or folders contained within
this collection.

This operation is performed by calling function `getCollectionItems`.

See the endpoint docs at
[API Reference](https://developer.box.com/reference/get-collections-id-items/).

<!-- sample get_collections_id_items -->
```
try await client.collections.getCollectionItems(collectionId: favouriteCollection.id!)
```

### Arguments

- collectionId `String`
  - The ID of the collection. Example: "926489"
- queryParams `GetCollectionItemsQueryParams`
  - Query parameters of getCollectionItems method
- headers `GetCollectionItemsHeaders`
  - Headers of getCollectionItems method


### Returns

This function returns a value of type `ItemsOffsetPaginated`.

Returns an array of items in the collection.


## Get collection by ID

Retrieves a collection by its ID.

This operation is performed by calling function `getCollectionById`.

See the endpoint docs at
[API Reference](https://developer.box.com/reference/get-collections-id/).

<!-- sample get_collections_id -->
```
try await client.collections.getCollectionById(collectionId: collections.entries![0].id!)
```

### Arguments

- collectionId `String`
  - The ID of the collection. Example: "926489"
- headers `GetCollectionByIdHeaders`
  - Headers of getCollectionById method


### Returns

This function returns a value of type `Collection`.

Returns an array of items in the collection.


