//
//  CollaborationsModule.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/29/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Specifies type of value that has granted access to an object.
public enum AccessibleBy: BoxEnum {
    /// The user that is granted access
    case user
    /// The group that is granted access
    case group
    /// A custom object type for defining access that is not yet implemented
    case customValue(String)

    /// Creates a new value
    ///
    /// - Parameter value: String representation of an AccessibleBy rawValue
    public init(_ value: String) {
        switch value {
        case "user":
            self = .user
        case "group":
            self = .group
        default:
            self = .customValue(value)
        }
    }

    /// Returns string representation of type that can be used in a request.
    public var description: String {
        switch self {
        case .user:
            return "user"
        case .group:
            return "group"
        case let .customValue(userValue):
            return userValue
        }
    }
}

/// Provides [Collaborations](../Structs/Collaborations.html) management.
public class CollaborationsModule {
    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Get information about a collaboration.
    ///
    /// - Parameters:
    ///   - collaborationId: The ID of the collaboration to get details
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: The collaboration object is returned or an error
    public func get(
        collaborationId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<Collaboration>
    ) {

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/collaborations/\(collaborationId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Create a new collaboration that grants a group access to a file or folder in a specific role.
    ///
    /// - Parameters:
    ///   - itemType: The object type. Can be file or folder
    ///   - itemId: The id of the file or the folder
    ///   - role: The level of access granted. Can be editor, viewer, previewer, uploader, previewer uploader, viewer uploader, or co-owner.
    ///   - accessibleBy: The ID of the group that is granted access
    ///   - accessibleByType: Can be user or group
    ///   - canViewPath: Whether view path collaboration feature is enabled or not. View path collaborations allow the invitee to see the entire ancestral path to the associated folder.
    ///     this parameter is only available for folder collaborations
    ///     The user will not gain privileges in any ancestral folder (e.g. see content the user is not collaborated on).
    ///   - fields: Attribute(s) to include in the response
    ///   - notify: Determines if the user, (or all the users in the group) should receive email notification of the collaboration.
    ///   - completion: The collaboration object is returned or an error
    public func create(
        itemType: String,
        itemId: String,
        role: CollaborationRole,
        accessibleBy: String,
        accessibleByType: AccessibleBy,
        canViewPath: Bool? = nil,
        fields: [String]? = nil,
        notify: Bool? = nil,
        completion: @escaping Callback<Collaboration>
    ) {
        var json: [String: Any] = [
            "item": [
                "id": itemId,
                "type": itemType
            ],
            "role": role.description
        ]

        if let canViewPath = canViewPath {
            json["can_view_path"] = canViewPath
        }

        var accessibleByJSON: [String: Any] = ["type": accessibleByType.description]
        accessibleByJSON["id"] = accessibleBy

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/collaborations", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields), "notify": notify],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Create a new collaboration that grants a user to a file or folder in a specific role.
    ///
    /// - Parameters:
    ///   - itemType: The object type. Can be file or folder
    ///   - itemId: The id of the file or the folder
    ///   - role: The level of access granted. Can be editor, viewer, previewer, uploader, previewer uploader, viewer uploader, or co-owner.
    ///   - login: The ID of the user or group that is granted access
    ///   - canViewPath: Whether view path collaboration feature is enabled or not. View path collaborations allow the invitee to see the entire ancestral path to the associated folder.
    ///     this parameter is only available for folder collaborations
    ///     The user will not gain privileges in any ancestral folder (e.g. see content the user is not collaborated on).
    ///   - fields: Attribute(s) to include in the response
    ///   - notify: Determines if the user, (or all the users in the group) should receive email notification of the collaboration.
    ///   - completion: The collaboration object is returned or an error
    public func createByUserEmail(
        itemType: String,
        itemId: String,
        role: CollaborationRole,
        login: String,
        canViewPath: Bool? = nil,
        fields: [String]? = nil,
        notify: Bool? = nil,
        completion: @escaping Callback<Collaboration>
    ) {
        var json: [String: Any] = [
            "item": [
                "id": itemId,
                "type": itemType
            ],
            "role": role.description
        ]

        if let canViewPath = canViewPath {
            json["can_view_path"] = canViewPath
        }

        var accessibleByJSON: [String: Any] = ["type": "user"]
        accessibleByJSON["login"] = login

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/collaborations", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields), "notify": notify],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Update a collaboration.
    ///
    /// - Parameters:
    ///   - collaborationId: The ID of the collaboration to get details
    ///   - role: The level of access granted. Can be editor, viewer, previewer, uploader, previewer uploader, viewer uploader, co-owner, or owner.
    ///   - status: The status of the collaboration invitation. Can be accepted or  rejected.
    ///   - canViewPath: Whether view path collaboration feature is enabled or not. View path collaborations allow the invitee to see the entire ancestral path to the associated folder.
    ///   The user will not gain privileges in any ancestral folder (e.g. see content the user is not collaborated on).
    ///   This parameter is only available for folder collaborations
    ///   - fields: Attribute(s) to include in the response
    ///   - completion: The collaboration object is returned or an error
    public func update(
        collaborationId: String,
        role: CollaborationRole,
        status: CollaborationStatus? = nil,
        canViewPath: Bool? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<Collaboration>
    ) {

        var json: [String: Any] = ["role": role.description]

        if let canViewPath = canViewPath {
            json["can_view_path"] = canViewPath
        }

        if let status = status {
            json["status"] = status.description
        }

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/collaborations/\(collaborationId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Delete a collaboration.
    ///
    /// - Parameters:
    ///   - collaborationId: The ID of the collaboration to delete
    ///   - completion: An empty response will be returned upon successful deletion or an error
    public func delete(
        collaborationId: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/collaborations/\(collaborationId)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Get information about a collaboration.
    ///
    /// - Parameters:
    ///   - collaborationId: The ID of the collaboration to get details
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: The collaboration object is returned or an error
    public func listPendingForEnterprise(
        offset: Int? = nil,
        limit: Int? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<Collaboration>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/collaborations", configuration: boxClient.configuration),
            queryParameters: [
                "offset": offset,
                "limit": limit,
                "status": "pending",
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Retrieves the acceptance requirements status for a specified collaboration
    ///
    /// - Parameters:
    ///   - collaborationId: The ID of the collaboration to get details
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: The collaboration object is returned or an error
    public func getAcceptanceRequirementsStatus(
        collaborationId: String,
        completion: @escaping Callback<Collaboration.AcceptanceRequirementsStatus>
    ) {
        boxClient.collaborations.get(
            collaborationId: collaborationId,
            fields: ["acceptance_requirements_status"],
            completion: { result in
                switch result {
                case let .success(collaboration):
                    guard let acceptanceRequirement = collaboration.acceptanceRequirementsStatus else {
                        completion(.failure(BoxAPIError(message: .notFound("Collaboration does not have acceptance requirement status"))))
                        return
                    }
                    completion(.success(acceptanceRequirement))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        )
    }
}
