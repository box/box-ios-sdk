//
//  SearchModule.swift
//  BoxSDK-iOS
//
//  Created by Matthew Willer on 5/3/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Defines search scope
public enum SearchScope: BoxEnum {
    /// Scope limited to current user
    case user
    /// Scope limited the enterprise.
    case enterprise
    /// A custom search scope that is not yet implemented. To enable this type of scope for an administrator,
    /// please [contact us](https://community.box.com/t5/custom/page/page-id/BoxSearchLithiumTKB)
    case customValue(String)

    /// Initializer
    ///
    /// - Parameter value: String representing search scope
    public init(_ value: String) {
        switch value {
        case "user":
            self = .user
        case "enterprise":
            self = .enterprise
        default:
            self = .customValue(value)
        }
    }

    /// Returns string representation of scope.
    public var description: String {

        switch self {
        case .user:
            return "user_content"
        case .enterprise:
            return "enterprise_content"
        case let .customValue(userValue):
            return userValue
        }
    }
}

/// Defines the attributes for which the search should look for matches
public enum SearchContentType: BoxEnum {
    /// Searching in names of items
    case name
    /// Searching in description of items
    case description
    /// Searching in files content
    case fileContents
    /// Searching in comments
    case comments
    /// Searching in tags
    case tags
    /// Custom attribute defined for searching that is not yet implemented.
    case customValue(String)

    /// Initializer.
    ///
    /// - Parameter value: String representation of SearchContentType
    public init(_ value: String) {
        switch value {
        case "name":
            self = .name
        case "description":
            self = .description
        case "file_content":
            self = .fileContents
        case "comments":
            self = .comments
        case "tags":
            self = .tags
        default:
            self = .customValue(value)
        }
    }

    /// Returns string representation of search area type
    public var description: String {
        switch self {
        case .name:
            return "name"
        case .description:
            return "description"
        case .fileContents:
            return "file_content"
        case .comments:
            return "comments"
        case .tags:
            return "tags"
        case let .customValue(userValue):
            return userValue
        }
    }
}

/// Defines type of objects to include in the search results
public enum SearchItemType: BoxEnum {
    /// Object type file
    case file
    /// Object type folder
    case folder
    /// Object type weblink
    case webLink
    /// A custom object type defined for searching that is not yet implemented.
    case customValue(String)

    /// Initializer.
    ///
    /// - Parameter value: String representation of SearchItemType
    public init(_ value: String) {
        switch value {
        case "file":
            self = .file
        case "folder":
            self = .folder
        case "web_link":
            self = .webLink
        default:
            self = .customValue(value)
        }
    }

    /// Returns string representation of searched item type.
    public var description: String {
        switch self {
        case .file:
            return "file"
        case .folder:
            return "folder"
        case .webLink:
            return "web_link"
        case let .customValue(userValue):
            return userValue
        }
    }
}

/// Provides functionality to search for content.
public class SearchModule {

    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Searches for items in Box.
    ///
    /// - Parameters:
    ///   - query: The text to serach for.
    ///   - scope: The scope of content to search within; admins can serach within their entire enterprise.
    ///   - fileExtensions: Limit the search to files with the given extensions.
    ///   - createdAfter: Limit the search to items created after this date.
    ///   - createdBefore: Limit the search to items created before this date.
    ///   - updatedAfter: Limit the search to items updated after this date.
    ///   - updatedBefore: Limit the search to items updated before this date.
    ///   - sizeAtLeast: Limit the search to items at least this size, in bytes.
    ///   - sizeAtMost: Limit the search to items at most this size, in bytes
    ///   - ownerUserIDs: Limit the search to only items owned by one of the specified users.
    ///   - ancestorFolderIDs: Limit the search to items within the specified folders.  This includes all
    ///     content under these folders, not just their immediate children.
    ///   - searchIn: Specifies the areas where the search should look for the query string.
    ///   - itemType: Limits the search to only items of the given type.
    ///   - searchTrash: Whether to search in the trash.  The options are mutually exclusive; either
    ///   - metadataFilter: The metadata template filters to limit the search results to.
    ///     only trashed content or non-trashed content will be searched.
    ///   - offset: The offset within the collection of results to start from.
    ///   - limit: The limit for how many search results will be returned.
    ///   - completion: Called with the results of the search query, or an error if the request is unsuccessful.
    public func query(
        query: String?,
        scope: SearchScope? = nil,
        fileExtensions: [String]? = nil,
        createdAfter: Date? = nil,
        createdBefore: Date? = nil,
        updatedAfter: Date? = nil,
        updatedBefore: Date? = nil,
        sizeAtLeast: Int64? = nil,
        sizeAtMost: Int64? = nil,
        ownerUserIDs: [String]? = nil,
        ancestorFolderIDs: [String]? = nil,
        searchIn: [SearchContentType]? = nil,
        itemType: SearchItemType? = nil,
        searchTrash: Bool? = nil,
        metadataFilter: MetadataSearchFilter? = nil,
        fields: [String]? = nil,
        offset: Int? = nil,
        limit: Int? = nil,
        completion: @escaping Callback<PagingIterator<FolderItem>>
    ) {

        let dateEncoder = JSONEncoder()
        dateEncoder.dateEncodingStrategy = .iso8601

        var queryParams: [String: QueryParameterConvertible] = [
            "query": query,
            "scope": scope,
            "file_extensions": fileExtensions?.joined(separator: ","),
            "owner_user_ids": ownerUserIDs?.joined(separator: ","),
            "ancestor_folder_ids": ancestorFolderIDs?.joined(separator: ","),
            "content_types": searchIn?.map { $0.description }.joined(separator: ","),
            "type": itemType,
            "trash_content": searchTrash.flatMap { $0 ? "trashed_only" : "non_trashed_only" },
            "fields": FieldsQueryParam(fields),
            "limit": limit,
            "offset": offset,
            "mdfilters": MetadataFilterQueryParam(metadataFilter)
        ]

        if createdAfter != nil || createdBefore != nil {
            queryParams["created_at_range"] = "\(createdAfter?.iso8601 ?? ""),\(createdBefore?.iso8601 ?? "")"
        }

        if updatedAfter != nil || updatedBefore != nil {
            queryParams["updated_at_range"] = "\(updatedAfter?.iso8601 ?? ""),\(updatedBefore?.iso8601 ?? "")"
        }

        if sizeAtLeast != nil || sizeAtMost != nil {
            queryParams["size_range"] = "\(sizeAtLeast.flatMap { String($0) } ?? ""),\(sizeAtMost.flatMap { String($0) } ?? "")"
        }

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/search", configuration: boxClient.configuration),
            queryParameters: queryParams,
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }
}
