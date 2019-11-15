//
//  FoldersModule.swift
//  BoxSDK-iOS
//
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Defines the level of access to upload a file to a folder via its upload email address
public enum FolderUploadEmailAccess: BoxEnum {
    /// Any user can upload.
    case open
    /// Any folder collaborator can upload
    case collaborators
    /// A custom object type for defining access to a folder's upload email address that is not yet implemented.
    case customValue(String)

    /// Initializer
    ///
    /// - Parameter value: String value representing access type
    public init(_ value: String) {
        switch value {
        case "open":
            self = .open
        case "collaborators":
            self = .collaborators
        default:
            self = .customValue(value)
        }
    }

    /// Returns a string representation of the folder upload email access
    public var description: String {

        switch self {
        case .open:
            return "open"
        case .collaborators:
            return "collaborators"
        case let .customValue(userValue):
            return userValue
        }
    }
}

/// Defines by which parameter should list of box items be ordered.
public enum FolderItemsOrderBy: BoxEnum {
    /// Order by item identifier
    case id
    /// Order by item name
    case name
    /// Order by item date
    case date
    /// Order by item type
    case type
    /// Custom value for enum values not yet implemented by the SDk
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "id":
            self = .id
        case "name":
            self = .name
        case "date":
            self = .date
        case "type":
            self = .type
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .id:
            return "id"
        case .name:
            return "name"
        case .date:
            return "date"
        case .type:
            return "type"
        case let .customValue(value):
            return value
        }
    }
}

extension FolderItemsOrderBy: QueryParameterConvertible {
    /// Query parameter value
    public var queryParamValue: String? {
        return description
    }
}

/// Provides [Folder](../Structs/Folder.html) management.
public class FoldersModule {
    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Get information about a folder.
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder on which to retrieve information.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full folder object or an error.
    public func get(
        folderId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<Folder>
    ) {

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/folders/\(folderId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Gets all of the files, folders, or web links contained within a folder.
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder on which to retrieve information.
    ///   - usemarker: This specifies whether you would like to use marker-based or offset-based
    ///     paging. You can only use one or the other. Marker-based paging is the preferred method
    ///     and is most performant. If not specified, this endpoint defaults to using offset-based
    ///     paging. This parameter is unique to Get Folder Items to retain backwards compatibility
    ///     for this endpoint. This parameter is required for both the first and subsequent calls to
    ///     use marked-based paging.
    ///   - marker: The position marker at which to begin the response. See [marker-based paging]
    ///     (https://developer.box.com/reference#section-marker-based-paging) for details. This
    ///     parameter cannot be used simultaneously with the 'offset' parameter.
    ///   - offset: The offset of the item at which to begin the response. See [offset-based paging]
    ///     (https://developer.box.com/reference#section-offset-based-paging) for details. This
    ///     parameter cannot be used simultaneously with the 'marker' parameter.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is
    ///     1,000.
    ///   - sort: This can be id, name, or date. This parameter is not yet supported for marker-
    ///     based paging on folder 0.
    ///   - direction: This can be ASC or DESC.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    public func listItems(
        folderId: String,
        usemarker: Bool? = nil,
        marker: String? = nil,
        offset: Int? = nil,
        limit: Int? = nil,
        sort: FolderItemsOrderBy? = nil,
        direction: OrderDirection? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<FolderItem>>
    ) {

        var queryParams: QueryParameters = [
            "limit": limit,
            "sort": sort,
            "direction": direction,
            "fields": FieldsQueryParam(fields)
        ]
        if usemarker ?? false {
            queryParams["usemarker"] = true
            queryParams["marker"] = marker
        }
        else {
            queryParams["offset"] = offset
        }

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/folders/\(folderId)/items", configuration: boxClient.configuration),
            queryParameters: queryParams,
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Create a new folder.
    ///
    /// - Parameters:
    ///   - name: The desired name for the folder.  Box supports folder names of 255 characters or
    ///     less. Names containing non-printable ASCII characters, "/" or "\", names with trailing
    ///     spaces, and the special names “.” and “..” are also not allowed.
    ///   - parentId: The ID of the parent folder.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full folder object or an error if the parentId is invalid or if a
    ///     name collision occurs.
    public func create(
        name: String,
        parentId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<Folder>
    ) {
        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/folders", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: [
                "parent": [
                    "id": parentId
                ],
                "name": name
            ],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Update a folder.
    ///
    /// - Parameters:
    ///   - folderId: The ID of the file to update
    ///   - name: The name of the folder.
    ///   - description: The description of the folder.
    ///   - parentId: The ID of the parent folder
    ///   - access: The level of access. Can be open ("People with the link"), company ("People in your company"), or collaborators ("People in this folder").
    ///     If you omit this field then the access level will be set to the default access level specified by the enterprise admin.
    ///   - password: The password required to access the shared link. Set to .empty value to delete password
    ///   - unsharedAt: The date-time that this link will become disabled. This field can only be set by users with paid accounts.
    ///   - canDownload: Whether the shared link allows downloads. For shared links on folders, this also applies to any items in the folder.
    ///     Can only be set with access levels open and company (not collaborators).
    ///   - folderUploadEmailAccess: Can be open or collaborators
    ///   - tags: Array of tags to be added or replaced to the folder
    ///   - canNonOwnersInvite: If this parameter is set to false, only folder owners and co-owners can send collaborator invites
    ///   - isCollaborationRestrictedToEnterprise: Whether to restrict future collaborations to within the enterprise. Does not affect existing collaborations.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns The updated folder is returned if the name is valid. Errors generally occur only if there is a name collision.
    public func update(
        folderId: String,
        name: String? = nil,
        description: String? = nil,
        parentId: String? = nil,
        sharedLink: NullableParameter<SharedLinkData>? = nil,
        folderUploadEmailAccess: FolderUploadEmailAccess? = nil,
        tags: [String]? = nil,
        canNonOwnersInvite: Bool? = nil,
        isCollaborationRestrictedToEnterprise: Bool? = nil,
        collections: [String]? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<Folder>
    ) {
        var body: [String: Any] = [:]
        body["name"] = name
        body["description"] = description

        if let parentId = parentId {
            body["parent"] = ["id": parentId]
        }

        if let unwrappedSharedLink = sharedLink {
            switch unwrappedSharedLink {
            case .null:
                body["shared_link"] = NSNull()
            case let .value(sharedLinkValue):
                body["shared_link"] = sharedLinkValue.bodyDict
            }
        }

        body["folder_upload_email"] = folderUploadEmailAccess.map { ["access": $0.description] }
        body["tags"] = tags?.joined(separator: ",")
        body["can_non_owners_invite"] = canNonOwnersInvite
        body["is_collaboration_restricted_to_enterprise"] = isCollaborationRestrictedToEnterprise
        body["collections"] = collections?.map { ["id": $0] }

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/folders/\(folderId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Delete a folder or move a folder to the trash. The recursive parameter must be included in
    /// order to delete folders that aren't empty. Depending on the [enterprise settings for this
    /// user](https://community.box.com/t5/Managing-Files-and-Folders/Trash/ta-p/19212), the item
    /// will either be actually deleted from Box or [moved to the trash]
    /// (https://developer.box.com/reference#get-the-items-in-the-trash).
    ///
    /// - Parameters:
    ///   - folderId: The ID of the file to delete.
    ///   - recursive: Whether to delete this folder if it has items inside of it.
    ///   - completion: An empty response will be returned upon successful deletion. An error is
    ///     thrown if the folder is not empty and the ‘recursive’ parameter is not included.
    public func delete(
        folderId: String,
        recursive: Bool? = nil,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/folders/\(folderId)", configuration: boxClient.configuration),
            queryParameters: ["recursive": recursive],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Used to create a copy of a folder in another folder. The original version of the folder will not be altered.
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder that will be copy.
    ///   - destinationFolderID: The ID of the destination folder
    ///   - name: An optional new name for the folder
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full folder object or an error if the parentId is invalid or if a
    ///     name collision occurs.
    public func copy(
        folderId: String,
        destinationFolderID: String,
        name: String? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<Folder>
    ) {

        var body: [String: Any] = ["parent": ["id": destinationFolderID]]
        body["name"] = name

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/folders/\(folderId)/copy", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Use this to get a list of all the collaborations on a folder i.e. all of the users that have access to that folder.
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder on which to retrieve collaborations.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    public func listCollaborations(
        folderId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<Collaboration>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/folders/\(folderId)/collaborations", configuration: boxClient.configuration),
            queryParameters: [
                "offset": 0,
                "limit": 1000,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Add folder to favorites
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder
    ///   - completion: Returns the updated folder or an error
    public func addToFavorites(
        folderId: String,
        completion: @escaping Callback<Folder>
    ) {
        boxClient.collections.getFavorites { [weak self] result in
            guard let self = self else {
                completion(.failure(BoxSDKError(message: .instanceDeallocated("Unable to add to Favorites - FoldersModule deallocated"))))
                return
            }

            switch result {
            case let .success(favorites):
                self.addToCollection(folderId: folderId, collectionId: favorites.id, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /// Add folder to particular collection
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder
    ///   - collectionId: The ID of the collection
    ///   - completion: Returns the updated folder or an error
    public func addToCollection(
        folderId: String,
        collectionId: String,
        completion: @escaping Callback<Folder>
    ) {
        get(folderId: folderId) { [weak self] result in
            guard let self = self else {
                completion(.failure(BoxSDKError(message: .instanceDeallocated("Unable add to Collection - FoldersModule deallocated"))))
                return
            }

            switch result {
            case let .success(folder):
                let collectionList = folder.collections ?? []
                let collectionIdList = collectionList.compactMap { $0["id"] }
                let updatedCollectionIdList = Array(Set(collectionIdList + [collectionId])) // Add only new

                self.update(folderId: folderId, collections: updatedCollectionIdList, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /// Remove folder from favorites
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder
    ///   - completion: Returns the updated folder or an error
    public func removeFromFavorites(
        folderId: String,
        completion: @escaping Callback<Folder>
    ) {
        boxClient.collections.getFavorites { [weak self] result in
            guard let self = self else {
                completion(.failure(BoxSDKError(message: .instanceDeallocated("Unable to remove from Favorites - FoldersModule deallocated"))))
                return
            }

            switch result {
            case let .success(favorites):
                self.removeFromCollection(folderId: folderId, collectionId: favorites.id, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /// Add folder to particular collection
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder
    ///   - collectionId: The ID of the collection
    ///   - completion: Returns the updated folder or an error
    public func removeFromCollection(
        folderId: String,
        collectionId: String,
        completion: @escaping Callback<Folder>
    ) {
        get(folderId: folderId) { [weak self] result in
            guard let self = self else {
                completion(.failure(BoxSDKError(message: .instanceDeallocated("Unable to remove from Collection - FoldersModule deallocated"))))
                return
            }

            switch result {
            case let .success(folder):
                let collectionList = folder.collections ?? []
                var collectionIdList = collectionList.compactMap { $0["id"] }

                if let index = collectionIdList.firstIndex(of: collectionId) {
                    collectionIdList.remove(at: index)
                }

                self.update(folderId: folderId, collections: collectionIdList, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /// Gets folder with updated shared link
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder
    ///   - completion: Returns a standard SharedLink object or an error
    public func getSharedLink(
        forFolder folderId: String,
        completion: @escaping Callback<SharedLink>
    ) {
        get(folderId: folderId, fields: ["shared_link"], completion: { result in
            completion(FoldersModule.unwrapSharedLinkObject(from: result))
        })
    }

    /// Creates or updates shared link for a folder
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder
    ///   - access: The level of access. If you omit this field then the access level will be set to the default access level specified by the enterprise admin
    ///   - unsharedAt: The date-time that this link will become disabled. This field can only be set by users with paid accounts
    ///   - password: The password required to access the shared link. Set to .null to remove the password
    ///   - canDownload: Whether the shared link allows downloads. Applies to any items in the folder
    ///   - completion: Returns a standard SharedLink object or an error
    public func setSharedLink(
        forFolder folderId: String,
        access: SharedLinkAccess? = nil,
        unsharedAt: NullableParameter<Date>? = nil,
        password: NullableParameter<String>? = nil,
        canDownload: Bool? = nil,
        completion: @escaping Callback<SharedLink>
    ) {
        update(
            folderId: folderId,
            sharedLink: .value(SharedLinkData(
                access: access,
                password: password,
                unsharedAt: unsharedAt,
                canDownload: canDownload
            )),
            fields: ["shared_link"]
        ) { result in
            completion(FoldersModule.unwrapSharedLinkObject(from: result))
        }
    }

    /// Removes shared link for a folder
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder
    ///   - completion: Returns an empty response or an error
    public func deleteSharedLink(
        forFolder folderId: String,
        completion: @escaping Callback<Void>
    ) {
        update(folderId: folderId, sharedLink: .null) { result in
            completion(result.map { _ in })
        }
    }

    /// Unwrap a SharedLink object from folder
    ///
    /// - Parameter result: A standard collection of objects with the folder object or an error
    /// - Returns: Returns a standard SharedLink object or an error
    static func unwrapSharedLinkObject(from result: Result<Folder, BoxSDKError>) -> Result<SharedLink, BoxSDKError> {
        switch result {
        case let .success(folder):
            guard let sharedLink = folder.sharedLink else {
                return .failure(BoxSDKError(message: .notFound("Folder shared link")))
            }
            return .success(sharedLink)
        case let .failure(error):
            return .failure(error)
        }
    }

    /// Retrieves the watermark on a specified folder.
    ///
    /// - Parameters:
    ///   - folderId: The id of the folder to retrieve the watermark from.
    ///   - completion: Returns a watermark object or an error.
    public func getWatermark(
        folderId: String,
        completion: @escaping Callback<Watermark>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/folders/\(folderId)/watermark", configuration: boxClient.configuration)
        ) { result in
            let objectResult: Result<Watermark.WatermarkResponse, BoxSDKError> = result.flatMap {
                ObjectDeserializer.deserialize(data: $0.body)
            }
            completion(Watermark.unwrapWatermarkObject(from: objectResult))
        }
    }

    /// Apply or update the watermark on a specified folder.
    ///
    /// - Parameters:
    ///   - folderId: The id of the folder to update the watermark for.
    ///   - completion: Returns a watermark object or an error.
    public func applyWatermark(
        folderId: String,
        completion: @escaping Callback<Watermark>
    ) {
        let body = [
            Watermark.resourceKey: [
                Watermark.imprintKey: Watermark.defaultImprint
            ]
        ]

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/folders/\(folderId)/watermark", configuration: boxClient.configuration),
            json: body
        ) { result in
            let objectResult: Result<Watermark.WatermarkResponse, BoxSDKError> = result.flatMap {
                ObjectDeserializer.deserialize(data: $0.body)
            }
            completion(Watermark.unwrapWatermarkObject(from: objectResult))
        }
    }

    /// Remove the watermark from a specified folder.
    ///
    /// - Parameters:
    ///   - folderId: The id of the folder to remove the watermark from.
    ///   - completion: Returns an empty response or an error.
    public func removeWatermark(
        folderId: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/folders/\(folderId)/watermark", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }
}
