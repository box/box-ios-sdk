//
//  CollectionsModule.swift
//  BoxSDK-iOS
//
//  Created by Daniel Cech on 03/06/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Management of collections of files and folders. The only collection available is the "Favorites".
public class CollectionsModule {

    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Retrieves the collections for the given user.
    ///
    /// - Parameters:
    ///   - offset: The offset of the item at which to begin the response. See [offset-based paging]
    ///     (https://developer.box.com/reference#section-offset-based-paging) for details. This
    ///     parameter cannot be used simultaneously with the 'marker' parameter.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is
    ///     1,000.
    public func list(
        offset: Int? = nil,
        limit: Int? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<BoxCollection>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/collections", configuration: boxClient.configuration),
            queryParameters: [
                "offset": offset,
                "limit": limit,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Retrieve the favorites collection
    ///
    /// - Parameters:
    ///   - fields: The set of fields to retrieve on the resulting collection object
    ///   - completion: Passed the favorites collection, or an error if the API call fails
    public func getFavorites(fields: [String]? = nil, completion: @escaping Callback<BoxCollection>) {
        list(offset: 0, limit: 1000, fields: fields) { results in
            switch results {
            case let .success(iterator):
                iterator.next { result in
                    switch result {
                    case let .success(collection):
                        if collection.collectionType == "favorites" {
                            completion(.success(collection))
                        }
                        else {
                            completion(.failure(BoxSDKError(message: .notFound("Collections does not have the favorites collection type"))))
                            return
                        }
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /// Gets all of the files, folders, or web links contained within a collection.
    ///
    /// - Parameters:
    ///   - collectionId: The ID of the collection on which to retrieve information.
    ///   - offset: The offset of the item at which to begin the response. See [offset-based paging]
    ///     (https://developer.box.com/reference#section-offset-based-paging) for details. This
    ///     parameter cannot be used simultaneously with the 'marker' parameter.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is
    ///     1,000.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.  Any attribute in the full
    ///     [file](https://developer.box.com/reference#file-object) or
    ///     [folder](https://developer.box.com/reference#folder-object) objects can be
    ///     passed in with the fields parameter to get specific attributes, and only those specific
    ///     attributes back; otherwise, the mini format is returned for each item by default.
    ///     Multiple attributes can be passed in separated by commas e.g. fields=name,created_at.
    public func listItems(
        collectionId: String,
        offset: Int? = nil,
        limit: Int? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<FolderItem>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/collections/\(collectionId)/items", configuration: boxClient.configuration),
            queryParameters: [
                "offset": offset,
                "limit": limit,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }
}
