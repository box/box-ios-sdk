//
//  RecentItemsModule.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 8/26/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Returns information about files that have been accessed by a user not long ago.
public class RecentItemsModule {
    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Get recent items.
    ///
    /// - Parameters:
    ///   - marker: The position marker at which to begin the response. See [marker-based paging]
    ///     (https://developer.box.com/reference#section-marker-based-paging) for details. This
    ///     parameter cannot be used simultaneously with the 'offset' parameter.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is
    ///     1,000.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    public func list(
        marker: String? = nil,
        limit: Int? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<RecentItem>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/recent_items", configuration: boxClient.configuration),
            queryParameters: [
                "marker": marker,
                "limit": limit,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }
}
