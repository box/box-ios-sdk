//
//  GroupsModule.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 9/3/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Provides [Group](../Structs/Group.html) management
public class GroupsModule {

    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Retrieves a specified Group.
    ///
    /// - Parameters:
    ///   - groupId: The Id of the Group to retrieve.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full Group object or an error.
    public func get(
        groupId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<Group>
    ) {

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/groups/\(groupId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Creates a new Group.
    ///
    /// - Parameters:
    ///   - name: The name specifier for the new Group to create.
    ///   - provenance: Used to track the external source where the group is coming from
    ///   - externalSyncIdentifier: Used as a group identifier for groups coming from an external source.
    ///   - description: Description of the Group
    ///   - invitabilityLevel: Specifies who can invite this Group to folders.
    ///   - memberViewabilityLevel: Specifies who can view the members of this Group.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full Group object or an error.
    public func create(
        name: String,
        provenance: String? = nil,
        externalSyncIdentifier: String? = nil,
        description: String? = nil,
        invitabilityLevel: GroupInvitabilityLevel? = nil,
        memberViewabilityLevel: GroupMemberViewabilityLevel? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<Group>
    ) {
        var body: [String: Any] = [
            "name": name
        ]
        body["provenance"] = provenance
        body["external_sync_identifier"] = externalSyncIdentifier
        body["description"] = description
        body["invitability_level"] = invitabilityLevel?.description
        body["member_viewability_level"] = memberViewabilityLevel?.description

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/groups", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Updates the specified Group.
    ///
    /// - Parameters:
    ///   - groupId: The id of the Group to update info for.
    ///   - name: The name specifier to update the specified Group with.
    ///   - provenance: Used to track the external source where the group is coming from
    ///   - externalSyncIdentifier: Used as a group identifier for groups coming from an external source.
    ///   - description: Description of the Group
    ///   - invitabilityLevel: Specifies who can invite this Group to folders.
    ///   - memberViewabilityLevel: Specifies who can view the members of this Group.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full Group object or an error.
    public func update(
        groupId: String,
        name: String? = nil,
        provenance: NullableParameter<String>? = nil,
        externalSyncIdentifier: NullableParameter<String>? = nil,
        description: NullableParameter<String>? = nil,
        invitabilityLevel: GroupInvitabilityLevel? = nil,
        memberViewabilityLevel: GroupMemberViewabilityLevel? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<Group>
    ) {
        var body: [String: Any] = [:]
        body["name"] = name
        body["invitability_level"] = invitabilityLevel?.description
        body["member_viewability_level"] = memberViewabilityLevel?.description

        if let unwrappedDescription = description {
            switch unwrappedDescription {
            case .null:
                body["description"] = NSNull()
            case let .value(descriptionValue):
                body["description"] = descriptionValue
            }
        }

        if let unwrappedProvenance = provenance {
            switch unwrappedProvenance {
            case .null:
                body["provenance"] = NSNull()
            case let .value(provenanceValue):
                body["provenance"] = provenanceValue
            }
        }

        if let unwrappedSyncIdentifier = externalSyncIdentifier {
            switch unwrappedSyncIdentifier {
            case .null:
                body["external_sync_identifier"] = NSNull()
            case let .value(syncIdentifierValue):
                body["external_sync_identifier"] = syncIdentifierValue
            }
        }

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/groups/\(groupId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Deletes the specified Group.
    ///
    /// - Parameters:
    ///   - groupId: The ID of the Group to delete.
    ///   - completion: An empty response will be returned upon successful deletion.
    public func delete(
        groupId: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/groups/\(groupId)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Get all Groups for an enterprise.
    ///
    /// - Parameters:
    ///   - name: Only return groups whose name contains the given string (case insensitive).
    ///   - offset: The offset of the item at which to begin the response.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is 1,000.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    public func listForEnterprise(
        name: String? = nil,
        offset: Int? = nil,
        limit: Int? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<Group>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/groups", configuration: boxClient.configuration),
            queryParameters: [
                "name": name,
                "offset": offset,
                "limit": limit,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Retrieves a specified Group Membership.
    ///
    /// - Parameters:
    ///   - membershipId: The Id of the Group Membership to retrieve.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full Group Membership object or an error.
    public func getMembershipInfo(
        membershipId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<GroupMembership>
    ) {

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/group_memberships/\(membershipId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Creates a Group Membership.
    ///
    /// - Parameters:
    ///   - userId: The Id of the user to add to the Group.
    ///   - groupId: The Id of the group to add the user to.
    ///   - role: The role of the user within the group. Defaults to "member". Can be set to "admin".
    ///   - configurablePermission: The set of [permissions](https://developer.box.com/reference#add-a-member-to-a-group) allowed to the admin of the group.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full Group Membership object or an error.
    public func createMembership(
        userId: String,
        groupId: String,
        role: GroupRole? = nil,
        configurablePermission: NullableParameter<ConfigurablePermissionData>? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<GroupMembership>
    ) {
        var body: [String: Any] = [
            "user": [
                "id": userId
            ],
            "group": [
                "id": groupId
            ]
        ]
        body["role"] = role?.description

        if let unwrappedConfigurablePermission = configurablePermission {
            switch unwrappedConfigurablePermission {
            case .null:
                body["configurable_permissions"] = NSNull()
            case let .value(configurablePermissionValue):
                body["configurable_permissions"] = configurablePermissionValue.bodyDict
            }
        }

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/group_memberships", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Updates the specified Group Membership.
    ///
    /// - Parameters:
    ///   - membershipId: The ID of the Group Membership to update.
    ///   - role: The role of the user within the group. Defaults to "member". Can be set to "admin".
    ///   - configurablePermission: The set of [permissions](https://developer.box.com/reference#add-a-member-to-a-group) allowed to the admin of the group.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full Group Membership object or an error.
    public func updateMembership(
        membershipId: String,
        role: GroupRole? = nil,
        configurablePermission: NullableParameter<ConfigurablePermissionData>? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<GroupMembership>
    ) {
        var body: [String: Any] = [:]
        body["role"] = role?.description

        if let unwrappedConfigurablePermission = configurablePermission {
            switch unwrappedConfigurablePermission {
            case .null:
                body["configurable_permissions"] = NSNull()
            case let .value(configurablePermissionValue):
                body["configurable_permissions"] = configurablePermissionValue.bodyDict
            }
        }

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/group_memberships/\(membershipId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Deletes the specified Group Membership.
    ///
    /// - Parameters:
    ///   - membershipId: The ID of the Group Membership to delete.
    ///   - completion: An empty response will be returned upon successful deletion.
    public func deleteMembership(
        membershipId: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/group_memberships/\(membershipId)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Get all Memberships for a specified Group.
    ///
    /// - Parameters:
    ///   - groupId: The ID of the group to return memberships for.
    ///   - offset: The offset of the item at which to begin the response.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is 1,000.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    public func listMemberships(
        groupId: String,
        offset: Int? = nil,
        limit: Int? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<GroupMembership>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/groups/\(groupId)/memberships", configuration: boxClient.configuration),
            queryParameters: [
                "offset": offset,
                "limit": limit,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Returns all of the group memberships for a given user. Note this is only available to group admins.
    ///
    /// - Parameters:
    ///   - userId: The ID of the User to retrieve collaborations for.
    ///   - offset: The offset of the item at which to begin the response.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is 1,000.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    public func listMembershipsForUser(
        userId: String,
        offset: Int? = nil,
        limit: Int? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<GroupMembership>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/users/\(userId)/memberships", configuration: boxClient.configuration),
            queryParameters: [
                "offset": offset,
                "limit": limit,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Returns all of the group collaborations for a given group. Note this is only available to group admins.
    ///
    /// - Parameters:
    ///   - groupId: The ID of the Group to retrieve collaborations for.
    ///   - offset: The offset of the item at which to begin the response.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is 1,000.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    public func listCollaborations(
        groupId: String,
        offset: Int? = nil,
        limit: Int? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<Collaboration>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/groups/\(groupId)/collaborations", configuration: boxClient.configuration),
            queryParameters: [
                "offset": offset,
                "limit": limit,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }
}
