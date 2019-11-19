//
//  RetentionPolicyModule.swift
//  BoxSDK-iOS
//
//  Created by Martina Stremeňová on 8/29/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Provides [RetentionPolicy](../Structs/RetentionPolicy.html) management.
public class RetentionPoliciesModule {
    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Retrieves information about a retention policy
    ///
    /// - Parameters:
    ///   - id: Policy id.
    ///   - completion: Returns either standard RetentionPolicy object or an error.
    public func get(
        policyId id: String,
        completion: @escaping Callback<RetentionPolicy>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/retention_policies/\(id)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Creates a new retention policy.
    ///
    /// - Parameters:
    ///   - name: Name of retention policy to be created.
    ///   - type: Type of retention policy.
    ///   - length: The retention_length is the amount of time, in days, to apply the retention policy to the selected content in days.
    ///     Do not specify for `indefinite` policies. Required for `finite` policies.
    ///   - dispositionAction: If creating a finite policy, the disposition action can be `permanently_delete` or `remove_retention`.
    ///     For `indefinite` policies, disposition action must be `remove_retention`.
    ///   - canOwnerExtendRetention: The Owner of a file will be allowed to extend the retention.
    ///   - areOwnersNotified: The Owner or Co-owner will get notified when a file is nearing expiration.
    ///   - customNotificationRecipients: Notified users.
    ///   - completion: Returns either standard RetentionPolicy object or an error.
    public func create(
        name: String,
        type: RetentionPolicyType,
        length: Int? = nil,
        dispositionAction: DispositionAction,
        canOwnerExtendRetention: Bool? = nil,
        areOwnersNotified: Bool? = nil,
        customNotificationRecipients: [User]? = nil,
        completion: @escaping Callback<RetentionPolicy>
    ) {

        var body: [String: Any] = [:]
        body["policy_name"] = name
        body["policy_type"] = type.description
        body["retention_length"] = length
        body["disposition_action"] = dispositionAction.description
        body["can_owner_extend_retention"] = canOwnerExtendRetention
        body["are_owners_notified"] = areOwnersNotified
        body["custom_notification_recipients"] = customNotificationRecipients?.compactMap {
            var userBody: [String: Any] = [:]
            userBody["type"] = "user"
            userBody["id"] = $0.id
            userBody["name"] = $0.name
            userBody["login"] = $0.login
            return userBody
        } ?? []

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/retention_policies", configuration: boxClient.configuration),
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Updates existing retention policy.
    ///
    /// - Parameters:
    ///   - id: Retention policy id.
    ///   - name: Updated name of retention policy.
    ///   - dispositionAction: If updating a `finite` policy, the disposition action can be `permanently_delete` or `remove_retention`.
    ///     For indefinite policies, disposition action must be remove_retention.
    ///   - status: Used to `retire` a retention policy if status is set to `retired`. If not retiring a policy, do not include or set to null.
    ///   - completion: Returns either updated retention policy object or an error.
    public func update(
        policyId id: String,
        name: String? = nil,
        dispositionAction: DispositionAction? = nil,
        status: RetentionPolicyStatus? = nil,
        completion: @escaping Callback<RetentionPolicy>
    ) {

        var body: [String: Any] = [:]
        body["policy_name"] = name
        body["disposition_action"] = dispositionAction?.description
        body["status"] = status?.description

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/retention_policies/\(id)", configuration: boxClient.configuration),
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Retrieves all of the retention policies for the given enterprise.
    ///
    /// - Parameters:
    ///   - name: A name to filter the retention policies by. A trailing partial match search is performed.
    ///   - type: A policy type to filter the retention policies by.
    ///   - createdByUserId: A user id to filter the retention policies by.
    ///   - marker: The position marker at which to begin the response. See [marker-based paging]
    ///     (https://developer.box.com/reference#section-marker-based-paging) for details.
    ///   - limit: The maximum number of items to return.
    /// - Returns: Returns pagination iterator to fetch items. Returns the list of all retention policies for the enterprise.
    ///     If query parameters are given, only the retention policies that match the query parameters are returned.
    public func list(
        name: String? = nil,
        type: RetentionPolicyType? = nil,
        createdByUserId: String? = nil,
        marker: String? = nil,
        limit: Int? = nil,
        completion: @escaping Callback<PagingIterator<RetentionPolicyEntry>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/retention_policies", configuration: boxClient.configuration),
            queryParameters: [
                "policy_name": name,
                "policy_type": type?.description,
                "created_by_user_id": createdByUserId,
                "marker": marker,
                "limit": limit
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Retrieves information about a retention policy assignment.
    ///
    /// - Parameters:
    ///   - id: Retention policy assignment ID.
    ///   - completion: Either the specified retention policy assignment will be returned upon success or an error.
    public func getAssignment(
        assignmentId id: String,
        completion: @escaping Callback<RetentionPolicyAssignment>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/retention_policy_assignments/\(id)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Creates new retention policy assignment to a content.
    ///
    /// - Parameters:
    ///   - id: The id of the retention policy to assign this content to.
    ///   - assignedContentId: The id of the content to assign the retention policy to. If assigning to an enterprise, no id should be provided.
    ///   - assignContentType: The type of item policy is assigned to. The type can only be one of three attributes: enterprise, folder, or metadata_template.
    ///   - filterFields: The array of metadata field filters
    ///   - completion: Returns either new assignment upon success or an error.
    public func assign(
        policyId id: String,
        assignedContentId: String,
        assignContentType: RetentionPolicyAssignmentItemType,
        filterFields: [MetadataFieldFilter]? = nil,
        completion: @escaping Callback<RetentionPolicyAssignment>
    ) {
        var body: [String: Any] = [:]
        body["policy_id"] = id
        body["assign_to"] = [
            "id": assignedContentId,
            "type": assignContentType.description
        ]
        if let unwrappedFilterFields = filterFields {
            body["filter_fields"] = unwrappedFilterFields.map { $0.bodyDictWithDefaultKeys }
        }

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/retention_policy_assignments", configuration: boxClient.configuration),
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Returns a list of all retention policy assignments associated with a specified retention policy.
    ///
    /// - Parameters:
    ///   - id: Retention policy id.
    ///   - type: The type of the retention policy assignment to retrieve.
    ///   - marker: The position marker at which to begin the response. See [marker-based paging]
    ///     (https://developer.box.com/reference#section-marker-based-paging) for details.
    ///   - limit: The maximum number of items to return. The default is 100.
    /// - Returns: Returns either a list of the retention policy assignments associated with the specified retention policy or an error.
    public func listAssignments(
        policyId id: String,
        type: RetentionPolicyType? = nil,
        marker: String? = nil,
        limit: Int? = nil,
        completion: @escaping Callback<PagingIterator<RetentionPolicyAssignment>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/retention_policies/\(id)/assignments", configuration: boxClient.configuration),
            queryParameters: [
                "policy_type": type?.description,
                "marker": marker,
                "limit": limit
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }
}
