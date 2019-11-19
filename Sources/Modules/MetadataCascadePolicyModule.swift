//
//  MetadataCascadePolicyModule.swift
//  BoxSDK-iOS
//
//  Created by Daniel Cech on 9/3/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// The desired behavior for conflict-resolution if a template already exists on a given file or folder
public enum ConflictResolution: BoxEnum {
    /// Preserve the existing value on the file
    case none
    /// Force-apply the cascade policy's value over any existing value.
    case overwrite
    /// A custom conflict resolution method.
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "none":
            self = .none
        case "overwrite":
            self = .overwrite
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .none:
            return "none"
        case .overwrite:
            return "overwrite"
        case let .customValue(userValue):
            return userValue
        }
    }
}

/// Defines methods for metadata management
public class MetadataCascadePolicyModule {

    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Retrieve an iterator for available metadata cascade policies within a given folder for the current enterprise.
    ///
    /// - Parameters:
    ///   - folderId: Specifies which folders' policies to return.
    ///   - ownerEnterpriseId: The ID of the owner of the metadata cascade policies. If not specified, defaults to current enterprise.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - marker: The position marker at which to begin the response. See [marker-based paging]
    ///     (https://developer.box.com/reference#section-marker-based-paging) for details.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is
    ///     1,000.
    public func list(
        folderId: String,
        ownerEnterpriseId: String? = nil,
        fields: [String]? = nil,
        marker: String? = nil,
        limit: Int? = nil,
        completion: @escaping Callback<PagingIterator<MetadataCascadePolicy>>
    ) {

        let queryParameters: QueryParameters = [
            "fields": FieldsQueryParam(fields),
            "folder_id": folderId,
            "owner_enterprise_id": ownerEnterpriseId,
            "limit": limit,
            "marker": marker
        ]

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/metadata_cascade_policies", configuration: boxClient.configuration),
            queryParameters: queryParameters,
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Get information about a specific metadata cascade policy.
    ///
    /// - Parameters:
    ///   - id: The ID of the cascade policy.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: The metadata cascade policy object is returned or an error
    public func get(
        id: String,
        fields: [String]? = nil,
        completion: @escaping Callback<MetadataCascadePolicy>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/metadata_cascade_policies/\(id)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Create a metadata cascade policy that applies to a given folder and a metadata instance attached to the given folder.
    /// In order for the policy to work, a metadata instance must be applied to the folder.
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder.
    ///   - scope: The scope of the metadata object (global or enterprise_{enterprise_id})
    ///   - templateKey: The key of the template. For example, the global scope has the properties template.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: The metadata cascade policy object is returned or an error
    public func create(
        folderId: String,
        scope: MetadataScope,
        templateKey: String,
        fields: [String]? = nil,
        completion: @escaping Callback<MetadataCascadePolicy>
    ) {
        let json = [
            "folder_id": folderId,
            "scope": scope.description,
            "templateKey": templateKey
        ]

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/metadata_cascade_policies", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Delete a metadata cascade policy that applies to a given folder and a folder-attached instance of given template.
    ///
    /// - Parameters:
    ///   - id: The ID of the cascade policy.
    ///   - completion: An empty response will be returned upon successful deletion or an error
    public func delete(
        id: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/metadata_cascade_policies/\(id)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// If a policy already exists on a folder, this will apply that policy to all existing files and sub-folders within the target folder.
    ///
    /// - Parameters:
    ///   - id: The ID of the cascade policy.
    ///   - conflictResolution: The desired behavior for conflict-resolution if a template already exists on a given file or folder.
    ///     Currently supported values are none, which will preserve the existing value on the file, and overwrite, which will
    ///     force-apply the cascade policy's value over any existing value.
    ///   - completion: An empty response will be returned upon successful deletion or an error
    public func forceApply(
        id: String,
        conflictResolution: ConflictResolution,
        completion: @escaping Callback<Void>
    ) {
        let json = [
            "conflict_resolution": conflictResolution.description
        ]

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/metadata_cascade_policies/\(id)/apply", configuration: boxClient.configuration),
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }
}
