//
//  StoragePoliciesModule.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 9/5/19.
//  Copyright © 2019 box. All rights reserved.
//
import Foundation

/// Provides management of Storage Policies
public class StoragePoliciesModule {
    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Get information about a storage policy.
    ///
    /// - Parameters:
    ///   - storagePolicyId: Id for storage policy needed.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full Storage Policy objects can be
    ///     passed in the fields parameter to get specific attributes.
    ///   - completion: Returns a StoragePolicy response object if successful otherwise a BoxSDKError.
    public func get(
        storagePolicyId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<StoragePolicy>
    ) {

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/storage_policies/\(storagePolicyId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Get all of the storage policies in an enterprise.
    ///
    /// - Parameters:
    ///   - marker: The position marker at which to begin the response. See [marker-based paging]
    ///     (https://developer.box.com/reference#section-marker-based-paging) for details. This
    ///     parameter cannot be used simultaneously with the 'offset' parameter.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is
    ///     1,000.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full StoragePolicy objects can be
    ///     passed in the fields parameter to get specific attributes.
    public func listForEnterprise(
        marker: String? = nil,
        limit: Int? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<StoragePolicy>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/storage_policies", configuration: boxClient.configuration),
            queryParameters: [
                "marker": marker,
                "limit": limit,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Get storage policy assignment information.
    ///
    /// - Parameters:
    ///   - storagePolicyAssignmentId: Id for storage policy assignment needed.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full Storage Policy Assignment objects can be
    ///     passed in the fields parameter to get specific attributes.
    ///   - completion: Returns a StoragePolicyAssignment response object if successful otherwise a BoxSDKError.
    public func getAssignment(
        storagePolicyAssignmentId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<StoragePolicyAssignment>
    ) {

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/storage_policy_assignments/\(storagePolicyAssignmentId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Get the storage policy assignment assigned to a user or enterprise.
    ///
    /// - Parameters:
    ///   - resolvedForType: Specify user or enterprise.
    ///   - resolverForId: Specify Id of user or enterprise
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full StoragePolicy objects can be
    ///     passed in the fields parameter to get specific attributes.
    public func listAssignments(
        resolvedForType: String,
        resolvedForId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<StoragePolicyAssignment>
    ) {

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/storage_policy_assignments", configuration: boxClient.configuration),
            queryParameters: [
                "resolved_for_type": resolvedForType,
                "resolved_for_id": resolvedForId,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.unwrapCollection(wrapping: completion)
        )
    }

    /// Create storage policy assignment.
    ///
    /// - Parameters:
    ///   - storagePolicyId: Id of the storage policy.
    ///   - assignedToType: Set type to "user" or "enterprise".
    ///   - assignedToId: Id of the user or enterprise.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full Storage Policy Assignment objects can be
    ///     passed in the fields parameter to get specific attributes.
    ///   - completion: Returns a StoragePolicyAssignment response object if successful otherwise a BoxSDKError.
    public func assign(
        storagePolicyId: String,
        assignedToType: String,
        assignedToId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<StoragePolicyAssignment>
    ) {

        let json: [String: Any] = [
            "storage_policy": [
                "type": "storage_policy",
                "id": storagePolicyId
            ],
            "assigned_to": [
                "type": assignedToType,
                "id": assignedToId
            ]
        ]

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/storage_policy_assignments", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Assign policy
    ///
    /// - Parameters:
    ///   - storagePolicyId: Id of the storage policy.
    ///   - assignedToType: Set type to "user" or "enterprise".
    ///   - assignedToId: Id of the user or enterprise.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full Storage Policy Assignment objects can be
    ///     passed in the fields parameter to get specific attributes.
    ///   - completion: Returns a StoragePolicyAssignment response object if successful otherwise a BoxSDKError.
    public func forceAssign(
        storagePolicyId: String,
        assignedToType: String,
        assignedToId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<StoragePolicyAssignment>
    ) {

        assign(storagePolicyId: storagePolicyId, assignedToType: assignedToType, assignedToId: assignedToId, fields: fields) { result in
            switch result {
            case let .success(response):
                completion(.success(response))
            case let .failure(error):
                guard let apiError = error as? BoxAPIError else {
                    completion(.failure(error))
                    return
                }

                let statusCode = apiError.response?.statusCode
                if statusCode == 409 {
                    self.listAssignments(resolvedForType: assignedToType, resolvedForId: assignedToId) { result in
                        switch result {
                        case let .success(assignment):
                            self.updateAssignment(storagePolicyAssignmentId: assignment.id, storagePolicyId: storagePolicyId, completion: completion)
                        case let .failure(error):
                            completion(.failure(error))
                        }
                    }
                }
                else {
                    completion(.failure(error))
                }
            }
        }
    }

    /// Update storage policy assignment.
    ///
    /// - Parameters:
    ///   - storagePolicyAssignmentId: Id for storage policy assignment to update.
    ///   - storagePolicyId: Id for the storage policy.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full Storage Policy Assignment objects can be
    ///     passed in the fields parameter to get specific attributes.
    ///   - completion: Returns a Storage Policy Assignment response object if successful otherwise a BoxSDKError.
    public func updateAssignment(
        storagePolicyAssignmentId: String,
        storagePolicyId: String? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<StoragePolicyAssignment>
    ) {

        let json: [String: Any] = [
            "storage_policy": [
                "type": "storage_policy",
                "id": storagePolicyId
            ]
        ]

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/storage_policy_assignments/\(storagePolicyAssignmentId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Deleting a storage policy assignment means the user will inherit the Enterprise's default storage policy.
    ///
    /// - Parameters:
    ///   - storagePolicyAssignmentId: Id for storage policy assignment.
    ///   - completion: Returns Void if the storage policy assignment is deleted.
    public func deleteAssignment(
        storagePolicyAssignmentId: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/storage_policy_assignments/\(storagePolicyAssignmentId)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }
}
