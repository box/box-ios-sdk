//
//  RetentionPolicy+File.swift
//  BoxSDK-iOS
//
//  Created by Martina Stremenova on 01/09/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Handles retention policy management for file versions. A retention policy blocks permanent deletion of content for a specified amount of time.
/// Admins can apply policies to specified folders, or an entire enterprise. A file version retention is a record for a retained file version.
/// To use this feature, you must have the manage retention policies scope enabled for your API key via your application management console.
/// For more information about retention policies, please visit our [help documentation.] (https://community.box.com/t5/For-Admins/Retention-Policies-In-Box/ta-p/1095)
public extension FilesModule {

    /// Retrieves information about a file version retention policy.
    ///
    /// - Parameters:
    ///   - id: Identifier of retention policy of a file version.
    ///   - completion: Either specified file version retention will be returned upon success or an error.
    func getVersionRetention(
        retentionId id: String,
        completion: @escaping Callback<FileVersionRetention>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/file_version_retentions/\(id)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Retrieves all file version retentions for the given enterprise.
    ///
    /// - Parameters:
    ///   - fileId: A file id to filter the file version retentions by.
    ///   - fileVersionId: A file version id to filter the file version retentions by.
    ///   - policyId: A policy id to filter the file version retentions by.
    ///   - dispositionAction: The disposition action of the retention policy.
    ///   - dispositionBefore: Filter retentions with disposition date before provided date.
    ///   - dispositionAfter: Filter retentions with disposition date after provided date.
    ///   - limit: The maximum number of items to return in a page.
    ///   - marker: The position marker at which to begin the response. See [marker-based paging]
    ///     (https://developer.box.com/reference#section-marker-based-paging) for details.
    /// - Returns: Returns either the list of all file version retentions for the enterprise or an error.
    ///     If optional parameters are given, only the file version retentions that match the query parameters are returned.
    func listVersionRetentions(
        fileId: String? = nil,
        fileVersionId: String? = nil,
        policyId: String? = nil,
        dispositionAction: DispositionAction? = nil,
        dispositionBefore: Date? = nil,
        dispositionAfter: Date? = nil,
        limit: Int? = nil,
        marker: String? = nil,
        completion: @escaping Callback<PagingIterator<FileVersionRetention>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/file_version_retentions", configuration: boxClient.configuration),
            queryParameters: [
                "file_id": fileId,
                "file_version_id": fileVersionId,
                "policy_id": policyId,
                "disposition_action": dispositionAction?.description,
                "disposition_before": dispositionBefore?.iso8601,
                "disposition_after": dispositionAfter?.iso8601,
                "marker": marker,
                "limit": limit
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }
}
