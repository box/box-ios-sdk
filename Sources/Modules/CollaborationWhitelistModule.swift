//
//  CollaborationWhitelistModule.swift
//  BoxSDK
//
//  Created by Daniel Cech on 29/08/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Provides [Collaborations](../Structs/Collaborations.html) management.
public class CollaborationWhitelistModule {
    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Returns the list of Whitelist entries for the current Enterprise. Each entry lists type, id,
    /// domain, and direction. You can specify more by using the fields parameter.
    ///
    /// - Parameters:
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - marker: The position marker at which to begin the response. See [marker-based paging]
    ///     (https://developer.box.com/reference#section-marker-based-paging) for details.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is
    ///     1,000.
    public func listEntries(
        fields: [String]? = nil,
        marker: String? = nil,
        limit: Int? = nil,
        completion: @escaping Callback<PagingIterator<CollaborationWhitelistEntry>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/collaboration_whitelist_entries", configuration: boxClient.configuration),
            queryParameters: [
                "marker": marker,
                "limit": limit,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Get Collaboration Whitelist Entry by ID.
    ///
    /// - Parameters:
    ///   - id: The ID of the collaboration whitelist entry to get details
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: The collaboration whitelist entry object is returned or an error
    public func get(
        id: String,
        fields: [String]? = nil,
        completion: @escaping Callback<CollaborationWhitelistEntry>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/collaboration_whitelist_entries/\(id)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Create Collaboration Whitelist Entry.
    ///
    /// - Parameters:
    ///   - domain: Domain to add to whitelist (e.g. box.com).
    ///   - direction: inbound, outbound, or both.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: The collaboration whitelist entry object is returned or an error
    public func create(
        domain: String,
        direction: CollaborationDirection,
        fields: [String]? = nil,
        completion: @escaping Callback<CollaborationWhitelistEntry>
    ) {
        let json = ["domain": domain, "direction": direction.description]

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/collaboration_whitelist_entries", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Remove a single item from the Enterprise's Collaboration Whitelist by id.
    /// If there are no longer any entries in the whitelist table, the Collaboration
    /// Whitelist feature will be turned off.
    ///
    /// - Parameters:
    ///   - id: The ID of the collaboration whitelist entry to remove.
    ///   - completion: An empty response will be returned upon successful deletion. An error is
    ///     thrown if the collaboration whitelist cannot be deleted.
    public func delete(
        id: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/collaboration_whitelist_entries/\(id)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Returns an interator for listing of Exempt User entries for the current Enterprise.
    /// By default, each will return type, id, and user, but you can specify more by using the
    /// fields parameter.
    ///
    /// - Parameters:
    ///   - marker: The position marker at which to begin the response. See [marker-based paging]
    ///     (https://developer.box.com/reference#section-marker-based-paging) for details.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is
    ///     1,000.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    public func listExemptTargets(
        marker: String? = nil,
        limit: Int? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<CollaborationWhitelistExemptTarget>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/collaboration_whitelist_exempt_targets", configuration: boxClient.configuration),
            queryParameters: [
                "marker": marker,
                "limit": limit,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Returns a specific exempt target for the passed in ID.
    ///
    /// - Parameters:
    ///   - id: The ID of the collaboration whitelist entry to get details
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: The exempt target entry, object is returned or an error
    public func getExemptTarget(
        id: String,
        fields: [String]? = nil,
        completion: @escaping Callback<CollaborationWhitelistExemptTarget>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/collaboration_whitelist_exempt_targets/\(id)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Creates the Exempt Target entry.
    ///
    /// - Parameters:
    ///   - userId: The ID of user to add to exempt target list.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: The collaboration whitelist entry object is returned or an error
    public func exemptUser(
        userId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<CollaborationWhitelistExemptTarget>
    ) {
        let json = ["user": ["id": userId]]

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/collaboration_whitelist_exempt_targets", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Remove a single user from the exempt target list.
    ///
    /// - Parameters:
    ///   - id: The ID of the collaboration whitelist exempt target to remove.
    ///   - completion: An empty response will be returned upon successful deletion. An error is
    ///     thrown if the exempt target cannot be deleted.
    public func deleteExemptTarget(
        id: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/collaboration_whitelist_exempt_targets/\(id)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }
}
