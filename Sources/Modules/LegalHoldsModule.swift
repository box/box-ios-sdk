//
//  LegalHoldsModule.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 9/3/19.
//  Copyright © 2019 box. All rights reserved.
//
import Foundation

/// Provides management of Legal Holds
public class LegalHoldsModule {
    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional
    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Get information about a legal hold policy.
    ///
    /// - Parameters:
    ///   - policyId: The ID of the Legal Hold Policy on which to retrieve information.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full Legal Hold Policy objects can be
    ///     passed in the fields parameter to get specific attributes.
    ///   - completion: Returns a LegalHoldPolicy response object if successful otherwise a BoxSDKError.
    public func get(
        policyId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<LegalHoldPolicy>
    ) {

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/legal_hold_policies/\(policyId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Create a new legal hold policy.
    ///
    /// - Parameters:
    ///   - policyName: Name of Legal Hold Policy
    ///   - description: Description of Legal Hold Policy
    ///   - filterStartedAt: Date filter applies to Custodian assignments only
    ///   - filterEndedAt: Date filter applies to Custodian assignments only
    ///   - isOngoing: After initialization, Assignments under this Policy will continue applying to files based on events, indefinitely
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full Legal Hold Policy objects can be
    ///     passed in the fields parameter to get specific attributes.
    ///   - completion: Returns a LegalHoldPolicy response object if successful otherwise a BoxSDKError.
    public func create(
        policyName: String,
        description: String? = nil,
        filterStartedAt: Date? = nil,
        filterEndedAt: Date? = nil,
        isOngoing: Bool? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<LegalHoldPolicy>
    ) {

        var json: [String: Any] = ["policy_name": policyName]
        json["description"] = description
        json["filter_started_at"] = filterStartedAt?.iso8601
        json["filter_ended_at"] = filterEndedAt?.iso8601
        json["is_ongoing"] = isOngoing

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/legal_hold_policies", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Update a legal hold policy.
    ///
    /// - Parameters:
    ///   - policyId: ID of the Legal Hold Policy to update
    ///   - policyName: Name of Legal Hold Policy
    ///   - description: Description of Legal Hold Policy
    ///   - releaseNotes: Notes around why the policy was released
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full Legal Hold Policy objects can be
    ///     passed in the fields parameter to get specific attributes.
    ///   - completion: Returns a LegalHoldPolicy response object if successful otherwise a BoxSDKError.
    public func update(
        policyId: String,
        policyName: String? = nil,
        description: String? = nil,
        releaseNotes: String? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<LegalHoldPolicy>
    ) {

        var json = [String: String]()
        json["policy_name"] = policyName
        json["description"] = description
        json["releaseNotes"] = releaseNotes

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/legal_hold_policies/\(policyId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Deletes a legal hold policy.
    ///
    /// - Parameters:
    ///   - policyId: The ID of the legal hold policy to delete.
    ///   - completion: Returns Void if the legal hold policy is deleted.
    public func delete(
        policyId: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/legal_hold_policies/\(policyId)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Get all of the legal hold policies for the enterprise.
    ///
    /// - Parameters:
    ///   - policyName: Case insensitive prefix-match filter on Policy name.
    ///   - marker: The position marker at which to begin the response. See [marker-based paging]
    ///     (https://developer.box.com/reference#section-marker-based-paging) for details. This
    ///     parameter cannot be used simultaneously with the 'offset' parameter.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is
    ///     1,000.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full Legal Hold Policy objects can be
    ///     passed in the fields parameter to get specific attributes.
    public func listForEnterprise(
        policyName: String? = nil,
        marker: String? = nil,
        limit: Int? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<LegalHoldPolicy>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/legal_hold_policies", configuration: boxClient.configuration),
            queryParameters: [
                "policy_name": policyName,
                "marker": marker,
                "limit": limit,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Get information about a policy assignmnet.
    ///
    /// - Parameters:
    ///   - assignmentId: The ID of the policy assignment on which to retrieve information.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full Legal Hold Policy Assingment objects can be
    ///     passed in the fields parameter to get specific attributes.
    ///   - completion: Returns a LegalHoldPolicyAssignment response object if successful otherwise a BoxSDKError.
    public func getPolicyAssignment(
        assignmentId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<LegalHoldPolicyAssignment>
    ) {

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/legal_hold_policy_assignments/\(assignmentId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Assign a legal hold to a file, file version, folder, or user.
    ///
    /// - Parameters:
    ///   - policyId: Name of Legal Hold Policy
    ///   - assignToId: ID of box item to assign policy to
    ///   - assignToType: Type of box item to assign policy to
    ///   - isOngoing: After initialization, Assignments under this Policy will continue applying to files based on events, indefinitely
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full Legal Hold Policy Assignment objects can be
    ///     passed in the fields parameter to get specific attributes.
    ///   - completion: Returns a LegalHoldPolicyAssignment response object if successful otherwise a BoxSDKError.
    public func assignPolicy(
        policyId: String,
        assignToId: String,
        assignToType: String,
        fields: [String]? = nil,
        completion: @escaping Callback<LegalHoldPolicyAssignment>
    ) {

        let json: [String: Any] = ["policy_id": policyId, "assign_to": ["id": assignToId, "type": assignToType]]

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/legal_hold_policy_assignments", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Sends a request to delete an existing policy assignment.
    ///
    /// - Parameters:
    ///   - assignmentId: The ID of the legal hold policy assignment to delete.
    ///   - completion: Returns Void if the legal hold policy assignment is deleted.
    public func deletePolicyAssignment(
        assignmentId: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/legal_hold_policy_assignments/\(assignmentId)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Get all of the assignments for a legal hold policy.
    ///
    /// - Parameters:
    ///   - policyId: ID of Policy to get Assignments for. Can also specify a part of a URL.
    ///   - assignToType: Filter assignments of this type only. Can be file_version, file, folder, or user.
    ///   - assignToId: Filter assignments to this ID only
    ///   - marker: The position marker at which to begin the response. See [marker-based paging]
    ///     (https://developer.box.com/reference#section-marker-based-paging) for details. This
    ///     parameter cannot be used simultaneously with the 'offset' parameter.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is
    ///     1,000.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full Legal Hold Policy Assignment objects can be
    ///     passed in the fields parameter to get specific attributes.
    public func listPolicyAssignments(
        policyId: String,
        assignToType: String? = nil,
        assignToId: String? = nil,
        marker: String? = nil,
        limit: Int? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<LegalHoldPolicyAssignment>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/legal_hold_policy_assignments", configuration: boxClient.configuration),
            queryParameters: [
                "policy_id": policyId,
                "assign_to_type": assignToType,
                "assign_to_id": assignToId,
                "marker": marker,
                "limit": limit,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Get information about a file version legal hold.
    ///
    /// - Parameters:
    ///   - legalHoldId: The ID of the legal hold.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full File Version Legal Hold objects can be
    ///     passed in the fields parameter to get specific attributes.
    ///   - completion: Returns a FileVersionLegalHold response object if successful otherwise a BoxSDKError.
    public func getFileVersionPolicy(
        legalHoldId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<FileVersionLegalHold>
    ) {

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/file_version_legal_holds/\(legalHoldId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Get all of the non-deleted legal holds for a single legal hold policy
    ///
    /// - Parameters:
    ///   - policyId: ID of Legal Hold Policy to get File Version Legal Holds for
    ///   - marker: The position marker at which to begin the response. See [marker-based paging]
    ///     (https://developer.box.com/reference#section-marker-based-paging) for details.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is
    ///     1,000.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full File Version Legal Hold objects can be
    ///     passed in the fields parameter to get specific attributes.
    public func listFileVersionPolicies(
        policyId: String,
        marker: String? = nil,
        limit: Int? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<FileVersionLegalHold>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/file_version_legal_holds", configuration: boxClient.configuration),
            queryParameters: [
                "policy_id": policyId,
                "marker": marker,
                "limit": limit,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }
}
