import Foundation

public class StoragePolicyAssignmentsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Fetches all the storage policy assignment for an enterprise or user.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getStoragePolicyAssignments method
    ///   - headers: Headers of getStoragePolicyAssignments method
    /// - Returns: The `StoragePolicyAssignments`.
    /// - Throws: The `GeneralError`.
    public func getStoragePolicyAssignments(queryParams: GetStoragePolicyAssignmentsQueryParams, headers: GetStoragePolicyAssignmentsHeaders = GetStoragePolicyAssignmentsHeaders()) async throws -> StoragePolicyAssignments {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "resolved_for_type": Utils.Strings.toString(value: queryParams.resolvedForType), "resolved_for_id": Utils.Strings.toString(value: queryParams.resolvedForId)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/storage_policy_assignments")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try StoragePolicyAssignments.deserialize(from: response.data!)
    }

    /// Creates a storage policy assignment for an enterprise or user.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createStoragePolicyAssignment method
    ///   - headers: Headers of createStoragePolicyAssignment method
    /// - Returns: The `StoragePolicyAssignment`.
    /// - Throws: The `GeneralError`.
    public func createStoragePolicyAssignment(requestBody: CreateStoragePolicyAssignmentRequestBody, headers: CreateStoragePolicyAssignmentHeaders = CreateStoragePolicyAssignmentHeaders()) async throws -> StoragePolicyAssignment {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/storage_policy_assignments")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try StoragePolicyAssignment.deserialize(from: response.data!)
    }

    /// Fetches a specific storage policy assignment.
    ///
    /// - Parameters:
    ///   - storagePolicyAssignmentId: The ID of the storage policy assignment.
    ///     Example: "932483"
    ///   - headers: Headers of getStoragePolicyAssignmentById method
    /// - Returns: The `StoragePolicyAssignment`.
    /// - Throws: The `GeneralError`.
    public func getStoragePolicyAssignmentById(storagePolicyAssignmentId: String, headers: GetStoragePolicyAssignmentByIdHeaders = GetStoragePolicyAssignmentByIdHeaders()) async throws -> StoragePolicyAssignment {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/storage_policy_assignments/")\(storagePolicyAssignmentId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try StoragePolicyAssignment.deserialize(from: response.data!)
    }

    /// Updates a specific storage policy assignment.
    ///
    /// - Parameters:
    ///   - storagePolicyAssignmentId: The ID of the storage policy assignment.
    ///     Example: "932483"
    ///   - requestBody: Request body of updateStoragePolicyAssignmentById method
    ///   - headers: Headers of updateStoragePolicyAssignmentById method
    /// - Returns: The `StoragePolicyAssignment`.
    /// - Throws: The `GeneralError`.
    public func updateStoragePolicyAssignmentById(storagePolicyAssignmentId: String, requestBody: UpdateStoragePolicyAssignmentByIdRequestBody, headers: UpdateStoragePolicyAssignmentByIdHeaders = UpdateStoragePolicyAssignmentByIdHeaders()) async throws -> StoragePolicyAssignment {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/storage_policy_assignments/")\(storagePolicyAssignmentId)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try StoragePolicyAssignment.deserialize(from: response.data!)
    }

    /// Delete a storage policy assignment.
    /// 
    /// Deleting a storage policy assignment on a user
    /// will have the user inherit the enterprise's default
    /// storage policy.
    /// 
    /// There is a rate limit for calling this endpoint of only
    /// twice per user in a 24 hour time frame.
    ///
    /// - Parameters:
    ///   - storagePolicyAssignmentId: The ID of the storage policy assignment.
    ///     Example: "932483"
    ///   - headers: Headers of deleteStoragePolicyAssignmentById method
    /// - Throws: The `GeneralError`.
    public func deleteStoragePolicyAssignmentById(storagePolicyAssignmentId: String, headers: DeleteStoragePolicyAssignmentByIdHeaders = DeleteStoragePolicyAssignmentByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/storage_policy_assignments/")\(storagePolicyAssignmentId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
